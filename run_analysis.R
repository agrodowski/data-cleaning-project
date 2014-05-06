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

# [agr] 0. Fetching data
if (!file.exists("UCI HAR Dataset.zip")) {
  cat("Dataset package not found and shall be retrieved.")
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","UCI HAR Dataset.zip",method="curl")
}
if (!file.exists("UCI HAR Dataset")) {
  cat("Extracting UCI HAR dataset package.")
  unzip("UCI HAR Dataset.zip")
}
# [agr] determine which features are means and standard deviations
feature <- read.table("./UCI HAR Dataset/features.txt")
indx <- feature[grepl("mean|std",feature$V2,feature),]$V1
# [agr] normalise names: lowercase and removal of brackets
featurenames <- gsub("[()]","",tolower(feature[indx,]$V2))

# [agr] import only relevant data from test and train datasets
cols <- rep("NULL",length(feature$V1))
cols[indx] <- "numeric"

testdt <- data.table(read.table("./UCI HAR Dataset/test/X_test.txt",colClasses=cols))
setnames(testdt, featurenames)
testdt[, activity := read.table("./UCI HAR Dataset/test/y_test.txt")]
testdt[, subject := read.table("./UCI HAR Dataset/test/subject_test.txt")]

traindt <- data.table(read.table("./UCI HAR Dataset/train/X_train.txt",colClasses=cols))
setnames(traindt, featurenames)
traindt[, activity := read.table("./UCI HAR Dataset/train/y_train.txt")]
traindt[, subject := read.table("./UCI HAR Dataset/train/subject_train.txt")]

# [agr] merge test with train
dt <- rbindlist(list(testdt,traindt))

# [agr] compute tidy dataset: reduce: mean(.SD) per subject per activity
dtt <- dt[,lapply(.SD,mean),by=list(subject,activity)]
write.table(dtt,"tidy.txt",row.names=FALSE)
