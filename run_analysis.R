
library(data.table)
setwd("C:\\Users\\hclark\\datasciencecoursera\\GettingAndCleaningDataProject\\UCI HAR Dataset")

dtFeatures <- data.table(read.csv("features.txt", sep="", header=FALSE, stringsAsFactors=FALSE))
setnames(dtFeatures, c("FeatureId", "FeatureName"))  
dtFeatures$FeatureName <- make.unique(dtFeatures$FeatureName)
                         


## Get Activity List
dtActivityLabels <- data.table(read.csv("activity_labels.txt",sep="", header=FALSE, stringsAsFactors=TRUE))
setnames(dtActivityLabels, c("ActivityId", "ActivityName"))
setkey(dtActivityLabels, ActivityId)


############################################################################
## The following steps will need to be repeated for Test and Train data sets
############################################################################

## Read Test data
dtTest <- data.table(read.csv("test\\X_test.txt", sep = "", header=FALSE, stringsAsFactors=FALSE))
setnames(dtTest, dtFeatures$FeatureName)

## get Number of tests
nTest <- nrow(dtTest)
testId <- 1:nTest
dtTest <- cbind(testId, dtTest)
rownames(dtTest) = testId
setkey(dtTest, testId)

## Read Subject
dtTestSubject <- data.table(read.csv("test\\subject_test.txt", header=FALSE, stringsAsFactors=TRUE))
setnames(dtTestSubject, "Subject")
dtTestSubject <- cbind(testId, dtTestSubject)
setkey(dtTestSubject, testId)

## Read Activity
dtActivity <- data.table(read.csv("test\\y_Test.txt", header=FALSE, stringsAsFactors=TRUE))
setnames(dtActivity, "ActivityId")
dtActivity <- cbind(testId, dtActivity)
setkey(dtActivity, ActivityId)
dtActivity <- merge(dtActivity, dtActivityLabels)
setkey(dtActivity, testId)

resultTest <- merge(dtTestSubject, dtActivity)
resultTest <- merge(resultTest, dtTest)

############################################################################
## Now repeat for the Trainging data set
############################################################################

## Read Train data
dtTrain <- data.table(read.csv("train\\X_train.txt", sep = "", header=FALSE, stringsAsFactors=FALSE))
setnames(dtTrain, dtFeatures$FeatureName)

## get Number of tests
nTrain <- nrow(dtTrain)
testId <- (nTest+1):(nTest+nTrain)
dtTrain <- cbind(testId, dtTrain)
rownames(dtTrain) <- testId
setkey(dtTrain, testId)

## Read Subject
dtTrainSubject <- data.table(read.csv("train\\subject_train.txt", header=FALSE, stringsAsFactors=TRUE))
setnames(dtTrainSubject, "Subject")
dtTrainSubject <- cbind(testId, dtTrainSubject)
setkey(dtTrainSubject, testId)

## Read Activity
dtActivityTrain <- data.table(read.csv("train\\y_Train.txt", header=FALSE, stringsAsFactors=TRUE))
setnames(dtActivityTrain, "ActivityId")
dtActivityTrain <- cbind(testId, dtActivityTrain)
setkey(dtActivityTrain, ActivityId)
dtActivityTrain <- merge(dtActivityTrain, dtActivityLabels)
setkey(dtActivityTrain, testId)

resultTrain <- merge(dtTrainSubject, dtActivityTrain)
resultTrain <- merge(resultTrain, dtTrain)

totalTest <- rbind(resultTrain, resultTest)


############################################################################################################
## STEP 4
##
## Select just those columns containing a mean or std deviation, 
##
## We do this by greping just those column names containing the string "mean" or "std"
## Keep columns 1-4 since they contain "key" fields
############################################################################################################

stdMeanTest <- totalTest[,c(1:4, grep("mean|std", colnames(totalTest))), with=FALSE]

############################################################################################################
## Step 5 
## 
## Create a tidy data set that averages each variable by Subject and Activity
############################################################################################################

#Copy stdMeanTest to a standard data frame
testdf <- data.frame(stdMeanTest)

# get rid of extraneous columns
testdf$testId <- NULL
testdf$ActivityId <- NULL

#load the dplyr library
library(dplyr)

#create a data frame table
testDfTbl <- tbl_df(testdf)

summBySubjActivity <- testDfTbl %>% group_by(Subject, ActivityName) %>% summarise_each(funs(mean)) 

print(summBySubjActivity)