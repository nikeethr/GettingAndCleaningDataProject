library(data.table)
library(dplyr)

#Download file

#setwd("") #- replace "" with working directory
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL, "./data.zip")

#UCI HAR Dataset path
pathIn <- file.path(getwd(), "UCI HAR Dataset")

#Get labels
activityLabels <- fread(file.path(pathIn, "activity_labels.txt"))
featureVariables <- fread(file.path(pathIn, "features.txt"))

#Grab data, activity and subject from training and test folders
trainingData <- data.table(read.table(file.path(pathIn, "train", "X_train.txt")))
trainingSubject <- data.table(read.table(file.path(pathIn, "train", "subject_train.txt")))
trainingActivity <- data.table(read.table(file.path(pathIn, "train", "y_train.txt")))
    
testData <- data.table(read.table(file.path(pathIn, "test", "X_test.txt")))
testSubject <- data.table(read.table(file.path(pathIn, "test", "subject_test.txt")))
testActivity <- data.table(read.table(file.path(pathIn, "test", "y_test.txt")))

#Note test subject IDs and training subject IDs are unique
unique(testSubject)
unique(trainingSubject)
match(testSubject, trainingSubject)

#Set names
SubjectID = "SubjectID"
ActivityID = "ActivityID"
FeatureID = "FeatureID"

setnames(featureVariables, c("V1", "V2"), c(FeatureID, "FeatureName"))
setnames(activityLabels,  c("V1", "V2"), c(ActivityID, "ActivityLabel"))

setnames(trainingData, featureVariables$FeatureName)
setnames(trainingSubject, SubjectID)
setnames(trainingActivity, ActivityID)

setnames(testData, featureVariables$FeatureName)
setnames(testSubject, SubjectID)
setnames(testActivity, ActivityID)

#Combine data
trainingDatatemp <- cbind(trainingSubject, trainingActivity, trainingData)
testDatatemp <- cbind(testSubject, testActivity, testData)
dataset <- rbind(trainingDatatemp, testDatatemp)

#Extract mean and standard dev
featureNamesMeanStd <- featureVariables$FeatureName[grep("mean\\(\\)|std\\(\\)",featureVariables$FeatureName)]
keepColumns <- c(SubjectID, ActivityID, featureNamesMeanStd)
datasetMeanStd <- dataset[,keepColumns,with=FALSE]

#Label Activities
datasetMeanStd$Activity <- factor(datasetMeanStd$ActivityID,levels = activityLabels$ActivityID,labels = activityLabels$ActivityLabel)

#Melt by feature and take average
dataTidy <- melt(datasetMeanStd, id=c("SubjectID","Activity"), measure.vars = featureNamesMeanStd, variable.name = "FeatureName", value.name = "FeatureValue")
dataTidy <- dataTidy[, list(FeatureAverage=mean(FeatureValue)), by = c("SubjectID","Activity","FeatureName")]

#Split out type of transformation i.e. mean() or std() in another column, since all variables have this, and may be useful to select just means or std in the future
#Could potentially have done this in an earlier step?
featureStatistic <- dataTidy$FeatureName
featureStatistic <- gsub(".*mean\\(\\).*", "mean", featureStatistic)
featureStatistic <- gsub(".*std\\(\\).*", "std", featureStatistic)
featureStatistic <- as.factor(featureStatistic)
dataTidy$FeatureStatistic <- featureStatistic

#Get rid of -mean() and -std()
tempFeatureName <- dataTidy$FeatureName
tempFeatureName <- gsub("-mean\\(\\)|-std\\(\\)","",tempFeatureName)
featureNamesBefore <- tempFeatureName
#There are some weird variables with repetition e.g. 'BodyBody' in 'fBodyBodyAccJerkMag'
#There are no signs of fBodyAccJerkMag so this is potentially a mistake, remove the duplicate 'Body'

#uncomment to try the following:
#grep("fBodyAccJerkMag", tempFeatureName,ignore.case = TRUE, value = TRUE)
#grep("BodyBody", tempFeatureName,ignore.case = TRUE, value = TRUE)

#Remove duplicate 'Body', in practice this should have been done before any data manipulation, to avoid duplicates...
tempFeatureName <- gsub("BodyBody","Body",tempFeatureName)
featureNamesAfter <- tempFeatureName

#Update feature names
dataTidy$FeatureName <- tempFeatureName

#Make sure number of feature names before and after are the same
featureNamesBeforeEqualsAfter = length(unique(featureNamesBefore)) == length(unique(featureNamesAfter))

#Order by SubjectID, Activity, FeatureName, FeatureStatistic, and finally the average
setcolorder(dataTidy, c("SubjectID", "Activity", "FeatureName", "FeatureStatistic", "FeatureAverage"))
dataTidy <- arrange(dataTidy, SubjectID, Activity, FeatureName)

#print out unique FeatureNames for codebook
pathwd <- getwd()
write.table(unique(dataTidy$FeatureName), file = file.path(pathwd, "FeatureNames.txt"), row.names = FALSE, col.names = FALSE)

#Output tall and narrow tidy data set
write.table(unique(dataTidy), file = file.path(pathwd, "TidyData.txt"), row.names = FALSE)

#Done :)