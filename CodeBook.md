---
title: "Code Book"
date: "April 25, 2019"
output: html_document
---

This file describes the variables extracted, processed, and output in the associated run_analysis.R file. Methods of data extraction and preparation are also described

###Part 1: Data loading
Data are downloaded from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip` using `download.file()`. Training and testing data from the `X_train.txt ` and `X_test.txt` files are loaded into R using `read.delim()`, because the data provided are in a `.txt` format. Training and testing labels are also extracted from `Y_train.txt` and `Y_test.txt`, respectively.

Activity labels are loaded from `activity_labels.txt`.

Participants are read in from `subjects_train.txt` and `subjects_test.txt`.

Finally, feature names are read in from `features.txt`.

###Part 2: Processing variable names
Column names are added to `XTRAIN` and `XTEST` from the `features` array as described above. Data for `activity labels` and `y train` are merged. Data rows are also labelled as `TRAINING` or `TESTING` depending on which dataset they originate form (`X_train` or `X_test`, respectively). Participant IDs and data type (train/test) are combined using `cbind()`. Finally, column names are added corresponding to `Participant ID`, `Activity type`, `Activity description`, and `Data class`, to make the dataset more human-readable.


###Part 3: Processing data
Training and testing data are combined using `rbind()`. These are combined with the labels mentioned above using `cbind()`. The columns containing only the means or standard deviations are isolated and stored in a a separate variable. These variables are:

`final_combined_dataset`: This variable contains all results of processing
`final_combined_dataset_means`: This variable contains only the columns from final_combined_dataset that correspond to means and standard deviations

Column names are also cleaned further using `gsub()` to convert hyphens to underscores, remove commas, and remove parentheses.

###Part 4: Averaging data
The means of each activity with each participant are calculated using `group_by()` and `summarise_all()` loaded in from the `dplyr` package. This produces the variable:
`results_summarised`: This variable contains the means of each activity for each participant

###Part 5: Optional clearing of memory
This process generates many relatively large dataframes as intermediate variables. The user has the option to clean them out to save memory using `rm()`. The variables that can be removed are subdivided by the corresponding part of the analysis.



