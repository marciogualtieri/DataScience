-   [Installing the Required Packages](#installing-the-required-packages)
-   [Importing the Required Packages](#importing-the-required-packages)
-   [Raw Data](#raw-data)
    -   [Downloading the Data](#downloading-the-data)
    -   [Data Files](#data-files)
    -   [Data Overview](#data-overview)
-   [Data Cleanup](#data-cleanup)
    -   [Loading the Raw Data](#loading-the-raw-data)
        -   [Feature Data](#feature-data)
        -   [Feature Names](#feature-names)
        -   [Label Data](#label-data)
        -   [Subject Data](#subject-data)
        -   [Activity Names Data](#activity-names-data)
    -   [Pertinent Variables (Mean, Standard Deviation, Activity & Subject)](#pertinent-variables-mean-standard-deviation-activity-subject)
    -   [Binding Feature, Label and Subject Data Together](#binding-feature-label-and-subject-data-together)
    -   [Re-Naming the Data-set Variables](#re-naming-the-data-set-variables)
    -   [Filtering Out Non-Pertinent Variables](#filtering-out-non-pertinent-variables)
    -   [Normalizing Variable Names](#normalizing-variable-names)
    -   [Joining with Activity Names Data](#joining-with-activity-names-data)
    -   [Putting All Transformations Together](#putting-all-transformations-together)
    -   [Resulting Clean Data-set](#resulting-clean-data-set)
-   [Computing Averages per Activity and Subject](#computing-averages-per-activity-and-subject)
-   [Saving the Output Data to Disk](#saving-the-output-data-to-disk)

<h1>
Wearable Computing: Human Activity Recognition Using Smartphones
</h1>
<br/>

Installing the Required Packages
--------------------------------

You might need to install the following packages if you don't already have them:

``` r
install.packages("dplyr")
```

Just uncomment the packages you need and run this chunk before you run the remaining ones in this notebook.

Importing the Required Packages
-------------------------------

Once the libraries are installed, they need to be loaded as follows:

``` r
suppressMessages(library(dplyr))
```

Raw Data
--------

### Downloading the Data

The data is packaged in a zip file and can be downloaded from the given [URL](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip):

``` r
download_zipped_data <- function(url, destination) {
  temp_file <- tempfile()
  download.file(url, temp_file)
  unzip(zipfile = temp_file, exdir = destination)
  unlink(temp_file)
}

download_zipped_data("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                     "./data")
```

This file has been downloaded from [UCI's Machine Learning Repository](http://archive.ics.uci.edu/ml/). You will find the original data [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

### Data Files

Here's a list of the unzipped files:

``` r
list.files(path = "./data", recursive = TRUE)
```

    ##  [1] "UCI HAR Dataset/activity_labels.txt"                         
    ##  [2] "UCI HAR Dataset/features_info.txt"                           
    ##  [3] "UCI HAR Dataset/features.txt"                                
    ##  [4] "UCI HAR Dataset/README.txt"                                  
    ##  [5] "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
    ##  [6] "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
    ##  [7] "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
    ##  [8] "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
    ##  [9] "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
    ## [10] "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
    ## [11] "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
    ## [12] "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
    ## [13] "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
    ## [14] "UCI HAR Dataset/test/subject_test.txt"                       
    ## [15] "UCI HAR Dataset/test/X_test.txt"                             
    ## [16] "UCI HAR Dataset/test/y_test.txt"                             
    ## [17] "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
    ## [18] "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
    ## [19] "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
    ## [20] "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
    ## [21] "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
    ## [22] "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
    ## [23] "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
    ## [24] "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
    ## [25] "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
    ## [26] "UCI HAR Dataset/train/subject_train.txt"                     
    ## [27] "UCI HAR Dataset/train/X_train.txt"                           
    ## [28] "UCI HAR Dataset/train/y_train.txt"

Follows a short description of its contents:

<table>
<colgroup>
<col width="21%" />
<col width="78%" />
</colgroup>
<thead>
<tr class="header">
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>README.txt</td>
<td>An overview of the experiment performed to collect the data.</td>
</tr>
<tr class="even">
<td>features_info.txt</td>
<td>A brief description of the feature variables contained in the data-set.</td>
</tr>
<tr class="odd">
<td>features.txt</td>
<td>A list of the available feature variables with their respective index numbers.</td>
</tr>
<tr class="even">
<td>activity_labels.txt</td>
<td>A list of activities, i.e., walking, sitting, stading, etc with their respective indexes.</td>
</tr>
<tr class="odd">
<td>train/X_train.txt</td>
<td>&quot;X&quot; is a matrix with training feature data.</td>
</tr>
<tr class="even">
<td>train/y_train.txt</td>
<td>&quot;Y&quot; is a vector with the label/response for the training data.</td>
</tr>
<tr class="odd">
<td>train/subject_train.txt</td>
<td>&quot;subject&quot; is a vector with the subject ID's for the training data.</td>
</tr>
<tr class="even">
<td>train/Inertial Signals/*.txt</td>
<td>The original pre-processed training data.</td>
</tr>
<tr class="odd">
<td>test/X_test.txt</td>
<td>&quot;X&quot; is a matrix with testing feature data.</td>
</tr>
<tr class="even">
<td>test/y_test.txt</td>
<td>&quot;Y&quot; is a vector with the label/response for the test data.</td>
</tr>
<tr class="odd">
<td>test/subject_test.txt</td>
<td>&quot;subject&quot; is a vector with the subject ID's for the test data.</td>
</tr>
<tr class="even">
<td>test/Inertial Signals/*.txt</td>
<td>The original pre-processed test data.</td>
</tr>
</tbody>
</table>

> **Note:** The data files have no headers, one record per line and columns are space delimited.

### Data Overview

The pre-processed data ("Inertial Signals" folders) has been collected from human subjects carrying cellphones equipped with built-in accelerometers and gyroscopes. The purpose of the experiment that collected this data is to use these measurements to classify different categories of activities performed by human subjects (walking, sitting, standing, etc).

The accelerometers and gyroscopes produce tri-axial measurements (carthesian X, Y & Z components) for the acceleration (in number of g's, where "g" is the Earth's gravitational acceleration, i.e., ~ 9.764 m/s2) and angular velocity (in radians per second) respectively.

These measurements are collected overtime at a constant rate of 50 Hz, i.e., a measurement is performed every 1/50 seconds (thus, the respective variables prefixed with 't', which stands for "time domain signal").

The acceleration measured has components due to the Earth's gravity and due to the subject's body motion. Given that the Earth's gravity is constant (low frequency), a low-pass filter was used to separate the action due to the Earth's gravity from the action due to body motion. The body variables are infixed with "body", while gravity variables are infixed with "gravity".

A Fast Fourier Transform for the given sampling frequency of 50 Hz and with a number of bins equal to the number of observations was applied to the "time domain signal"" variables, to generate the "frequency domain signal" variables (which are prefixed with 'f').

Finally, these measurements were used to estimate variables for mean, standard deviation, median, max, min, etc. You will find the full list of estimated variables in `features_info.txt`. These estimated variables comprise the data for the given raw training and testing data-sets.

For the purpose of this data exploration, we are not interested in the pre-processed data, thus we're going to work with the following files:

<table>
<colgroup>
<col width="28%" />
<col width="71%" />
</colgroup>
<thead>
<tr class="header">
<th>File</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>train/X_train.txt</td>
<td>training feature data.</td>
</tr>
<tr class="even">
<td>train/y_train.txt</td>
<td>training label data.</td>
</tr>
<tr class="odd">
<td>test/X_test.txt</td>
<td>test feature data.</td>
</tr>
<tr class="even">
<td>test/y_test.txt</td>
<td>test label data.</td>
</tr>
<tr class="odd">
<td>features.txt</td>
<td>feature names which map to feature index numbers.</td>
</tr>
<tr class="even">
<td>activity_labels.txt</td>
<td>human-readable labels which map to activity index numbers.</td>
</tr>
<tr class="odd">
<td>test/subject_test.txt</td>
<td>ID's of the human subjects for the testing data.</td>
</tr>
<tr class="even">
<td>train/subject_train.txt</td>
<td>ID's of the human subjects for the training data.</td>
</tr>
</tbody>
</table>

Data Cleanup
------------

### Loading the Raw Data

#### Feature Data

``` r
test_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
dim(test_data)
```

    ## [1] 2947  561

``` r
train_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
dim(train_data)
```

    ## [1] 7352  561

The feature data contains 561 feature variables and 10299 observations (adding up testing and training data-sets).

#### Feature Names

``` r
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
str(features)
```

    ## 'data.frame':    561 obs. of  2 variables:
    ##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

As expected, the list of feature names contains 561 entries, which matches with the number of columns in the feature data.

Given that we only need the feature names, let's create a new variable without the indexes (columns in the feature data are ordered in the same way as feature names, thus indexes are not necessary to join them together):

``` r
feature_names <- features[, 2]
sample(feature_names, 6)
```

    ## [1] "tBodyGyro-entropy()-Y"        "fBodyGyro-bandsEnergy()-1,24"
    ## [3] "fBodyGyro-bandsEnergy()-9,16" "tBodyGyro-entropy()-X"       
    ## [5] "tBodyAcc-entropy()-Y"         "tGravityAcc-max()-Z"

#### Label Data

In the raw data-set the labels are separated in a different file:

``` r
test_labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
dim(test_labels)
```

    ## [1] 2947    1

``` r
train_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
dim(train_labels)
```

    ## [1] 7352    1

#### Subject Data

In the raw data-set the subjects are separated in a different file:

``` r
test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
dim(test_labels)
```

    ## [1] 2947    1

``` r
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
dim(train_labels)
```

    ## [1] 7352    1

Later on we will bind feature, label and subject data together in a single data-set.

#### Activity Names Data

``` r
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activities
```

|   V1| V2                  |
|----:|:--------------------|
|    1| WALKING             |
|    2| WALKING\_UPSTAIRS   |
|    3| WALKING\_DOWNSTAIRS |
|    4| SITTING             |
|    5| STANDING            |
|    6| LAYING              |

### Pertinent Variables (Mean, Standard Deviation, Activity & Subject)

Let's create a list of all variables, which include the features names, subject and activity:

``` r
variables <- c(feature_names, "ActivityID", "SubjectID")
```

The variable names for subject and activity are my own choice. I believe they are descriptive enough.

Let's also create a list of the variables we are interested in exploring (means and standard deviations at the moment):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "fBodyGyro-bandsEnergy()-33,40" "fBodyAcc-bandsEnergy()-9,16"  
    ## [3] "tBodyGyro-arCoeff()-Z,2"       "fBodyGyro-bandsEnergy()-49,56"
    ## [5] "tGravityAcc-std()-Z"           "fBodyGyro-skewness()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "tGravityAccMag-mean()"   "tBodyGyro-mean()-Y"     
    ## [3] "tBodyAcc-mean()-Y"       "tBodyGyroJerkMag-mean()"
    ## [5] "fBodyAcc-mean()-Y"       "fBodyGyro-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAcc-std()-X"      "tGravityAcc-std()-Y"   "tBodyGyroJerk-std()-X"
    ## [4] "fBodyAcc-std()-Y"      "tBodyAcc-std()-Z"      "tBodyGyroJerk-std()-Z"

### Binding Feature, Label and Subject Data Together

``` r
test_data <- cbind(test_data, test_labels)
test_data <- cbind(test_data, test_subjects)
dim(test_data)
```

    ## [1] 2947  563

The resulting data-set has one additional column, as expected.

### Re-Naming the Data-set Variables

``` r
add_variable_names <- function(data) {
  names(data) <- variables
  data
}

test_data <- add_variable_names(test_data)
sample(names(test_data), 6)
```

    ## [1] "tBodyAccMag-energy()"           "fBodyAccMag-entropy()"         
    ## [3] "fBodyGyro-bandsEnergy()-33,40"  "fBodyBodyAccJerkMag-std()"     
    ## [5] "fBodyAccJerk-bandsEnergy()-1,8" "fBodyBodyGyroJerkMag-mean()"

### Filtering Out Non-Pertinent Variables

``` r
select_pertinent_variables <- function(data)
  data[, c(mean_variables, std_variables, "ActivityID", "SubjectID")]


test_data <- select_pertinent_variables(test_data)
names(test_data)
```

    ##  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
    ##  [3] "tBodyAcc-mean()-Z"           "tGravityAcc-mean()-X"       
    ##  [5] "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"       
    ##  [7] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
    ##  [9] "tBodyAccJerk-mean()-Z"       "tBodyGyro-mean()-X"         
    ## [11] "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"         
    ## [13] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
    ## [15] "tBodyGyroJerk-mean()-Z"      "tBodyAccMag-mean()"         
    ## [17] "tGravityAccMag-mean()"       "tBodyAccJerkMag-mean()"     
    ## [19] "tBodyGyroMag-mean()"         "tBodyGyroJerkMag-mean()"    
    ## [21] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
    ## [23] "fBodyAcc-mean()-Z"           "fBodyAccJerk-mean()-X"      
    ## [25] "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"      
    ## [27] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
    ## [29] "fBodyGyro-mean()-Z"          "fBodyAccMag-mean()"         
    ## [31] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyGyroMag-mean()"    
    ## [33] "fBodyBodyGyroJerkMag-mean()" "tBodyAcc-std()-X"           
    ## [35] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
    ## [37] "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"        
    ## [39] "tGravityAcc-std()-Z"         "tBodyAccJerk-std()-X"       
    ## [41] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
    ## [43] "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"          
    ## [45] "tBodyGyro-std()-Z"           "tBodyGyroJerk-std()-X"      
    ## [47] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
    ## [49] "tBodyAccMag-std()"           "tGravityAccMag-std()"       
    ## [51] "tBodyAccJerkMag-std()"       "tBodyGyroMag-std()"         
    ## [53] "tBodyGyroJerkMag-std()"      "fBodyAcc-std()-X"           
    ## [55] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
    ## [57] "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"       
    ## [59] "fBodyAccJerk-std()-Z"        "fBodyGyro-std()-X"          
    ## [61] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
    ## [63] "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-std()"  
    ## [65] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-std()" 
    ## [67] "ActivityID"                  "SubjectID"

### Normalizing Variable Names

``` r
normalize_variable_names <- function(data) {
  names(data) <- make.names(names(data))
  names(data) <- gsub("\\.", "", names(data))
  names(data) <- gsub("mean", "Mean", names(data))
  names(data) <- gsub("std", "Sigma", names(data))
  names(data) <- gsub("Acc", "Acceleration", names(data))
  names(data) <- gsub("Mag", "Magnitude", names(data))
  data
}

sample_data_frame <- function(data, size) {
  sample_index <- sample(1:nrow(data), size)
  return(data[sample_index, ])
}

test_data <- normalize_variable_names(test_data)
sample_data_frame(test_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  ActivityID|  SubjectID|
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|-----------:|----------:|
| 1624 |               0.3000144|               0.0093416|              -0.1016907|                  0.8868488|                 -0.2682857|                 -0.2915859|                   0.0955222|                  -0.1316500|                  -0.6236156|      -0.0556194|      -0.1172309|       0.0903534|          -0.2301955|          -0.1565550|          -0.0384956|                      -0.1985352|                         -0.1985352|                          -0.1669630|              -0.3024342|                  -0.2846359|              -0.4312911|              -0.1258534|              -0.0835381|                  -0.4082639|                  -0.1697241|                  -0.2596103|      -0.4736678|      -0.1555350|      -0.4613187|                      -0.3211049|                              -0.2530494|                  -0.2431614|                      -0.2285106|               -0.4043852|               -0.1211518|               -0.0703648|                  -0.9816037|                  -0.9860493|                  -0.9942487|                   -0.3222550|                   -0.1147562|                   -0.2520098|       -0.5798182|       -0.1755531|       -0.4311418|           -0.4362047|           -0.1692819|           -0.5876006|                       -0.3971118|                          -0.3971118|                           -0.2677903|               -0.2752391|                   -0.2600580|               -0.3939984|               -0.1740377|               -0.1379090|                   -0.2952690|                   -0.1127718|                   -0.2441298|       -0.6134887|       -0.1939932|       -0.4734668|                       -0.5379426|                               -0.2808593|                   -0.4290382|                       -0.3568798|           1|         13|
| 549  |               0.2824390|               0.0011556|              -0.1304729|                  0.9644327|                 -0.0651390|                  0.1056106|                   0.1390917|                   0.1043300|                   0.1130325|      -0.0413378|      -0.0761373|       0.0986408|          -0.4655210|           0.1267887|          -0.0036599|                      -0.2548791|                         -0.2548791|                          -0.2973637|              -0.4507082|                  -0.6628441|              -0.3869873|              -0.0741433|              -0.6814623|                  -0.2895949|                  -0.1866255|                  -0.7644068|      -0.2156800|      -0.6726573|      -0.6410914|                      -0.4130107|                              -0.2660396|                  -0.6160664|                      -0.7083189|               -0.3834696|                0.0128914|               -0.6360055|                  -0.9795773|                  -0.9863918|                  -0.9861373|                   -0.2458000|                   -0.1118892|                   -0.7977315|       -0.4399308|       -0.6249459|       -0.6855447|           -0.4374787|           -0.8128219|           -0.6574113|                       -0.4971577|                          -0.4971577|                           -0.3086507|               -0.5482339|                   -0.7286459|               -0.3819989|               -0.0068990|               -0.6392074|                   -0.2663938|                   -0.0884383|                   -0.8315343|       -0.5128212|       -0.6007790|       -0.7302659|                       -0.6296893|                               -0.3571240|                   -0.5803062|                       -0.7760761|           1|          4|
| 1026 |               0.3565334|              -0.0073061|              -0.1724061|                  0.9480175|                 -0.1509564|                  0.0307804|                  -0.3070024|                   0.0772502|                  -0.0766786|      -0.1870396|      -0.0762649|       0.1368229|          -0.5195518|          -0.1017820|           0.3225246|                       0.1250418|                          0.1250418|                          -0.0088259|              -0.0437306|                  -0.4042202|               0.0923322|               0.0015331|              -0.2693396|                   0.1577252|                  -0.1349567|                  -0.2495137|       0.0131289|      -0.2132222|      -0.0076875|                       0.1078133|                               0.1452729|                  -0.2995531|                      -0.5141391|                0.1481924|                0.0508626|               -0.3026482|                  -0.9054630|                  -0.9499779|                  -0.9156249|                    0.1428460|                   -0.0773141|                   -0.3561154|       -0.2111820|       -0.2847439|       -0.0087926|           -0.4198182|           -0.4657273|           -0.2103454|                        0.0614674|                           0.0614674|                            0.0699108|               -0.2337747|                   -0.4721617|                0.1695164|                0.0102064|               -0.3809170|                    0.0198757|                   -0.0750037|                   -0.4678946|       -0.2823506|       -0.3378617|       -0.0996864|                       -0.1307266|                               -0.0423259|                   -0.3196977|                       -0.4563506|           3|         10|
| 341  |               0.2780502|              -0.0162528|              -0.1115783|                  0.8531945|                  0.3022785|                  0.2006574|                   0.0760316|                   0.0105910|                   0.0026092|      -0.0286377|      -0.0735560|       0.0913694|          -0.1009500|          -0.0411427|          -0.0539819|                      -0.9842962|                         -0.9842962|                          -0.9898001|              -0.9848586|                  -0.9946438|              -0.9962570|              -0.9855886|              -0.9810874|                  -0.9953648|                  -0.9853649|                  -0.9864377|      -0.9921656|      -0.9872145|      -0.9928314|                      -0.9862381|                              -0.9924673|                  -0.9898052|                      -0.9956230|               -0.9958743|               -0.9882926|               -0.9627482|                  -0.9956810|                  -0.9957175|                  -0.9810865|                   -0.9947269|                   -0.9849664|                   -0.9882352|       -0.9944303|       -0.9779667|       -0.9940836|           -0.9927275|           -0.9945478|           -0.9942287|                       -0.9831963|                          -0.9831963|                           -0.9933806|               -0.9871519|                   -0.9959901|               -0.9955723|               -0.9895771|               -0.9556316|                   -0.9944044|                   -0.9855049|                   -0.9885366|       -0.9951397|       -0.9736210|       -0.9950654|                       -0.9828369|                               -0.9935821|                   -0.9872877|                       -0.9964052|           4|          4|
| 1808 |               0.3023689|               0.0041653|              -0.0457429|                  0.9393123|                 -0.2219714|                  0.0019944|                  -0.0303067|                  -0.1757196|                  -0.3212979|      -0.2581561|       0.0147788|       0.0205139|          -0.1086349|           0.3321685|          -0.1060627|                       0.0928417|                          0.0928417|                          -0.0350172|              -0.0421615|                  -0.4090859|               0.0719749|               0.2440471|              -0.1624271|                   0.0981260|                   0.0249790|                  -0.3562462|      -0.1076277|      -0.2515997|      -0.1889096|                       0.2546731|                               0.0703209|                  -0.3256106|                      -0.4884060|                0.0946232|                0.2367502|               -0.2464601|                  -0.9619484|                  -0.8824427|                  -0.8710949|                    0.1038092|                    0.1006023|                   -0.4404456|       -0.0957857|       -0.3588662|       -0.3498321|           -0.3180667|           -0.4863716|           -0.2322258|                        0.2007640|                           0.2007640|                            0.1324180|               -0.2657824|                   -0.4406004|                0.1034171|                0.1543093|               -0.3652928|                    0.0092211|                    0.1110088|                   -0.5266805|       -0.1039983|       -0.4397537|       -0.4718088|                       -0.0177058|                                0.2039848|                   -0.3505150|                       -0.4206218|           3|         13|
| 2167 |               0.2884499|              -0.0067198|              -0.0364100|                  0.9131525|                 -0.2243397|                 -0.2070921|                  -0.0485882|                   0.1120284|                  -0.0205611|      -0.1557982|       0.0003452|       0.2312991|          -0.1782172|          -0.0383847|          -0.2131130|                      -0.3691901|                         -0.3691901|                          -0.4948823|              -0.5486694|                  -0.6657704|              -0.4152265|              -0.4177596|              -0.5093722|                  -0.4329684|                  -0.5667213|                  -0.6102042|      -0.6341424|      -0.6013495|      -0.4746737|                      -0.2776259|                              -0.4076738|                  -0.6447906|                      -0.6587356|               -0.3912650|               -0.3139525|               -0.4208293|                  -0.9012042|                  -0.9764219|                  -0.8495665|                   -0.4030574|                   -0.5405875|                   -0.6407881|       -0.6850781|       -0.6263479|       -0.5555971|           -0.7241618|           -0.6585180|           -0.5874343|                       -0.2916241|                          -0.2916241|                           -0.4133754|               -0.6577091|                   -0.6683916|               -0.3819692|               -0.3066915|               -0.4185898|                   -0.4243174|                   -0.5422535|                   -0.6692026|       -0.7018219|       -0.6452950|       -0.6262047|                       -0.4094311|                               -0.4242836|                   -0.7283419|                       -0.7052071|           3|         18|

I could have expanded 't' to something like "TimeDomainSignal" and 'f' to "FrequencyDomainSignal", but I think that's unnecessary and make the variable names too big.

### Joining with Activity Names Data

Here we join the measurements data with the activity names data by "ActivityID":

``` r
names(activities) <- c("ActivityID", "ActivityName")
str(activities)
```

    ## 'data.frame':    6 obs. of  2 variables:
    ##  $ ActivityID  : int  1 2 3 4 5 6
    ##  $ ActivityName: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1

``` r
add_activity_name_variable <- function(data, activities) {
  data <- merge(data, activities)
  data <- data[, !names(data) %in% c("ActivityID")]
  data
}

test_data <- add_activity_name_variable(test_data, activities)
sample_data_frame(test_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:--------------------|
| 610  |               0.3436894|              -0.0131872|              -0.0940072|                  0.9508406|                 -0.2798615|                 -0.0172246|                   0.0472189|                  -0.2350248|                   0.0601258|      -0.3145139|       0.0121251|       0.0858877|          -0.0037226|          -0.0185287|          -0.2883139|                      -0.1778869|                         -0.1778869|                          -0.3792541|              -0.3282629|                  -0.5927682|              -0.2371362|              -0.0984105|              -0.6350042|                  -0.3582636|                  -0.2820773|                  -0.7504356|      -0.3192636|      -0.5940602|      -0.3798018|                      -0.2977913|                              -0.4056470|                  -0.5258545|                      -0.6910487|               -0.1889728|               -0.1084507|               -0.5115059|                  -0.9243578|                  -0.9709511|                  -0.8826155|                   -0.3158686|                   -0.3183658|                   -0.7726298|       -0.4823732|       -0.5065085|       -0.4994679|           -0.4430580|           -0.7313226|           -0.5042721|                       -0.2251654|                          -0.2251654|                           -0.4405385|               -0.5121570|                   -0.7083758|               -0.1706926|               -0.1701544|               -0.4873077|                   -0.3317285|                   -0.4183404|                   -0.7930703|       -0.5343138|       -0.4627783|       -0.5914064|                       -0.3074277|                               -0.4905525|                   -0.5871148|                       -0.7545212|         12| WALKING\_UPSTAIRS   |
| 2757 |               0.2701410|              -0.0125991|              -0.1127965|                 -0.1864651|                  0.8538040|                  0.4875080|                   0.0754927|                   0.0127590|                  -0.0010886|      -0.0317581|      -0.1389458|       0.1664051|          -0.1043183|          -0.0260631|          -0.0911650|                      -0.9832344|                         -0.9832344|                          -0.9890223|              -0.9439634|                  -0.9840280|              -0.9848269|              -0.9845551|              -0.9815136|                  -0.9870737|                  -0.9851995|                  -0.9896572|      -0.9796708|      -0.9648881|      -0.9381424|                      -0.9839286|                              -0.9910798|                  -0.9530733|                      -0.9844264|               -0.9855592|               -0.9871142|               -0.9730638|                  -0.9913351|                  -0.9856868|                  -0.9831780|                   -0.9874026|                   -0.9855025|                   -0.9913409|       -0.9781000|       -0.9594766|       -0.9341077|           -0.9890138|           -0.9808526|           -0.9874768|                       -0.9829819|                          -0.9829819|                           -0.9916932|               -0.9332868|                   -0.9852817|               -0.9857296|               -0.9883663|               -0.9695033|                   -0.9889431|                   -0.9869521|                   -0.9915774|       -0.9778401|       -0.9565852|       -0.9386292|                       -0.9839262|                               -0.9912801|                   -0.9323773|                       -0.9872025|         20| LAYING              |
| 838  |               0.2809610|              -0.0240699|              -0.1029422|                  0.9325029|                 -0.2385470|                 -0.1352310|                   0.0631537|                   0.1329853|                   0.0123366|      -0.3389153|       0.0575656|       0.1922645|           0.1393306|          -0.0821507|          -0.1031878|                      -0.3290037|                         -0.3290037|                          -0.5210430|              -0.3350705|                  -0.7318688|              -0.4894174|              -0.4430086|              -0.5873045|                  -0.4737230|                  -0.5392498|                  -0.6873195|      -0.4972920|      -0.6386642|      -0.5148986|                      -0.4984374|                              -0.4445129|                  -0.6983990|                      -0.7422191|               -0.3791964|               -0.3212349|               -0.4519332|                  -0.9797640|                  -0.9687218|                  -0.9721136|                   -0.4204049|                   -0.5505488|                   -0.6971396|       -0.6242600|       -0.5563514|       -0.2620352|           -0.6538189|           -0.7557152|           -0.7285897|                       -0.4459998|                          -0.4459998|                           -0.4426859|               -0.6164794|                   -0.7355798|               -0.3406126|               -0.3060383|               -0.4263325|                   -0.4162974|                   -0.5983399|                   -0.7047456|       -0.6648138|       -0.5153556|       -0.2637016|                       -0.5041121|                               -0.4397434|                   -0.6297348|                       -0.7450147|         12| WALKING\_UPSTAIRS   |
| 1057 |               0.3182156|              -0.0477498|              -0.1038352|                  0.9477887|                 -0.2062006|                  0.1052088|                   0.0349119|                   0.0281681|                  -0.0207801|      -0.0667927|      -0.1274108|       0.0062202|           0.0965935|          -0.0904748|           0.0815170|                      -0.2834205|                         -0.2834205|                          -0.4566180|              -0.4493819|                  -0.6813309|              -0.2920544|              -0.2165540|              -0.6072119|                  -0.3776399|                  -0.3606489|                  -0.6752072|      -0.4378305|      -0.6552016|      -0.3612236|                      -0.2061111|                              -0.3004742|                  -0.6578878|                      -0.7360185|               -0.2725016|               -0.1907519|               -0.5138164|                  -0.9810521|                  -0.9587348|                  -0.9676167|                   -0.3847139|                   -0.3064044|                   -0.6775021|       -0.5253051|       -0.6427144|       -0.4378275|           -0.5653750|           -0.7733170|           -0.5544109|                       -0.1960806|                          -0.1960806|                           -0.3089303|               -0.6409815|                   -0.7089451|               -0.2648625|               -0.2280234|               -0.5026549|                   -0.4497987|                   -0.2925291|                   -0.6780627|       -0.5536265|       -0.6376569|       -0.5167168|                       -0.3152638|                               -0.3228644|                   -0.6909707|                       -0.6960307|         18| WALKING\_DOWNSTAIRS |
| 721  |               0.2553956|              -0.0129163|              -0.1116268|                  0.9449048|                 -0.1459682|                 -0.1712093|                   0.0363407|                   0.0480296|                   0.3279132|       0.0728708|      -0.0584418|       0.2310391|          -0.0005248|          -0.0026179|          -0.1233296|                      -0.2960880|                         -0.2960880|                          -0.4343066|              -0.2251965|                  -0.7042004|              -0.3691019|              -0.2725345|              -0.4636429|                  -0.3840554|                  -0.5115331|                  -0.6083024|      -0.4636918|      -0.6235920|      -0.2561200|                      -0.3251047|                              -0.3336775|                  -0.6174258|                      -0.7847688|               -0.3699845|               -0.1307682|               -0.4579116|                  -0.9712539|                  -0.9161499|                  -0.9560328|                   -0.3268598|                   -0.4899808|                   -0.6359434|       -0.4490699|       -0.5702682|        0.0741980|           -0.6771156|           -0.7767052|           -0.6166070|                       -0.3419924|                          -0.3419924|                           -0.3699901|               -0.5505441|                   -0.8049438|               -0.3702491|               -0.1175628|               -0.4980810|                   -0.3268115|                   -0.5005169|                   -0.6612394|       -0.4523291|       -0.5433115|        0.0638647|                       -0.4536109|                               -0.4219003|                   -0.5828123|                       -0.8498878|          9| WALKING\_UPSTAIRS   |
| 943  |               0.2308523|              -0.0422856|              -0.0899204|                  0.8911273|                 -0.2784662|                 -0.2207862|                  -0.3042368|                   0.3129585|                   0.0864778|       0.1287200|      -0.1483702|      -0.0059513|          -0.2786850|          -0.0040840|           0.0241806|                      -0.1906097|                         -0.1906097|                          -0.4164558|              -0.2810365|                  -0.5635251|              -0.2902006|              -0.1925576|              -0.2232987|                  -0.4318719|                  -0.4918730|                  -0.3951722|      -0.3876613|      -0.3971552|      -0.3361263|                      -0.1822282|                              -0.2991060|                  -0.4514572|                      -0.5040135|               -0.3093472|               -0.0791262|               -0.1517267|                  -0.9786992|                  -0.9586799|                  -0.9454819|                   -0.4194367|                   -0.4722285|                   -0.4146212|       -0.4294672|       -0.4355078|       -0.2568029|           -0.6145717|           -0.4942424|           -0.5679675|                       -0.2088020|                          -0.2088020|                           -0.3170825|               -0.3956858|                   -0.4810767|               -0.3169241|               -0.0811491|               -0.1790399|                   -0.4584111|                   -0.4862822|                   -0.4313697|       -0.4464218|       -0.4645766|       -0.3004279|                       -0.3469121|                               -0.3447924|                   -0.4606719|                       -0.4880775|         24| WALKING\_UPSTAIRS   |

We also remove "ActivityID", given that "ActivityName" is better suited for data exploration (more readable).

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels, subjects) {
  data <- cbind(data, labels)
  data <- cbind(data, subjects)
  data <- add_variable_names(data)
  data <- select_pertinent_variables(data)
  data <- normalize_variable_names(data)
  add_activity_name_variable(data, activities)
}
```

Which we can apply to the training data-set as well:

``` r
train_data <- cleanup_data(train_data, train_labels, train_subjects)
sample_data_frame(train_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:-------------|
| 3553 |               0.2776076|              -0.0174429|              -0.1111496|                  0.9375182|                  0.0992945|                  0.2068215|                   0.0749770|                   0.0067857|                   0.0002294|      -0.0282869|      -0.0745641|       0.0864667|          -0.0981117|          -0.0375827|          -0.0547160|                      -0.9862913|                         -0.9862913|                          -0.9871243|              -0.9906406|                  -0.9933904|              -0.9932189|              -0.9689283|              -0.9897482|                  -0.9926819|                  -0.9737905|                  -0.9934876|      -0.9937185|      -0.9876704|      -0.9916248|                      -0.9813620|                              -0.9834702|                  -0.9896813|                      -0.9919572|               -0.9940327|               -0.9645370|               -0.9832793|                  -0.9962967|                  -0.9956157|                  -0.9865262|                   -0.9927273|                   -0.9659036|                   -0.9943164|       -0.9952162|       -0.9860103|       -0.9915975|           -0.9936838|           -0.9899471|           -0.9914416|                       -0.9808833|                          -0.9808833|                           -0.9833747|               -0.9889026|                   -0.9890835|               -0.9943263|               -0.9634474|               -0.9799386|                   -0.9934266|                   -0.9597216|                   -0.9935979|       -0.9956478|       -0.9850234|       -0.9922165|                       -0.9824514|                               -0.9817367|                   -0.9900499|                       -0.9860713|         27| SITTING      |
| 4849 |               0.2776758|               0.0110205|              -0.0622918|                  0.9666192|                 -0.1650502|                  0.0342367|                   0.0779520|                   0.0278551|                  -0.0486366|      -0.0528719|      -0.0730577|       0.0388712|          -0.1948412|          -0.0620911|          -0.0260224|                      -0.8800540|                         -0.8800540|                          -0.9114211|              -0.7873676|                  -0.9218649|              -0.9386749|              -0.8165972|              -0.8689772|                  -0.9067524|                  -0.8455105|                  -0.8798696|      -0.7606120|      -0.8565081|      -0.8707786|                      -0.8664139|                              -0.8479091|                  -0.8125907|                      -0.8751100|               -0.9586201|               -0.8158295|               -0.8491539|                  -0.9963389|                  -0.9794157|                  -0.9243289|                   -0.9086729|                   -0.8418867|                   -0.8997808|       -0.7499107|       -0.8745733|       -0.8950963|           -0.9034508|           -0.8983163|           -0.9020014|                       -0.8734866|                          -0.8734866|                           -0.8268833|               -0.7558867|                   -0.8702184|               -0.9698725|               -0.8261307|               -0.8492141|                   -0.9193887|                   -0.8487813|                   -0.9201311|       -0.7503820|       -0.8880275|       -0.9139925|                       -0.8963636|                               -0.8023323|                   -0.7616931|                       -0.8723759|         30| STANDING     |
| 5168 |               0.2837486|               0.0060373|              -0.1023574|                  0.9626226|                 -0.1834722|                  0.0690607|                   0.0749370|                   0.0080850|                   0.0022809|      -0.0326744|      -0.0758409|       0.0864311|          -0.0935896|          -0.0432590|          -0.0374222|                      -0.9607243|                         -0.9607243|                          -0.9745186|              -0.9691998|                  -0.9783983|              -0.9883846|              -0.9421430|              -0.9707299|                  -0.9851458|                  -0.9550229|                  -0.9756961|      -0.9779950|      -0.9714323|      -0.9428617|                      -0.9556588|                              -0.9706859|                  -0.9648053|                      -0.9742427|               -0.9898793|               -0.9306774|               -0.9627273|                  -0.9914609|                  -0.9640949|                  -0.9859936|                   -0.9833049|                   -0.9529790|                   -0.9753330|       -0.9818411|       -0.9732375|       -0.9453059|           -0.9837421|           -0.9753310|           -0.9619930|                       -0.9454078|                          -0.9454078|                           -0.9658832|               -0.9614139|                   -0.9707560|               -0.9904682|               -0.9283994|               -0.9601643|                   -0.9827027|                   -0.9537838|                   -0.9732718|       -0.9829905|       -0.9745347|       -0.9509825|                       -0.9472726|                               -0.9584378|                   -0.9654313|                       -0.9680626|         26| STANDING     |
| 5443 |               0.2718184|              -0.0322743|              -0.1139938|                  0.9589980|                 -0.1861292|                  0.1205363|                   0.0777594|                   0.0250630|                   0.0103888|      -0.0015713|      -0.0804445|       0.0735053|          -0.1089224|          -0.0415832|          -0.0670153|                      -0.9680202|                         -0.9680202|                          -0.9889935|              -0.9640252|                  -0.9884010|              -0.9948974|              -0.9637880|              -0.9788666|                  -0.9935732|                  -0.9804350|                  -0.9890391|      -0.9693461|      -0.9834996|      -0.9707938|                      -0.9795522|                              -0.9920335|                  -0.9745458|                      -0.9901031|               -0.9959876|               -0.9593530|               -0.9555634|                  -0.9944140|                  -0.9637609|                  -0.9743796|                   -0.9932036|                   -0.9811191|                   -0.9899035|       -0.9720846|       -0.9800836|       -0.9711996|           -0.9831399|           -0.9910003|           -0.9847865|                       -0.9751894|                          -0.9751894|                           -0.9927522|               -0.9624077|                   -0.9903824|               -0.9964981|               -0.9585607|               -0.9469805|                   -0.9933384|                   -0.9834208|                   -0.9891602|       -0.9729753|       -0.9781931|       -0.9738011|                       -0.9753677|                               -0.9921290|                   -0.9611941|                       -0.9910619|          6| STANDING     |
| 3983 |               0.2845029|              -0.0097268|              -0.1211382|                  0.7775614|                  0.3512674|                  0.3359764|                   0.0709215|                   0.0026049|                   0.0030292|      -0.0329743|      -0.0996013|       0.1566264|          -0.1038141|          -0.0238127|          -0.0916830|                      -0.9827773|                         -0.9827773|                          -0.9894371|              -0.9504234|                  -0.9916433|              -0.9917499|              -0.9796270|              -0.9812355|                  -0.9930868|                  -0.9840144|                  -0.9837831|      -0.9913180|      -0.9645968|      -0.9529943|                      -0.9848369|                              -0.9879744|                  -0.9702009|                      -0.9906592|               -0.9912606|               -0.9769276|               -0.9799464|                  -0.9951314|                  -0.9731846|                  -0.9896350|                   -0.9933087|                   -0.9837114|                   -0.9860911|       -0.9943284|       -0.9551520|       -0.9553350|           -0.9935561|           -0.9881738|           -0.9922403|                       -0.9821762|                          -0.9821762|                           -0.9874733|               -0.9688808|                   -0.9889502|               -0.9908908|               -0.9758810|               -0.9797991|                   -0.9941898|                   -0.9844659|                   -0.9869546|       -0.9953489|       -0.9503000|       -0.9600628|                       -0.9821735|                               -0.9852234|                   -0.9731198|                       -0.9871324|         26| SITTING      |
| 7135 |               0.2618631|              -0.0248280|              -0.1035361|                 -0.7054131|                 -0.1898991|                 -0.9960970|                   0.0752763|                   0.0005223|                   0.0083294|      -0.0311227|      -0.0768466|       0.1088010|          -0.0935157|          -0.0401309|          -0.0633665|                      -0.9822517|                         -0.9822517|                          -0.9890619|              -0.9794158|                  -0.9917581|              -0.9886345|              -0.9845135|              -0.9812746|                  -0.9884120|                  -0.9932317|                  -0.9810450|      -0.9753505|      -0.9869055|      -0.9929247|                      -0.9880026|                              -0.9871339|                  -0.9819906|                      -0.9921038|               -0.9891470|               -0.9738238|               -0.9840073|                  -0.9848559|                  -0.9843996|                  -0.9910447|                   -0.9890086|                   -0.9935900|                   -0.9849519|       -0.9784099|       -0.9840562|       -0.9934784|           -0.9827670|           -0.9937695|           -0.9980070|                       -0.9856046|                          -0.9856046|                           -0.9890161|               -0.9781530|                   -0.9925993|               -0.9892326|               -0.9696704|               -0.9863850|                   -0.9907732|                   -0.9945548|                   -0.9878023|       -0.9793386|       -0.9824502|       -0.9941790|                       -0.9852427|                               -0.9906711|                   -0.9790320|                       -0.9935187|         28| LAYING       |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    68

The following tables describe all the variables in the clean data-set:

<br/>

> **Note:**
>
> -   Acceleration Units: Number of g's.
>
> -   "Acceleration Jerk" or simply [jerk](https://en.wikipedia.org/wiki/Jerk_(physics)) is the rate of change of the acceleration.
>
> -   Jerk Units: Number of g's per second.
>
> -   Giro (Angular Velocity) Units: radians per second.
>
> -   Prefix 't' stands for "time domain signal", 'f' for "frequency domain signal".
>
<br/>

<table>
<colgroup>
<col width="10%" />
<col width="89%" />
</colgroup>
<thead>
<tr class="header">
<th>ID Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ActivityName</td>
<td>A descriptive name for the activity, i.e.: LAYING, SITTING, WALKING, WALKING_UPSTAIRS or WALKING_DOWNSTAIRS.</td>
</tr>
<tr class="even">
<td>SubjectID</td>
<td>An integer indentifier for the human subjected to the experiment.</td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col width="33%" />
<col width="66%" />
</colgroup>
<thead>
<tr class="header">
<th>Acceleration Mean Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>[tf]BodyAccelerationMean[XYZ]</td>
<td>Mean of each component (X, Y &amp; Z) of acceleration due to body motion.</td>
</tr>
<tr class="even">
<td>[tf]BodyAccelerationMagnitudeMean</td>
<td>Mean of the magnitude (modulus) of acceleration vector due to body motion.</td>
</tr>
<tr class="odd">
<td>[tf]GravityAccelerationMean[XYZ]</td>
<td>Mean of each component (X, Y &amp; Z) of acceleration due to gravity.</td>
</tr>
<tr class="even">
<td>[tf]GravityAccelerationMagnitudeMean</td>
<td>Mean of the magnitude (modulus) of acceleration vector due to gravity.</td>
</tr>
</tbody>
</table>

<table style="width:100%;">
<colgroup>
<col width="32%" />
<col width="67%" />
</colgroup>
<thead>
<tr class="header">
<th>Acceleration Standard Deviation Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>[tf]BodyAccelerationSigma[XYZ]</td>
<td>Standard Deviation of each component (X, Y &amp; Z) of acceleration due to body motion.</td>
</tr>
<tr class="even">
<td>[tf]BodyAccelerationMagnitudeSigma</td>
<td>Standard Deviation of the magnitude (modulus) of acceleration vector due to body motion.</td>
</tr>
<tr class="odd">
<td>[tf]GravityAccelerationSigma[XYZ]</td>
<td>Standard Deviation of each component (X, Y &amp; Z) of acceleration due to gravity.</td>
</tr>
<tr class="even">
<td>[tf]GravityAccelerationMagnitudeSigma</td>
<td>Standard Deviation of the magnitude (modulus) of acceleration vector due to gravity.</td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col width="37%" />
<col width="62%" />
</colgroup>
<thead>
<tr class="header">
<th>Acceleration Jerk Mean Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>[tf]BodyAccelerationJerkMean[XYZ]</td>
<td>Mean of each component (X, Y &amp; Z) of jerk due to body motion.</td>
</tr>
<tr class="even">
<td>[tf]BodyAccelerationJerkMagnitudeMean</td>
<td>Mean of the magnitude (modulus) of jerk vector due to body motion.</td>
</tr>
<tr class="odd">
<td>[tf]GravityAccelerationJerkMean[XYZ]</td>
<td>Mean of each component (X, Y &amp; Z) of jerk due to gravity.</td>
</tr>
<tr class="even">
<td>[tf]GravityAccelerationJerkMagnitudeMean</td>
<td>Mean of the magnitude (modulus) of jerk vector due to gravity.</td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col width="36%" />
<col width="63%" />
</colgroup>
<thead>
<tr class="header">
<th>Acceleration Jerk Standard Deviation Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>[tf]BodyAccelerationJerkSigma[XYZ]</td>
<td>Standard Deviation of each component (X, Y &amp; Z) of jerk due to body motion.</td>
</tr>
<tr class="even">
<td>[tf]BodyAccelerationJerkMagnitudeSigma</td>
<td>Standard Deviation of the magnitude (modulus) of jerk vector due to body motion.</td>
</tr>
<tr class="odd">
<td>[tf]GravityAccelerationJerkSigma[XYZ]</td>
<td>Standard Deviation of each component (X, Y &amp; Z) of jerk due to gravity.</td>
</tr>
<tr class="even">
<td>[tf]GravityAccelerationJerkMagnitudeSigma</td>
<td>Standard Deviation of the magnitude (modulus) of jerk vector due to gravity.</td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col width="23%" />
<col width="76%" />
</colgroup>
<thead>
<tr class="header">
<th>Gyro Mean Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>[tf]BodyGyroMean[XYZ]</td>
<td>Mean of each component (X, Y &amp; Z) of the angular velocity due to body motion.</td>
</tr>
<tr class="even">
<td>[tf]BodyGyroMagnitudeMean</td>
<td>Mean of the magnitude (modulus) of the angular velocity vector due to body motion.</td>
</tr>
</tbody>
</table>

<table>
<colgroup>
<col width="25%" />
<col width="74%" />
</colgroup>
<thead>
<tr class="header">
<th>Gyro Standard Deviation Variables</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>[tf]BodyGyroSigma[XYZ]</td>
<td>Standard Deviation of each component (X, Y &amp; Z) of the angular velocity due to body motion.</td>
</tr>
<tr class="even">
<td>[tf]BodyGyroMagnitudeSigma</td>
<td>Standard Deviation of the magnitude (modulus) of the angular velocity vector due to body motion.</td>
</tr>
</tbody>
</table>

Computing Averages per Activity and Subject
-------------------------------------------

The following data-set has been grouped by subject and activity and all columns summarised into their respective means:

``` r
averages_data <- all_data %>% group_by(SubjectID, ActivityName) %>% summarise_each(funs(mean))
sample_data_frame(averages_data, 6)
```

|  SubjectID| ActivityName        |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|----------:|:--------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
|          1| WALKING\_UPSTAIRS   |               0.2554617|              -0.0239531|              -0.0973020|                  0.8933511|                 -0.3621534|                 -0.0754029|                   0.1013727|                   0.0194863|                  -0.0455625|       0.0505494|      -0.1661700|       0.0583595|          -0.1222328|          -0.0421486|          -0.0407126|                      -0.1299276|                         -0.1299276|                          -0.4665034|              -0.1267356|                  -0.5948829|              -0.4043218|              -0.1909767|              -0.4333497|                  -0.4798752|                  -0.4134446|                  -0.6854744|      -0.4926117|      -0.3194746|      -0.4535972|                      -0.3523959|                              -0.4426522|                  -0.3259615|                      -0.6346651|               -0.3547080|               -0.0023203|               -0.0194792|                  -0.9563670|                  -0.9528492|                  -0.9123794|                   -0.4468439|                   -0.3782744|                   -0.7065935|       -0.5448711|        0.0041052|       -0.5071687|           -0.6147865|           -0.6016967|           -0.6063320|                       -0.3249709|                          -0.3249709|                           -0.4789916|               -0.1486193|                   -0.6485530|               -0.3374282|                0.0217695|                0.0859566|                   -0.4619070|                   -0.3817771|                   -0.7260402|       -0.5658925|        0.1515389|       -0.5717078|                       -0.4162601|                               -0.5330599|                   -0.1829855|                       -0.6939305|
|          4| SITTING             |               0.2715383|              -0.0071631|              -0.1058746|                  0.8693030|                  0.2116225|                  0.1101205|                   0.0784500|                  -0.0108582|                  -0.0121500|      -0.0494435|      -0.0894301|       0.1011503|          -0.0969495|          -0.0418484|          -0.0489964|                      -0.9356948|                         -0.9356948|                          -0.9701323|              -0.9260633|                  -0.9804905|              -0.9774625|              -0.9057829|              -0.9517837|                  -0.9768457|                  -0.9442984|                  -0.9751549|      -0.9605896|      -0.9675836|      -0.9337769|                      -0.9290021|                              -0.9625007|                  -0.9487698|                      -0.9765478|               -0.9803099|               -0.8902240|               -0.9322030|                  -0.9814053|                  -0.9327271|                  -0.9509493|                   -0.9767422|                   -0.9445961|                   -0.9790388|       -0.9701318|       -0.9584681|       -0.9279722|           -0.9698997|           -0.9844414|           -0.9688048|                       -0.9144078|                          -0.9144078|                           -0.9625491|               -0.9288983|                   -0.9758067|               -0.9819082|               -0.8894673|               -0.9269993|                   -0.9787769|                   -0.9492932|                   -0.9816994|       -0.9733331|       -0.9541204|       -0.9328684|                       -0.9198157|                               -0.9615845|                   -0.9288506|                       -0.9762618|
|          9| SITTING             |               0.2483267|              -0.0270168|              -0.0753785|                  0.9163245|                 -0.0414258|                  0.0852631|                   0.0770050|                   0.0098174|                  -0.0086747|      -0.0423289|      -0.0414271|       0.0807919|          -0.0930708|          -0.0466634|          -0.0528415|                      -0.8933617|                         -0.8933617|                          -0.9643838|              -0.9032355|                  -0.9733641|              -0.9594136|              -0.9116832|              -0.8922013|                  -0.9655962|                  -0.9580074|                  -0.9575270|      -0.9503152|      -0.9396930|      -0.9403123|                      -0.8977182|                              -0.9530504|                  -0.9344377|                      -0.9683156|               -0.9572278|               -0.8751414|               -0.8320019|                  -0.9552804|                  -0.9464520|                  -0.8858541|                   -0.9645359|                   -0.9567775|                   -0.9618894|       -0.9590200|       -0.9191882|       -0.9301768|           -0.9645323|           -0.9719274|           -0.9687389|                       -0.8637564|                          -0.8637564|                           -0.9517802|               -0.9066063|                   -0.9663611|               -0.9569035|               -0.8676136|               -0.8180018|                   -0.9666604|                   -0.9585230|                   -0.9649413|       -0.9618360|       -0.9105834|       -0.9341875|                       -0.8691725|                               -0.9493950|                   -0.9064712|                       -0.9659970|
|         20| LAYING              |               0.2395079|              -0.0144406|              -0.1042743|                 -0.4724314|                  0.8648830|                  0.4775733|                   0.0892716|                   0.0011082|                  -0.0030989|      -0.0231761|      -0.0954900|       0.1236802|          -0.0995033|          -0.0387763|          -0.0610028|                      -0.9607431|                         -0.9607431|                          -0.9846701|              -0.9604474|                  -0.9867495|              -0.9657288|              -0.9655960|              -0.9763927|                  -0.9838900|                  -0.9772207|                  -0.9828762|      -0.9826194|      -0.9731200|      -0.9722786|                      -0.9528271|                              -0.9796955|                  -0.9698322|                      -0.9811198|               -0.9622491|               -0.9640982|               -0.9725720|                  -0.9286742|                  -0.9760185|                  -0.9765186|                   -0.9842707|                   -0.9770026|                   -0.9849892|       -0.9844774|       -0.9729419|       -0.9724099|           -0.9892836|           -0.9815401|           -0.9866705|                       -0.9394894|                          -0.9394894|                           -0.9801617|               -0.9621536|                   -0.9810793|               -0.9609979|               -0.9649610|               -0.9719013|                   -0.9862139|                   -0.9784514|                   -0.9857078|       -0.9851546|       -0.9730925|       -0.9749953|                       -0.9418941|                               -0.9795652|                   -0.9642059|                       -0.9819862|
|          4| WALKING\_UPSTAIRS   |               0.2708767|              -0.0319804|              -0.1142195|                  0.9462643|                 -0.2329443|                  0.0841675|                   0.0560972|                   0.0234019|                   0.0034028|       0.0393825|      -0.0859472|       0.0843754|          -0.1314721|          -0.0390509|          -0.0722496|                      -0.1537039|                         -0.1537039|                          -0.4009223|              -0.2997794|                  -0.6869784|              -0.2944883|              -0.1171092|              -0.5246557|                  -0.4183046|                  -0.2978052|                  -0.6901069|      -0.3710690|      -0.6843102|      -0.3507657|                      -0.2768255|                              -0.3974063|                  -0.5757941|                      -0.7407492|               -0.2049330|               -0.0666899|               -0.3721378|                  -0.9584952|                  -0.9233760|                  -0.9196195|                   -0.3804880|                   -0.2815432|                   -0.7264953|       -0.4544310|       -0.5511856|       -0.3608110|           -0.5336668|           -0.8407228|           -0.5562366|                       -0.2120123|                          -0.2120123|                           -0.4372615|               -0.5109741|                   -0.7552705|               -0.1732172|               -0.1014344|               -0.3451098|                   -0.3967626|                   -0.3145250|                   -0.7627722|       -0.4835487|       -0.4898243|       -0.4245335|                       -0.3010059|                               -0.4973241|                   -0.5524896|                       -0.7942095|
|         19| WALKING\_DOWNSTAIRS |               0.2626881|              -0.0145942|              -0.1336952|                  0.8819409|                 -0.2150180|                 -0.1261469|                   0.0730930|                  -0.0386872|                  -0.0095520|      -0.2057754|       0.0274708|       0.1639625|          -0.0337430|          -0.0394613|          -0.0545566|                       0.6446043|                          0.6446043|                           0.4344904|               0.4180046|                   0.0875817|               0.5370120|               0.4944578|               0.1106592|                   0.4743173|                   0.2767169|                   0.0595906|       0.4749624|       0.1470831|       0.2106731|                       0.5866376|                               0.5384048|                   0.2039798|                      -0.0229045|                0.6269171|                0.5148164|                0.0493225|                  -0.8997261|                  -0.9178809|                  -0.8993631|                    0.5442730|                    0.3553067|                   -0.0200111|        0.2676572|        0.0483148|       -0.0314083|            0.1791486|           -0.0146299|            0.1166462|                        0.4134724|                           0.4134724|                            0.4506121|                0.2378212|                   -0.0438985|                0.6585065|                0.4279288|               -0.0783635|                    0.4768039|                    0.3497713|                   -0.0983930|        0.1966133|       -0.0284896|       -0.2158922|                        0.0828631|                                0.3163464|                    0.0320367|                       -0.1432545|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE)
```
