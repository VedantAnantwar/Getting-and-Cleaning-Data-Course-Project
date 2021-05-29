#DOwnloading and Unzipping the file
file_name<-"COursera_cleaning_data_CP.zip"
zip_url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
if(!file.exists(file_name)){
  download.file(zip_url,file_name,method="curl")
  
}
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

#Reading the files from given data set and storing it in an variable

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merging Of Data
X_merged<-rbind(x_test,x_train)
Y_merged<-rbind(y_test,y_train)
subject_merged<-rbind(subject_test,subject_train)
Merged<-cbind(subject_merged,Y_merged,X_merged)
#Using dplyr package 
library(dplyr)
Tidy_data<-select(Merged,subject,code,contains("mean"),contains("std"))
Tidy_data
Tidy_data$code <-activities[Tidy_data$code, 2]
names(Tidy_data)[2]="activity"
Tidy_data
#Appropriately labels the data set with descriptive variable names. 
names(Tidy_data)<-gsub("Acc", "Accelerometer", names(Tidy_data))
names(Tidy_data)<-gsub("Gyro", "Gyroscope", names(Tidy_data))
names(Tidy_data)<-gsub("BodyBody", "Body", names(Tidy_data))
names(Tidy_data)<-gsub("Mag", "Magnitude", names(Tidy_data))
names(Tidy_data)<-gsub("^t", "Time", names(Tidy_data))
names(Tidy_data)<-gsub("^f", "Frequency", names(Tidy_data))
names(Tidy_data)<-gsub("tBody", "TimeBody", names(Tidy_data))
names(Tidy_data)<-gsub("-mean()", "Mean", names(Tidy_data), ignore.case = TRUE)
names(Tidy_data)<-gsub("-std()", "STD", names(Tidy_data), ignore.case = TRUE)
names(Tidy_data)<-gsub("-freq()", "Frequency", names(Tidy_data), ignore.case = TRUE)
names(Tidy_data)<-gsub("angle", "Angle", names(Tidy_data))
names(Tidy_data)<-gsub("gravity", "Gravity", names(Tidy_data))
#From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
FinalData <- Tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
str(FinalData)