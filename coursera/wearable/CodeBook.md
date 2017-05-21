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
    -   [Pertinent Variables (Mean, Standard Deviation & Activity)](#pertinent-variables-mean-standard-deviation-activity)
    -   [Binding Feature, Label and Subject Data Together](#binding-feature-label-and-subject-data-together)
    -   [Re-Naming the Data-set Variables](#re-naming-the-data-set-variables)
    -   [Filtering Out Non-Pertinent Variables](#filtering-out-non-pertinent-variables)
    -   [Normalizing Variable Names](#normalizing-variable-names)
    -   [Joining with Activity Names Data](#joining-with-activity-names-data)
    -   [Putting All Transformations Together](#putting-all-transformations-together)
    -   [Resulting Clean Data-set](#resulting-clean-data-set)
-   [Computing Averages per Activity and Subject](#computing-averages-per-activity-and-subject)
-   [Saving Resulting Data to Disk](#saving-resulting-data-to-disk)

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

    ## [1] "tBodyGyro-std()-Y"                "fBodyAccJerk-bandsEnergy()-57,64"
    ## [3] "tBodyGyro-arCoeff()-Z,4"          "fBodyAcc-energy()-Z"             
    ## [5] "fBodyGyro-energy()-X"             "fBodyAcc-bandsEnergy()-49,56"

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

### Pertinent Variables (Mean, Standard Deviation & Activity)

Let's create a list of all variables, which include the features names and label name:

``` r
variables <- c(feature_names, "ActivityID", "SubjectID")
```

The variable name for activity is my own choice. I believe is descriptive enough.

Let's also create a list of the variables we are interested in exploring (means and standard deviations at the moment):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "tBodyGyroJerk-min()-Y"         "fBodyGyro-bandsEnergy()-17,32"
    ## [3] "tBodyGyroJerk-std()-Y"         "fBodyAccMag-maxInds"          
    ## [5] "SubjectID"                     "fBodyBodyGyroMag-mad()"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-Y"       "fBodyAccMag-mean()"     
    ## [3] "tBodyAccJerk-mean()-X"   "fBodyGyro-mean()-Y"     
    ## [5] "fBodyGyro-mean()-Z"      "tBodyGyroJerkMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyGyro-std()-Y"     "tBodyGyro-std()-Y"     "tGravityAcc-std()-X"  
    ## [4] "fBodyAccJerk-std()-X"  "tBodyGyroJerk-std()-Z" "fBodyAcc-std()-Z"

### Binding Feature, Label and Subject Data Together

``` r
add_labels <- function(data, labels) {
  data <- cbind(data, labels)
  data
}

add_subjects <- function(data, subjects) {
  data <- cbind(data, subjects)
  data
}

test_data <- add_labels(test_data, test_labels)
test_data <- add_subjects(test_data, test_subjects)
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

    ## [1] "tBodyAccJerk-std()-Z"         "fBodyAcc-entropy()-X"        
    ## [3] "fBodyAcc-bandsEnergy()-9,16"  "fBodyAcc-bandsEnergy()-25,48"
    ## [5] "fBodyBodyGyroJerkMag-min()"   "fBodyAccMag-sma()"

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
| 439  |               0.3632399|              -0.0919882|              -0.2395856|                  0.9525714|                 -0.2222170|                  0.1237638|                   0.1644340|                  -0.0350776|                  -0.2742128|      -0.0230212|      -0.2195060|      -0.0134397|          -0.0117843|           0.0629664|          -0.1949682|                      -0.1627354|                         -0.1627354|                          -0.4878677|              -0.4674254|                  -0.7477027|              -0.2917674|              -0.2021231|              -0.4456087|                  -0.4356616|                  -0.4712733|                  -0.7179835|      -0.6167056|      -0.7002177|      -0.3197015|                      -0.3334595|                              -0.4533337|                  -0.7313107|                      -0.8045888|               -0.2544697|               -0.0139216|               -0.3506489|                  -0.9518015|                  -0.7469473|                  -0.7797384|                   -0.4222644|                   -0.4788167|                   -0.7474895|       -0.7014308|       -0.6198798|       -0.2336005|           -0.6901492|           -0.8522792|           -0.5928817|                       -0.2052899|                          -0.2052899|                           -0.5082949|               -0.6845336|                   -0.8119220|               -0.2401933|                0.0121577|               -0.3503886|                   -0.4598883|                   -0.5267864|                   -0.7757535|       -0.7282868|       -0.5803050|       -0.2773828|                       -0.2651073|                               -0.5878353|                   -0.7071818|                       -0.8354283|           2|          4|
| 893  |               0.2133831|               0.0095161|              -0.1329670|                  0.8487489|                  0.0718207|                 -0.3888863|                  -0.0029755|                  -0.1854872|                   0.3802198|      -0.4983933|      -0.1622106|       0.4104517|           0.1246656|           0.0789964|          -0.1327449|                      -0.1713456|                         -0.1713456|                          -0.3546365|               0.0408822|                  -0.6297863|              -0.2807332|              -0.4884504|              -0.2208918|                  -0.3504118|                  -0.6048092|                  -0.5291392|      -0.3675981|      -0.3324264|      -0.4424164|                      -0.1613058|                              -0.3343107|                  -0.5356389|                      -0.6683590|               -0.2086392|               -0.4835583|               -0.0194526|                  -0.9561148|                  -0.9428752|                  -0.8719860|                   -0.2284905|                   -0.6126283|                   -0.5684267|       -0.2874735|       -0.1707592|       -0.4288116|           -0.6558093|           -0.6359598|           -0.6324239|                       -0.1553832|                          -0.1553832|                           -0.3796033|               -0.4020536|                   -0.6828926|               -0.1818801|               -0.5130017|                0.0074233|                   -0.1766727|                   -0.6512555|                   -0.6055961|       -0.2787328|       -0.0907573|       -0.4765136|                       -0.2832004|                               -0.4462601|                   -0.4198725|                       -0.7263140|           2|          9|
| 137  |               0.2427426|               0.0099776|              -0.0933862|                  0.8225396|                 -0.4354549|                 -0.2281307|                   0.3167920|                  -0.1757361|                  -0.4520016|       0.3240511|      -0.4765694|      -0.2504386|          -0.0698123|          -0.0698472|           0.0144942|                      -0.2201273|                         -0.2201273|                          -0.4522697|              -0.1804778|                  -0.6299798|              -0.3743434|              -0.0265124|              -0.3611620|                  -0.4732632|                  -0.2516409|                  -0.5841908|      -0.4127030|      -0.5306493|      -0.2896822|                      -0.2218217|                              -0.3033664|                  -0.4765622|                      -0.6751018|               -0.4157809|                0.0617599|               -0.2380767|                  -0.9633993|                  -0.9383780|                  -0.9527586|                   -0.4705482|                   -0.2510373|                   -0.6341373|       -0.3621454|       -0.5291271|       -0.2260912|           -0.6005069|           -0.6997340|           -0.5116386|                       -0.3116647|                          -0.3116647|                           -0.3619604|               -0.3177256|                   -0.7088699|               -0.4328517|                0.0395435|               -0.2323234|                   -0.5160323|                   -0.3048825|                   -0.6840811|       -0.3586578|       -0.5314687|       -0.2770150|                       -0.4747167|                               -0.4479749|                   -0.3347620|                       -0.7835814|           2|          2|
| 1459 |               0.3090925|              -0.0218608|              -0.1026760|                  0.9667230|                 -0.1714689|                 -0.0341002|                  -0.4416504|                  -0.0392667|                   0.0115558|       0.0025301|      -0.0723206|      -0.0005243|          -0.0893870|           0.0675115|           0.0446346|                      -0.0054589|                         -0.0054589|                          -0.0354024|              -0.3405465|                  -0.4035136|               0.1341740|               0.0642726|              -0.5757310|                   0.0538561|                  -0.0654957|                  -0.6289031|      -0.3319859|      -0.3202298|      -0.4400624|                      -0.0038705|                               0.0361778|                  -0.2820168|                      -0.4026450|               -0.0118039|                0.0548985|               -0.5147740|                  -0.9798993|                  -0.9700321|                  -0.9551594|                    0.1760280|                   -0.0125444|                   -0.5800079|       -0.4883318|       -0.2915196|       -0.5327457|           -0.1944605|           -0.4219421|           -0.5423439|                       -0.1234250|                          -0.1234250|                            0.0818915|               -0.3106140|                   -0.3710990|               -0.0755315|               -0.0169747|               -0.5192935|                    0.1975086|                   -0.0198658|                   -0.5388452|       -0.5380558|       -0.2793113|       -0.6102126|                       -0.3351234|                                0.1315570|                   -0.4545673|                       -0.3735932|           1|         12|
| 2542 |               0.0290891|              -0.1263674|              -0.1365972|                  0.8776577|                 -0.4202782|                  0.0118657|                  -0.4230533|                   0.4086345|                  -0.3254698|       0.7667958|      -1.0000000|       0.0649563|          -0.0564390|          -0.0662697|          -0.5029738|                       0.1258412|                          0.1258412|                          -0.0300260|               0.3856932|                  -0.2352544|               0.0367272|               0.1136242|              -0.1439368|                  -0.0616037|                  -0.1282779|                  -0.3515873|      -0.2877224|      -0.0627315|       0.3586980|                       0.0160428|                               0.0559942|                  -0.0172857|                      -0.4144652|               -0.0552906|                0.3617422|               -0.1315262|                  -0.8581575|                  -0.8448785|                  -0.8025308|                    0.0379291|                   -0.0537808|                   -0.3176586|       -0.4281620|        0.0886825|        0.2275938|           -0.3852921|           -0.2885092|           -0.0852445|                       -0.0727752|                          -0.0727752|                           -0.0193474|                0.0883081|                   -0.4145211|               -0.0940148|                0.3925229|               -0.1945766|                    0.0489835|                   -0.0343828|                   -0.2873725|       -0.4727804|        0.1648767|        0.0692477|                       -0.2709449|                               -0.1323028|                   -0.0260267|                       -0.4561782|           2|         20|
| 1601 |               0.2749008|              -0.0183139|              -0.1041087|                 -0.1131791|                  0.4451194|                  0.8657865|                   0.0729076|                   0.0030557|                  -0.0001855|      -0.0301910|      -0.0678306|       0.0874133|          -0.0969642|          -0.0425152|          -0.0527588|                      -0.9542493|                         -0.9542493|                          -0.9893960|              -0.9664846|                  -0.9894025|              -0.9859162|              -0.9763529|              -0.9737667|                  -0.9921811|                  -0.9896922|                  -0.9826256|      -0.9847132|      -0.9779168|      -0.9914184|                      -0.9799723|                              -0.9896452|                  -0.9809753|                      -0.9853750|               -0.9689664|               -0.9411705|               -0.9405605|                  -0.9791123|                  -0.9821400|                  -0.9754143|                   -0.9920245|                   -0.9905620|                   -0.9851859|       -0.9760184|       -0.9631294|       -0.9841019|           -0.9922003|           -0.9830588|           -0.9943156|                       -0.9662560|                          -0.9662560|                           -0.9904155|               -0.9773821|                   -0.9831111|               -0.9636749|               -0.9307790|               -0.9292385|                   -0.9925295|                   -0.9925009|                   -0.9863309|       -0.9744183|       -0.9563269|       -0.9832618|                       -0.9635792|                               -0.9902467|                   -0.9785404|                       -0.9810462|           6|         13|

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
| 2879 |               0.2489269|              -0.0151642|              -0.1031153|                 -0.1898142|                  0.8569025|                  0.4862113|                   0.0736063|                   0.0116333|                   0.0173676|      -0.0382759|      -0.0877437|       0.0886856|          -0.0957490|          -0.0405957|          -0.0642629|                      -0.9855662|                         -0.9855662|                          -0.9912542|              -0.9753661|                  -0.9878235|              -0.9908180|              -0.9883629|              -0.9904738|                  -0.9904941|                  -0.9879530|                  -0.9916800|      -0.9894825|      -0.9754388|      -0.9769850|                      -0.9931887|                              -0.9947275|                  -0.9800426|                      -0.9854078|               -0.9915544|               -0.9905095|               -0.9888165|                  -0.9809623|                  -0.9949529|                  -0.9944859|                   -0.9898878|                   -0.9875924|                   -0.9929991|       -0.9913345|       -0.9714538|       -0.9745665|           -0.9930310|           -0.9833251|           -0.9894708|                       -0.9943068|                          -0.9943068|                           -0.9938703|               -0.9746306|                   -0.9852845|               -0.9917704|               -0.9912962|               -0.9877016|                   -0.9900469|                   -0.9879889|                   -0.9928324|       -0.9918512|       -0.9692804|       -0.9759039|                       -0.9952312|                               -0.9910764|                   -0.9751334|                       -0.9857149|         20| LAYING              |
| 1800 |               0.2791638|              -0.0113148|              -0.1096560|                  0.9555018|                 -0.0412497|                  0.1869476|                   0.0925487|                  -0.0112026|                   0.0421160|      -0.0327440|      -0.0492182|       0.0772499|          -0.0921073|          -0.0289317|          -0.0573556|                      -0.9261657|                         -0.9261657|                          -0.9567084|              -0.9366753|                  -0.9769073|              -0.9621551|              -0.9064438|              -0.9196158|                  -0.9639266|                  -0.9411394|                  -0.9576462|      -0.9628274|      -0.9519299|      -0.9271093|                      -0.9441745|                              -0.9580599|                  -0.9474376|                      -0.9824825|               -0.9706995|               -0.8889789|               -0.8982871|                  -0.9927610|                  -0.9914789|                  -0.9739865|                   -0.9681840|                   -0.9366106|                   -0.9645132|       -0.9663695|       -0.9319227|       -0.9066186|           -0.9751106|           -0.9816158|           -0.9669655|                       -0.9456963|                          -0.9456963|                           -0.9601142|               -0.9194674|                   -0.9834916|               -0.9748279|               -0.8864688|               -0.8939209|                   -0.9770357|                   -0.9356471|                   -0.9704076|       -0.9675335|       -0.9222866|       -0.9090062|                       -0.9539378|                               -0.9614554|                   -0.9166214|                       -0.9858065|         20| SITTING             |
| 2313 |               0.2766510|              -0.0179161|              -0.1083993|                  0.8473614|                 -0.4673918|                  0.0364933|                   0.0653349|                  -0.0068323|                  -0.0300311|      -0.1432794|      -0.0275603|       0.1063106|          -0.0431507|          -0.0669574|          -0.0337453|                      -0.9755399|                         -0.9755399|                          -0.9855196|              -0.8704946|                  -0.9857934|              -0.9817477|              -0.9588681|              -0.9790874|                  -0.9831395|                  -0.9833187|                  -0.9864217|      -0.9054443|      -0.9591522|      -0.9530482|                      -0.9795002|                              -0.9849922|                  -0.9026145|                      -0.9866699|               -0.9842107|               -0.9521916|               -0.9753316|                  -0.9795820|                  -0.9695312|                  -0.9773300|                   -0.9827250|                   -0.9833265|                   -0.9880820|       -0.9220632|       -0.9509111|       -0.9478148|           -0.9840245|           -0.9873201|           -0.9806427|                       -0.9770224|                          -0.9770224|                           -0.9866388|               -0.8685940|                   -0.9874874|               -0.9852260|               -0.9507868|               -0.9740677|                   -0.9837701|                   -0.9845262|                   -0.9882181|       -0.9272930|       -0.9466017|       -0.9507213|                       -0.9779592|                               -0.9879534|                   -0.8697194|                       -0.9892385|         20| STANDING            |
| 238  |               0.3368281|              -0.0082663|              -0.1442838|                  0.9246144|                 -0.3002455|                  0.0396990|                   0.0304639|                   0.1992701|                   0.2018321|      -0.0216046|      -0.0508283|       0.0477384|          -0.4618726|           0.1023797|           0.1486820|                      -0.1538483|                         -0.1538483|                          -0.1582230|              -0.2253989|                  -0.3787736|              -0.4066143|               0.3042194|              -0.4158618|                  -0.3379460|                   0.1506647|                  -0.4786315|       0.0066081|      -0.4577230|      -0.2349592|                      -0.1882562|                              -0.1726397|                  -0.3323653|                      -0.5195471|               -0.4247397|                0.4089001|               -0.4436611|                  -0.9810477|                  -0.9737602|                  -0.9874288|                   -0.3061068|                    0.2906971|                   -0.5480557|       -0.2305883|       -0.4596452|       -0.3953955|           -0.0606444|           -0.6375616|           -0.2382218|                       -0.2632508|                          -0.2632508|                           -0.1175227|               -0.3001015|                   -0.5201395|               -0.4319605|                0.3730664|               -0.5067322|                   -0.3339491|                    0.3575576|                   -0.6194453|       -0.3060484|       -0.4646053|       -0.5138053|                       -0.4235790|                               -0.0575932|                   -0.3983622|                       -0.5548442|         13| WALKING             |
| 983  |               0.4098989|              -0.0498973|              -0.1614313|                  0.9718546|                 -0.0648173|                  0.0705956|                  -0.0141363|                  -0.1621986|                   0.0147623|       0.0166137|      -0.1210045|       0.0656927|          -0.4323198|          -0.0788684|          -0.1690376|                       0.0212973|                          0.0212973|                          -0.2504871|              -0.3086524|                  -0.5047196|               0.0215162|              -0.2473664|              -0.4104754|                  -0.1690215|                  -0.3757901|                  -0.4882980|      -0.2676112|      -0.4125002|      -0.4757948|                       0.0679595|                              -0.1324167|                  -0.4878663|                      -0.5696579|                0.1521887|               -0.2636666|               -0.3896355|                  -0.9747243|                  -0.9580907|                  -0.9015524|                   -0.0661959|                   -0.3744886|                   -0.5175451|       -0.4432441|       -0.4215741|       -0.3960654|           -0.4999550|           -0.5088846|           -0.5736563|                        0.1612079|                           0.1612079|                           -0.1164147|               -0.5114280|                   -0.5665834|                0.1997814|               -0.3189061|               -0.4263797|                   -0.0436045|                   -0.4184002|                   -0.5440344|       -0.4991350|       -0.4313265|       -0.4272012|                        0.0295385|                               -0.1024475|                   -0.6169059|                       -0.5925727|          9| WALKING\_DOWNSTAIRS |
| 704  |               0.2365570|              -0.0061943|              -0.1394829|                  0.8323148|                 -0.4403431|                 -0.2143870|                   0.0496215|                  -0.0387407|                   0.0612641|       0.0892784|      -0.1087498|      -0.0996921|           0.1456187|          -0.2290259|          -0.1334352|                      -0.2166302|                         -0.2166302|                          -0.4351527|              -0.2693784|                  -0.6405393|              -0.4169721|              -0.1053915|              -0.4902337|                  -0.4304560|                  -0.2345636|                  -0.6378767|      -0.3670291|      -0.5056895|      -0.2151836|                      -0.3235085|                              -0.3382084|                  -0.5295581|                      -0.7093813|               -0.3789479|                0.0289876|               -0.2995960|                  -0.9356389|                  -0.9586675|                  -0.8793164|                   -0.4484364|                   -0.2271530|                   -0.6868244|       -0.4925703|       -0.4344601|       -0.0957153|           -0.6050124|           -0.7320137|           -0.4743633|                       -0.3329716|                          -0.3329716|                           -0.3857883|               -0.4307158|                   -0.7197168|               -0.3644736|                0.0299450|               -0.2601483|                   -0.5213571|                   -0.2740297|                   -0.7368147|       -0.5324108|       -0.3984919|       -0.1424772|                       -0.4415980|                               -0.4559760|                   -0.4632979|                       -0.7541649|          2| WALKING\_UPSTAIRS   |

We also remove "ActivityID", given that "ActivityName" is better suited for data exploration (more readable).

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels, subjects) {
  data <- add_labels(data, labels)
  data <- add_subjects(data, subjects)
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
| 5790 |               0.2715782|              -0.0626951|              -0.0323205|                  0.9435440|                 -0.2370669|                 -0.1011060|                   0.0464321|                  -0.0795675|                   0.0517923|       0.0483998|      -0.0337780|       0.1158823|          -0.0743739|          -0.0646375|          -0.0159921|                      -0.7603539|                         -0.7603539|                          -0.8994833|              -0.7450799|                  -0.9042809|              -0.9390522|              -0.6874491|              -0.7892363|                  -0.9429400|                  -0.8534554|                  -0.8882149|      -0.7480779|      -0.8925008|      -0.8192617|                      -0.8014814|                              -0.8838733|                  -0.8349580|                      -0.9163897|               -0.9462542|               -0.5829115|               -0.6656719|                  -0.9795487|                  -0.8563408|                  -0.8247977|                   -0.9387187|                   -0.8448502|                   -0.9018459|       -0.7521191|       -0.8621409|       -0.7580787|           -0.8243967|           -0.9422624|           -0.9210078|                       -0.6913068|                          -0.6913068|                           -0.8805841|               -0.7615760|                   -0.9084075|               -0.9492813|               -0.5615006|               -0.6336446|                   -0.9395606|                   -0.8455680|                   -0.9143687|       -0.7559455|       -0.8471045|       -0.7629530|                       -0.6907077|                               -0.8754352|                   -0.7584919|                       -0.9044528|         28| STANDING            |
| 242  |               0.2035147|              -0.0016890|              -0.0991992|                  0.9649173|                 -0.1405822|                  0.0988510|                  -0.1075898|                  -0.0374548|                   0.1533418|      -0.0452567|      -0.0430455|       0.1542903|          -0.2513544|           0.0671502|          -0.0111775|                      -0.2017777|                         -0.2017777|                          -0.2963968|              -0.3475208|                  -0.5168859|              -0.3057231|              -0.1324541|              -0.3596736|                  -0.3745435|                  -0.2863678|                  -0.4459040|      -0.3259330|      -0.5643041|      -0.3456403|                      -0.4615116|                              -0.3505209|                  -0.5767315|                      -0.6577005|               -0.3315745|               -0.0905266|               -0.3511747|                  -0.9796121|                  -0.9789766|                  -0.9803914|                   -0.3418868|                   -0.2687821|                   -0.4529402|       -0.4186264|       -0.5810186|       -0.3379264|           -0.4142316|           -0.6165537|           -0.5245901|                       -0.4615374|                          -0.4615374|                           -0.3682555|               -0.5361216|                   -0.6786636|               -0.3419587|               -0.1259423|               -0.3985149|                   -0.3656822|                   -0.2997953|                   -0.4580011|       -0.4492357|       -0.5946021|       -0.3958408|                       -0.5447078|                               -0.3903377|                   -0.5875665|                       -0.7324582|         26| WALKING             |
| 4702 |               0.2769379|              -0.0103825|              -0.1047803|                  0.9579625|                  0.0004680|                  0.1632211|                   0.0743844|                   0.0068275|                   0.0256678|      -0.0276838|      -0.0583023|       0.0853140|          -0.0969740|          -0.0364195|          -0.0527540|                      -0.9817466|                         -0.9817466|                          -0.9905557|              -0.9904646|                  -0.9951427|              -0.9947768|              -0.9825191|              -0.9739287|                  -0.9943253|                  -0.9880304|                  -0.9842385|      -0.9919550|      -0.9902891|      -0.9926081|                      -0.9882632|                              -0.9905215|                  -0.9915608|                      -0.9961701|               -0.9951166|               -0.9791208|               -0.9686080|                  -0.9955690|                  -0.9820861|                  -0.9809035|                   -0.9929790|                   -0.9876564|                   -0.9880792|       -0.9921106|       -0.9902054|       -0.9927839|           -0.9945578|           -0.9944236|           -0.9951288|                       -0.9884553|                          -0.9884553|                           -0.9913287|               -0.9878752|                   -0.9965349|               -0.9951732|               -0.9776074|               -0.9670034|                   -0.9920413|                   -0.9880308|                   -0.9910142|       -0.9921114|       -0.9901259|       -0.9933833|                       -0.9893668|                               -0.9912311|                   -0.9872806|                       -0.9969972|          5| STANDING            |
| 6491 |               0.5168399|               0.0034079|              -0.1126922|                 -0.8350382|                  0.6928042|                  0.7152430|                   0.1446705|                   0.0288808|                  -0.0050618|      -0.0127105|      -0.2275853|       0.1236530|          -0.0964219|          -0.0444209|          -0.0540412|                      -0.8454176|                         -0.8454176|                          -0.9797063|              -0.9196210|                  -0.9770974|              -0.9002366|              -0.9577864|              -0.9794250|                  -0.9829693|                  -0.9737270|                  -0.9783439|      -0.9648323|      -0.9587590|      -0.9726441|                      -0.8853429|                              -0.9764651|                  -0.9562365|                      -0.9738490|               -0.8631751|               -0.9444558|               -0.9783195|                  -0.8831547|                  -0.9801497|                  -0.9963038|                   -0.9838790|                   -0.9728944|                   -0.9790268|       -0.9753524|       -0.9467480|       -0.9756298|           -0.9627084|           -0.9790070|           -0.9793046|                       -0.7940969|                          -0.7940969|                           -0.9792400|               -0.9396278|                   -0.9740545|               -0.8506394|               -0.9406528|               -0.9784239|                   -0.9865141|                   -0.9737547|                   -0.9780114|       -0.9787770|       -0.9406739|       -0.9788287|                       -0.7875432|                               -0.9823464|                   -0.9393970|                       -0.9757656|         19| LAYING              |
| 2934 |               0.3642292|              -0.0188343|              -0.1875624|                  0.9049796|                 -0.2088165|                 -0.2600577|                  -0.6553386|                   0.2876140|                   0.8349103|      -0.0309685|      -0.0475909|       0.0256893|           0.0956100|          -0.1147458|          -0.2328357|                       0.1722593|                          0.1722593|                          -0.2027108|              -0.2332968|                  -0.5831856|               0.1310352|               0.0123544|               0.0999736|                  -0.2219131|                  -0.2182125|                  -0.2531120|      -0.4278351|      -0.4772303|      -0.1989163|                       0.0990933|                              -0.1024667|                  -0.5845945|                      -0.5811023|                0.1506275|               -0.0439791|                0.0293209|                  -0.9535004|                  -0.9553231|                  -0.8683181|                   -0.1894959|                   -0.1925428|                   -0.2864014|       -0.3248305|       -0.5188851|       -0.2668368|           -0.6871625|           -0.5797927|           -0.4253342|                        0.0794742|                           0.0794742|                           -0.0759943|               -0.5667147|                   -0.5802089|                0.1583365|               -0.1364106|               -0.1011934|                   -0.2272234|                   -0.2193649|                   -0.3164480|       -0.3112467|       -0.5499479|       -0.3575042|                       -0.0994904|                               -0.0497459|                   -0.6288996|                       -0.6068201|         16| WALKING\_DOWNSTAIRS |
| 4013 |               0.2743946|              -0.0441762|              -0.0889174|                  0.9608524|                  0.0077428|                  0.1479473|                   0.0681348|                   0.0285908|                   0.0240991|      -0.0759709|      -0.0383946|      -0.0679651|          -0.0762830|          -0.0295739|           0.0058754|                      -0.9325606|                         -0.9325606|                          -0.9669427|              -0.9094914|                  -0.9871504|              -0.9719536|              -0.9273334|              -0.9483289|                  -0.9736457|                  -0.9502852|                  -0.9721122|      -0.9601895|      -0.9793677|      -0.9072373|                      -0.9580468|                              -0.9631739|                  -0.9334752|                      -0.9869620|               -0.9722627|               -0.9101040|               -0.9372715|                  -0.9789552|                  -0.9221812|                  -0.9557038|                   -0.9694967|                   -0.9486046|                   -0.9755132|       -0.9631508|       -0.9801485|       -0.8983313|           -0.9898596|           -0.9863594|           -0.9803559|                       -0.9550216|                          -0.9550216|                           -0.9631436|               -0.8992172|                   -0.9865106|               -0.9722146|               -0.9065190|               -0.9350847|                   -0.9677664|                   -0.9501711|                   -0.9774500|       -0.9641886|       -0.9807045|       -0.9046180|                       -0.9590943|                               -0.9614797|                   -0.8961284|                       -0.9863574|         11| SITTING             |

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
|         29| STANDING            |               0.2779651|              -0.0172606|              -0.1086591|                  0.9745087|                 -0.0584872|                  0.0316146|                   0.0753053|                   0.0115105|                   0.0003329|      -0.0276076|      -0.0721061|       0.0827584|          -0.0988702|          -0.0405111|          -0.0544926|                      -0.9847453|                         -0.9847453|                          -0.9907854|              -0.9806573|                  -0.9921447|              -0.9950240|              -0.9733458|              -0.9840960|                  -0.9937369|                  -0.9831950|                  -0.9885416|      -0.9744854|      -0.9915867|      -0.9836547|                      -0.9845481|                              -0.9897939|                  -0.9808797|                      -0.9916721|               -0.9960686|               -0.9692957|               -0.9802075|                  -0.9967642|                  -0.9851340|                  -0.9844645|                   -0.9936528|                   -0.9833382|                   -0.9905939|       -0.9779948|       -0.9903649|       -0.9833686|           -0.9832931|           -0.9955331|           -0.9906857|                       -0.9817457|                          -0.9817457|                           -0.9904957|               -0.9753587|                   -0.9914536|               -0.9966046|               -0.9682786|               -0.9788030|                   -0.9941234|                   -0.9847828|                   -0.9913164|       -0.9791626|       -0.9896437|       -0.9847142|                       -0.9822477|                               -0.9903279|                   -0.9759387|                       -0.9915168|
|         25| WALKING             |               0.2789928|              -0.0186478|              -0.1087376|                  0.9374831|                 -0.1273159|                  0.1884163|                   0.0721721|                   0.0035112|                  -0.0033510|      -0.0156305|      -0.0820768|       0.0867869|          -0.1023773|          -0.0398987|          -0.0512696|                      -0.4052894|                         -0.4052894|                          -0.5382914|              -0.3943624|                  -0.6784661|              -0.6090389|              -0.2518803|              -0.5335632|                  -0.6255954|                  -0.4344552|                  -0.6592864|      -0.4119097|      -0.6787504|      -0.5613230|                      -0.5660600|                              -0.5645913|                  -0.5627333|                      -0.7703009|               -0.5960074|               -0.1618524|               -0.4371334|                  -0.9794993|                  -0.9650934|                  -0.9449957|                   -0.6076209|                   -0.3826197|                   -0.6756014|       -0.4011588|       -0.6040321|       -0.5627752|           -0.5079571|           -0.7996354|           -0.6595762|                       -0.5656015|                          -0.5656015|                           -0.5428701|               -0.4898094|                   -0.7570325|               -0.5914500|               -0.1703138|               -0.4306246|                   -0.6241457|                   -0.3677601|                   -0.6904134|       -0.4066781|       -0.5672013|       -0.6035442|                       -0.6329275|                               -0.5190042|                   -0.5292622|                       -0.7573858|
|         12| WALKING\_DOWNSTAIRS |               0.2815211|              -0.0180843|              -0.1095559|                  0.9498620|                 -0.1787022|                 -0.0561051|                   0.0621500|                  -0.0119289|                   0.0048526|      -0.1125316|      -0.0427337|       0.0895435|          -0.0264669|          -0.0609177|          -0.0653240|                       0.0183139|                          0.0183139|                          -0.1070910|              -0.2133515|                  -0.4428311|               0.0235049|               0.1505100|              -0.4021212|                  -0.0070147|                   0.0063941|                  -0.4516143|      -0.1788562|      -0.4206315|      -0.2127674|                       0.1480173|                               0.0769968|                  -0.3449384|                      -0.4582275|                0.0424085|                0.1108353|               -0.4250174|                  -0.9595040|                  -0.9432984|                  -0.9353993|                    0.0063191|                    0.0629217|                   -0.4986558|       -0.3621431|       -0.4762877|       -0.3378067|           -0.2786082|           -0.5174791|           -0.3652322|                        0.0972608|                           0.0972608|                            0.0655781|               -0.3204586|                   -0.4524499|                0.0483347|                0.0167495|               -0.4873901|                   -0.0723114|                    0.0515123|                   -0.5444614|       -0.4223632|       -0.5189231|       -0.4485130|                       -0.1051250|                                0.0420631|                   -0.4235540|                       -0.4867804|
|         29| WALKING\_DOWNSTAIRS |               0.2931404|              -0.0149412|              -0.0981340|                  0.9484862|                 -0.0760963|                  0.0919650|                   0.0636872|                   0.0006210|                  -0.0140643|      -0.0374126|      -0.0851046|       0.0822244|          -0.0743986|          -0.0671482|          -0.0359648|                       0.1037052|                          0.1037052|                          -0.1386376|              -0.1229681|                  -0.5391745|               0.1106632|              -0.0212294|              -0.2666922|                  -0.0382458|                  -0.0977851|                  -0.4111735|      -0.1894180|      -0.4631250|      -0.1992259|                       0.1159740|                               0.0004489|                  -0.3814599|                      -0.5965786|                0.1673836|               -0.1224635|               -0.2231780|                  -0.9417362|                  -0.9139031|                  -0.8693009|                   -0.0239526|                   -0.0773408|                   -0.4787642|       -0.2820773|       -0.3904601|       -0.3111226|           -0.3478076|           -0.6934690|           -0.3797694|                        0.1344812|                           0.1344812|                           -0.0307693|               -0.2674098|                   -0.5970570|                0.1874386|               -0.2393491|               -0.2620732|                   -0.0986379|                   -0.1203815|                   -0.5473209|       -0.3191231|       -0.3548727|       -0.4161658|                       -0.0330868|                               -0.0797714|                   -0.3230246|                       -0.6266760|
|         28| WALKING\_DOWNSTAIRS |               0.2936421|              -0.0220230|              -0.1085890|                  0.9292917|                 -0.2358971|                 -0.1214773|                   0.0972653|                   0.0143451|                   0.0012395|      -0.1410963|       0.0071056|       0.1386224|          -0.0266493|          -0.0570411|          -0.0776174|                       0.1043592|                          0.1043592|                          -0.0707560|              -0.0682463|                  -0.3404173|               0.0890722|               0.1864417|              -0.3081616|                  -0.0268677|                  -0.0127040|                  -0.3652874|      -0.0299970|      -0.2171002|      -0.1843923|                       0.1888400|                              -0.0128824|                  -0.2233548|                      -0.3967207|                0.1257129|                0.1564966|               -0.3410318|                  -0.9569215|                  -0.9484042|                  -0.9170598|                   -0.0167652|                    0.0265530|                   -0.4270533|       -0.2681063|       -0.2593687|       -0.3070250|           -0.1639449|           -0.4245679|           -0.3362127|                        0.1354656|                           0.1354656|                           -0.0418873|               -0.2244841|                   -0.4071323|                0.1377971|                0.0653012|               -0.4169403|                   -0.0980112|                   -0.0017539|                   -0.4884884|       -0.3454533|       -0.2931084|       -0.4165059|                       -0.0740586|                               -0.0883599|                   -0.3629038|                       -0.4647222|
|         24| WALKING\_UPSTAIRS   |               0.2698811|              -0.0251979|              -0.1142486|                  0.9063695|                 -0.2374984|                 -0.2271349|                   0.0862310|                  -0.0150816|                  -0.0132354|       0.0883164|      -0.1059329|       0.0248291|          -0.1468008|          -0.0317351|          -0.0498427|                      -0.2264028|                         -0.2264028|                          -0.4884876|              -0.3344358|                  -0.6587516|              -0.3957906|              -0.2524125|              -0.3127922|                  -0.5156446|                  -0.5276042|                  -0.4833910|      -0.5031887|      -0.5466210|      -0.3721829|                      -0.3223010|                              -0.4298008|                  -0.5646650|                      -0.6461147|               -0.3443994|               -0.1168045|               -0.2556010|                  -0.9621906|                  -0.9166908|                  -0.9349529|                   -0.4987647|                   -0.5152208|                   -0.5238073|       -0.5774264|       -0.5685341|       -0.2745963|           -0.6404895|           -0.6466444|           -0.6489753|                       -0.3068545|                          -0.3068545|                           -0.4410687|               -0.5039291|                   -0.6381804|               -0.3261656|               -0.1077877|               -0.2831434|                   -0.5271047|                   -0.5358433|                   -0.5627271|       -0.6029455|       -0.5861778|       -0.3119964|                       -0.4062834|                               -0.4596478|                   -0.5490710|                       -0.6538770|

Saving Resulting Data to Disk
-----------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
dir.create("./tidy_data")
```

    ## Warning in dir.create("./tidy_data"): './tidy_data' already exists

``` r
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
