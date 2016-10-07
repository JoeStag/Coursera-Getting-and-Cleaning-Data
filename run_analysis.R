#establish a download file name

downloadName <- "getdata_UCI_Dataset.zip"

#Check to see if data directory exists, if not create directory.
if(!file.exists("./data")){dir.create("./data")}

#Sets working directory to "./data"
setwd("./data")

#Check to see if dataset file exists in the directory
if(!file(downloadName)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url=fileURL, destfile=downloadName)
}

#Unzip file if dataset is not already unzipped
if(!file.exists("UCI HAR Dataset")){unzip(downloadName)}

#Sets working directory to UCI HAR Dataset
setwd("./UCI HAR Dataset/")

#Read in common data for use with both training and test data
features <- read.table("./features.txt", header = FALSE)
activityType <- read.table("./activity_labels.txt", header = FALSE)

#assign column names to activity type
colnames(activityType) <- c("activityID","activityType")

#Read in training data
trainSubject <- read.table("./train/subject_train.txt", header = FALSE)
trainData <- read.table("./train/X_train.txt", header = FALSE)
trainActivity <- read.table("./train/y_train.txt", header = FALSE)

#assign correct column names to training data
colnames(trainSubject) <- "subjectID"
colnames(trainData) <- features[,2]
colnames(trainActivity) <- "activityID"

#Merge trainData, trainActivity, and subjecttrain
trainData <- cbind(trainActivity,trainSubject,trainData)

#Read in test data
testSubject <- read.table("./test/subject_test.txt", header = FALSE)
testData <- read.table("./test/X_test.txt", header = FALSE)
testActivity <- read.table("./test/y_test.txt", header = FALSE)

#assign correct column names to test data
colnames(testSubject) <- "subjectID"
colnames(testData) <- features[,2]
colnames(testActivity) <- "activityID"

#Merge testData, testActivity, and testSubject
testData <- cbind(testActivity,testSubject,testData)

#combine train and test data
allData <- rbind(trainData, testData)
colNames <- colnames(allData)

#create a logical vector that reports TRUE only for the column names
# we want to use
logicColNames <- (grepl("activity..",colNames) | grepl("subject..",colNames) | 
                         grepl("-mean..",colNames) 
                 & !grepl("-meanFreq..",colNames) 
                 & !grepl("mean..-",colNames) | grepl("-std..",colNames) 
                 & !grepl("-std()..-",colNames))

finalData <- allData[logicColNames == TRUE]

finalData <- merge(finalData, activityType, by="activityID", all.x = TRUE)

colNames <- colnames(finalData)

#create descriptive column names
for(i in 1:length(colNames)){
        colNames[i] <- gsub("\\()","",colNames[i])
        colNames[i] <- gsub("Acc","Accelerometer",colNames[i])
        colNames[i] <- gsub("Mag","Magnitude",colNames[i])
        colNames[i] <- gsub("-std$","StdDev",colNames[i])
        colNames[i] <- gsub("-mean$","Mean",colNames[i])
        colNames[i] <- gsub("[Bb]ody[Bb]ody|[Bb]ody","Body",colNames[i])
        colNames[i] <- gsub("^t","Euclidean",colNames[i])
        colNames[i] <- gsub("^f","Fourier",colNames[i])
}

colnames(finalData) <- colNames

#remove Activity Type column

reducedFinal <- finalData[,names(finalData) != "activityType"]

tidyData <- aggregate(reducedFinal[,names(reducedFinal) 
                                   != c("activityID","subjectID")], 
                      by=list(activityID = reducedFinal$activityID,
                              subjectID = reducedFinal$subjectID),
                      mean)
tidyData <- merge(tidyData, activityType, by = "activityID", all.x = TRUE)

write.table(tidyData, "./tidyData.txt", row.names = FALSE, quote = TRUE)