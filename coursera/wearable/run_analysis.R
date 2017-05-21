#
# Library Dependencies
#
suppressMessages(library(dplyr))

#
# Download Data
#

download_zipped_data <- function(url, destination) {
  temp_file <- tempfile()
  download.file(url, temp_file)
  unzip(zipfile = temp_file, exdir = destination)
  unlink(temp_file)
}
download_zipped_data("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                     "./data")

#
# Load Raw Data
#

# Feature Data
test_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
train_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
feature_names <- features[, 2]

# Label Data
test_labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
train_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)

# Subject Data
test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)

# Activities Data
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")


#
# Data Cleanup
#

# Compute variable names
variables <- c(feature_names, "ActivityID", "SubjectID")

# Compute pertinent variables
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)

# Add variable names to loaded data-set 
add_variable_names <- function(data) {
  names(data) <- variables
  data
}

# Filter out non-pertinent variables
select_pertinent_variables <- function(data)
  data[, c(mean_variables, std_variables, "ActivityID", "SubjectID")]

# Normalize variable names
normalize_variable_names <- function(data) {
  names(data) <- make.names(names(data))
  names(data) <- gsub("\\.", "", names(data))
  names(data) <- gsub("mean", "Mean", names(data))
  names(data) <- gsub("std", "Sigma", names(data))
  names(data) <- gsub("Acc", "Acceleration", names(data))
  names(data) <- gsub("Mag", "Magnitude", names(data))
  data
}

# Join feature and label data with activity data
names(activities) <- c("ActivityID", "ActivityName")
add_activity_name_variable <- function(data, activities) {
  data <- merge(data, activities)
  data <- data[, !names(data) %in% c("ActivityID")]
  data
}

# Putting all transformations together in a single function
cleanup_data <- function(data, labels, subjects) {
  data <- cbind(data, labels)
  data <- cbind(data, subjects)
  data <- add_variable_names(data)
  data <- select_pertinent_variables(data)
  data <- normalize_variable_names(data)
  add_activity_name_variable(data, activities)
}

# Apply the transformation to the data-sets
test_data <- cleanup_data(test_data, test_labels, test_subjects)
train_data <- cleanup_data(train_data, train_labels, train_subjects)

# Bind training and testing data together
all_data <- rbind(test_data, train_data)

#
# Compute Averages per Subject and Activity
#

averages_data <- all_data %>% group_by(SubjectID, ActivityName) %>% summarise_each(funs(mean))

#
# Save output data to disk
#

suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE)