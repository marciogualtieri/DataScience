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
Data Cleaning: Wearable Computing, Human Activity Recognition Using Smartphones
</h1>
<h3>
by Marcio Gualtieri
</h3>
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

    ## [1] "fBodyAcc-bandsEnergy()-33,48" "fBodyGyro-std()-Z"           
    ## [3] "fBodyAccJerk-mad()-Y"         "tBodyAccJerkMag-iqr()"       
    ## [5] "fBodyBodyGyroMag-maxInds"     "tGravityAcc-iqr()-Z"

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

    ## [1] "fBodyGyro-bandsEnergy()-9,16"    "fBodyGyro-bandsEnergy()-17,24"  
    ## [3] "fBodyAccJerk-bandsEnergy()-1,24" "fBodyGyro-bandsEnergy()-9,16"   
    ## [5] "fBodyGyro-mad()-Z"               "fBodyAccJerk-min()-Y"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyroJerkMag-mean()" "tBodyAccJerk-mean()-Y"  
    ## [3] "tBodyAccMag-mean()"      "fBodyAccMag-mean()"     
    ## [5] "fBodyAcc-mean()-Z"       "tGravityAccMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyAccMag-std()"          "fBodyBodyGyroJerkMag-std()"
    ## [3] "fBodyAccJerk-std()-Y"       "fBodyBodyGyroMag-std()"    
    ## [5] "tBodyAccJerk-std()-Y"       "tBodyGyroJerkMag-std()"

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

    ## [1] "tBodyAcc-arCoeff()-X,1"       "fBodyGyro-mad()-Z"           
    ## [3] "fBodyAccMag-entropy()"        "fBodyAcc-bandsEnergy()-49,64"
    ## [5] "fBodyAcc-entropy()-Y"         "fBodyAcc-mad()-Z"

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
| 1026 |               0.3565334|              -0.0073061|              -0.1724061|                  0.9480175|                 -0.1509564|                  0.0307804|                  -0.3070024|                   0.0772502|                  -0.0766786|      -0.1870396|      -0.0762649|       0.1368229|          -0.5195518|          -0.1017820|           0.3225246|                       0.1250418|                          0.1250418|                          -0.0088259|              -0.0437306|                  -0.4042202|               0.0923322|               0.0015331|              -0.2693396|                   0.1577252|                  -0.1349567|                  -0.2495137|       0.0131289|      -0.2132222|      -0.0076875|                       0.1078133|                               0.1452729|                  -0.2995531|                      -0.5141391|                0.1481924|                0.0508626|               -0.3026482|                  -0.9054630|                  -0.9499779|                  -0.9156249|                    0.1428460|                   -0.0773141|                   -0.3561154|       -0.2111820|       -0.2847439|       -0.0087926|           -0.4198182|           -0.4657273|           -0.2103454|                        0.0614674|                           0.0614674|                            0.0699108|               -0.2337747|                   -0.4721617|                0.1695164|                0.0102064|               -0.3809170|                    0.0198757|                   -0.0750037|                   -0.4678946|       -0.2823506|       -0.3378617|       -0.0996864|                       -0.1307266|                               -0.0423259|                   -0.3196977|                       -0.4563506|           3|         10|
| 1241 |               0.2263042|              -0.0089766|              -0.1613092|                  0.9939462|                 -0.0504202|                  0.0210921|                   0.0851671|                  -0.0182102|                   0.1287749|      -0.2370792|       0.3828940|      -0.3617334|          -0.0783805|          -0.0524606|          -0.0066598|                      -0.8719368|                         -0.8719368|                          -0.9689815|              -0.6269217|                  -0.9745541|              -0.9426663|              -0.9199451|              -0.8613525|                  -0.9533884|                  -0.9588122|                  -0.9683913|      -0.9393560|      -0.9429073|      -0.9070197|                      -0.9310675|                              -0.9553382|                  -0.9063204|                      -0.9660013|               -0.9287623|               -0.8649818|               -0.8209530|                  -0.8518046|                  -0.8918443|                  -0.8959390|                   -0.9583613|                   -0.9613984|                   -0.9750795|       -0.9392679|       -0.9192736|       -0.9054042|           -0.9629413|           -0.9720097|           -0.9678906|                       -0.8784176|                          -0.8784176|                           -0.9530418|               -0.8702569|                   -0.9634519|               -0.9236100|               -0.8500945|               -0.8131052|                   -0.9689853|                   -0.9678549|                   -0.9812515|       -0.9398306|       -0.9079340|       -0.9133316|                       -0.8738075|                               -0.9486740|                   -0.8701516|                       -0.9622540|           4|         12|
| 1641 |               0.2627601|              -0.0099264|              -0.0526400|                  0.9343530|                 -0.1946398|                 -0.1975267|                   0.3418063|                   0.1164347|                   0.0931188|      -0.1424086|       0.1022563|       0.0859867|          -0.0748522|          -0.5805924|           0.0205207|                      -0.1658631|                         -0.1658631|                          -0.3335888|              -0.2000345|                  -0.4213636|              -0.2660354|              -0.0370049|              -0.2082254|                  -0.3481479|                  -0.2640960|                  -0.4161796|      -0.4052534|      -0.1070978|      -0.3338830|                      -0.2072825|                              -0.2438807|                  -0.2267765|                      -0.1948281|               -0.3147855|                0.0007627|               -0.1616576|                  -0.9494324|                  -0.8891599|                  -0.8548140|                   -0.3538567|                   -0.2069580|                   -0.4758971|       -0.3746069|       -0.2187451|       -0.4198026|           -0.6093500|           -0.2577585|           -0.5084357|                       -0.2386858|                          -0.2386858|                           -0.2602801|               -0.2754696|                   -0.2435755|               -0.3349156|               -0.0425860|               -0.2021081|                   -0.4200346|                   -0.1964276|                   -0.5345492|       -0.3752293|       -0.3021052|       -0.5039560|                       -0.3750326|                               -0.2867507|                   -0.4442902|                       -0.3698139|           3|         13|
| 24   |               0.2938975|               0.0111509|              -0.0692812|                  0.8828259|                 -0.4303132|                  0.0663071|                   0.0679641|                  -0.0080135|                  -0.0283144|      -0.0319336|      -0.0808790|       0.0678886|          -0.0895516|          -0.0559783|          -0.0393114|                      -0.9142446|                         -0.9142446|                          -0.9337913|              -0.8950773|                  -0.9338919|              -0.9478904|              -0.8685315|              -0.9151236|                  -0.9302045|                  -0.8963231|                  -0.9572720|      -0.9382222|      -0.8843491|      -0.6829985|                      -0.8823854|                              -0.9190528|                  -0.8057158|                      -0.8317834|               -0.9624133|               -0.8633399|               -0.8599571|                  -0.9776391|                  -0.9179957|                  -0.8671727|                   -0.9275079|                   -0.8949826|                   -0.9612516|       -0.9545124|       -0.8737911|       -0.7543924|           -0.9460553|           -0.9366154|           -0.7506008|                       -0.8488401|                          -0.8488401|                           -0.9093431|               -0.7741979|                   -0.8406852|               -0.9700001|               -0.8682478|               -0.8440588|                   -0.9310108|                   -0.9008797|                   -0.9636344|       -0.9597025|       -0.8684478|       -0.8054498|                       -0.8548413|                               -0.8959372|                   -0.7915122|                       -0.8646075|           5|          2|
| 1440 |               0.3101509|              -0.0193809|              -0.1245277|                 -0.3898287|                  0.9654301|                 -0.2017490|                   0.0867090|                  -0.0088666|                   0.0092497|      -0.0117866|      -0.0723190|       0.1879241|          -0.1250290|          -0.0475644|          -0.1026299|                      -0.9634195|                         -0.9634195|                          -0.9609237|              -0.9353714|                  -0.9657130|              -0.9657583|              -0.9498915|              -0.9630029|                  -0.9603088|                  -0.9452981|                  -0.9594244|      -0.9532447|      -0.9512470|      -0.9122810|                      -0.9623935|                              -0.9554944|                  -0.9363539|                      -0.9613492|               -0.9732241|               -0.9590301|               -0.9663660|                  -0.9779661|                  -0.9923420|                  -0.9824149|                   -0.9631093|                   -0.9483421|                   -0.9655114|       -0.9681313|       -0.9570005|       -0.9116424|           -0.9706306|           -0.9600218|           -0.9687916|                       -0.9697854|                          -0.9697854|                           -0.9563445|               -0.9207041|                   -0.9625867|               -0.9767947|               -0.9663430|               -0.9705317|                   -0.9701376|                   -0.9563605|                   -0.9704470|       -0.9730687|       -0.9612286|       -0.9193194|                       -0.9789725|                               -0.9561746|                   -0.9238086|                       -0.9660458|           6|         12|
| 326  |               0.2759695|              -0.0303097|              -0.1207818|                  0.9542539|                 -0.0946650|                  0.1858706|                   0.0700928|                  -0.0276869|                  -0.0100816|      -0.0344047|      -0.0886800|       0.0990369|          -0.0711982|          -0.0450861|          -0.0410983|                      -0.9545740|                         -0.9545740|                          -0.9708123|              -0.9422796|                  -0.9764384|              -0.9854639|              -0.9191410|              -0.9718196|                  -0.9816142|                  -0.9567012|                  -0.9729417|      -0.9296681|      -0.9724362|      -0.9605105|                      -0.9582022|                              -0.9703322|                  -0.9521850|                      -0.9807966|               -0.9890440|               -0.9031061|               -0.9694056|                  -0.9970768|                  -0.9776929|                  -0.9814353|                   -0.9795720|                   -0.9536639|                   -0.9762095|       -0.9355168|       -0.9727105|       -0.9501852|           -0.9627105|           -0.9816108|           -0.9793148|                       -0.9545058|                          -0.9545058|                           -0.9730375|               -0.9421873|                   -0.9797245|               -0.9908242|               -0.9004092|               -0.9694289|                   -0.9790871|                   -0.9532367|                   -0.9780027|       -0.9376059|       -0.9729823|       -0.9514458|                       -0.9582817|                               -0.9758490|                   -0.9451820|                       -0.9793008|           5|          4|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:-------------|
| 252  |               0.2407515|              -0.0218536|              -0.1606405|                  0.9307024|                  0.0199705|                 -0.2353452|                  -0.2609424|                  -0.0668042|                  -0.1971020|      -0.1127970|      -0.1609143|       0.1470008|          -0.0412793|          -0.2462985|           0.4506321|                      -0.0503159|                         -0.0503159|                          -0.0975747|              -0.1467727|                  -0.3798503|              -0.2017852|              -0.1698787|              -0.1901508|                  -0.1571618|                  -0.2427240|                  -0.3182845|      -0.2224511|      -0.2345533|      -0.0813703|                      -0.1327883|                              -0.1217587|                  -0.3365515|                      -0.4444618|               -0.1461893|               -0.2071588|               -0.0503805|                  -0.9637230|                  -0.9725073|                  -0.9449713|                   -0.0173238|                   -0.1966611|                   -0.3559456|       -0.3440863|       -0.2864271|       -0.1530436|           -0.4038969|           -0.3798514|           -0.4176120|                       -0.2651407|                          -0.2651407|                           -0.1098708|               -0.3616482|                   -0.4458867|               -0.1251615|               -0.2780610|               -0.0502410|                    0.0351709|                   -0.1992356|                   -0.3904689|       -0.3835047|       -0.3255473|       -0.2552256|                       -0.4659478|                               -0.1011691|                   -0.4942264|                       -0.4861487|          9| WALKING      |
| 2584 |               0.3101509|              -0.0193809|              -0.1245277|                 -0.3898287|                  0.9654301|                 -0.2017490|                   0.0867090|                  -0.0088666|                   0.0092497|      -0.0117866|      -0.0723190|       0.1879241|          -0.1250290|          -0.0475644|          -0.1026299|                      -0.9634195|                         -0.9634195|                          -0.9609237|              -0.9353714|                  -0.9657130|              -0.9657583|              -0.9498915|              -0.9630029|                  -0.9603088|                  -0.9452981|                  -0.9594244|      -0.9532447|      -0.9512470|      -0.9122810|                      -0.9623935|                              -0.9554944|                  -0.9363539|                      -0.9613492|               -0.9732241|               -0.9590301|               -0.9663660|                  -0.9779661|                  -0.9923420|                  -0.9824149|                   -0.9631093|                   -0.9483421|                   -0.9655114|       -0.9681313|       -0.9570005|       -0.9116424|           -0.9706306|           -0.9600218|           -0.9687916|                       -0.9697854|                          -0.9697854|                           -0.9563445|               -0.9207041|                   -0.9625867|               -0.9767947|               -0.9663430|               -0.9705317|                   -0.9701376|                   -0.9563605|                   -0.9704470|       -0.9730687|       -0.9612286|       -0.9193194|                       -0.9789725|                               -0.9561746|                   -0.9238086|                       -0.9660458|         12| LAYING       |
| 2653 |               0.2730933|              -0.0163069|              -0.1065635|                 -0.2763573|                  0.9067542|                  0.3644753|                   0.0703389|                   0.0091865|                   0.0119429|      -0.0283244|      -0.0791338|       0.0294900|          -0.0991220|          -0.0404531|          -0.0517446|                      -0.9947294|                         -0.9947294|                          -0.9920305|              -0.9768065|                  -0.9961828|              -0.9936168|              -0.9919252|              -0.9868875|                  -0.9939471|                  -0.9909410|                  -0.9864688|      -0.9968210|      -0.9946259|      -0.9924379|                      -0.9931167|                              -0.9905518|                  -0.9943449|                      -0.9961079|               -0.9931133|               -0.9946054|               -0.9887040|                  -0.9926590|                  -0.9991254|                  -0.9934819|                   -0.9939480|                   -0.9910673|                   -0.9878964|       -0.9974718|       -0.9933220|       -0.9926736|           -0.9974567|           -0.9942919|           -0.9929409|                       -0.9925276|                          -0.9925276|                           -0.9909215|               -0.9928470|                   -0.9942690|               -0.9927420|               -0.9955574|               -0.9900300|                   -0.9944777|                   -0.9918729|                   -0.9877615|       -0.9976313|       -0.9924977|       -0.9933067|                       -0.9922836|                               -0.9900649|                   -0.9927705|                       -0.9920470|         13| LAYING       |
| 1997 |               0.3985829|               0.1862603|              -0.0359330|                  0.9316066|                 -0.1672146|                  0.1004960|                   0.0066834|                  -0.2603956|                  -0.0977307|      -0.0231830|      -0.1403792|      -0.1382770|          -0.1579565|          -0.0471786|           0.0524438|                      -0.5603318|                         -0.5603318|                          -0.9415425|              -0.8449857|                  -0.9584976|              -0.9027039|              -0.4702643|              -0.8900964|                  -0.9503246|                  -0.8945799|                  -0.9472615|      -0.8353690|      -0.9595553|      -0.8045626|                      -0.6536333|                              -0.9100724|                  -0.8413684|                      -0.9483208|               -0.8942317|               -0.1078904|               -0.8429049|                  -0.7772425|                  -0.2880160|                  -0.7793276|                   -0.9491848|                   -0.8919486|                   -0.9556483|       -0.8585139|       -0.9482563|       -0.7981306|           -0.9164173|           -0.9773860|           -0.9325407|                       -0.3499906|                          -0.3499906|                           -0.9105830|               -0.7791835|                   -0.9417963|               -0.8908120|               -0.0192072|               -0.8308221|                   -0.9524601|                   -0.8964448|                   -0.9631767|       -0.8660489|       -0.9425130|       -0.8143153|                       -0.3312999|                               -0.9102197|                   -0.7789669|                       -0.9375069|          4| STANDING     |
| 2297 |               0.2730599|              -0.0390846|              -0.1324808|                  0.9659130|                 -0.1438174|                  0.0849077|                   0.0812625|                  -0.0162676|                  -0.0708676|      -0.0519387|      -0.1520353|       0.1483929|          -0.1317783|          -0.0121879|          -0.1037831|                      -0.8014921|                         -0.8014921|                          -0.9180933|              -0.8093168|                  -0.9208422|              -0.8866896|              -0.7842435|              -0.8566766|                  -0.8971571|                  -0.8906996|                  -0.9426911|      -0.8268297|      -0.8749880|      -0.7936339|                      -0.8235934|                              -0.8916742|                  -0.8322152|                      -0.8971742|               -0.8975474|               -0.6827051|               -0.7662385|                  -0.9907447|                  -0.9147923|                  -0.8937952|                   -0.8988852|                   -0.8859009|                   -0.9469402|       -0.8259183|       -0.8725086|       -0.7728704|           -0.8793346|           -0.9249429|           -0.8957127|                       -0.8102330|                          -0.8102330|                           -0.8797430|               -0.7908023|                   -0.8950769|               -0.9020518|               -0.6584164|               -0.7417732|                   -0.9102529|                   -0.8881937|                   -0.9494837|       -0.8276768|       -0.8718035|       -0.7870050|                       -0.8314395|                               -0.8647148|                   -0.7996277|                       -0.8991458|         20| STANDING     |
| 1959 |               0.2737938|              -0.0144634|              -0.1303267|                  0.9462147|                 -0.2290054|                 -0.1528670|                   0.0791491|                   0.0253778|                   0.0164956|      -0.0328399|      -0.0646817|       0.0734488|          -0.0851276|          -0.0371964|          -0.0517870|                      -0.9480816|                         -0.9480816|                          -0.9789942|              -0.9644792|                  -0.9783564|              -0.9824710|              -0.9476167|              -0.9612099|                  -0.9796609|                  -0.9611658|                  -0.9760437|      -0.9694940|      -0.9626497|      -0.9814102|                      -0.9631454|                              -0.9653855|                  -0.9640133|                      -0.9709120|               -0.9845164|               -0.9306629|               -0.9207907|                  -0.9855454|                  -0.9788175|                  -0.9300494|                   -0.9786508|                   -0.9596002|                   -0.9791648|       -0.9737239|       -0.9611016|       -0.9730888|           -0.9798017|           -0.9710934|           -0.9886459|                       -0.9571873|                          -0.9571873|                           -0.9632636|               -0.9643362|                   -0.9717652|               -0.9853203|               -0.9261247|               -0.9077318|                   -0.9793726|                   -0.9605088|                   -0.9808432|       -0.9750219|       -0.9603352|       -0.9729065|                       -0.9593401|                               -0.9589023|                   -0.9706930|                       -0.9745718|         13| STANDING     |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:--------------------|
| 7180 |               0.2945942|              -0.0206274|              -0.1077985|                 -0.4220346|                  0.4122240|                  0.9346533|                   0.1044227|                   0.0166055|                   0.0164363|      -0.0222766|      -0.1140574|       0.0836392|          -0.0609969|          -0.0251875|          -0.0638410|                      -0.9529240|                         -0.9529240|                          -0.9736892|              -0.9424066|                  -0.9584486|              -0.9446020|              -0.9721766|              -0.9510084|                  -0.9661562|                  -0.9755365|                  -0.9452226|      -0.9217271|      -0.9147194|      -0.9694384|                      -0.9437940|                              -0.9450677|                  -0.9076032|                      -0.9224286|               -0.9463372|               -0.9664256|               -0.9568904|                  -0.9740574|                  -0.9885762|                  -0.9910660|                   -0.9718508|                   -0.9768726|                   -0.9552107|       -0.9552563|       -0.9196102|       -0.9751740|           -0.9166528|           -0.9397872|           -0.9781706|                       -0.9486369|                          -0.9486369|                           -0.9470279|               -0.9070645|                   -0.9120556|               -0.9468686|               -0.9645982|               -0.9636764|                   -0.9830855|                   -0.9803937|                   -0.9648296|       -0.9681786|       -0.9232832|       -0.9796063|                       -0.9586316|                               -0.9485187|                   -0.9227285|                       -0.9053114|         23| LAYING              |
| 1194 |               0.2692914|              -0.0133914|              -0.1447125|                  0.9650274|                 -0.1473743|                  0.0426152|                   0.1895917|                   0.1445069|                  -0.0783414|       0.0327795|      -0.2329783|       0.1167534|          -0.1107334|           0.1510172|           0.2170724|                      -0.1786001|                         -0.1786001|                          -0.3767491|               0.0535522|                  -0.4495728|              -0.3269610|              -0.1773525|              -0.3822637|                  -0.4199273|                  -0.3275642|                  -0.5295517|      -0.3223878|      -0.1025501|      -0.1431966|                      -0.3944036|                              -0.3721407|                  -0.3808838|                      -0.4793854|               -0.3045666|               -0.1624382|               -0.1820443|                  -0.9845883|                  -0.9797667|                  -0.9539210|                   -0.3910958|                   -0.2576894|                   -0.5816805|       -0.3249192|        0.0615217|       -0.1424750|           -0.4112837|           -0.4715420|           -0.4679262|                       -0.3675528|                          -0.3675528|                           -0.3739686|               -0.2962770|                   -0.5077195|               -0.2958456|               -0.2072094|               -0.1454585|                   -0.4145801|                   -0.2301933|                   -0.6332528|       -0.3336262|        0.1438653|       -0.2205287|                       -0.4507919|                               -0.3798865|                   -0.3594857|                       -0.5781819|         30| WALKING             |
| 5168 |               0.2837486|               0.0060373|              -0.1023574|                  0.9626226|                 -0.1834722|                  0.0690607|                   0.0749370|                   0.0080850|                   0.0022809|      -0.0326744|      -0.0758409|       0.0864311|          -0.0935896|          -0.0432590|          -0.0374222|                      -0.9607243|                         -0.9607243|                          -0.9745186|              -0.9691998|                  -0.9783983|              -0.9883846|              -0.9421430|              -0.9707299|                  -0.9851458|                  -0.9550229|                  -0.9756961|      -0.9779950|      -0.9714323|      -0.9428617|                      -0.9556588|                              -0.9706859|                  -0.9648053|                      -0.9742427|               -0.9898793|               -0.9306774|               -0.9627273|                  -0.9914609|                  -0.9640949|                  -0.9859936|                   -0.9833049|                   -0.9529790|                   -0.9753330|       -0.9818411|       -0.9732375|       -0.9453059|           -0.9837421|           -0.9753310|           -0.9619930|                       -0.9454078|                          -0.9454078|                           -0.9658832|               -0.9614139|                   -0.9707560|               -0.9904682|               -0.9283994|               -0.9601643|                   -0.9827027|                   -0.9537838|                   -0.9732718|       -0.9829905|       -0.9745347|       -0.9509825|                       -0.9472726|                               -0.9584378|                   -0.9654313|                       -0.9680626|         26| STANDING            |
| 2587 |               0.1578943|               0.0228801|              -0.1369806|                  0.9306042|                 -0.1686326|                  0.1370589|                   0.0843887|                  -0.5445422|                  -0.0721559|      -0.5287714|       0.2561755|       0.0001328|          -0.4602889|          -0.0225236|          -0.3766501|                       0.2462307|                          0.2462307|                          -0.1754813|              -0.1843817|                  -0.5598397|               0.0731097|               0.0150832|              -0.3277915|                  -0.0478924|                  -0.1893990|                  -0.4724868|      -0.3269549|      -0.4754252|      -0.1521136|                       0.1034164|                               0.0972877|                  -0.3235872|                      -0.6097287|                0.3124398|                0.0377891|               -0.2864137|                  -0.9747190|                  -0.9452881|                  -0.9347216|                    0.0757148|                   -0.2130228|                   -0.5355374|       -0.5729186|       -0.4499038|       -0.2213823|           -0.5378667|           -0.6406017|           -0.3662896|                        0.1813124|                           0.1813124|                            0.0760727|               -0.3453730|                   -0.6221589|                0.3955018|               -0.0156733|               -0.3196741|                    0.1065896|                   -0.3020404|                   -0.5989132|       -0.6589554|       -0.4385287|       -0.3165982|                        0.0388835|                                0.0406805|                   -0.4780423|                       -0.6662204|         15| WALKING\_DOWNSTAIRS |
| 3054 |               0.1414307|              -0.0278663|              -0.1480747|                  0.9315833|                 -0.2111815|                  0.0466350|                   0.1133151|                   0.2890337|                   0.2520719|      -0.2375097|       0.0272465|      -0.0256811|          -0.0590499|          -0.0811867|          -0.1046183|                       0.3434261|                          0.3434261|                           0.1622967|               0.2958910|                   0.0594160|               0.1749574|               0.4168156|               0.1589983|                   0.0264428|                   0.0696505|                   0.3615692|       0.3937400|       0.0971553|       0.1841535|                       0.3635304|                               0.4405454|                   0.2422788|                       0.0736241|                0.2985259|                0.4404223|               -0.0006908|                  -0.9783686|                  -0.8770684|                  -0.9547080|                    0.0636211|                    0.1195537|                    0.2536896|        0.2299563|        0.0223392|       -0.0825428|            0.1768387|            0.0151135|            0.2223685|                        0.3190499|                           0.3190499|                            0.3905495|                0.2221788|                    0.0653878|                0.3440601|                0.3615593|               -0.1967774|                    0.0081894|                    0.0994211|                    0.1493167|        0.1739311|       -0.0340856|       -0.2733293|                        0.0900751|                                0.3142038|                   -0.0088021|                       -0.0214257|          6| WALKING\_DOWNSTAIRS |
| 825  |               0.2695149|              -0.0300630|              -0.1631582|                  0.9489731|                 -0.1526917|                 -0.1683933|                   0.0025510|                  -0.0349600|                  -0.2386995|      -0.0156760|      -0.1376111|      -0.0003491|          -0.3395627|           0.0106160|           0.0255104|                      -0.2122781|                         -0.2122781|                          -0.1796284|              -0.1513803|                  -0.1744567|              -0.3744234|              -0.1955178|              -0.0067847|                  -0.3886645|                  -0.2752273|                  -0.1461488|      -0.2666093|      -0.0583999|      -0.2110688|                      -0.1673842|                              -0.1085132|                  -0.0672152|                       0.0210591|               -0.4043945|               -0.2360545|                0.0783500|                  -0.9591174|                  -0.9690758|                  -0.9121795|                   -0.3073392|                   -0.2304938|                   -0.1160793|       -0.4896479|       -0.0218558|       -0.1647458|           -0.3658178|            0.0680943|           -0.4213808|                       -0.2470723|                          -0.2470723|                           -0.1162330|               -0.0733423|                    0.0930513|               -0.4165521|               -0.3070578|                0.0401351|                   -0.2857876|                   -0.2323174|                   -0.0889244|       -0.5630951|       -0.0068538|       -0.2263919|                       -0.4129800|                               -0.1308731|                   -0.2410352|                        0.1069509|         23| WALKING             |

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
|         21| WALKING             |               0.2791835|              -0.0181610|              -0.1043193|                  0.8625248|                 -0.3709845|                 -0.2209480|                   0.0782252|                   0.0023520|                  -0.0101813|      -0.0459323|      -0.0590294|       0.0983716|          -0.0868768|          -0.0515650|          -0.0621192|                      -0.1234557|                         -0.1234557|                          -0.1481390|              -0.2847756|                  -0.4269307|              -0.2734962|               0.0338466|              -0.3003091|                  -0.2004420|                  -0.1125647|                  -0.4057002|      -0.2466574|      -0.3717441|      -0.2832625|                      -0.2512664|                              -0.1440099|                  -0.4095161|                      -0.4995972|               -0.2978148|                0.0540881|               -0.1686887|                  -0.9695764|                  -0.9641445|                  -0.9749394|                   -0.1148889|                   -0.0347144|                   -0.4251426|       -0.4322329|       -0.3978923|       -0.3118756|           -0.2389083|           -0.4828543|           -0.4949277|                       -0.2997098|                          -0.2997098|                           -0.0838488|               -0.4083044|                   -0.4503700|               -0.3085472|               -0.0025629|               -0.1649610|                   -0.1074128|                   -0.0148415|                   -0.4435634|       -0.4918592|       -0.4194009|       -0.3855054|                       -0.4381498|                               -0.0186734|                   -0.5122493|                       -0.4293235|
|         22| WALKING             |               0.2788646|              -0.0167214|              -0.1071125|                  0.9360964|                 -0.2596449|                  0.0233780|                   0.0627778|                   0.0356746|                   0.0044369|       0.0007772|      -0.0960881|       0.0775267|          -0.1329776|          -0.0321911|          -0.0569812|                       0.0722419|                          0.0722419|                           0.0229200|              -0.2106080|                  -0.4619995|              -0.0994929|               0.1453675|              -0.2552165|                  -0.0367047|                   0.1599956|                  -0.2819734|      -0.1446487|      -0.5011769|      -0.0835012|                      -0.0241585|                               0.0659727|                  -0.4383787|                      -0.5539461|               -0.0086592|                0.1003842|               -0.2133520|                  -0.9696434|                  -0.9636393|                  -0.9551478|                    0.0358787|                    0.2255423|                   -0.3131559|       -0.3185379|       -0.4863221|       -0.1514395|           -0.2266564|           -0.6518755|           -0.2342782|                       -0.1615918|                          -0.1615918|                            0.1115329|               -0.3907757|                   -0.5031063|                0.0243958|                0.0038684|               -0.2536436|                    0.0180048|                    0.2134236|                   -0.3431956|       -0.3744963|       -0.4816244|       -0.2531739|                       -0.3813993|                                0.1582867|                   -0.4640191|                       -0.4764053|
|         22| SITTING             |               0.2735838|              -0.0123468|              -0.1058274|                  0.8393059|                  0.2085539|                  0.3155515|                   0.0807687|                  -0.0008427|                  -0.0126852|      -0.0360431|      -0.0793617|       0.0804427|          -0.0986493|          -0.0423410|          -0.0517194|                      -0.9421674|                         -0.9421674|                          -0.9793037|              -0.9420774|                  -0.9854760|              -0.9785054|              -0.9395460|              -0.9466353|                  -0.9809445|                  -0.9631295|                  -0.9753307|      -0.9772667|      -0.9591618|      -0.9483671|                      -0.9430782|                              -0.9689083|                  -0.9519528|                      -0.9777754|               -0.9784668|               -0.9280591|               -0.9175649|                  -0.9720100|                  -0.9542250|                  -0.9279506|                   -0.9816641|                   -0.9647828|                   -0.9789284|       -0.9810992|       -0.9501735|       -0.9465014|           -0.9856713|           -0.9802756|           -0.9795441|                       -0.9243362|                          -0.9243362|                           -0.9685768|               -0.9332685|                   -0.9765038|               -0.9786232|               -0.9269953|               -0.9093443|                   -0.9842996|                   -0.9697761|                   -0.9812722|       -0.9823733|       -0.9461079|       -0.9510457|                       -0.9267980|                               -0.9670263|                   -0.9335630|                       -0.9763181|
|         28| WALKING\_DOWNSTAIRS |               0.2936421|              -0.0220230|              -0.1085890|                  0.9292917|                 -0.2358971|                 -0.1214773|                   0.0972653|                   0.0143451|                   0.0012395|      -0.1410963|       0.0071056|       0.1386224|          -0.0266493|          -0.0570411|          -0.0776174|                       0.1043592|                          0.1043592|                          -0.0707560|              -0.0682463|                  -0.3404173|               0.0890722|               0.1864417|              -0.3081616|                  -0.0268677|                  -0.0127040|                  -0.3652874|      -0.0299970|      -0.2171002|      -0.1843923|                       0.1888400|                              -0.0128824|                  -0.2233548|                      -0.3967207|                0.1257129|                0.1564966|               -0.3410318|                  -0.9569215|                  -0.9484042|                  -0.9170598|                   -0.0167652|                    0.0265530|                   -0.4270533|       -0.2681063|       -0.2593687|       -0.3070250|           -0.1639449|           -0.4245679|           -0.3362127|                        0.1354656|                           0.1354656|                           -0.0418873|               -0.2244841|                   -0.4071323|                0.1377971|                0.0653012|               -0.4169403|                   -0.0980112|                   -0.0017539|                   -0.4884884|       -0.3454533|       -0.2931084|       -0.4165059|                       -0.0740586|                               -0.0883599|                   -0.3629038|                       -0.4647222|
|          5| LAYING              |               0.2783343|              -0.0183042|              -0.1079376|                 -0.4834706|                  0.9548903|                  0.2636447|                   0.0848165|                   0.0074746|                  -0.0030407|      -0.0218935|      -0.0798710|       0.1598944|          -0.1021141|          -0.0404447|          -0.0708310|                      -0.9667779|                         -0.9667779|                          -0.9801413|              -0.9469383|                  -0.9864194|              -0.9687417|              -0.9654195|              -0.9770077|                  -0.9826897|                  -0.9653286|                  -0.9832503|      -0.9757975|      -0.9782496|      -0.9632029|                      -0.9622350|                              -0.9773564|                  -0.9682571|                      -0.9846180|               -0.9659345|               -0.9692956|               -0.9685625|                  -0.9456953|                  -0.9859641|                  -0.9770766|                   -0.9833079|                   -0.9645604|                   -0.9854194|       -0.9794987|       -0.9774274|       -0.9605838|           -0.9834223|           -0.9837595|           -0.9896796|                       -0.9586128|                          -0.9586128|                           -0.9774771|               -0.9582879|                   -0.9837714|               -0.9649539|               -0.9729092|               -0.9658822|                   -0.9856253|                   -0.9662426|                   -0.9861356|       -0.9807058|       -0.9772578|       -0.9633057|                       -0.9625254|                               -0.9763819|                   -0.9592631|                       -0.9834345|
|          4| SITTING             |               0.2715383|              -0.0071631|              -0.1058746|                  0.8693030|                  0.2116225|                  0.1101205|                   0.0784500|                  -0.0108582|                  -0.0121500|      -0.0494435|      -0.0894301|       0.1011503|          -0.0969495|          -0.0418484|          -0.0489964|                      -0.9356948|                         -0.9356948|                          -0.9701323|              -0.9260633|                  -0.9804905|              -0.9774625|              -0.9057829|              -0.9517837|                  -0.9768457|                  -0.9442984|                  -0.9751549|      -0.9605896|      -0.9675836|      -0.9337769|                      -0.9290021|                              -0.9625007|                  -0.9487698|                      -0.9765478|               -0.9803099|               -0.8902240|               -0.9322030|                  -0.9814053|                  -0.9327271|                  -0.9509493|                   -0.9767422|                   -0.9445961|                   -0.9790388|       -0.9701318|       -0.9584681|       -0.9279722|           -0.9698997|           -0.9844414|           -0.9688048|                       -0.9144078|                          -0.9144078|                           -0.9625491|               -0.9288983|                   -0.9758067|               -0.9819082|               -0.8894673|               -0.9269993|                   -0.9787769|                   -0.9492932|                   -0.9816994|       -0.9733331|       -0.9541204|       -0.9328684|                       -0.9198157|                               -0.9615845|                   -0.9288506|                       -0.9762618|

This data-set's variables have the same units as the resulting clean data-set, but the values represent averages over data grouped by `SubjectID` and `ActivityName`.

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE)
```
