# DataScience
Essential concepts and examples for doing/understanding data science

There are basically 2 types of files here:
1. scripts(.R) that meant as tutorials and contain very useful examples. The scripts aren't meant to be 'run', they are collections of run-able code
2. PDF docs that provide a combination of theory and examples

Scripts and PDF docs are meant to combined, used together.

I think that I break all of these topics up into categories:

* Dplyr
* ggplot2
* caret

What is each script good for?

* [Anova.HowTo.R](https://github.com/beaunorgeot/DataScience/blob/master/Anova.HowTo.R)
* [EPAemssions.R](https://github.com/beaunorgeot/DataScience/blob/master/EPAemssions.R): rds input file. dplr time series grouping, lead/lag where grouping order changed things in very important ways
* [Exponential_Dist_Analysis.Rmd](https://github.com/beaunorgeot/DataScience/blob/master/Exponential_Dist_Analysis.Rmd): generating random test data for particular distributions.Shapiro-Wilk Normality Test tests the Null Hypothesis that samples come from a Normal Distribution.
* [Hadley.dplyr.tutorial.R](https://github.com/beaunorgeot/DataScience/blob/master/Hadley.dplyr.tutorial.R)
* [MotorTrendAnalysis.Rmd](https://github.com/beaunorgeot/DataScience/blob/master/MotorTrendAnalysis.Rmd): Excellent example of going from raw data to h-testing, model building, and model diagnostics. Good example of how to do Rmd. Remember that the easiest way to knit to pdf on a mac is just to knit to html --> select open in browser --> download as pdf
* [baseRplotting.R](https://github.com/beaunorgeot/DataScience/blob/master/baseRplotting.R)
* [ggplot2.TutorialComplete.R](https://github.com/beaunorgeot/DataScience/blob/master/ggplot2.TutorialComplete.R)
* [run_analysis.R](https://github.com/beaunorgeot/DataScience/blob/master/run_analysis.R): Tidying data. Use reshape2's dcast and melt making both long-format and wide-format tidy data. cbind/rbind, grepl, turning variables into factors and setting labels. The [tidyMobileREADME.md](https://github.com/beaunorgeot/DataScience/blob/master/tidyMobileREADME.md) is a companion for this. 
* [ExploratoryAnalysis.R](https://github.com/beaunorgeot/DataScience/blob/master/ExploratoryAnalysis.R): rPeng's script w/my annotations. Mostly I don't like his use of R, but there are good examples of using read.table()Options, using a vector/list to assign names to columns in a df,counting na's and calculating their proportions in in column, working w/dates, arranging plots together in different ways, setting ranges from 2 different df's to be equal in a plot.

## Exploratory Analysis workflow
5 steps to evaluate 

1. exploratory analysis was done to get a quick understanding of the data and form a simple hypothesis.
2. Hypothesis test was performed to ensure that differences seen did not come from sampling error. 
3. Correlation Test, cor.test() was done to check for non-independence between possible additional confonding variables (such as weight and number of cylinders). 
4. Linear Regression was used to fit a model to the data to make predictions. Multiple models were examined to see which combination of predictors best explained and predicted mpg. Model assessment/choice and the importance of the interaction between the variable in step3 was assessed using a Liklihood Ratio Test, lrtest(). This could also been done using ANOVA
5. Finally, Regression Diagnostics were performed to check the validity of the model and verify assumptions. 


The elements in "Most Useful" are simply a snapshot of my condensed notes w/concepts and some examples that I feel are important from my google drive. The most update versions of these will always be in my drive. They exist here as an additional backup to make sure that I don't loose my prescious. 

[Favorite MarkDown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links)