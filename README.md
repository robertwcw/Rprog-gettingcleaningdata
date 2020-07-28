---
title: "README"
subtitle: Technical summary of run_analysis.R
course: Coursera Data Science using R
output: 
  pdf_document: 
    keep_tex: yes
    fig_caption: yes
project: Getting and Cleaning data
---

## Introduction

This course project `Getting and Cleaning data` requires the learner to create an R script `run_analysis.R` to acquire the `UCI HAR Dataset` from the internet cloud, import into R and apply tidy data principle in the transformation process to produce a set of tidied data for easier analysis downstream.

`UCI HAR Dataset` contains human activity recognition (HAR) data from an experiment conducted by DITEN - Universita degli Studi di Genova in Italy carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### For each record it is provided: 

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


### The dataset includes the following files: 

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


#### Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


### Project directory structure
- `working directory`  *(where README.md and CodeBook.md are located)*
  - `data directory`  *(where the samsung data and subsequent tidy data are stored)*


### Instruction
1. change current directory to project working directory (`wd`)
2. load `run_analysis.R` script in the `wd` directory 
3. source `run_analysis.R` script to initiate the data transformation process 


### Transformation Process 

This section briefly describes the steps involved in the transformation process.

1. download samsung `UCI HAR Dataset` from the internet cloud to a local temporary file holder. 

2. unzip `UCI HAR Dataset` save output file to `wd/data/UCI HAR Dataset/`.
   `wd/data/UCI HAR Dataset/` directory layout 
   + activity_labels.txt 
   + features.txt 
   + features_info.txt 
   + README.txt 
   + `wd/data/test/` 
     + `Inertial Signals/` 
     + subject_test.txt 
     + X_test.txt 
     + Y_test.txt 
   + `wd/data/train/` 
     + `Inertial Signals/` 
     + subject_train.txt 
     + X_train.txt 
     + Y_train.txt 

3. read_lines(`activity_labels.txt`, `features.txt`) from `wd/data/UCI HAR Dataset/`. 

4. read_delim(`X_test.txt`, `Y_test.txt`, `subject_test.txt`) from `wd/data/UCI HAR Dataset/test/`. 

5. read_delim(`X_train.txt`, `Y_train.txt`, `subject_train.txt`) from `wd/data/UCI HAR Dataset/train`. 

6. bind `activity_labels` with `subject_train` and `subject_test` to create activity-subject value-pairs. 

7. bind `train` HAR data and `test` HAR data with activity-subject value-pairs to create `ucihardata` dataset consists of variables of mean and standard deviation. 

8. write.table(`ucihardata`) save output file to `wd/ucihardata.txt`. 

9. summarize `ucihardata` having mean calculated on each variable for each activity and each subject to create `s_ucihardata` dataset. 

10. write.table(`s_ucihardata`) save output file to `wd/s_ucihardata.txt`. 


**s_ucihardata.csv is summarized mean and standard deviation data values for each variable for each activity and each subject**

**ucihardata.csv is non-summarized and ungrouped dataset**

End of transformation process.

