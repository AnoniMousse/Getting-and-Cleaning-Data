### This R scipt will fulfill the requirements of the class. Permission is granted to others to use this software
### for their own purposes. THIS SOFTWARE (R SCRIPT)  COMES WITH NO WARRANTY OF ANY SORT. 

## Load libraries required to execute the script
library(data.table)
library(Jmisc)
library(dplyr)

## I decided to first work on all the training set files and then the test set files.
## In this section I am working on the training set files.
## I will first process the subject (volunteer) ID file, followed by the activity ID 
## file, and finally the actual data file (the various readings). I will 
## merge them all by mathing the row positions.

## Read subject ID text file into data frame
SubjTrain <- read.table("subject_train.txt")

## Change name of v1 to a descriptive label
names(SubjTrain)[1] <- 'subjectID' 

## Create an explicit variable to store the sequential row position as 
## an integer for merging
SubjTrain$seqID <- as.integer(row.names(SubjTrain))

##
## Now work on file containing activity labels
##
## read activity text file into data frame
ActivityTrain <- read.table("y_train.txt")

## change name of v1 to a descritive name
names(ActivityTrain)[1] <- 'activity' 

## Create an explicit variable to store the sequential row position as 
## an integer for merging
ActivityTrain$seqID <- as.integer(row.names(ActivityTrain))

## Merge subject IDs and activity IDs into one file
SubjActTrain <- merge(SubjTrain, ActivityTrain, by="seqID")

## Although the group to which the data were assigned (train vs test) is not relevant
## for the current exercise, I like to keep that information for future analyses
## such as trying to predict the activity from the features (a classification problem)

## Add training set identifier
SubjActTrain <- addCol(SubjActTrain, group = "train")

## Change group from a list to a character vector
SubjActTrain$group <- as.character(SubjActTrain$group)

## This next part reads and processes the movement data (features)
## Read training group performance data into data frame
## THIS MAY TAKE A WHILE...
DFTrain <- read.table("X_train.txt")

## Read the feature names into data frame (to be used as column/variable names)
features <- read.table("features.txt")  

## Drop first variable (sequence number) and transpose to row array
featureNames <- t(features[-1])         

## Attach column names to top of performance data
colnames(DFTrain) <- featureNames 

## Retain only columns with -mean() or -std() in the variable name
DTrainFin <- DFTrain[, grep("-mean[[:punct:]]|-std[[:punct:]]",names(DFTrain))]

## Remove parentheses and dashes from column names
colnames(DTrainFin) <- gsub(pattern = "\\(|)", replacement = "", x = names(DTrainFin))
colnames(DTrainFin) <- gsub(pattern = "\\-", replacement = "", x = names(DTrainFin))

## Create an explicit variable to store the sequential row position as 
## an integer for merging
DTrainFin$seqID <- as.integer(row.names(DTrainFin))

## merge labels data file with activity file to create a tidy data file for the training data
SubjActFeatTrain <- merge(SubjActTrain, DTrainFin, by="seqID")


###############################################
## Repeat the above processing for the test set
###############################################

## Read subject ID text file into data frame
SubjTest <- read.table("subject_test.txt")

## Change name of v1 to a descriptive label
names(SubjTest)[1] <- 'subjectID' 

## Create an explicit variable to store the sequential row position as 
## an integer for merging
SubjTest$seqID <- as.integer(row.names(SubjTest))

##
## Now work on file containing activity labels
##
## read activity text file into data frame
ActivityTest <- read.table("y_test.txt")

## change name of v1 to a descriptive name
names(ActivityTest)[1] <- 'activity'

## Create an explicit variable to store the sequential row position as 
## an integer for merging
ActivityTest$seqID <- as.integer(row.names(ActivityTest))

## Merge subject IDs and activity IDs into one file
SubjActTest <- merge(SubjTest, ActivityTest, by="seqID")

## Add training set identifier
SubjActTest <- addCol(SubjActTest, group = "test")

## Change group from a list to a character vector
SubjActTest$group <- as.character(SubjActTest$group)

####
### Read test set behavioral/performance data
####
DFTest <- read.table("X_test.txt")  ##read Testing group performance data into data frame

## Attach column names to top of performance data
colnames(DFTest) <- featureNames  ## attach column names to top of performance data

## Retain only columns with -mean() or -std() in the variable name
DTestFin <- DFTest[, grep("-mean[[:punct:]]|-std[[:punct:]]",names(DFTest))]

## Remove parentheses and dashes from column names
colnames(DTestFin) <- gsub(pattern = "\\(|)", replacement = "", x = names(DTestFin))
colnames(DTestFin) <- gsub(pattern = "\\-", replacement = "", x = names(DTestFin))

## Create an explicit variable to store the sequential row position as 
## an integer for merging
DTestFin$seqID <- as.integer(row.names(DTestFin))

## Merge labels file with activity file to create a tidy data file for the test data
SubjActFeatTest <- merge(SubjActTest, DTestFin, by="seqID")

# Create a tidy data file for the Training and Test data
FinalData <-rbind(SubjActFeatTrain,SubjActFeatTest)

## Convert activity to a character vector
FinalData$activity <- as.character(FinalData$activity)
## Replace activity number labels with descriptive labels
## this meets requirement 3: "Uses descriptive activity names to name the activities in the data set"
FinalData$activity[FinalData$activity == "1"] <- "WALKING"
FinalData$activity[FinalData$activity == "2"] <- "WALKING_UPSTAIRS"
FinalData$activity[FinalData$activity == "3"] <- "WALKING_DOWNSTAIRS"
FinalData$activity[FinalData$activity == "4"] <- "SITTING"
FinalData$activity[FinalData$activity == "5"] <- "STANDING"
FinalData$activity[FinalData$activity == "6"] <- "LAYING"
## convert activity to factor vector to be used in the rest of the scripts below
FinalData$activity <- as.factor(FinalData$activity)

## Although not requifred by this exercise, Write tidy data set created up to this point for
## possible future analysis
write.csv(FinalData,"./data/FinalData.csv",row.names = FALSE)

## The rest of the scripts meet requirement 5 "From the data set in step 4, 
##   creates a second, independent tidy data set with the average of each variable
##   for each activity and each subject."

## Remove seqID and group from data set since they will not be in the aggregated data (means)
penultimate <- select(FinalData, -seqID, -group)

## Use subjectID and activity as the grouping variables
penultimate <- penultimate %>% group_by(subjectID,activity)

## Compute the mean of each activity within subject (volunteer) and put the data into
## a data frame named TidyData
TidyData <- penultimate %>% summarise_each(funs(mean))

## Write final TidyData file to disk in a subdirectory of the working directory called "data".
write.table(TidyData,"./data/TidyData.txt",row.names = FALSE)
