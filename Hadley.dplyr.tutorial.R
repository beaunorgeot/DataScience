library(hflights)
flights <- tbl_df(hflights)

#What flights flew every day and where did they fly?

dailyflights <- flights %>%
  mutate(DATE = paste(Year,Month,DayofMonth,sep="_")) %>%
  group_by(UniqueCarrier, FlightNum, Dest) %>%
  summarise(n = n_distinct(DATE)) %>%
  filter(n == 365)
  
#NOTE, graphing pasted dates can be weird, but converting to POSIXct() seems to solve this problem. 
#mutate(DateTime = paste(as.Date(days2$Date,format = "%d/%m/%Y"), days2$Time)) %>%
#mutate(posDT = as.POSIXct(DateTime))

library(ggplot2)

#On average, how do the delays of non-cancelled flights vary over the course of the day?
dailyDelays <- flights %>%
  filter(Cancelled == 0) %>%
  mutate(depHOUR = DepTime %/% 100, depMINS = DepTime %% 100) %>%
  group_by(depHOUR, depMINS) %>%
  summarise(n = n(), meanDELAY = mean(DepDelay)) 
#add a time as a floating point variable to make visualization easier
dailyDelays <- dailyDelays %>%
  mutate(time = depHOUR + depMINS/60)
#Visualize the data on a scatterplot
qplot(time, meanDELAY, data = dailyDelays)
#fancier visualization
qplot(time, meanDELAY, data = filter(dailyDelays, n > 30), size =n) + scale_size_area() 
# The n > 30 is from the group_by above

#Here was my initial way of doing the same thing
dailyDelays <- flights %>%
  filter(Cancelled == 0) %>%
  group_by(DepTime) %>%
  summarise(n = n(), meanDELAY = mean(DepDelay)) 
qplot(DepTime,meanDELAY, data = dailyDelays)

# ggplot method of making the above plot
ggplot(filter(dailyDelays, n > 30), aes(time, meanDELAY)) + geom_vline(xintercept = 5:24, colour = "white", size = 2) + geom_point()
# add white lines on every hour, from hour 5-24. 

# GROUPWISE VARIABLES
#creating new variables w/in a group can be useful. 
# this can be done w/ a combination of aggregation and recyling like: zScore = (x - mean(x)) / sd(x)  OR w/window-functions
# Window Functions basically have 2 types; ranking & lead/lag(change between observations over time)
# For a great tutorial on window functions in dpylr see:
vignette("window-functions")

# get info on each individual plane, remove any planes that flew less than 30 times in the year
planes <- flights %>%
  filter(!is.na(ArrDelay)) %>%
  group_by(TailNum) %>%
  filter(n() > 30)
# create a zScore for arrival delay, and take only those plane w/a zScore more extreme than 5, which should be VERY rare
#This allows you to find flights that are particulary bad (high delays) for each plane (it's possible that a plane has no flights that are this bad)
#aggregate/recycle method
#Ranking
planes %>%
  mutate(z_delay = (ArrDelay - mean(ArrDelay)) / sd(ArrDelay)) %>%
  filter(z_delay > 5)
#window-function method. Remember, window functions are computed per-group
#Give me the top 5 least delayed flights for each plane. This is a different question than the aggregate/recycle question
planes %>% filter(min_rank(ArrDelay) < 5)

#For each plane, Give the 2 most delayed flights
planes %>% filter(dense_rank(desc(ArrDelay)) <= 2)
#This is the same as above, but starting from flights, however planes had extra filters, so this returns more planes
flights %>% group_by(TailNum) %>% filter(dense_rank(desc(ArrDelay)) <= 2)

# Lead/Lag: change between observations over time (lag() gives the previous observation)
# Compute the avg delay per day. What is the difference between the delay yesterday and today?
daily <- flights %>%
  mutate(DATE = paste(Year,Month,DayofMonth,sep="_")) %>%
  group_by(DATE) %>%
  summarise(num = n(), avgDelay = mean(DepDelay, na.rm = TRUE))
daily %>% mutate(avgDelay - lag(avgDelay), order_by = DATE ) #subtract today's delay from yesterday's delay. Do this for every day. Notice there will
# be an NA for the first row, b/c on day 1, there was no previous day to subtract
# order_by= lets lag() know what the previous entry was. lag() will just go row-by-row and do these calculations if 
# order_by isn't specified. Here, we say the previous entry should be the previous DATE, not the previous row
# Make sure DATE is properly formated as a date (posIX), mine isn't

#Check was there a change? x != lag(x)
# What is % change? (x - lag(x))/x
# What was the fold-change? x/lag(x)
# Was the Previous observation false, and is the current observation now true? !lag(x) & x

install.packages("nycflights13")
library(nycflights13)
data(airports)
library(ggplot2)
install.packages("maps")
library(maps)
# 2 TABLE VERBS: INTERACTIONS BETWEEN 2 DATA.FRAMES
# How can we show airport delays on a map? Need to connect to airports dataset
# Take a smaller subset of columns
location <- airports %>%
  select(Dest = faa,lat, lon) #change the column name from faa to dest; take that column plus lat and lon columns
#Take each flight, group by destination, calculate the average delay, sort them in decreasing order
delays <- flights %>% 
  group_by(Dest) %>%
  summarise(n = n(), AvgarrDelay = mean(ArrDelay, na.rm = TRUE)) %>%
  arrange(desc(AvgarrDelay)) %>%
  left_join(location) # This joins location TO delays ON/by 'Dest'
# Note, this failed at first b/c locations had 'dest', and delays had 'Dest'. I changed the name
# of the column in location above. Doing $> delays %>% left_join(location) // also failed to actually join()
# it would show the join on the console, but str(delays) revealed that the object didn't have the location-info added to it

#make map
delayMap <- ggplot(delays, aes(lon,lat)) +
  borders("state") + 
  geom_point(aes(color = AvgarrDelay), size = 5, alpha = .9) +
  scale_color_gradient2() +
  coord_quickmap()
#You could also break down the delays by season and plot, this would be a cool next task
