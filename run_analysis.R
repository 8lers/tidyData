###----------Part 0: instructions---------------###



# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.                                                                                      
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Good luck!



###-NOTE the following 'parts' do not correspond to the ordering of the instructions as listed above-###



###----------Part 1: loading data---------------###

#Downloading the file and setting its destination
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
#               destfile='C:/Users/leifs/Documents/train_test_data.zip')

#Loading the training and testing data
xtrain=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/train/X_train.txt',
                  header=FALSE, sep="")
xtest=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/test/X_test.txt',
                 header=FALSE, sep="")

#Loading the training and testing labels
y_train=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/train/y_train.txt',
                   header=FALSE, sep="")
y_test=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/test/y_test.txt',
                  header=FALSE, sep="")

#Loading the activity labels
activity_labels=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/activity_labels.txt',
                           header=FALSE, sep="")

#Loading subjects
subjects_train=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/train/subject_train.txt',
                          header=FALSE, sep="")
subjects_test=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/test/subject_test.txt',
                         header=FALSE, sep="")

#Loading feature names
features=read.delim('C:/Users/leifs/Documents/train_test_data/UCI HAR Dataset/features.txt',
                    header=FALSE, sep="")



###----------Part 2: processing names-----------###

#Adding feature names to the XTRAIN and XTEST dataframes to make it easier to investigate if need be
colnames(xtrain)=features$V2
colnames(xtest)=features$V2

#There are a lot of label entries but only a few labels. Time to merge! This will give a text label for each indexed activity type which we can use later
merged_train_labels=merge(activity_labels, y_train, by.x='V1')
merged_test_labels=merge(activity_labels, y_test, by.x='V1')

#Identifying data rows as 'TRAINING' or 'TESTING'
data_type_training=rep('TRAINING', nrow(xtrain))
data_type_testing=rep('TESTING', nrow(xtest))

#Combine merged activity labels, training/testing labels, and participant ID labels
subject_type_label_merge_train=cbind(subjects_train, merged_train_labels, data_type_training)
subject_type_label_merge_test=cbind(subjects_test, merged_test_labels, data_type_testing)

#Naming label variables
colnames(subject_type_label_merge_train)=c('Participant ID', 'Activity type', 'Activity description', 'Data class')
colnames(subject_type_label_merge_test)=c('Participant ID', 'Activity type', 'Activity description', 'Data class')



###----------Part 3: processing data------------###

#Combining train and test sets
combined_data=rbind(xtrain, xtest)
combined_labels=rbind(subject_type_label_merge_train, subject_type_label_merge_test)
final_combined_dataset=cbind(combined_labels, combined_data)

#Getting only the means
combined_data_means=combined_data[grep('mean', colnames(combined_data))]
combined_data_SDs=combined_data[grep('std', colnames(combined_data))]
final_combined_dataset_means=cbind(combined_labels, combined_data_means, combined_data_SDs)

#Renaming columns
colnames(final_combined_dataset)=gsub("-", "_", colnames(final_combined_dataset))
colnames(final_combined_dataset)=gsub(",", "", colnames(final_combined_dataset))
colnames(final_combined_dataset)=gsub("\\()", "", colnames(final_combined_dataset))

colnames(final_combined_dataset_means)=gsub("-", "_", colnames(final_combined_dataset_means))
colnames(final_combined_dataset_means)=gsub(",", "", colnames(final_combined_dataset_means))
colnames(final_combined_dataset_means)=gsub("\\()", "", colnames(final_combined_dataset_means))

###----------Part 4: averaging data-------------###

#Getting the mean of each variable for each participant and each activity, using dplyr

library(dplyr)
results_summarised=final_combined_dataset_means %>%
    group_by(`Participant ID`, `Activity type`) %>% 
    summarise_all(mean)



###-Optional: cleaning stuff up to save memory

#From part 1
rm(features, activity_labels, y_test, y_train, xtest, xtrain, subjects_test, subjects_train, subject_type_label_merge_test, subject_type_label_merge_train)
#From part 2
rm(merged_test_labels, merged_train_labels, data_type_testing, data_type_training)
#From part 3
rm(combined_data, combined_data_means, combined_labels)


