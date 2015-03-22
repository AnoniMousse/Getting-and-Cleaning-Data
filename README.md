# Getting-and-Cleaning-Data
Repo for Coursera class
PURPOSE
The purpose of the data analysis is to fulfill the requirements of the Coursera class Getting and Cleaning Data. Specifically, the course website calls for the following:

“You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.”

FILES
R script: The R file that processes the data to achieve the results required is run_analysis.R. Executing the script will achieve the desired outcome by assembling the files that were provided by the original authors (Reyes-Ortiz et al., 2012) into one big tidy data file, extracting out the required features, aggregating these features by taking their means, and writing the aggregated data into a tidy data file which I have called FinalData.txt. More detail on how the script combines all the files into one big file can be found in the comments in the file. Note: the script will run in the current directory if the zip files are unzipped in the current directory. The zip file is included in the repository and was originally found at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

Data Files: The data are split up into various files that contain the components that would go into one big tidy data file. Apparently the data were split up that way in order to be used with relational data bases. The data files in the original zip are split into files pertaining to a training set and a test set.  All files are matched by row sequence. The data files are the following:

Identification Data Files:
subject_train.txt and subject_test.txt: These files contain only one column that is a unique identifier for each of the thirty subjects (volunteers) who contributed that particular record (row)

y_train.txt and y_test.txt: The numeric code corresponding to the activity that the subject was performing when that record was recorded. 

activity_labels.txt: Descriptive labels of the activities that were being performed, linked by the numeric codes in y_train.txt and y_test.txt.

features.txt: These are the labels for the features (columns) in y_train.txt and y_test.txt, described below. Only those features meeting the class requirements were retained for the final data set. I interpret the instructions to require me to keep those features whose names end in “mean()” and “std()”. The feature names were modified to be more compliant with the requirements of the R language. And since I find it nearly impossible to know what these features really mean, I am keeping variations of the original names as “descriptive labels).”

Performance/movement measure files:
x_test.txt and y_train.txt: These are the features, i.e., actual measures of the movement data captured by the gizmos inside the smart phones. The data have been transformed as noted in the README file provided by the original authors. The interested reader can also consult the original README file to see the description of what these data really mean. 

Output Files:
Although not required by this exercise,  the script writes the large tidy data set created at the end of step 4 to disk so that it can be used in future analyses. The file is output to ./data/FinalData.csv.

The final tidy set required in step 5 is output to ./data/TidyData.txt.






































































































































































































