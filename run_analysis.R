# This script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data 
#    set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy 
#    data set with the average of each variable for each activity and each 
#    subject.

library(dplyr)
library(data.table)

run_analysis <- function() {
        
        ## All given raw data files are loaded into memory by calling read.table().
        dtLabels <- data.table(read.table("./activity_labels.txt", sep = "", 
                               header = F, quote = "", col.names = c("activity.id", "activity")))
        dfFeats <- read.table("./features.txt", sep = "", header = F, 
                              quote = "", col.names = c("id", "feature"), stringsAsFactors = F)
        
        dfXTrain <- read.table("./X_train.txt", sep = "", 
                               header = F, quote = "", col.names = dfFeats$feature)
        dfYTrain <- read.table("./y_train.txt", sep = "", 
                               header = F, quote = "", col.names = "activity.id")
        dfSbjTrain <- read.table("./subject_train.txt", sep = "", 
                                 header = F, quote = "", col.names = "subject")
        
        dfXTest <- read.table("./X_test.txt", sep = "", 
                              header = F, quote = "", col.names = dfFeats$feature)
        dfYTest <- read.table("./y_test.txt", sep = "", 
                              header = F, quote = "", col.names = "activity.id")
        dfSbjTest <- read.table("./subject_test.txt", sep = "", 
                                header = F, quote = "", col.names = "subject")
        
        ## Column-binda the tables "X_train", "y_train", and "subject_train" to produce an 
        ## intermediate table "train".
        dtTrain <- data.table(cbind(dfXTrain, dfYTrain, dfSbjTrain))
        
        ## Column-binda the tables "X_test", "y_test", and "subject_test" to produce an 
        ## intermediate table "test".
        dtTest <- data.table(cbind(dfXTest, dfYTest, dfSbjTest))
        
        ## Row-bind the tables "train" and "test" to produce an intermediate table "all".
        ## This should bind all give tables togather except the "activity_label".
        dtAll <- rbind(dtTrain, dtTest)
        
        ## Extracts the measurements on the mean and standard deviation for each measurement 
        ## to produce an intermediate table "extract".
        mean_std <- filter(dfFeats, grepl("-mean\\(\\)|-std\\(\\)", feature))
        dtExtract <- data.table(select(dtAll, c(subject, activity.id, mean_std$id)))
        
        ## Merges the tables "extract" and "activity_labels".
        setkey(dtLabels, activity.id)
        setkey(dtExtract, activity.id)
        dtExtract <- merge(dtLabels, dtExtract)
        
        ## Drops the dup column
        dtExtract <- select(dtExtract, -(activity.id))
        
        ## Gets data set with the average of each variable for each activity and 
        ## each subject.
        dtFinal <- dtExtract %>% group_by(activity, subject) %>% summarise_each(funs(mean))
        ## Updates the descriptive variable names. i.e. Mean of the mean/std values.
        setnames(dtFinal, names(dtFinal)[3:68], paste0(mean_std$feature, "-mean()", collapse = NULL))

        dtFinal
}
