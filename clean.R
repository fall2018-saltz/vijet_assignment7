
library(ggplot2)
library(maps)
library(ggmap)
#------------------------------------------------------------------------------------------------------
#Step A: Loading and Merging Datasets:

no_arg <- function(){                                                                                            #Creating a function to make sure that all the columns except those mentioned in the vector 'drop' are retained from the data frame. The ones that are in drop, those columns are dropped for all rows in the data frame.
  clean_data <- raw_data                     
  clean_data <- clean_data[!(clean_data$NAME=="United States" | clean_data$NAME=="Puerto Rico Commonwealth"),]   #Removing the first and last entries, i.e., just keeping the states.
}

dfStates <- no_arg()                                                                                             #Catching the clean_data from the function in dfStates
arrest <- USArrests
merged <- merge(dfStates, arrest, by.x="NAME", by.y="row.names", all=TRUE)                                       #Merging the 2 data sets into one. The state names for both the data sets are in 'NAME' for the 1st and are row names for the 2nd.So we combine/merge the data sets by those 2 columns.
merged <- merged[!(merged$NAME=="District of Columbia"),]                                                        #Removing the row for 'District of Columbia' for it isn't having the entries from the 'arrest' data frame.
#------------------------------------------------------------------------------------------------------
merged["starea"] <- state.area                                                                                   #Adding a new column to the 'merged' data frame named 'starea' and filling it up with area of states from 'state.area' vector.
merged["center_x"] <- state.center$x                                                                             #Adding a new column to the 'merged' data frame named 'center_x' with the x co-ordinates for the center of all states from 'state.center$x'.
merged["center_y"] <- state.center$y                                                                             #Adding a new column to the 'merged' data frame named 'center_y' with the y co-ordinates for the center of all states from 'state.center$y'.
merged["state_low"] <- tolower(merged$NAME)                                                                      #Adding a new column to the 'merged' data frame named 'state_low' with the state names in lower case.
#------------------------------------------------------------------------------------------------------
usa <- map_data("state")
map1 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill=merged$starea) + expand_limits(x=usa$long,y=usa$lat) + coord_map()
map1
#------------------------------------------------------------------------------------------------------
map2 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill=merged$Murder) + expand_limits(x=usa$long,y=usa$lat) + coord_map()
map2
#------------------------------------------------------------------------------------------------------
map3 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa) + expand_limits(x=usa$long, y=usa$lat) + geom_point(aes(x=merged$center_x,y=merged$center_y,color="red",size=merged$POPESTIMATE2017)) + coord_map()
map3
#------------------------------------------------------------------------------------------------------
nyc <- geocode(source="dsk","new york city,new york")
map4 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill="dark red") + xlim(nyc$lon-10,nyc$lon+10) + ylim(nyc$lat-10,nyc$lat+10) +coord_map()
map4
