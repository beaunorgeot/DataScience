
# I have a companion text for this script and the baseRplotting.R called "grapsh,plotting,ggplot2,clustering,etc" in my google docs
# upload these 3 together into a 'plotting repo' on git hub. 

library(ggplot2)
data(mpg)

#qplot(x-coord, y-coord, data.frame)
#view displacement vs hwy milage, w/different colors for each type of drive(4wl,front-wl,rear-whl)
#Here, color doesn't have quotes, it is assigned to a FACTOR variable
# Whenever you add color=someFACTOR you will get a new line for each factor(if geom= a line of some kind),
# or new bars, each w/a different color for each factor. If you have dots, you don't get anything new, the
# dots just change colors
qplot(displ,hwy,data=mpg,color = drv)
#add a statistical function. Smoothing shows the overall trend in the dataset, with a blue line,
# The 95% confidence intervals for the line are added in the grey zone. 
# The default method of smoothing is 'Lowess', to use just a simple linear regression set method = "lm"
#qplot(displ,hwy,data=mpg,color = drv, geom = c("point", "smooth"), method = "lm")
# In SIMPLEST TERMS: Loess gives curved lines(where appropriate), lm always gives straight line
# It's often good to do both lm-smooth and lowess-smooth side-by-side panels on the same data

# Since smooth is a line, it's added as a 'geom'. Since we've added a geom we've removed the default 
# plot of points, and need to add points as a part of the geom, makes sense, lines/points = shapes
qplot(displ,hwy,data=mpg, geom = c("point", "smooth"))
# Same as above, but now looking at trends for each factor.
qplot(displ,hwy,data=mpg,color = drv, geom = c("point", "smooth"))
#Note, "smooth" and "density" are essentially the same, I think, but smooth adds the confidence interval around the line

#If you only specify a single variable, qplot() will give you a histogram. Use fill instead of color
# Show counts of the different hwy mpg's broken up by type of drive. 
qplot(hwy, data = mpg, fill = drv)

#FACETS = panels. Break up your plots based on FACTOR variables
#facets takes a variable on the left, and a variable on the right, seperated by a ~
# The var on the right determines the columns of the panels,
#The var on the left determines the rows. Use a '.' when you only want 1 row
# factes = rows ~ columns
# Break the different factors in drive down into side-by-side plots
# Since there are 3 levels to the drv Factor, there will be 3 columns, each column w/1 of the factors(4wl,front-whl,rear-whl)
qplot(displ,hwy,data=mpg,facets = .~ drv)
#Same thing but w/ 3 rows(1 for each drv type) and 1 column(.)
qplot(displ,hwy,data=mpg,facets = drv~.)
#make panels of histograms, w/ 3 rows(1 for each drv type) and 1 column(.), looking at 
# counts of hwy mpg for each drv type
qplot(hwy,data=mpg,facets = drv~.,binwidth=2)

# GGPLOT2
#g <- ggplot(data.frame, aes(x-coord, y-coord))  # doesn't actually plot/print anything
# summary(g) # will tell you all about your plot-object
# g + geom_point() will actually print/plot
# p <- g + geom_point() will save the plot. print(p) will print it to screen
# g + geom_point() + geom_smooth() add a smoothing layer.  # geom_smooth(method= "lm") if want lm instead of lowess
# g + facet_grid(rows ~ columns)  // example: facet_grid(. ~ bmicat)
qplot(logpm25, NocturnalSympt, data = maacs, facets = . ~ bmicat, geom =c("point", "smooth"), method = "lm")
# recreate, building up in layers
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
g + geom_point() + geom_smooth() # OR:::  g + geom_point() + geom_smooth(method = "lm”)
# full recreation of the qplot() above
g + geom_point() + facet_grid(. ~ bmicat) + geom_smooth(method = "lm")

#MODIFYING AESTHETICS: There's a difference between aesthetics that are constants and those that are data variables
# size for the size of the points. alpha for the transparency
# for constant values, just add the color argument. The color here is constant. It will never change
g + geom_point(color = "steelblue",size = 4, alpha = 1/2)
# for a data variable, you need an aes() argument
g + geom_point(aes(color = bmicat),size = 4, alpha = 1/2) #where bmicat is a Factor Variable

#MODIFYING LABELS
# You can Use labs() and specify; title = "", or x= "", OR you could use a combination of
# ggtitle(), xlab(), ylab(), which do the exact same thing
g + geom_point(aes(color = bmicat)) + labs(title = "MAACS Cohort") + labs(x = expression("log "* PM[2.5]), y = "Nocturnal Symptoms")
# this: "log "* PM[2.5]) is cool and produces the 2.5 as a subscript to PM

