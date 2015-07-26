# libraries needed
library(plyr);

# globals
data_zip_file_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_dest_file = "dataset.zip"
data_set_dir_name = "./UCI HAR Dataset"

##############################
##
## functions
##
##############################

# files -- from readme.txt
getFileNames <- function (data_dir = data_set_dir_name) {
	
	featureInfo 	<- sprintf('%s/features_info.txt', data_dir)			#: Shows information about the variables used on the feature vector.
	features 		<- sprintf('%s/features.txt', data_dir)					#: List of all features.
	activityLabels 	<- sprintf('%s/activity_labels.txt', data_dir)		#: Links the class labels with their activity name.
	subject_train 	<- sprintf('%s/train/subject_train.txt', data_dir)				#: Training set.
	x_train 		<- sprintf('%s/train/X_train.txt', data_dir)				#: Training set.
	y_train 		<- sprintf('%s/train/y_train.txt', data_dir)				#: Training labels.
	subject_test 	<- sprintf('%s/test/subject_test.txt', data_dir)					#: Test set.
	x_test 			<- sprintf('%s/test/X_test.txt', data_dir)					#: Test set.
	y_test 			<- sprintf('%s/test/y_test.txt', data_dir)  					#: Test labels.
	list( featureInfo=featureInfo, features=features,
		activityLabels=activityLabels, x_train=x_train,
		y_train=y_train, x_test=x_test, y_test=y_test,
		subject_test=subject_test, subject_train=subject_train)	
}

combineData <- function() {
	activityLabels <- read.table(fileNames$activityLabels)

	activityTestData <- read.table(fileNames$y_test, header=FALSE)
	activityTrainData <- read.table(fileNames$y_train, header=FALSE)

	subjectTestData <- read.table(fileNames$subject_test, header=FALSE)
	subjectTrainData <- read.table(fileNames$subject_train, header=FALSE)

	featureTestData <- read.table(fileNames$x_test, header=FALSE)
	featureTrainData <- read.table(fileNames$x_train, header=FALSE)


	# set the names of the variables
	dataSubject <- rbind(subjectTrainData, subjectTestData)
	dataActivity <- rbind(activityTrainData, activityTestData)
	dataFeatures <- rbind(featureTrainData, featureTestData)

	names(dataSubject) <- c("subject")
	names(dataActivity) <- c("activity")
	dataFeaturesNames <- read.table(fileNames$features,header=FALSE)
	names(dataFeatures)<- dataFeaturesNames$V2

	# merge the dataFeatures
	dataCombine <- cbind(dataSubject, dataActivity)
	theData <- cbind(dataFeatures, dataCombine)

	#wantedNames <- features$V2[grep(".*mean.*|.*std.*", features$V2)]
	subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
	#subsetNames <- c(as.character(wantedNames), "subject, activity")
	selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

	#subdata <- subset(data, select=subsetNames)
	theData<-subset(theData,select=selectedNames)
	theData
}


######################################################
#script proper
if(!file.exists(data_set_dir_name)) {
	if(!file.exists(data_dest_file)) {
		download.file(data_zip_file_url, destfile=data_dest_file, method="curl")
	}	
	unzip(data_dest_file)
}

# get file names
fileNames = getFileNames()

theData = combineData()

# do some re-naming
names(theData)<-gsub("^t", "time", names(theData))
names(theData)<-gsub("^f", "frequency", names(theData))
names(theData)<-gsub("Acc", "accelerometer", names(theData))
names(theData)<-gsub("Gyro", "gyroscope", names(theData))
names(theData)<-gsub("Mag", "magnitude", names(theData))
names(theData)<-gsub("BodyBody", "body", names(theData))



outData<-aggregate(. ~subject + activity, theData, mean)
outData<-outData[order(outData$subject,outData$activity),]
write.table(outData, file = "outputData.txt", row.name=FALSE)

