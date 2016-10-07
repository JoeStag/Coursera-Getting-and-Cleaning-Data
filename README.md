# Coursera-Getting-and-Cleaning-Data
For the Coursera Getting and Cleaning Data final project

The script run_analysis.R is for the UCI HAR Dataset that has already processed data from testing done with a Samsung Galaxy S II to record information about human movement during 6 different activities. The script does the following:

1. It checks to see if a data directory exists in the working directory. If not it will create the directory.
2. Checks to see if the file has already been downloaded, and downnloads the file if it has not.
3. It unzips the file contents into the data directory, then sets the working directory to the unzipped file. 
4. Reads in the data from the features and activity type. 
5. Reads in the data from both Train and Test folders for subject, X, and Y. 
6. Names the columns for the Train and Test data, then combines them into one file.
7. It then selects a subset of columns from the data frame. 
8. Creates tidy data column names. 
9. Merges data into a tidy data and writes a table to the directory called tidyData.txt
