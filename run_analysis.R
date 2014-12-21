# This script processes the data from 'sourcefile' and creates a tidy dataset
# containing only the mean and std values for each measurement of the original source.
# Produces 2 output files to working directory:
# totalData.txt : Contains a tidy dataset with all the mean and std values from the 
# original source.
# totalAveWide.txt : Contains a reduced tidy dataset with the average of the values 
# measured (mean and std as in totalData.txt) for each activity of each subjectID. 

# Prerequisites: 
# Unzipped source file in 'sourcefile' must be uncompressed in the current
# working directory.
# Package reshape must be installed, and availble in the working environment.

# Set url for source zip file. Not loaded directly as loading varies by platform.
sourcefile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

train_files <- c("subject_train.txt","X_train.txt","y_train.txt")
test_files <- c("subject_test.txt","X_test.txt","y_test.txt" )
files <- c("activity_labels.txt","features_info.txt","features.txt","Readme.txt")

# Check if source data folder exists. We assume all files are inside, no further checks
if (!file.exists("UCI HAR Dataset")) {
    stop("Source Data is missing from workspace directory")
}

# Read the activiy_labels.txt (levels used in ytrain and xtrain files) 
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
# Read the features.txt variable names (for xtrain and xtest files)
features<-read.table("UCI HAR Dataset/features.txt")

# Read the test files
subtest<-read.table("UCI HAR Dataset/test/subject_test.txt")
xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")

# Read the train files
subtrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")

# Fix column names
colnames(xtest)<-features[,2]
colnames(xtrain)<-features[,2]
colnames(subtest)<-"subjectID"
colnames(subtrain)<-"subjectID"
colnames(ytest)<-"activity"
colnames(ytrain)<-"activity"

# Create a vector called 'selected' with all the indices of means and std 
# values within xtest/xtrain data.frames
selected <- grep("std|mean", features[,2], ignore.case=T)

# Subset xtest and xtrain data.frames to contain only the selected values
xtest<-subset(xtest, select = selected)
xtrain<-subset(xtrain, select = selected)

# Combine actions to get a single data.frame
# Combine xtest and xtrain in a single data.frame 'xtotal' using rbind
xtotal <- rbind (xtest, xtrain)
# Combine ytest and ytrain in a single data.frame 'ytotal' using rbind
ytotal <- rbind (ytest, ytrain)
# Combine subtest and subtrain in a single data.frame 'subtotal' using rbind
subtotal <- rbind (subtest, subtrain)

# Combine subtotal, ytotal, xtotal in a single data.frame 'totaldata' using cbind
# could be optimized to use less memory (data.frames)
totaldata <- cbind (subtotal,ytotal,xtotal)

# Set activity column as a factor variable
totaldata$activity <- factor(totaldata$activity)
# Set the levels of activity variable to those listed in activity_labels
levels(totaldata$activity) <- activity_labels[,2]
# Output totaldata tidy set to totalData.txt
write.table(totaldata,file="totalData.txt",row.names=FALSE)


library(reshape)
# Melt totaldata to get a skinny dataframe with subjectID and activity as ID vars.
totalMolten <- melt(totaldata, id.vars = c("subjectID", "activity"))
# Cast the Molten dataframe with an aggregate function 'mean' to create an average
# of the measured values for each activity for each subjectID
totalWide<- cast(totalMolten, subjectID + activity ~ variable, mean)
# Write the output to a file
write.table(totalWide,file="totalAveWide.txt",row.names=FALSE)
