##################
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##################

rm(list=ls())
setwd(path)
path = '/Users/ouakira/Dropbox/Learning and Job/Coursera/Data Science/3. Getting and Cleaning Data/Assignments/UCI HAR Dataset/'

# 1. Merges the training and the test sets to create one data set.
ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain, ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)

names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

All.Data <- cbind(cbind(Subject, Activity), Features)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Sub.Data = All.Data[,names(All.Data)[grepl("mean\\(\\)|std\\(\\)", names(All.Data))]]

# 3. Uses descriptive activity names to name the activities in the data set.

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

All.Data$activity = factor(All.Data$activity,levels=activityLabels$V1,labels=activityLabels$V2)
head(All.Data$activity,50)

# 4. Appropriately labels the data set with descriptive variable names.

names(All.Data)<-gsub("^t", "time", names(All.Data))
names(All.Data)<-gsub("^f", "frequency", names(All.Data))
names(All.Data)<-gsub("Acc", "Accelerometer", names(All.Data))
names(All.Data)<-gsub("Gyro", "Gyroscope", names(All.Data))
names(All.Data)<-gsub("Mag", "Magnitude", names(All.Data))
names(All.Data)<-gsub("BodyBody", "Body", names(All.Data))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr);
SummaryData<-aggregate(. ~subject + activity, All.Data, mean)
SummaryData<-SummaryData[order(SummaryData$subject,SummaryData$activity),]
write.table(SummaryData, file = "tidydata.txt",row.name=FALSE)

names(SummaryData)

library(knitr)
knit2html("CodeBook.Rmd")





