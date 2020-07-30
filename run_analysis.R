# # 1. Change directory to your working directory.
# # 2. Source this R script.
# 

library(parallel)
library(tidyverse)
# library(readr)
# library(tidyr)
# library(dplyr)
# library(stringr)
# library(tibble)


# Set data directory pathname and temporary file holder for the downloaded file.
# 
datadir <- paste(".", "data", sep = "/")
tmpfil <- tempfile()

# Set download URL for UCI human activity recognition data set.
# 
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = tmpfil); rm(fileurl)

# Extract and place the downloaded zip file into the data directory.
# 
if(!dir.exists(datadir)){dir.create(datadir)}
unzip(tmpfil, exdir = datadir)
datadir <- paste(datadir, "UCI HAR Dataset", sep = "/")


# Variable names list 
x_features <- read_lines(file.path(datadir, "features.txt"))
x_features <- strsplit(x_features, "[\\s]", perl = TRUE)

# Activity labels
act_labels <- read_lines(file.path(datadir, "activity_labels.txt"))
act_labels <- strsplit(act_labels, "[\\s]", perl = TRUE)


# 'Training data - x_train'
# Each row in the table represents a collection of training measurement data
# correspond to a participant who performs all the six human activities.
filepath <- paste(datadir, "train", "X_train.txt", sep = "/")
x_train <- read_delim(filepath, delim = " ", col_names=FALSE, trim_ws = TRUE)

# 'Training activity - y_train'
# Each element represents the label of one of the six human activities.
# Index of each element in the vector corresponds to a row index of
# 'train' data frame table forming the relationship linkage.
filepath <- paste(datadir, "train", "y_train.txt", sep = "/")
y_train <- read_lines(filepath)

# 'Training subject - z_train'
# Each element represents a training subject.
# Index of each element in the vector corresponds to a row index of
# 'x_train' data frame table forming the relationship linkage.
filepath <- paste(datadir, "train", "subject_train.txt", sep = "/")
z_train <- read_lines(filepath)


# 'Test data - x_test'
# Each row in the table represents a collection of test measurement data 
# correspond to a participant who performs all the six human activities.
filepath <- paste(datadir, "test", "X_test.txt", sep = "/")
x_test <- read_delim(filepath, delim = " ", col_names=FALSE, trim_ws = TRUE)

# 'Test activity  - y_test'
# Each element represents the label of one of the six human activities.
# Each element index corresponds to a row index of 'xtest' data frame table. 
filepath <- paste(datadir, "test", "y_test.txt", sep = "/")
y_test <- read_lines(filepath)

# 'Test subject - z_test'
# Each element represents a test subject.
# Index of each  element in the vector corresponds to a row index of
# 'x_test' data frame table forming the relationship linkage.
filepath <- paste(datadir, "test", "subject_test.txt", sep = "/")
z_test <- read_lines(filepath)


# GETTING 'THE DATASETS' (TEST and TRAIN) INTO SHAPE
# 
# Convert human activity measurement data values from 
# character data type to numerical data type.
# 
# x_test <- x_test %>% transmute(across(X1:X561, as.numeric)) 
# x_train <- x_train %>% transmute(across(X1:X561, as.numeric))

# Merge 'Subject' with 'Activity Labels'
# 
zy_test <- data.frame(as.integer(z_test), as.integer(y_test))
colnames(zy_test) <- c("subject", "actnum")

zy_train <- data.frame(as.integer(z_train) ,as.integer(y_train))
colnames(zy_train) <- c("subject", "actnum") 

zy_data <- rbind(zy_train, zy_test, make.row.names = TRUE)

zydata <- zy_data %>% tibble::as_tibble() %>% tibble::add_column(activity = "")
for (i in 1:length(act_labels)) {
        zydata$activity <- replace(zydata$activity,
                                zydata$actnum == as.integer(act_labels[[i]][1]),
                                act_labels[[i]][2])
}


# Binding X_dataset
x_data <- bind_rows(x_train, x_test)

# Binding 'Subject-Activity Label' to 'X_dataset Measurement Data'
xdata <- bind_cols(zydata, x_data)


