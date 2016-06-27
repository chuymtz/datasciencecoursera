# load dyplyr package
library(dplyr)

# download and unzip the data for the project
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = './data.zip')
unzip('./data.zip')

# Each row identifies the subject performeing the activity for each sample 
subject_test <- tbl_df(read.table('./UCI HAR Dataset/test/subject_test.txt'))
subject_train <- tbl_df(read.table('./UCI HAR Dataset/train/subject_train.txt'))

# Rows are subjects and columns denote features (names in features.txt)
data_test <- tbl_df(read.table('./UCI HAR Dataset/test/X_test.txt'))
data_train <- tbl_df(read.table('./UCI HAR Dataset/train/X_train.txt'))

# Row identifies the activity by numerical value found in activity_labels.txt
activity_test <- tbl_df(read.table('./UCI HAR Dataset/test/Y_test.txt'))
activity_train <- tbl_df(read.table('./UCI HAR Dataset/train/Y_train.txt'))

# Merge subject, activity and data set for train and test data.
subjects <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test) 
data <- rbind(data_train, data_test)

# Properly name columns for features in 'data' data frame
features <- read.table('./UCI HAR Dataset/features.txt')
labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
subjects <- rename(subjects, subject = V1)
activity <- rename(activity, activity_num = V1)
colnames(data) <- features$V2

# Merges the training and the test sets to create one data set.
df <- tbl_df(cbind(subjects, activity, data))

# Extract mean and standard deviation measurements
mean_std_features <- grep(".[Mm]ean.|.[Ss]td.",names(df))
df<- subset(df,select=c(1,2,mean_std_features))

# Use descriptive activity names for activity data frame.
names(labels) <- c('activity_num', 'activity')
df <- merge(labels, df , by='activity_num', all=TRUE); rm(labels)

# Rearragnge columns to show subject first and activity second.
df <- df %>%
    select(3, 2, 4:89) %>%
    arrange(subject)

# Use descriptive names for mean and standard devaition features 
names(df) <- tolower(names(df))
names(df) <- gsub('acc', 'acceleration', names(df))
names(df) <- gsub('gyro', 'angularvelocity', names(df))
names(df) <- gsub('mag', 'magnitude', names(df))
names(df) <- gsub('bodybody', 'body', names(df))
names(df) <- gsub('freq', 'frequency', names(df))
names(df) <- gsub('anglet', 'angletime', names(df))
names(df) <- gsub('meangravity', 'gravity', names(df))
names(df) <- gsub('^t|\\(t', 'time', names(df))
names(df) <- gsub('^f', 'frequency', names(df))
names(df) <- gsub('-|\\(|\\)|,', '', names(df))
names(df) <- gsub('anglexgravitymean', 'anglegravitymeanx', names(df))
names(df) <- gsub('angleygravitymean', 'anglegravitymeany', names(df))
names(df) <- gsub('anglezgravitymean', 'anglegravitymeanz', names(df))

# Creates a tidy data set with the average of each variable for each activity 
# and each subject.
tidySet <- aggregate(.~subject + activity, df, mean)
tidySet <- tidySet %>% arrange(subject, activity)

# Produce output and upload file.
write.table(df, file='tidydata.txt', row.name = FALSE)
