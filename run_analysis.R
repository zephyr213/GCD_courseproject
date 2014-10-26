# first read in the train, test data

testx <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F)
testy <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
tests <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)

trainx <- read.table("./UCI HAR Dataset/train/X_train.txt", header = F)
trainy <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)
trains <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)


# read in the variable descriptions

features <- read.table("./UCI HAR Dataset/features.txt")

# find only the mean() and std() variable index and create new index

meanindex <- grep("-mean()", features$V2, fixed = T)
stdindex <- grep("-std()", features$V2, fixed = T)
newindex <- sort(c(meanindex, stdindex))

# subset x data
testx1 <- testx[ ,newindex]
trainx1 <- trainx[ ,newindex]

# include label in y data and
testnew <- cbind(testx1, testy, tests)
trainnew <- cbind(trainx1, trainy, trains)

#merge test and train
testnew$group <- "test"
trainnew$group <- "train"
vnames1 <- featurex$V2[newindex]
vnames <- c(vnames1, "activity", "subject", "group") # descriptive variable name
names(testnew) <- vnames
names(trainnew) <- vnames
newdata <- rbind(testnew, trainnew)

#substitute label into activity
newdata$activity <- as.numeric(newdata$activity)
for (i in 1:length(newdata$activity)) {
    if (newdata$activity[i] == 1) newdata$activity[i] <- "WALKING"
    if (newdata$activity[i] == 2) newdata$activity[i] <- "WALKING_UPSTAIRS"
    if (newdata$activity[i] == 3) newdata$activity[i] <- "WALKING_DOWNSTAIRS"
    if (newdata$activity[i] == 4) newdata$activity[i] <- "SITTING"
    if (newdata$activity[i] == 5) newdata$activity[i] <- "STANDING"
    if (newdata$activity[i] == 6) newdata$activity[i] <- "LAYING"
}
# now newdata is the merged data set

# now create a second tidy dataset
library(reshape2)
tmpdata <- melt(newdata, id = c("activity", "subject"), measure.vars = vnames1)
newdata_2 <- dcast(tmpdata, activity + subject ~ variable, mean) 
# now newdata_2 is the data set required for step 5