# Simplified 'hardata' with only variables of mean and 
# standard deviation data values.
# 
hardata <- xdata %>% select(activity, 
                            subject, 
                            X1:X6,                
                            X41:X46,              
                            X81:X86,
                            X121:X126,
                            X161:X166,
                            X201:X202,
                            X214:X215,
                            X227:X228,
                            X240:X241,
                            X253:X254,
                            X266:X271,
                            X345:X350,
                            X424:X429,
                            X503:X504,
                            X516:X517,
                            X529:X530,
                            X542:X543,
                            X555:X561)

# Assigning meaningful variable names.
# Extract variable names from 'features.txt' file
# 
k <- matches("^X(?=[0-9])", perl=TRUE, vars=names(hardata))
for (i in k) {
     # j <- as.integer(strsplit(names(hardata)[i], 
     #                          "^X(?=[0-9])", 
     #                          perl=TRUE)[[1]][2])
     # h <- gsub("\\(\\)", "", x_features[j][[1]][2], perl=TRUE)
     # h <- gsub("\\-", "_", h, perl=TRUE)
     # h <- gsub("(?<=[Aa]cc)[Aa]cc", "", h, perl=TRUE)
     # h <- gsub("(?<=[Bb]ody)[Bb]ody", "", h, perl=TRUE)
     # h <- gsub("(?<=[Gg]yro)[Gg]yro", "", h, perl=TRUE)
     # h <- gsub("(?<=[Jj]erk)[Jj]erk", "", h, perl=TRUE)
     # h <- gsub("(?<=[Mm]ag)[Mm]ag", "", h, perl=TRUE)
     
     j <- as.integer(str_split(names(hardata)[i], "^X(?=[0-9])")[[1]][2])
     h <- x_features[j][[1]][2] %>% 
                                str_replace_all("\\-", "\\_") %>% 
                                str_replace("\\(\\)", "") %>% 
                                str_replace("\\)\\,","\\,") %>% 
                                str_replace("(?<=[Aa]cc)[Aa]cc", "") %>% 
                                str_replace("(?<=[Bb]ody)[Bb]ody", "") %>% 
                                str_replace("(?<=[Gg]yro)[Gg]yro", "") %>% 
                                str_replace("(?<=[Jj]erk)[Jj]erk", "") %>% 
                                str_replace("(?<=[Mm]ag)[Mm]ag", "") %>% 
                                str_replace("(?<=[Gg]ravity)[Gg]ravity", "")
     hardata <- hardata %>% rename_with(function(v){v <- h}, names(hardata)[i])
}


# Summarized 'Human Activity Recognition' in time domain and frequency domain
# mean measurement data values for each activity and each subject.
shardata <- hardata %>% 
               select(everything()) %>% 
               group_by(activity, subject) %>% 
               summarise(across(matches("^[tf]([Bb]ody|[Gg]ravity)|^[Aa]ngle", 
                                        perl = TRUE), mean, na.rm = TRUE))


datadir <- paste(".", "data", sep = "/")
filepath <- paste(datadir, "ucihardata.txt", sep = "/")
write.table(hardata, filepath, row.names = FALSE)
filepath <- paste(datadir, "s_ucihardata.txt", sep = "/")
write.table(shardata, filepath, row.names = FALSE)


# # CLEANING UP ENVIRONMENT VARIABLES 
# # 
unlink(tmpfil) 
unlink(datadir, recursive = TRUE)
unlink(paste(datadir, "UCI HAR Dataset", sep = "/") , recursive = TRUE)
rm(tmpfil, datadir, filepath, h, i, j, k) 
rm(x_test, y_test, z_test, zy_test, x_train, y_train, z_train, zy_train, x_data) 
rm(zy_data, zydata, act_labels, x_features) 
# rm(hardata, shardata, xdata) 

detach(package:ggplot2)
detach(package:tibble)
detach(package:tidyr)
detach(package:readr)
detach(package:purrr)
detach(package:dplyr)
detach(package:stringr)
detach(package:forcats)
detach(package:tidyverse, unload = TRUE)

