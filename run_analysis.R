## Course Project for Getting and Cleaning Data
# -----------------------------------------------------------------------------
# Program Name: run_analysis.R
#
# Requirements:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for
#    each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each
#    variable for each activity and each subject.
# -----------------------------------------------------------------------------

# Working directory
setwd('/Users/Pete/Personal/Coursera/Getting and Cleaning Data/Project/UCI HAR Dataset')

# -----------------------------------------------------------------------------
# Section 1. Merges the training and the test sets to create one data set.
# -----------------------------------------------------------------------------

# The files have been downloaded from:
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# and unzipped.
# The following file operations are done on unzipped files located in the 
# "UCI HAR Dataset" sub-folder. 

# Read reference files & assign column labels
features <- read.table('./features.txt')
activity_labels <- read.table('./activity_labels.txt'); colnames(activity_labels) <- c('ActivityNumber', 'Activity')
subject_train <- read.table('./train/subject_train.txt'); colnames(subject_train) <- c('Subject')
subject_test = read.table('./test/subject_test.txt'); colnames(subject_test) <- c('Subject')

# Read data files & assign column labels
featureCol <- features[,2]
x_train = read.table('./train/x_train.txt'); colnames(x_train) <- featureCol
y_train = read.table('./train/y_train.txt'); colnames(y_train) <- c('ActivityNumber')
x_test = read.table('./test/x_test.txt'); colnames(x_test) <- featureCol
y_test = read.table('./test/y_test.txt'); colnames(y_test) <- c('ActivityNumber')

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Strip out all columns but std()and mean() that appear at the end of the variable column name
a <- grepl("std[()].$",featureCol) | grepl("mean[()].$",featureCol)
# Subset the datasets for the identified standard deviation and mean variables
x_train <- x_train[a]
x_test <- x_test[a]

# 3. Uses descriptive activity names to name the activities in the data set
#    Create readable column names - names observed and appropriate replacements made
descriptiveColName <- colnames(x_train)
descriptiveColName <- gsub("^(t)","Time-",descriptiveColName)
descriptiveColName <- gsub("^(f)","Frequency-",descriptiveColName)
descriptiveColName <- gsub("BodyBody","Body",descriptiveColName)
descriptiveColName <- gsub("Mag","Magnitude",descriptiveColName)
descriptiveColName <- gsub("Acc","Acceleration",descriptiveColName)
descriptiveColName <- gsub("mean[(][)]","Mean",descriptiveColName)
descriptiveColName <- gsub("std[(][)]","StdDev",descriptiveColName)

# Replace column names with readable names
colnames(x_train) <- descriptiveColName
colnames(x_test) <- descriptiveColName


# 1. Merges the training and the test sets to create one data set.
#    Along with the respective reference data
mergedData = rbind(cbind(subject_train,y_train,x_train), cbind(subject_test,y_test,x_test))

# 5. Creates a second, independent tidy data set with the average of each variable
#    for each activity and each subject. 
#    Summarizing the mergedData table to include just the mean of each variable for
#    each activity and each subject
tidyData = aggregate(mergedData[,names(mergedData) != c('ActivityNumber','Subject')],by=list(ActivityNumber=mergedData$ActivityNumber,Subject = mergedData$Subject),mean)

# Remove duplicate columns created by aggregate for ActivityNumber and Subject
tidyData <- tidyData[,unique(colnames(tidyData))]

# 4. Appropriately labels the data set with descriptive activity names. 
# Merging the tidyData with activityType to include descriptive acitvity names
tidyData = merge(activity_labels, tidyData,by='ActivityNumber',all.x=TRUE)

# Sort data by Subject and Activity within Subject
tidyData <- tidyData[order(tidyData$Subject,tidyData$ActivityNumber),]

# Export the tidyData set.  Exclude row sequence to prevent column names from shifting by one
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t')


