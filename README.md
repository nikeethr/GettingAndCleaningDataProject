Readme
======

#Steps to reproduce tidy data:
1.  Open run_analysis.R
2.  Set working directory to where the data foler resides using setwd()
3.  If data folder is unavailable uncomment the section under 'Download file' and run it to get the zip file.
4.  Make sure the data directory is extracted into the working directory and all the data is in the folder "UCI HAR Dataset".
5.  Run the code. The output will be saved as 'TidyData.txt' in the root directory

Note: may need the following packages to run - 'data.table', 'dplyr'

#Summary of how code works:
1.  Extracts data, subjects and activities from 'test' and 'train' folders. Extracts activity labels from "activity_labels.txt" and feature names from "features.txt" 
2.  Combines test and training data into a single data frame, along with the subject and activity ('SubjectID', 'Activity')
3.  Extracts only the mean and std information
4.  Labels activities according to their appropriate names rather than ID
4.  Transforms the data frame into tall and narrow data by melting by 'FeatureName'
5.  Takes average of each feature and puts it in a new column 'FeatureAverage'
6.  Tidy up the data by seperating the mean and std information into a seperate column
7.  Final data frame ('TidyData.txt') will provide the average over mean/std of each activity and subject for each variable under 'FeatureAverage'
