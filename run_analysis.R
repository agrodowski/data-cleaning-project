#
# This file ...
#
# You should create one R script called run_analysis.R that does the following:
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive activity names. 
# - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
library(data.table)

readUCIHARDataset <- function(kind, names, cols) {
  dir <- paste0("./UCI HAR Dataset/",kind)
  dt <- data.table(read.table(paste0(dir,"/X_",kind,".txt"),colClasses=cols))
  setnames(dt, names)
  dt[, activity := read.table(paste0(dir,"/y_",kind,".txt"))]
  dt[, subject := read.table(paste0(dir,"/subject_",kind,".txt"))]
}

# Fetching data
if (!file.exists("UCI HAR Dataset.zip")) {
  cat("Dataset package not found and shall be retrieved.")
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","UCI HAR Dataset.zip",method="curl")
}
if (!file.exists("UCI HAR Dataset")) {
  cat("Extracting UCI HAR dataset package.")
  unzip("UCI HAR Dataset.zip")
}
# determine which features are means and standard deviations
feature <- read.table("./UCI HAR Dataset/features.txt")
indx <- feature[grepl("-(mean|std)\\(\\)",feature$V2,feature),]$V1
# normalise names: lowercase and removal of brackets
featurenames <- gsub("[()]","",tolower(feature[indx,]$V2))

# import only relevant data from test and train datasets
cols <- rep("NULL",length(feature$V1))
cols[indx] <- "numeric"

# read only relevant variables from test and train datasets
testdt <- readUCIHARDataset("test",featurenames,cols)
traindt <- readUCIHARDataset("train",featurenames,cols)

# merge test with train
dt <- rbindlist(list(testdt,traindt))

# replace activity number with label
activityname <- read.table("./UCI HAR Dataset/activity_labels.txt")
dt[, activity := as.factor(activityname[activity,]$V2) ]

# compute tidy dataset: reduce: mean(.SD) per subject per activity
dtt <- dt[,lapply(.SD,mean),by=list(subject,activity)]
write.table(dtt,"tidy.txt",row.names=FALSE)
