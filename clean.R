
library(ggplot2)
#library(tidyverse)
library(maps)
library(ggmap)

no_arg <- function(){                                                                                            #Creating a function to make sure that all the columns except those mentioned in the vector 'drop' are retained from the data frame. The ones that are in drop, those columns are dropped for all rows in the data frame.
  clean_data <- raw_data                     
  clean_data <- clean_data[!(clean_data$NAME=="United States" | clean_data$NAME=="Puerto Rico Commonwealth"),]   #Removing the first and last entries, i.e., just keeping the states.
}

dfStates <- no_arg()  

arrest <- USArrests
merged <- merge(dfStates, arrest, by.x="NAME",by.y="row.names",all=TRUE)                                         #Merging the 2 data sets into one. The state names for both the data sets are in 'NAME' for the 1st and are row names for the 2nd.So we combine/merge the data sets by those 2 columns.
merged <- merged[!(merged$NAME=="District of Columbia"),]

merged["starea"] <- state.area
merged["center_x"] <- state.center$x
merged["center_y"] <- state.center$y
merged["state_low"] <- tolower(merged$NAME)

usa <- map_data("state")
map1 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill=merged$starea) + expand_limits(x=usa$long,y=usa$lat) + coord_map()
map1

map2 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill=merged$Murder) + expand_limits(x=usa$long,y=usa$lat) + coord_map()
map2

map3 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa) + expand_limits(x=usa$long, y=usa$lat) + geom_point(aes(x=merged$center_x,y=merged$center_y,color="red",size=merged$POPESTIMATE2017)) + coord_map()
map3

nyc <- geocode(source="dsk","new york city,new york")
map4 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill="dark red") + xlim(nyc$lon-10,nyc$lon+10) + ylim(nyc$lat-10,nyc$lat+10) +coord_map()
map4
