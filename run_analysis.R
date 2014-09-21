library(plyr)
library(stringr)

# reading the files for description

activity_labels <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/activity_labels.txt')
features <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/features.txt')

# reading the data itself

train_set <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/train/X_train.txt')
train_lables <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/train/y_train.txt')
train_subject <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/train/subject_train.txt')
test_set <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/test/X_test.txt')
test_lables <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/test/y_test.txt')
test_subject <- read.table('/home/trofimova/Documents/Coursera/Data_Science/Getting_and_Cleaning_Data/week_3/assignment/UCI HAR Dataset/test/subject_test.txt')

# merging the datasets

full_set <- rbind(test_set,train_set)
full_labels <- rbind(test_lables, train_lables)
full_subject <- rbind(test_subject, train_subject)
full <- cbind(full_labels, full_subject, full_set)

# mean and standart deviation extraction

features$V3 <- grepl("mean|std",features$V2) #logical vector for std and mean
set_mean_std <- full[,features$V3]

# naming the activities in the data set

for (i in 1:length(activity_labels$V2)){
  set_mean_std$V1 = gsub(as.character(i),activity_labels$V2[i],set_mean_std$V1)
}

# labeling the data set with descriptive variable names

features$V2 <- str_replace_all(features$V2,"[[:punct:]]", "")
colnames(set_mean_std) <- c('Activity',"Subject",as.character(features$V2[features$V3]))

# averaging of each variable for each activity and each subject and saving the set to file

tidy <- ddply(set_mean_std, .(Activity, Subject), numcolwise(mean))
