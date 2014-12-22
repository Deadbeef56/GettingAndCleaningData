GettingAndCleaningData
======================

DataDescription.txt - a file that contains a description of the data frame stored in "ProjectOutput.txt"
ProjectOutput.txt - contains the final tidy data set produced by this project.  
run_analysis.R - contains the R code that reads and tidys the initial data set to produce the final tidy data set


What does run_Analysis.R do?
======================================================


STEP 1 Merges the training and the test sets to create one data set.
======================================================================================================================================================================================
Read the features.txt file into a data frame using read.csv
Read the activity_labels.txt file into a data frame using read.csv

The data is divided into two parts, a training set and a test set, the same set of steps will be performed on both sets and then the sets will be combined:
1. read the raw test data from X_test.txt into a data table using read.csv and converting the resulting data frame into a data table
2. get the number of rows and attach a sequential testId column to identify each row, make this the key for the data table
3. read the raw activity list from Y_test.txt into a data table using read.csv and converting the resulting data frame into a data table
4. use the same testId vector created in step 2 and bind it to the activity data table, both tables should contain the same number of rows.  Make testId the key for the activity table
5. merge the subject, activity and test tables

Repeat the previous steps for the trainging set.  The testIds will begin at the next number following the largest testId produced in the first data set

Use rbind to combine the test and training data sets having bound a testId and Activity column to each data set


STEP 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
=========================================================================================================================================================================================
Use grep() to select just those column names containing "mean" or "std" and select just those columns, along with the key fields

 
STEP 3 Uses descriptive activity names to name the activities in the data set
==========================================================================================================================================================================================
The data table produced in STEP 2 already contains the Activity names from activity_labels.txt.  That is descriptive enough and I don't have any additional information.


STEP 4 Appropriately labels the data set with descriptive variable names
===========================================================================================================================================================================================
The data table produced in STEP 2 already uses the column names from the test and training data tables.  That is descriptive enough.


STEP 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
============================================================================================================================================================================================
use the dplyr library
create a data frame table from the data set created in Step 2
use group_by and summarise_each to compute the mean grouped by Subject and Activity
