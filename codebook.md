# Data Dictionary for run_analysis.R

Describes all relevent variables in the R script run_analysis submitted for the Getting & Cleaning Data course project

Please note that not all source data values are described in this data dictionary.  Values that are removed in the first subset, so are never directly referenced by this script, are not explained.  If you would like additional information on these variables, please see the Source Data Information section to find where all of the original source documentation can be found.

### Source Data Information
This project uses a data set gathered from Samsung Galaxy S smartphone, described here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data set to be used with the run_analysis.R script was downloaded from here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The unaltered README from the source dataset has been added to the repository as:
README_from_dataset.txt

If you're interested in the meaning of additional variables not used in this script, so really outside the scope of this data dictionary, additional information is available in the file "UCI HAR Dataset/features_info.txt"  which can be found in the unzipped original data set.


### Data frame variables used to hold intermediate steps

1. activity_labels - holds the data from activity_labels.txt, which provides a mapping between activity_number and a readable activity_name.  Ultimately used to name the activities in the subsetted data before tidying the data.
2. features - holds the data from features.txt which is a list of all the features in each data set.  Used to provide most column names for training & test data.
3. train_x/test_x - core data set for training/test source data
4. train_y/test_y - activity number/label for the training/test source data
5. train_subject/test_subject - the identifier of the subject who carried out the experiment for each row of data in the trainin/test source data
6. total_train/total_test - intermediate data frames to hold the items from 3-5 (for training/test respectively) after being combined via cbind
7. total_data - result of using rbind to combine total_train & total_test into a single data frame
8. data_subset - total_data after having removed all measurements other than mean and standard deviation.  (Subject & activity label data are also kept)
9. data_with_activity - data_subset after adding the activity name (via a merge with activity_labels) and cleaning up the measurement column names.  The final change made before this becomes final_data (described below) is to remove the now redundant activity_number value and that final_data is a local data frame.


### Variable name transformation logic to get from raw names in features.txt to the column names in final_data
* For all variables in features.txt, reading them in as the column names when creating test_x & test_y stripped out characters that cannot be used in R data frame column names, such as "()", "-", and ","
* Once the initial subset has reduced the columns down the those necessary for later evaluation, gsub is used to remove extraneous ".." from the end of column names as well as replace "." and "..." with "_" to keep the names consistent yet readable.

### Column Header meaning for final_data data frame.

* subject_number 
	* Identifies the subject who performed the activity
	* Possible values 1 : 30

* activity_name
	* Name of the activity performed
	* Possible values WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

For each of the column headers below, per the information in the original data set file, features_info.txt:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

All column headers that include _mean are the mean value of the measurement described above for the combination of subject & activity.
All column headers that include _std are the standard devision of the measure described above for the combination of subject & activity.

tBodyAcc_mean_X
tBodyAcc_mean_Y
tBodyAcc_mean_Z
tGravityAcc_mean_X
tGravityAcc_mean_Y
tGravityAcc_mean_Z
tBodyAccJerk_mean_X
tBodyAccJerk_mean_Y
tBodyAccJerk_mean_Z
tBodyGyro_mean_X
tBodyGyro_mean_Y
tBodyGyro_mean_Z
tBodyGyroJerk_mean_X
tBodyGyroJerk_mean_Y
tBodyGyroJerk_mean_Z
tBodyAccMag_mean
tGravityAccMag_mean
tBodyAccJerkMag_mean
tBodyGyroMag_mean
tBodyGyroJerkMag_mean
fBodyAcc_mean_X
fBodyAcc_mean_Y
fBodyAcc_mean_Z
fBodyAccJerk_mean_X
fBodyAccJerk_mean_Y
fBodyAccJerk_mean_Z
fBodyGyro_mean_X
fBodyGyro_mean_Y
fBodyGyro_mean_Z
fBodyAccMag_mean
fBodyBodyAccJerkMag_mean
fBodyBodyGyroMag_mean
fBodyBodyGyroJerkMag_mean
tBodyAcc_std_X
tBodyAcc_std_Y
tBodyAcc_std_Z
tGravityAcc_std_X
tGravityAcc_std_Y
tGravityAcc_std_Z
tBodyAccJerk_std_X
tBodyAccJerk_std_Y
tBodyAccJerk_std_Z
tBodyGyro_std_X
tBodyGyro_std_Y
tBodyGyro_std_Z
tBodyGyroJerk_std_X
tBodyGyroJerk_std_Y
tBodyGyroJerk_std_Z
tBodyAccMag_std
tGravityAccMag_std
tBodyAccJerkMag_std
tBodyGyroMag_std
tBodyGyroJerkMag_std
fBodyAcc_std_X
fBodyAcc_std_Y
fBodyAcc_std_Z
fBodyAccJerk_std_X
fBodyAccJerk_std_Y
fBodyAccJerk_std_Z
fBodyGyro_std_X
fBodyGyro_std_Y
fBodyGyro_std_Z
fBodyAccMag_std
fBodyBodyAccJerkMag_std
fBodyBodyGyroMag_std

### Column Header meaning for tidy_data data frame.

subject_number 
	* Identifies the subject who performed the activity
	* Possible values 1 : 30

activity_name
	* Name of the activity performed
	* Possible values WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

measurement
	* Name of the measurement being captured
	* This has one of the 66 values listed/described above as the dataset features

mean(value)
	* Average of the summarized values of the meansurement
        
