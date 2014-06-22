Code Book - run_analysis.R
==========================

# Variables
## Variables for read.table|
Variable Name|Description|
-------------|-----------|
features|Data frame to hold contents of features.txt|
activity_labels|Data frame to hold the activity number and corresponding descriptions (activity_labels.txt)|
subject_train|Data frame to hold the subjects assigned to the training dataset (subject_train.txt)|
subject_test|Data frame to hold the subjects assigned to the test dataset (subject_test.txt)|
x_train|Data frame to hold the x_train.txt dataset|
y_train|Data frame to hold the y_train.txt dataset|
x_test|Data frame to hold the x_test.txt dataset|
y_test|Data frame to hold the y_test.txt dataset|

## Other Variables
Variable Name|Description|
-------------|-----------|
a|Logical vector to determine which columns to keep for subsetting only mean and standard deviation|
descriptiveColName|List variable to replace supplied column names with descriptive ones|
mergedData|Data frame to hold the merged rows from train and test data sets along with the columns for subject and activities|
tidyData|Data frame to hold the summarized data by Subject and Activity |

# Summary of approach
1. Read all input datasets
2. Assign column headings to each dataset - needed to determine what data columns were
3. Based on column headings stripped out any columns that were not Standard Deviation or Mean
4. Extracted column names from remaining set and observed values of columns names
5. Created a list of replacements required to make names meaningful and used gsub on the list for each replacement
6. Reassigned descriptive column names to dataset
7. Merged the datasets once the subset of the data was completed
8. Used aggregate function to summarize the data by Subject and Activity - summary was "mean"
9. Aggregate function inserted the Subject and Activity columns as  group columns in the dataset, thus duplicating those columns.
10. Updated the tidyData data frame using "unique" function to remove the duplicate columns
11. When dataset was written out the default row headings (row numbers) were inserted as first column in dataset, throwing the column names off by one
12. Updated the write.table call with row.names=False to fix above issue.
