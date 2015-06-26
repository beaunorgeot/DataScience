#Created by rpeng. Annotated by bnorgeot

## Has fine particle pollution in the U.S. decreased from 1999 to
## 2012?

## Read in data from 1999

pm0 <- read.table("RD_501_88101_1999-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
dim(pm0)
head(pm0)
#The column names are contained on the first line of the file. Read in that first line
cnames <- readLines("RD_501_88101_1999-0.txt", 1)
print(cnames)
# use strsplit() to split the line on the pipe symbol
cnames <- strsplit(cnames, "|", fixed = TRUE)
print(cnames)
#assign the names of the columns of the data frame to be the names from the list that you got
#make.names() is cool, it turns strings into valid column names (ie replaces spaces w/dots etc)
names(pm0) <- make.names(cnames[[1]])
head(pm0)
#pm2.5 is in the Sample.Value column
x0 <- pm0$Sample.Value
class(x0)
str(x0)
summary(x0)
#What % of the all of the pm2.5 values are na's?
mean(is.na(x0))  ## Are missing values important here?

## Read in data from 2012

pm1 <- read.table("RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "", nrow = 1304290)
names(pm1) <- make.names(cnames[[1]])
head(pm1)
dim(pm1)
x1 <- pm1$Sample.Value
class(x1)

## Five number summaries for both periods
summary(x1)
summary(x0)
mean(is.na(x1))  ## Are missing values important here?

## Make a boxplot of both 1999 and 2012
boxplot(x0, x1)
#View the data on a log scale
boxplot(log10(x0), log10(x1))

## Check negative values in 'x1'. This is a mass reading, can't have negative masses
summary(x1)
#logical vector, returning true if value is < 0
negative <- x1 < 0
sum(negative, na.rm = T) #count the number of values that are < 1. Remeber True =1, False =0
mean(negative, na.rm = T) #what proportion of all pm2.5 values are negative?
#Is there any pattern to when the negative values are happening?
dates <- pm1$Date #dates are stored as numerics here, which is kindof annoying
str(dates)
dates <- as.Date(as.character(dates), "%Y%m%d")
str(dates)
hist(dates, "month")  ## Check what's going on in months 1--6
hist(dates[negative], "month") #where do the negative values occur? Mostly in the winter. Not sure why?

#Exploring Changes at 1 monitor/location. This allows us to control for possible changes in monitor locations between the years

## Plot a subset for one monitor at both times

## Find a monitor for New York State that exists in both datasets
site0 <- unique(subset(pm0, State.Code == 36, c(County.Code, Site.ID))) #1999
site1 <- unique(subset(pm1, State.Code == 36, c(County.Code, Site.ID))) #2012
#Combine state and county code into 1 variable
site0 <- paste(site0[,1], site0[,2], sep = ".")
site1 <- paste(site1[,1], site1[,2], sep = ".")
str(site0)
str(site1)
both <- intersect(site0, site1) #Get the monitors that are in both the 1999 and 2012 datasets
print(both)

## Find how many observations available at each monitor. so we can choose 1 w/lots of good observations
pm0$county.site <- with(pm0, paste(County.Code, Site.ID, sep = "."))
pm1$county.site <- with(pm1, paste(County.Code, Site.ID, sep = "."))
cnt0 <- subset(pm0, State.Code == 36 & county.site %in% both) 
cnt1 <- subset(pm1, State.Code == 36 & county.site %in% both)
#Get number of observations for each monitor
sapply(split(cnt0, cnt0$county.site), nrow) 
sapply(split(cnt1, cnt1$county.site), nrow)

## Choose county 63 and site ID 2008
pm1sub <- subset(pm1, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
pm0sub <- subset(pm0, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
dim(pm1sub)
dim(pm0sub)

## Plot data for 2012 as a function of time
dates1 <- pm1sub$Date
x1sub <- pm1sub$Sample.Value
plot(dates1, x1sub)
dates1 <- as.Date(as.character(dates1), "%Y%m%d")
str(dates1)
plot(dates1, x1sub)

## Plot data for 1999
dates0 <- pm0sub$Date
dates0 <- as.Date(as.character(dates0), "%Y%m%d")
x0sub <- pm0sub$Sample.Value
plot(dates0, x0sub)

## Plot data for both years in same panel
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20)
abline(h = median(x0sub, na.rm = T)) #plot a horizontal line that is the median of the plots values
plot(dates1, x1sub, pch = 20)  ## Whoa! Different ranges
abline(h = median(x1sub, na.rm = T))

# Need to put both of the plots on the same range
## Find global range
rng <- range(x0sub, x1sub, na.rm = T) #get the combined range of the 2 data sets
rng
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20, ylim = rng) #now both y-ranges are the same
abline(h = median(x0sub, na.rm = T)) 
plot(dates1, x1sub, pch = 20, ylim = rng) #now both y-ranges are the same
abline(h = median(x1sub, na.rm = T))
# Not only are average pollution levels going down, but also variation has diminished quite a bit. Less very high pollution days

#What's the variation like on a state by state level?
## Show state-wide means and make a plot showing trend
head(pm0)
mn0 <- with(pm0, tapply(Sample.Value, State.Code, mean, na.rm = T)) #personally, I prefere dpylr. group_by(state) %>% summarize(mean = mean(Sample.Value))
str(mn0)
summary(mn0)
mn1 <- with(pm1, tapply(Sample.Value, State.Code, mean, na.rm = T))
str(mn1)

## Make separate data frames for states / years
# Again, I think dplyr has better ways to do this
d0 <- data.frame(state = names(mn0), mean = mn0)
d1 <- data.frame(state = names(mn1), mean = mn1)
mrg <- merge(d0, d1, by = "state")
dim(mrg)
head(mrg)

## Connect lines
par(mfrow = c(1, 1))
with(mrg, plot(rep(1, 52), mrg[, 2], xlim = c(.5, 2.5))) #plot 1999 data
with(mrg, points(rep(2, 52), mrg[, 3])) #add the 2012 data as points
segments(rep(1, 52), mrg[, 2], rep(2, 52), mrg[, 3]) #create lines connecting the state-value from 1999 to state-value for 2012