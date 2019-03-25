setwd(dirname(file.choose()))
getwd()

#see the structure of the data   # The top of the data
subjecttest.dis <- read.csv("subject_test.csv", stringsAsFactors = FALSE)
str(subjecttest.dis)

xtest <- read.csv("x_test.csv", stringsAsFactors = FALSE)
str(xtest.dis)

ytest.dis <- read.csv("y_test.csv", stringsAsFactors = FALSE)
str(ytest.dis)

subjecttrain.dis <- read.csv("subject_train.csv", stringsAsFactors = FALSE)
str(subjecttrain.dis)

xtrain <- read.csv("x_train.csv", stringsAsFactors = FALSE)
str(xtrain.dis)

ytrain.dis <- read.csv("y_train.csv", stringsAsFactors = FALSE)
str(ytrain.dis)

## merge train and test set to createone data set

dataSet <- rbind(xtrain,xtest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Create a vector of only mean and std, use the vector to subset.
MeanStdOnly <- grep("mean()|std()", features[, 2]) 
dataSet <- dataSet[,MeanStdOnly]


# 4. Appropriately labels the data set with descriptive activity names.
# Create vector of "Clean" feature names by getting rid of "()" apply to the dataSet to rename labels.
CleanFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(dataSet) <- CleanFeatureNames[MeanStdOnly]

# combine test and train of subject data and activity data, give descriptive lables
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

# combine subject, activity, and mean and std only data set to create final data set.
dataSet <- cbind(subject,activity, dataSet)


# 3. Uses descriptive activity names to name the activities in the data set
# group the activity column of dataSet, re-name lable of levels with activity_levels, and apply it to dataSet.
act_group <- factor(dataSet$activity)
levels(act_group) <- activity_labels[,2]
dataSet$activity <- act_group


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# check if reshape2 package is installed
if (!"reshape2" %in% installed.packages()) {
  install.packages("reshape2")
}
library("reshape2")

# melt data to tall skinny data and cast means. Finally write the tidy data to the working directory as "tidy_data.txt"
baseData <- melt(dataSet,(id.vars=c("subject","activity")))
secondDataSet <- dcast(baseData, subject + activity ~ variable, mean)
names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
write.table(secondDataSet, "tidy_data.txt", sep = ",")

# remove all variables from the environment

rm(list=ls())
