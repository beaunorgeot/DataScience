# tidyMobileData
Take disorganized data from multiple files and combine into single data-set in both long and wide data formats.

Data sets came from UC Irvine's  "Human Activity Recognition Using Smartphones" experiments. See their home page: [Smart Phone Experiment](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  Data sets were combined into a single data frame containing average values for each of the measurements. 

Replication of results simply requires the original data set and a single script that I have created [r_analysis.R](https://github.com/beaunorgeot/tidyMobileData/blob/master/run_analysis.R).

##Steps to perform tidying
**Setup**

Get the data. Put the relevant data files in the same directory as the script(r_analysis.R). Run the script.  

1. Download data [Zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) to your working directory.
	- Planning to download the data using something other than R and don't know where your working directory is?
	- Open R and type:
	getwd()
2. Unzip the data file
4. Move my script,run_analysis.R, to your working directory.
5. Install the 'data.table' & 'reshape2' packages
5. Open R and run_analysis.R



**The output of the R script are two tidy data sets** 

	- longTidy.csv
	- wideTidy.csv

There are many times when long data is better for analysis, and some times were wide data is better. In gerenal, long is more useful, but wide is more intuitive for humans to look at. See this article for some more info: [Long vs Wide Data](http://seananderson.ca/2013/10/19/reshape.html)

Since we haven't decided what kind of analysis we'll be using our data for downstream, it's nice to have the data in both formats.


You can read more about the data and the analysis in the code book.


