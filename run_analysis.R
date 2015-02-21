run_analysis  <- function () {
	
	#First block of code confirms if one of the correct file setups is present
	#If any of the file checks fails, function exits, but directs the user to README for correct setup 
  
	#Initial check is for either the root directory or the zip file to be present
	#If it's the zip file, that is unzipped & verfied
	if (!file.exists("UCI HAR Dataset")) {
	  if (file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
		  unzip("getdata-projectfiles-UCI HAR Dataset.zip")
	  	if (!file.exists("UCI HAR Dataset")) {
	  		print("Unzip failed to extract as expected.") 
	  		print("Please check that the functionality exists on the machine running this script")
	  		print("If failures continue, check README for other file configration options")
	  		return()
	  	}	
    } else {
    	print("Filesetup incorrect to run this script.  Please see File setup information in READ.md")
    	return()
    } 	
  } 
  #Second check is if each file that will be used in the function is present in the
	#expected directory structure.
	if (!(file.exists("UCI HAR Dataset/activity_labels.txt") &
		    file.exists("UCI HAR Dataset/features.txt") &
		    file.exists("UCI HAR Dataset/train/X_train.txt") &
		    file.exists("UCI HAR Dataset/train/y_train.txt") &
		    file.exists("UCI HAR Dataset/train/subject_train.txt") &	
		    file.exists("UCI HAR Dataset/test/X_test.txt") &
		    file.exists("UCI HAR Dataset/test/y_test.txt") &
		    file.exists("UCI HAR Dataset/test/subject_test.txt"))) {
	  print("One or more required files missing from dataset.") 
    print("Please see README_from_dataset for complete file listing")
		return()
	}
	
	#Second block of code reads in data from files, including adding descriptive column names 
	#The data in the file features.txt contains the descriptive names for the main test/train 
	#data files
	activity_col_names <- c("activity_number", "activity_name")
	activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=activity_col_names)
	features <- read.table("UCI HAR Dataset/features.txt")
	train_x  <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
	train_y  <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="activity_number")
	train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names="subject_number")
	test_x  <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
	test_y  <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="activity_number")
	test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names="subject_number")
	
	#Merge data to a single data set
	#Create 1 training data frame & 1 test data frame with the same structure
	#Then combine those 2 data frames into a single data frame
	total_train <- cbind(train_subject, train_y)
	total_train <- cbind(total_train, train_x)
	total_test <- cbind(test_subject, test_y)
	total_test <- cbind(total_test, test_x)
	total_data <- rbind(total_train, total_test)
	
	#Before data manipulation begins, load the dplyr package just in case 
	library(dplyr)
	
	#Extract the mean & standard deviation for each measurement
	#The subject & activity information should also be kept since they're needed in later analysis
	data_subset <- select(total_data, subject_number, activity_number,
		contains("mean", ignore.case=FALSE), contains("std")) %>% select(-contains("meanFreq"))
	
	#Add activity_name to the data subset by merging it with the data from activity_labels
	#The two data sets can be joined on activity_number for the merge
	data_with_activity <- merge(activity_labels, data_subset,
		by.x="activity_number", by.y="activity_number", all=TRUE)
	
	#Clean up column names that resulted from features.txt having characters not allowed in 
	#R data frame column names and remove redundant activity_number column for  data frame
	colnames(data_with_activity) <- gsub("...", "_", colnames(data_with_activity), fixed=TRUE)
	colnames(data_with_activity) <- gsub("..", "", colnames(data_with_activity), fixed=TRUE)
	colnames(data_with_activity) <- gsub(".", "_", colnames(data_with_activity), fixed=TRUE)
	
	final_data <- tbl_df(select(data_with_activity, -activity_number))
	
	#Create the long form of the tidy data set where each row contains a mean value for a single combination
	#of subject, activity & measurement
	tidy_data <- gather(final_data, measurement, value, -(subject_number:activity_name)) %>%
		       group_by(subject_number, activity_name, measurement) %>%
		       summarise(mean(value))
	return(tidy_data)
	
}