# CUSTOMIZING THE SMOOTH
g + geom_point(aes(color = bmicat), size = 2, alpha = 1/2) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)
# on geom_smooth(): size= for the thickness of the line, linetype= for smooth vs dashed line (3 is dotted), se=FALSE to turn off the confidence interval

# CHANGING THE THEME
g + geom_point(aes(color = bmicat)) + theme_bw(base_family = "Times")
# theme_bw() gives the black/white theme, with no grey background and white lines. base_family = "Font Type You Want". The font
# for the axis-labels, legend, and numeric ticks along the axis' all change when you change base_family
# base_size=12 by default. Change the font size by changing this value

# CHANGING AXIS LIMITS
# You have to be careful w/ggplot and axis limits. If you JUST changes the limits, ggplot will 
# subset the data to only include the values that fall w/in those limits
# By default ggplot will stretch the limits to include a view of all of data, which may not be what you want if you have outliers

# Here's some made up data w/an outlier to fuck w/the axis limits
testdat <- data.frame(x = 1:100, y = rnorm(100))
testdat[50,2] <- 100 ## Outlier added!
g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line() # This plot includes the outlier, which means you no longer get any details about 99% of the data
g + geom_line() + ylim(-3, 3) # Danger! This plot has completely removed the outlier!
g + geom_line() + coord_cartesian(ylim = c(-3, 3)) # This is what you want. The outlier is included in the plot, but it's out of scope. You can't see it
# You haven't lost the detail for the majority of the points


# A COMPLEX EXAMPLE
# TURN A CONTINUOUS VARIABLE INTO A CATEGORICAL VARIABLE using cut(). You can't condition on a continous variable, b/c then there would be an infinite # of plots
# cut() literally cuts the data into a series of ranges
# In this example turn NO2 from continous to categorical, so we can look at how Nocturnal symptoms vary by BMI and NO2
# So we're looking at how 1 var (the outcome, Nocturnal symptoms) varies by 2 variables(the predictors, both BMI and NO2)

#split NO2 into Tertiles (3 groups)
## Calculate the deciles of the data using the quantile() function. set length = NumberGroupsYouWant + 1. Want 3 groups, length =4
> cutpoints <- quantile(maacs$logno2_new, seq(0, 1, length = 4), na.rm = TRUE)
# To be clear, this will give 3 groups. First group is the bottom 33% of the data. Last group is the top 33% of the data
## Cut the data at the deciles and create a new factor variable. cut() replaces each original data point w/the categorical value for the group it falls into
# I probably should have added the 'labels' argument to cut() below, to give names for each level/group
> maacs$no2dec <- cut(maacs$logno2_new, cutpoints)
## See the levels of the newly created factor variable
> levels(maacs$no2dec)
#PLOT all this
## Setup ggplot with data frame
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
## Add layers
g + geom_point(alpha = 1/3) # add points and make them some-what transparent
+ facet_wrap(bmicat ~ no2dec, nrow = 2, ncol = 4) # make panels
+ geom_smooth(method="lm", se=FALSE, col="steelblue") # add smoother
+ theme_bw(base_family = "Avenir", base_size = 10) # change theme, change font, use a smaller font than normal
+ labs(x = expression("log " * PM[2.5]) # add labels
+ labs(y = "Nocturnal Symptoms") # more labels
+ labs(title = "MAACS Cohort") # final label
# NOTE: This produces 8 total plots. There are 2 categories of BMI (normal,fat) and 3 categories that we made of NO2
# 2*3 = 6, which is the expected number of plots. 1plot for the bottom 33% of NO2  on the x-axis vs number of 
# nocturnal symptoms on the y-axis, showing only normalBMI. plot2 for same, but only fatBMI. Then same pattern for middle 33% NO2
# Then same for top 33% NO2
# The extra 2 plots come from missing data, you can see NA in the title of these plots. They include information on the number of 
# symptoms oberserved, however no NO2 data was recorded (there's na's) for these data points

# MORE EXAMPLES
data(airquality)
#examining how the relationship between ozone and wind speed varies across each month
airquality = transform(airquality, Month = factor(Month)) #convert month to a factor
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

#Faceting
#If you have data, say on emissions from multiple cities, to compare them side by side you can:
myplot + facet_grid(. ~ City)
# See my EPAemssions.R, last plot for an example box plot of LA vs Balt.