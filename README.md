# gedata_proj
Stores necessary files for the Coursera "Getting &amp; Cleaning Data" course project

### Source Data Information

This project uses a data set gathered from Samsung Galaxy S smartphone, described here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data set to be used with the run_analysis.R script was downloaded from here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The unaltered README from the source dataset has been added to the repository as:
README_from_dataset.txt

###File Setup Information for run_analysis

The run_analysis.R script contained in this repository requires 1 of the 2 following file configurations to work:

1. The getdata-projectfiles-UCI HAR Dataset.zip file initially downloaded from the data set URL above must be present in the working directory 
(i.e. the same directory as run_analysis.R)

2. The unmodified directory/file structure that results from unzipping the getdata-projectfiles-UCI HAR Dataset.zip file should be 
present in the working directory.  This means the root folder (UCI HAR Dataset) should be in the same directory as run_analysis.R
and rest of the subdirectory/file structure should be unchanged from how unzip extracted them.

If there are issues finding individual files in the script, but the root directory was present as described in option 1, the user should confirm that the following 
files are all in the correct location according to the README_from_dataset.txt file.  The following files should be present in the directory strcucture indicated:
* activity_labels.txt
* features.txt
* train/X_train.txt
* train/y_train.txt
* train/subject_train.txt
* test/X_test.txt
* test/y_test.txt
* test/subject_test.txt

###R Setup requirements

The run_analysis script loads the dplyr package, so it does assume the package has already been installed

###Explanation of run_analysis.R script


1. The first block of code confirms that the files required for this script to run are available in 1 of the 2 options described above.  (See File Setup informtion for run_analysis.)  Any issues with finding files will abort the script with an error message sent back to the user.

2. If all files exist, they are read into data frames.  This step goes ahead & assigns preliminary column names for easier data manipulation in later steps.

3. The 6 training & test files are combined to a single data frame, total_data.  
  * First, cbind is used to bind all training data together to single data frame. 
  * Then cbind is used again to bind all test data together  to a single data frame - the structure should match the training data frame 
  * Finally, rbind is used to combine the training & test data frames to a single data frame.  The cbind order when manipulating the training & test data files ensured that the training & test data frames had all columns in the same order, so rbind could be used.

4. Now that the data has been combined, the dplyr library is loaded to be sure all functions the script uses for data manipulation are available.

5. The next step subsets the total_data data frame, selecting out only the mean and standard deviation measurements out of the features in total_data.  Subject & activity information are also preserved in the subset since those are needed for later analysis.  
  1.  There was some ambiguity in regard to the instruction to include mean measurements, specifically that the original dataset included values for mean() and meanFreq() as well as angle() values that also contained Mean in the signal vector names. 
  2.  This script only selects mean() measurements in this subselect since the others are, according to the variable descriptions provided in the original data set, slightly different measurements, regardless of the fact that they include mean in the variable name of the measurement.  
  3.  This decision means that 66 features/measurements are retained from the total data set.  The list of 66 items, plus explanation for the naming, can be found in the codebook for this project.

6. The next step adds descriptive activity names (rather than the numbers that were present initially) by merging the data subset created in step 5 with the activity label data read in back in step 3.  The shared value, activity number, is used to join these two data sets.

7. Finally, some cleanup is done on the intermediate data frame, data_with_activity, to make it easier to turn it into a tidy data set.  The output of this step is the local data frame final_data.  Specifically, 
  1. Column names are cleaned up; illegal characters for data frame column names in the features.txt file made for messy initial names.  See the codebook.md file for details on what the final names mean & specifics on how they were renamed.
  2. The now redundant activity_number column is removed; activity_name is the same information in a much more readable form.

8.  Creating a tidy data set
  1.  From the final state of the raw data (final_data) available at the end of step 7, the following steps are applied to turn this into a tidy data set that meets the tidy data principles of having a single variable per column & a single observation per row.  
  2. This script produces the long form of the tidy data set, meaning that there is 1 row per subject/activity/measurement and the row contains the mean of the values in the final_data set for that subject/activity/measurement combination.  Please see the codebook for specifics on the structure of the tidy data result.  
  3. The steps taken to transform the final_data data frame to a tidy data set are:
    1.  Since this script produces the long form of the tidy data set, the first step is that the 66 measurements still present in final_data must be gathered along with defining a value column to hold the measurement value in each row.  (For specifics on why 66 measurements, please see the explanation in step 5 above on the subselect decision for mean values.)  The subject_number & activity_name are the only existing columns not gathered.
    2.  Since we want 1 row per subject/activity/measurement, the next step is to group by those values so any operations will be applied to the specific grouping
    3.  Finally, summarize is used to make sure we have only 1 value per each subject/activity/measurement combination, which guarantees this final data set is tidy by having 1 row per observation.  The mean value is applied during summary so we're storing the average value of each summarized measurement. 

9.  (Outside of run_analysis.R)  The course project instructed us to upload the results of run_analysis, but didn't indicate that should be part of the run_analysis script.  So, the final step of the script is to create (and return) the tidy data set.  However, the following commands were executed in the R console to run and the save the results of run_analysis.R
  1. source("run_analysis.R")
  2. output <- run_analysis()
  3. write.table(output, file = "project_tidy_data.txt", row.name=FALSE)

### Instruction for evaluating the output of run_analysis.R

The output of the run_analysis.R script was saved as the file project_tidy_data.txt and submitted to Coursera for evaluation
The following steps make it possible to evaluate this output:

1.  Store the file project_tidy_data.txt to your working directory. 
  1.  I don't know if a fileURL will be made available to graders, but, if one is, then the following set of commands would allow the user to download the data file to their working directory.
    1.  fileUrl <- "Place the provided URL here"
    2.  download.file(fileUrl, destfile="project_tidy_data.txt", method="curl")  #The method = "curl" option may not be necessary depending on the users machine & the type of URL
  2. If a fileURL is not provided, then the user should use whatever local method is available to save the file project_tidy_data.txt to their R working directory.  If possible, the file name should be preserved so that the commands below will work without modification.
2. Read the file into R and then display the data using the following commands.  
  1.  These commands assume you did not change the name of the file from "project_tidy_data.txt".  If you did change the name when storing the file, you will also need to change local file name used in the first command.
  2.  submission <- read.table("project_tidy_data.txt", header = TRUE)
  3.  View(submission)
  4.  Since this is the long form of the data, only the first 1000 rows (out of 11880) will be visible in View.
3.  An explanation of the column headers is available in the project codebook.  Please see the section Column Header meanings for tidy_data data frame, which is the last section of the codebook.  The same column headers used in the tidy_data data frame are present in the output file.


###Other sources
Other than items quoted and noted as coming from the original source documentation, all information provided in the README.md & codebook.md files is original.  However, suggestions on the type of information to include were taken from the course discussion forum thread, 'David's Course Project FAQ', which can be seen here: (assuming you have permission to view the class discussion forum)
https://class.coursera.org/getdata-011/forum/thread?thread_id=69
