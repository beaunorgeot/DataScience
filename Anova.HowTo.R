
#ANOVA

#Read in the data
#Example was from a data table w/2 variables relating to oxygen contents in streams. 
#"DO" is numeric(continuous) and is the quantity of Disolved Oxygen
#Stream is categorical(and factor) and is the name of the stream that the measurement was taken from
data1 <- read.csv("streamData.csv")

#Make a side by side box plot of the data. Give yourself a quick look at the data to get a feel for the levels of DO in the different streams
boxplot(data1$DO ~ data1$Stream)

#Create an ANOVA table. Test: Are the DO levels statistically different in each/any of these creeks
# Here using aov() --> Only works if all variables have the same # obersrvations
# There's also anova() --> This test is the one to use if you have unequal observations. IE there are more
# obersvations/recordings of DO for stream1 than stream2. Or they all have enqual # of observations etc
#aov(variableOfInterest ~ GroupNames)
#aov(variablesThatCameAsResponses ~ VariablesThatGeneratedOrOwnTheResponses)
do2.aov <- aov(data1$DO ~ data1$Stream)
summary(do2.aov)
#Here you get overview. F-value is straight forward. Pr(>F) is the p.value for that F.value

#Conduct a Tukeys multiple comparison procedure.
#IF differences exist between the GroupNames, then a Tukey's HSD test is a common method to determine WHERE the
# Differences are.
tukeyHSD(do2.aov)
#The far-right column of the output is "p adj" which is the p-value for each pair-wise comparison of means
# (EG: row1 will be stream1 ~ stream2, comparison of means, row2 might be stream1 ~ stream3 etc)
# Low p.values here mean statistical differences (ie p.value < .05) exist, high p.values mean no difference

# TESTING FOR CONSTANT VARIANCE 
#You can test to see if the groups differ in variance from each other w/a Bartlett test and/or a Levene test
# Question: Do these groups have different standard deviations from each other. 
# The Null H is that all variances are the same/equal. low p.value mean reject Null H
#bartlett.test(responseVariableY ~ Categories)
bartlett.test(DO ~ Stream, data = data1)

#Levene's test is an ANOVA on the absolute value of the residuals.
do2.levene.data <- abs(do2.aov$residuals)
do2.levene <- aov(do2.levene.data ~ data1$Stream)
summary(do2.levene)