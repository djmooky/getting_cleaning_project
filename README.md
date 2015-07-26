# getting_cleaning_project

This script will:


Download and unzip data set.
Read in the activity test and training data.
Read in the subject test and training data.
Read in the feature test and training data.

Use rbind to combine the test and training data for each subsection, activity, subject and feature.
Set the name for the variables in the subject data to "subject".
Set the name for the variables in the activity data to "activity".

Combine the data sets from the previous 3 combined sets into a single large data set.
Create a list of feature names with the words "mean" or "std" in them.
Use this created list to filter out the unwanted features.

Perform some renaming of the feature names for clarity

Copy the data to a new variable and perform the writing of the data to outputData.txt