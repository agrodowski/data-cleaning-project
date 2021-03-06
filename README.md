README for Data Cleaning project
--------------------------------
Copyright (C) 2016 Adam Grodowski (adam.grodowski@gmail.com)

Note: These functions were written on a Mac and may have difficulties when read on Windows machines. 

Quoting from the assignment description:
> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.


### run_analysis.R
This file contains the R code to clean UCI HAR Dataset which does the following (quoting from the assignment description):
> Merges the training and the test sets to create one data set.

> Extracts only the measurements on the mean and standard deviation for each measurement.

> Uses descriptive activity names to name the activities in the data set

> Appropriately labels the data set with descriptive variable names.

> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The order of the above steps has been changed slightly by performing the extraction before merging for optimisation purposes. The variables have been normalised (lowercased and stripped of brackets) but no further renaming has been made to preserve its original meaning.

Note : Please note that all variables weighted average of the frequency components to obtain a mean frequency denoted as meanFreq() have been explicitely considered OUT OF SCOPE of the tidy data set because they are not the mean of the ***direct measurement that took place*** (denoted as mean()). For the same reason, additional vectors obtained by averaging the signals in a signal window sample used on the angle variable denoted as angle(...) are also explicitely considered OUT OF SCOPE.

### CodeBook.Rmd
This file contains a description of variables and the transformation made. It is a R markup document with the inline R code, therefore, some values may only be obtained by running it.

### tidy.txt
A refernece tidy set.


## To reproduce the results
(1) Run run_analysis.R to obtain the raw data, clean it and transform it into a tidy data set.

Note, because of the download step, it may take a while to run. The online environment is required, obviously. 
