
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
#Step B: Generate a color coded map:

usa <- map_data("state")                                                                                        #Loading the map data for the states in USA in the variable 'usa'                      
#------------------------------------------------------------------------------------------------------
#Before I start plotting, I feel the need to explain the role of 'ggplot'. It is essentially a way of filling up a 'blueprint'. Irrespective of the type of the plot, 'ggplot' will always be called
#ggplot takes the data frame to be plotted as an argument. In addition to that there is an 'aes' aspect to it(aesthetics). It handles what the plot will look as per, i.e. the values to be plotted and where 
#to plot them. The functions in addition to ggplot and following it define the type of plot (like maps in our case).
#------------------------------------------------------------------------------------------------------
map1 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,aes(fill=merged$starea)) + expand_limits(x=usa$long,y=usa$lat) + coord_map() 
#------------------------------------------------------------------------------------------------------
#geom_map is used to plot a map using ggplot. Here we are using the variable 'usa' with data for states, thus telling R what map is to be produced. The 'fill' is to color code the map on the basis of the areas of states.
#expand_limits is to tell R what area to display in the 'Plots' section or to copy in the .png file. coord_map is to self adjust the aspect ratio as per the resolution of the display area.
#------------------------------------------------------------------------------------------------------
map1
#------------------------------------------------------------------------------------------------------
#Step C: Create a color coded map of the U.S. on the Murder Rate for each state:
#------------------------------------------------------------------------------------------------------
map2 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill=merged$Murder) + expand_limits(x=usa$long,y=usa$lat) + coord_map()   
#Same as earlier, except now the map is filled or color coded on the basis of Murder rates.
#------------------------------------------------------------------------------------------------------
map2
#------------------------------------------------------------------------------------------------------
map3 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa) + expand_limits(x=usa$long, y=usa$lat) + geom_point(aes(x=merged$center_x,y=merged$center_y,color="red",size=merged$POPESTIMATE2017)) + coord_map()
#Same as before,however, there is no fill now. But we are plotting points at the center of each state and the size of each point depends on the population of that state.
#------------------------------------------------------------------------------------------------------
map3
#------------------------------------------------------------------------------------------------------
#Step D: Zoom the map:
#------------------------------------------------------------------------------------------------------
nyc <- geocode(source="dsk","new york city,new york")                                                            #Importing the co-ordinates(longitude and lattitude) for New York City from data science toolkit using geocode function.
map4 <- ggplot(merged,aes(map_id=state_low)) + geom_map(map=usa,fill="dark red") + xlim(nyc$lon-10,nyc$lon+10) + ylim(nyc$lat-10,nyc$lat+10) +coord_map()
#The map is supposed to be of 'dark red' color and xlim and ylim make sure that the range of x axis and y axis is contained to the input values, in this case +-10 of the co-ordinates of NYC.
#------------------------------------------------------------------------------------------------------
map4
#------------------------------------------------------------------------------------------------------
