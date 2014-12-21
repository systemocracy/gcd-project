---
title: "README"
author: "Ricardo Quintana"
---

# run_analysis.R

This script will proccess the [Human Activity Recognition Using Smartphones Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the authors captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

The script will produce a tidy dataset consisting of only the mean and standard deviation of features measurements in the original dataset (check _UCI HAR Dataset/README.txt_ of original dataset for more details)

## Prerequisites
The prerequisites for running the script are:

+ Souce Data from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip must be uncompressed in the working directory. Directory *UCI HAR Dataset* must exist with the structure and content from the source zip file:
```
> list.files("UCI HAR Dataset/","*.txt")
[1] "activity_labels.txt" "features_info.txt"   "features.txt"       
[4] "README.txt"         
> list.files("UCI HAR Dataset/test","*.txt")
[1] "subject_test.txt" "X_test.txt"       "y_test.txt"      
> list.files("UCI HAR Dataset/train","*.txt")
[1] "subject_train.txt" "X_train.txt"       "y_train.txt" 
```
+ R package *reshape* must be installed and loadable in the working environment:
```
> library(reshape, logical.return=TRUE)
[1] TRUE
```

## Procedure
According to the requirements, the script does the following actions, also a brief explaination of how its achieved, check code/comments for more detail.

1. Merge the training and the test sets to create one data set: Using rbind/cbind.
2. Extract only the measurements on the mean and standard deviation for each measurement: Using grep and subset.
3. Use descriptive activity names to name the activities in the data set: Using colnames.
4. Appropriately label the data set with descriptive variable names: Using factor, levels.
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject: Using reshape package, melt and cast.

## Output
The script produces 2 output files to the working directory:

+ totalData.txt : Tidy dataset with all the mean and standard deviation values from the 
original source. As per completion of __step 4__ in the procedure. File contains 88 columns.
+ totalAveWide.txt : Reduced tidy dataset with the average of the values measured (mean and std as in totalData.txt) for each _activity_ of each _subjectID_. File contains 88 columns and 30 (subject) * 6 (activities) = 180 rows.

## Run
The script was tested from the R console by sourcing it in the local environment and from the darwin (OSX Mavericks) terminal as follows:

In R console:
```
> getwd()
[1] "/Volumes/Brutus/ricardo/Code/gcd-project"
> source("run_analysis.R")
>
```
In the OSX terminal:
```
mymac:gcd-project ricardo$ pwd
/Users/ricardo/Code/gcd-project
mymac:gcd-project ricardo$ R CMD BATCH run_analysis.R
mymac:gcd-project ricardo$ls -lhrt
drwxr-xr-x@ 9 ricardo  staff   306B Dec 13 11:58 UCI HAR Dataset
-rw-r--r--  1 ricardo  staff   3.7K Dec 21 22:52 run_analysis.R
-rw-r--r--  1 ricardo  staff    10M Dec 21 23:09 totalData.txt
-rw-r--r--  1 ricardo  staff   285K Dec 21 23:09 totalAveWide.txt
-rw-r--r--  1 ricardo  staff   4.6K Dec 21 23:09 run_analysis.Rout
```
Note that the _totalData.txt_ output file is about __10MB__. If the cript is run from the terminal, an additional file _run_analysis.Rout_ is produced.
