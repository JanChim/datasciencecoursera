setwd(dirname(file.choose()))
getwd()

#see the structure of the data   # The top of the data
subject_test <- read.table("subject_test.csv", stringsAsFactors = FALSE)
str(subject_test)

x_test <- read.table("x_test.csv", stringsAsFactors = FALSE)
str(x_test)

y_test <- read.table("y_test.csv", stringsAsFactors = FALSE)
str(y_test)

subject_train <- read.table("subject_train.csv", stringsAsFactors = FALSE)
str(subject_train)

x_train <- read.table("x_train.csv", stringsAsFactors = FALSE)
str(x_train)

y_train <- read.table("y_train.csv", stringsAsFactors = FALSE)
str(y_train)

## merge train and test set to createone data set

test <- cbind(subject_test,x_test, y_test)
train <- cbind(subject_train, x_train, y_train)
merged <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Create a vector of only mean and std, use the vector to subset.
meanstd <- grepl("mean\\(\\)", names(merged)) |
  grep("std\\(\\)", names(merged))
meanstd[1:2] <- TRUE

## to exclude columns that aren't needed
merged <- merged[, meanstd]

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately label data set with descriptive activity names.
# group the activity column of dataSet, re-name lable of levels with activity_levels, and apply it to dataSet.
act_group <- factor(merged$activity, 
                    labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
levels(act_group)
merged$activity <- act_group

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library("reshape2")

# melt data to tall skinny data and cast means. Finally write the tidy data to the working directory as "clean_data.csv"
averages <- melt(merged, id=c("subjectID", "activity"))
cleandata <- dcast(averages, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(cleandata, "clean_data.csv", row.names=FALSE)

# remove all variables from the environment

rm(list=ls())
