
#The overall goal of this assignment is to explore the National Emissions Inventory database and
#see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008.
# zip file of data:https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Note that when I unzipped this file, I could not see the files in the dir

library(dplyr)
library(ggplot2)

# load the emissions data. This file contains a data frame with all of the 
# PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains 
# number of tons of PM2.5 emitted from a specific type of source for the entire year
NEI <- readRDS("summarySCC_PM25.rds")
#fips: A five-digit number (represented as a string) indicating the U.S. county
#SCC: The name of the source as indicated by a digit string (see source code classification table)
#Pollutant: A string indicating the pollutant
#Emissions: Amount of PM2.5 emitted, in tons
#type: The type of source (point, non-point, on-road, or non-road)
#year: The year of emissions recorded

# load the doc that maps from the SCC digit strings in the Emissions table 
# to the actual name of the PM2.5 source.
SCC <- readRDS("Source_Classification_Code.rds")

#1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, 
# make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
yearlyEm <- NEI %>%
  group_by(year) %>%
  summarise(n = n(), TotalEmit = sum(Emissions))
yearlyEm$TotalEmit # Here are the total emission values for each year
#Here's the right way to do this using ggplot2
qplot(as.factor(year),TotalEmit,data=yearlyEm, geom= "histogram", stat="identity", xlab="Year", ylab="Total Emissions per Year (Tons)", 
      main = "USA Yearly Emissions")
#Here's the dumb way
plot(yearlyEm$year,yearlyEm$TotalEmit, type = "o",xlab="Year", ylab="Total Emissions per Year (Tons)", 
     main = "USA Yearly Emissions" )
dev.copy(png, file = "plot1.png", width=400, height=400)  ## Copy my plot to a PNG file
dev.off()
#ANSWER= Yes, total emissions have been decreasing yearly.  

#2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.
BaltMD <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(n = n(), TotalEmit = sum(Emissions))

#Here's the right way to do this using ggplot2
qplot(as.factor(year),TotalEmit,data=BaltMD, geom= "histogram", stat="identity", xlab="Year", ylab="Total Emissions per Year (Tons)", 
      main = "Yearly Emissions in Baltimore, Maryland")
#Here's the dumb way
plot(BaltMD$year,BaltMD$TotalEmit, type = "o",xlab="Year", ylab="Total Emissions per Year (Tons)", 
     main = "UYearly Emissions in Baltimore, Maryland" )
dev.copy(png, file = "plot2.png", width=400, height=400)  ## Copy my plot to a PNG file
dev.off()
#ANSWER = The total emissions have decreased, however there was a large spike in 2005

#3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
NEI$type <- as.factor(NEI$type) # turn type into a factor
yearlyType <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year,type) %>%
  summarise(TotalEmit = sum(Emissions))
#plot
byType <- ggplot(yearlyType, aes(year, TotalEmit))
byType + geom_line(aes(color = type),size = 2, alpha = 1/2) + labs(title="Total Yearly Emissions\nin Baltimore by Type", x = "Year", y= "Total Emissions per Year (Tons)") + geom_point(size=2, shape=21, fill="white")
ggsave("TypeEmissions.png", width=3, height =3)
#ANSWER= All types except for 'point' saw a decrease in total emissions. Point type has seen an overall increase in total emissions

#4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
coal <- SCC %>% filter(grepl("Coal",Short.Name)) # Get only the codes that correspond to coal
coal1<- left_join(NEI,coal) #join all x that match y. All observatios from NEI that have SCC that matches 'coal'.
coal2 <- coal1 %>%
  group_by(year) %>%
  summarise(TotalEmit = sum(Emissions))

pcoal <- ggplot(coal2, aes(year, TotalEmit))
pcoal + geom_line(color = "steelblue") + geom_point( size=4, shape=21,fill="white") + labs(title="Total Yearly Emissions\nfrom Coal Sources", x = "Year", y= "Total Emissions per Year (Tons)")
ggsave("CoalEmissions.png")
#ANSWER= Emissions from coal sources have been approximately cut in half

#5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
vehics <- NEI %>%
  filter(type == "ON-ROAD" & fips == "24510") %>%
  group_by(year) %>%
  summarise(TotalEmit = sum(Emissions))

vplot <- ggplot(vehics, aes(year, TotalEmit))
vplot + geom_line(color = "steelblue") + geom_point( size=4, shape=21,fill="white") + labs(title="Yearly Emissions\nin BaltimoreMD\nfrom Motor Vehicles", x = "Year", y= "Total Emissions per Year (Tons)")
ggsave("VehicalEmissions.png")
#ANSWER = Emissions have decreased from motor vehicles

#6. Compare emissions from motor vehicle sources in Baltimore City with emissions from 
# motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
vehics2 <- NEI %>%
  filter(type == "ON-ROAD") %>%
  filter(fips == "24510" | fips == "06037") %>%
  mutate(fips = ifelse(fips == "24510", "Baltimore", "LA")) %>%
  group_by(year,fips) %>%
  summarise(TotalEmit = sum(Emissions))

compare <- ggplot(vehics2, aes(year,TotalEmit))
compare + geom_line(aes(color = fips)) + geom_point( size=4, shape=21,fill="white") + labs(title="Yearly Motor Vehicle Emissions\nBaltimore vs LA", x = "Year", y= "Total Emissions per Year (Tons)")
ggsave("TotalLAvs")

#ANSWER= Baltimore has decreased emissions each reporting period. LA has had a net increase in emissions from
# 2000 to 2008

vehics3 <- NEI %>%
  filter(type == "ON-ROAD") %>%
  filter(fips == "24510" | fips == "06037") %>%
  mutate(fips = ifelse(fips == "24510", "Baltimore", "LA")) %>%
  group_by(fips,year) %>%
  summarise(TotalEmit = sum(Emissions)) %>%
  mutate(change = (TotalEmit - lag(TotalEmit)))

compare1 <- ggplot(vehics3, aes(year,change))
compare1 + geom_line(aes(color = fips)) + geom_point( size=4, shape=21,fill="white") + labs(title="Yearly Motor Vehicle Emission Changes\nBaltimore vs LA", x = "Year", y= "Emission Change per Year (Tons)")
ggsave("ChangeLAvsBalt.png")

#Here's a method for making side by side box plot comparisons of LA vs Baltimore
#notice the facet_grid() instead of facet_wrap()
ggplot(data = plot_data, aes(x = year, y = Emissions)) + geom_bar(aes(fill = year),stat = "identity") + guides(fill = F) + ggtitle('Comparison of Motor Vehicle Emissions in LA and Baltimore') + ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position = 'none') + facet_grid(. ~ City) + geom_text(aes(label = round(Emissions, 0), size = 1, hjust = 0.5, vjust = -1))