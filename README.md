### What this project does
To prepare a tidy data that can be used for later analysis by using R libraries to read, bind, group, filter, and merge, etc. the given raw data files.

### What are in this project 
The R script

* run_analysis.R - To prepare a tidy data. 

The Code Book

* CodeBook.md - Data dictionary; describing the variables.

### Given raw data and other info

The given set of raw data files are as follow:

* features.txt - List of all features.
* activity_labels.txt - Links the class labels with their activity name.
* X_train.txt - Training set.
* y_train.txt - Training labels.
* X_test.txt - Test set.
* y_test.txt - Test labels.
* subject_train.txt -  Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
* subject_test.txt -  Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

The info files

* README.txt
* features_info.txt - Shows information about the variables used on the feature vector.

### How is the tidy data prepared

1. All given raw data files are loaded into memory by calling read.table().
    a. The features listed in the "features" table are the variable names of both tables "X_train", and "y_train".
    b. Other tables are provided with respective meaningful variable names.
2. Column-binda the tables "X_train", "y_train", and "subject_train" to produce an intermediate table "train".
3. Column-binda the tables "X_test", "y_test", and "subject_test" to produce an intermediate table "test".
4. Row-bind the tables "train" and "test" to produce an intermediate table "all".  This should bind all give tables togather except the "activity_label".
5. Extracts the measurements on the mean and standard deviation for each measurement to produce an intermediate table "extract".
6. Merges the tables "extract" and "activity_labels".
7. Drops the dup column; the id column originated in tbale "activity_labels". This should form the tidy data set that each variable measured should be in one column, and each different observation of that variable should be in a different row.
8. Gets data set with the average of each variable for each activity and each subject.
9. Updates the descriptive variable names. i.e. Mean of the mean/std values.

### Some considerations

* To extracts the measurements on the mean and standard deviation for each measurement, only the feature/variable names that contain either "-mean()" or "-sdt()" substring, case sensitive, are considered. The decision is based on what is mentioned in the features_info.txt file. For that reason, the features that contains substring either "meanFreq()" or "Mean", as they are for other measurements.

* The returned data table from R script run_analysis.R contains the mean of the measurements on the mean and standard deviation for each measurement.  For that reason, all these columns were renamed by appending a postfix "-mean()".



