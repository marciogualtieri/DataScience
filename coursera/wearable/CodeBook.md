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

    ## [1] "fBodyAccJerk-bandsEnergy()-49,56" "fBodyGyro-bandsEnergy()-1,24"    
    ## [3] "tGravityAcc-min()-X"              "fBodyBodyGyroMag-std()"          
    ## [5] "tBodyGyro-mean()-X"               "fBodyGyro-bandsEnergy()-1,24"

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

    ## [1] "fBodyGyro-std()-Y"            "fBodyGyro-bandsEnergy()-1,24"
    ## [3] "tGravityAcc-std()-Z"          "tGravityAcc-arCoeff()-Z,3"   
    ## [5] "tBodyGyro-arCoeff()-Y,3"      "tBodyAccJerkMag-iqr()"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-Y"       "fBodyGyro-mean()-X"     
    ## [3] "tBodyGyroJerk-mean()-X"  "fBodyAcc-mean()-Y"      
    ## [5] "fBodyBodyGyroMag-mean()" "tBodyGyro-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccJerk-std()-X" "tGravityAcc-std()-Z"  "fBodyAccMag-std()"   
    ## [4] "tBodyGyro-std()-Y"    "tBodyAccJerk-std()-Y" "tBodyAcc-std()-Y"

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

    ## [1] "fBodyGyro-meanFreq()-Z"           "tBodyAcc-mean()-Z"               
    ## [3] "fBodyAccJerk-bandsEnergy()-49,56" "fBodyAcc-meanFreq()-Y"           
    ## [5] "tBodyAcc-min()-Y"                 "tBodyAccJerk-energy()-Z"

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
| 1892 |               0.2757271|              -0.0152570|              -0.1111942|                  0.8018585|                  0.3705593|                  0.2626152|                   0.0717722|                   0.0165988|                   0.0131524|      -0.0301646|      -0.0535816|       0.0840963|          -0.0975267|          -0.0403369|          -0.0576203|                      -0.9927039|                         -0.9927039|                          -0.9903429|              -0.9899219|                  -0.9955461|              -0.9931611|              -0.9820452|              -0.9879615|                  -0.9919538|                  -0.9845688|                  -0.9890730|      -0.9932015|      -0.9926172|      -0.9884888|                      -0.9915897|                              -0.9903086|                  -0.9916601|                      -0.9959682|               -0.9950778|               -0.9832044|               -0.9901718|                  -0.9986032|                  -0.9974896|                  -0.9947070|                   -0.9917630|                   -0.9836486|                   -0.9909282|       -0.9936678|       -0.9921923|       -0.9910028|           -0.9946723|           -0.9953942|           -0.9921378|                       -0.9933243|                          -0.9933243|                           -0.9915192|               -0.9888844|                   -0.9954982|               -0.9960815|               -0.9838158|               -0.9917090|                   -0.9922500|                   -0.9836168|                   -0.9913631|       -0.9937471|       -0.9918827|       -0.9928068|                       -0.9948903|                               -0.9920580|                   -0.9886555|                       -0.9947140|           4|         18|
| 1932 |               0.2743763|              -0.0168907|              -0.1053007|                 -0.2601824|                  0.9178761|                  0.3739981|                   0.0753115|                   0.0113104|                   0.0054224|      -0.0279505|      -0.0740670|       0.0870283|          -0.0981716|          -0.0404876|          -0.0511507|                      -0.9978150|                         -0.9978150|                          -0.9949638|              -0.9961890|                  -0.9980461|              -0.9960838|              -0.9930133|              -0.9938744|                  -0.9943919|                  -0.9914151|                  -0.9930392|      -0.9987412|      -0.9953303|      -0.9949176|                      -0.9981504|                              -0.9955301|                  -0.9979350|                      -0.9976326|               -0.9973711|               -0.9956298|               -0.9939643|                  -0.9980876|                  -0.9986734|                  -0.9945277|                   -0.9947039|                   -0.9918355|                   -0.9945111|       -0.9988873|       -0.9937947|       -0.9958887|           -0.9990352|           -0.9971480|           -0.9953183|                       -0.9985685|                          -0.9985685|                           -0.9968200|               -0.9979014|                   -0.9979497|               -0.9980925|               -0.9964909|               -0.9936006|                   -0.9955868|                   -0.9930077|                   -0.9945774|       -0.9988881|       -0.9928489|       -0.9966162|                       -0.9984370|                               -0.9979850|                   -0.9981121|                       -0.9983102|           6|         18|
| 2648 |               0.2702571|              -0.0182132|              -0.1053686|                 -0.3861740|                  0.7357517|                  0.6898431|                   0.0640132|                   0.0129415|                  -0.0004355|      -0.0296872|      -0.0619618|       0.0871063|          -0.0970913|          -0.0339066|          -0.0534032|                      -0.9714230|                         -0.9714230|                          -0.9886459|              -0.9709781|                  -0.9861558|              -0.9798444|              -0.9862497|              -0.9816446|                  -0.9932016|                  -0.9865302|                  -0.9834942|      -0.9815084|      -0.9715335|      -0.9951670|                      -0.9852437|                              -0.9891428|                  -0.9779347|                      -0.9857475|               -0.9671987|               -0.9874462|               -0.9735003|                  -0.9791072|                  -0.9979219|                  -0.9905054|                   -0.9926583|                   -0.9864776|                   -0.9855241|       -0.9875141|       -0.9610387|       -0.9950376|           -0.9797290|           -0.9852100|           -0.9953034|                       -0.9813820|                          -0.9813820|                           -0.9905509|               -0.9779722|                   -0.9861564|               -0.9628278|               -0.9878147|               -0.9700564|                   -0.9926360|                   -0.9873667|                   -0.9860432|       -0.9895095|       -0.9557962|       -0.9953220|                       -0.9808413|                               -0.9911174|                   -0.9817049|                       -0.9873025|           6|         24|
| 103  |               0.3555293|              -0.0237897|              -0.1272397|                  0.9183235|                 -0.3474845|                  0.0236073|                   0.2757447|                  -0.0885226|                  -0.1694126|      -0.0209930|      -0.0796415|       0.0190977|          -0.1993846|           0.1460934|          -0.0835109|                      -0.3030246|                         -0.3030246|                          -0.3207210|              -0.4614872|                  -0.6199654|              -0.3153224|              -0.1535315|              -0.4961610|                  -0.2327781|                  -0.2637843|                  -0.6481087|      -0.5011618|      -0.5774468|      -0.4104261|                      -0.3755721|                              -0.2974502|                  -0.5787798|                      -0.7051929|               -0.4094154|               -0.1683614|               -0.4372344|                  -0.9807337|                  -0.9912987|                  -0.9822280|                   -0.2232972|                   -0.2325921|                   -0.6506125|       -0.5793004|       -0.5497970|       -0.4731550|           -0.5334328|           -0.7081675|           -0.5159222|                       -0.4581262|                          -0.4581262|                           -0.2446018|               -0.6028488|                   -0.6939684|               -0.4508444|               -0.2289237|               -0.4487940|                   -0.2836366|                   -0.2499497|                   -0.6513990|       -0.6045776|       -0.5365985|       -0.5435539|                       -0.5949926|                               -0.1847975|                   -0.6928708|                       -0.7006737|           1|          2|
| 1614 |               0.3358224|              -0.0095293|              -0.0530749|                  0.8854534|                 -0.2624440|                 -0.2877670|                  -0.0381250|                   0.1599384|                  -0.1788761|      -0.0416741|      -0.0001706|       0.2031266|          -0.0893715|           0.4390519|           0.1605642|                      -0.0800887|                         -0.0800887|                          -0.1446492|              -0.2534205|                  -0.2348415|              -0.4240452|              -0.0409881|              -0.0723921|                  -0.3944984|                  -0.1907488|                  -0.1796814|      -0.3372586|      -0.0125314|      -0.1611512|                      -0.2127208|                              -0.1871745|                  -0.2267258|                      -0.1407197|               -0.3280245|                0.0522374|                0.0404487|                  -0.9690425|                  -0.9690265|                  -0.9187311|                   -0.3350701|                   -0.0029232|                   -0.1934503|       -0.5315098|       -0.1797946|       -0.2801640|           -0.2968753|           -0.0994541|           -0.4030987|                       -0.3197830|                          -0.3197830|                           -0.1494884|               -0.2506034|                   -0.0965765|               -0.2936115|                0.0329553|                0.0200770|                   -0.3320481|                    0.1238661|                   -0.2047579|       -0.5949903|       -0.3087653|       -0.3895791|                       -0.4943425|                               -0.1090402|                   -0.4013128|                       -0.1032185|           1|         13|
| 295  |               0.2122305|               0.0029778|              -0.1037001|                  0.8318594|                 -0.4780220|                  0.0201828|                   0.4185016|                  -0.0474404|                  -0.0708036|      -0.4328136|       0.2322152|       0.0613640|          -0.1859807|          -0.1273629|           0.0502006|                      -0.0858396|                         -0.0858396|                          -0.2520428|              -0.2998549|                  -0.5744279|              -0.1310602|               0.1546304|              -0.4565734|                  -0.0990931|                   0.0354097|                  -0.6101748|      -0.5334949|      -0.4504702|      -0.3211117|                      -0.0713166|                              -0.0722540|                  -0.4718795|                      -0.5910727|               -0.1923252|                0.1303412|               -0.3296638|                  -0.9633823|                  -0.9518865|                  -0.9757272|                   -0.1609428|                    0.0036675|                   -0.6618805|       -0.6899130|       -0.4194755|       -0.4078226|           -0.4741120|           -0.6504904|           -0.3414306|                       -0.1923543|                          -0.1923543|                           -0.0779549|               -0.4560089|                   -0.5461280|               -0.2177042|                0.0453034|               -0.3157129|                   -0.3184489|                   -0.1123582|                   -0.7145947|       -0.7428936|       -0.4051625|       -0.4933199|                       -0.3945764|                               -0.0918055|                   -0.5390887|                       -0.5229157|           2|          2|

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
| 1157 |               0.2833200|               0.0194007|              -0.0897652|                  0.9426686|                 -0.2450484|                  0.1064942|                   0.2132334|                   0.2056617|                  -0.0281079|       0.1807898|      -0.2050823|       0.1062349|          -0.1187674|          -0.0197451|           0.0636037|                      -0.2610174|                         -0.2610174|                          -0.4480741|              -0.4238081|                  -0.7085741|              -0.3512780|              -0.3174591|              -0.6177297|                  -0.3924233|                  -0.4811696|                  -0.6946386|      -0.5352837|      -0.6883172|      -0.4837326|                      -0.2413613|                              -0.3970797|                  -0.7016144|                      -0.7877935|               -0.2631831|               -0.1974254|               -0.4934566|                  -0.9509870|                  -0.9246856|                  -0.9464131|                   -0.3507692|                   -0.4544431|                   -0.7146235|       -0.5587459|       -0.6094760|       -0.5015214|           -0.6173015|           -0.8006137|           -0.6347467|                       -0.2331280|                          -0.2331280|                           -0.4194692|               -0.6673013|                   -0.7902208|               -0.2311063|               -0.1897451|               -0.4700164|                   -0.3643405|                   -0.4614172|                   -0.7323583|       -0.5696159|       -0.5704697|       -0.5529536|                       -0.3474343|                               -0.4514465|                   -0.7007075|                       -0.8078746|         18| WALKING\_DOWNSTAIRS |
| 74   |               0.2724571|               0.0137535|              -0.1019263|                  0.9085994|                 -0.3176468|                 -0.0932312|                   0.2711174|                  -0.0840761|                   0.2335401|       0.0491509|      -0.0760612|       0.1623866|          -0.4516634|          -0.0664511|          -0.1545733|                      -0.1196783|                         -0.1196783|                          -0.2263064|              -0.1205875|                  -0.4062330|              -0.2848633|               0.1624760|              -0.2050298|                  -0.2609550|                  -0.0936680|                  -0.3536444|      -0.1341638|      -0.2133651|      -0.2041545|                      -0.2034554|                              -0.0733091|                  -0.2686932|                      -0.3235979|               -0.3726200|                0.2129677|               -0.1858410|                  -0.9789345|                  -0.9730808|                  -0.9704827|                   -0.2183223|                   -0.0461054|                   -0.4212469|       -0.2905642|       -0.2190835|       -0.1365106|           -0.3682986|           -0.3333794|           -0.4334772|                       -0.3421223|                          -0.3421223|                           -0.0906437|               -0.1796884|                   -0.2858702|               -0.4107164|                0.1625911|               -0.2403247|                   -0.2425651|                   -0.0573512|                   -0.4880534|       -0.3404618|       -0.2281642|       -0.1943313|                       -0.5381226|                               -0.1155916|                   -0.2594912|                       -0.2874295|         20| WALKING             |
| 1205 |               0.2455167|               0.0241219|              -0.0011614|                  0.9118383|                 -0.2483935|                 -0.2228190|                   0.0729511|                  -0.0656595|                  -0.1555645|       0.3926800|      -0.4356796|      -0.1866413|          -0.1675027|          -0.0591271|          -0.1308968|                      -0.2356244|                         -0.2356244|                          -0.5327421|              -0.3727063|                  -0.7294285|              -0.3602427|              -0.4102732|              -0.4264016|                  -0.5034924|                  -0.5964500|                  -0.6210568|      -0.6945343|      -0.6876216|      -0.4899929|                      -0.3875121|                              -0.4703605|                  -0.7319474|                      -0.7983443|               -0.2817648|               -0.3317515|               -0.3037404|                  -0.9491343|                  -0.9075016|                  -0.8174212|                   -0.4559322|                   -0.5894043|                   -0.6580487|       -0.7235067|       -0.6786142|       -0.5305595|           -0.7833910|           -0.7703120|           -0.6213326|                       -0.3196320|                          -0.3196320|                           -0.4736027|               -0.6851038|                   -0.8085766|               -0.2529837|               -0.3346126|               -0.2935592|                   -0.4545397|                   -0.6103618|                   -0.6935650|       -0.7339051|       -0.6753683|       -0.5874905|                       -0.3896933|                               -0.4807430|                   -0.7076105|                       -0.8366113|         18| WALKING\_DOWNSTAIRS |
| 1643 |               0.2652587|               0.0109957|              -0.1707752|                  0.9778144|                 -0.0991861|                  0.0845557|                   0.0796690|                  -0.0296162|                   0.0543007|      -0.0029395|      -0.2000105|      -0.0518677|          -0.0920903|          -0.0269210|          -0.0328637|                      -0.9007167|                         -0.9007167|                          -0.9857690|              -0.9104685|                  -0.9883616|              -0.9885092|              -0.9234290|              -0.9151681|                  -0.9886456|                  -0.9800119|                  -0.9791715|      -0.9766093|      -0.9747329|      -0.9531482|                      -0.9236840|                              -0.9842013|                  -0.9592563|                      -0.9893344|               -0.9886899|               -0.8745666|               -0.8384963|                  -0.9765020|                  -0.8889531|                  -0.8244018|                   -0.9888446|                   -0.9798849|                   -0.9841643|       -0.9808116|       -0.9722465|       -0.9489779|           -0.9841426|           -0.9900422|           -0.9842987|                       -0.8580283|                          -0.8580283|                           -0.9849108|               -0.9442782|                   -0.9893658|               -0.9886170|               -0.8612672|               -0.8162966|                   -0.9900863|                   -0.9811529|                   -0.9885004|       -0.9820736|       -0.9708688|       -0.9521034|                       -0.8519017|                               -0.9842014|                   -0.9442006|                       -0.9897408|          9| SITTING             |
| 383  |               0.2845140|              -0.0554762|              -0.1125468|                  0.9662938|                 -0.0743008|                 -0.1349164|                  -0.0180614|                   0.0391211|                   0.0551432|      -0.0470806|      -0.0389433|       0.0556349|          -0.1723299|          -0.0254882|          -0.0705134|                      -0.4090514|                         -0.4090514|                          -0.5030474|              -0.4956371|                  -0.6263217|              -0.5932868|              -0.4093950|              -0.4845545|                  -0.6194920|                  -0.5615018|                  -0.5812577|      -0.6071243|      -0.5775846|      -0.5416477|                      -0.5529707|                              -0.5695952|                  -0.6533381|                      -0.6556644|               -0.5590537|               -0.3045867|               -0.3588131|                  -0.9801355|                  -0.8942365|                  -0.9644412|                   -0.5598353|                   -0.4902074|                   -0.5330923|       -0.6538693|       -0.5577089|       -0.4835924|           -0.6126628|           -0.6207954|           -0.6408575|                       -0.5469780|                          -0.5469780|                           -0.4982239|               -0.6840200|                   -0.6342742|               -0.5460935|               -0.2974313|               -0.3434044|                   -0.5387578|                   -0.4477645|                   -0.4921500|       -0.6697238|       -0.5489165|       -0.5129862|                       -0.6133204|                               -0.4213767|                   -0.7664003|                       -0.6313211|         24| WALKING             |
| 127  |               0.1953458|              -0.0412707|              -0.1754803|                  0.9076962|                 -0.2370999|                 -0.2540101|                   0.0851119|                   0.0606865|                   0.2177732|      -0.0212581|      -0.1248179|       0.1370113|          -0.0603606|           0.0929136|          -0.0253177|                      -0.1634007|                         -0.1634007|                          -0.1596136|              -0.2990996|                  -0.2989710|              -0.3779062|              -0.1319084|              -0.0225323|                  -0.3336806|                  -0.2556376|                  -0.1249090|      -0.4520514|      -0.1734269|      -0.3563305|                      -0.3084129|                              -0.2712177|                  -0.2467233|                      -0.2771728|               -0.3996335|               -0.0962352|                0.0579213|                  -0.9406337|                  -0.9509306|                  -0.8138670|                   -0.2889536|                   -0.1778898|                   -0.2112838|       -0.5535543|       -0.2217038|       -0.3021517|           -0.3696833|           -0.2106975|           -0.5173742|                       -0.3034117|                          -0.3034117|                           -0.2365217|               -0.2565051|                   -0.2699798|               -0.4083390|               -0.1344662|                0.0187357|                   -0.3047462|                   -0.1469496|                   -0.2962734|       -0.5858827|       -0.2586418|       -0.3489750|                       -0.4085465|                               -0.1987543|                   -0.3943981|                       -0.3113059|         13| WALKING             |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName      |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:------------------|
| 5602 |               0.2852804|              -0.0098970|              -0.1046412|                  0.8964886|                 -0.3646426|                 -0.1167405|                   0.0781314|                   0.0136093|                  -0.0075637|      -0.0500015|      -0.0542960|       0.0746544|          -0.0906972|          -0.0469805|          -0.0550059|                      -0.9866824|                         -0.9866824|                          -0.9923538|              -0.9724467|                  -0.9966415|              -0.9959365|              -0.9852584|              -0.9875274|                  -0.9942011|                  -0.9892917|                  -0.9909636|      -0.9818157|      -0.9924162|      -0.9921921|                      -0.9901684|                              -0.9937227|                  -0.9875972|                      -0.9975160|               -0.9972229|               -0.9846478|               -0.9779816|                  -0.9947442|                  -0.9897304|                  -0.9801674|                   -0.9944104|                   -0.9888059|                   -0.9908450|       -0.9779622|       -0.9913013|       -0.9925686|           -0.9941926|           -0.9973472|           -0.9946225|                       -0.9898820|                          -0.9898820|                           -0.9942825|               -0.9747324|                   -0.9975211|               -0.9979322|               -0.9841705|               -0.9735677|                   -0.9951781|                   -0.9889504|                   -0.9890548|       -0.9772126|       -0.9905887|       -0.9932696|                       -0.9902416|                               -0.9937116|                   -0.9717612|                       -0.9973248|         17| STANDING          |
| 1872 |               0.2419469|              -0.0104258|              -0.0981322|                  0.9323867|                 -0.2395303|                 -0.0299851|                   0.3287246|                   0.0264168|                  -0.1701008|       0.3307806|      -0.3351726|      -0.0162259|          -0.0500354|          -0.0832195|           0.0609034|                      -0.2433501|                         -0.2433501|                          -0.6089701|              -0.3194782|                  -0.7100579|              -0.4720433|              -0.2945158|              -0.5482760|                  -0.6427954|                  -0.5402455|                  -0.7523885|      -0.5370558|      -0.6110524|      -0.5223591|                      -0.4570679|                              -0.5745698|                  -0.5465297|                      -0.7694362|               -0.4018257|               -0.1312479|               -0.2519401|                  -0.9716406|                  -0.9628248|                  -0.9422409|                   -0.6150603|                   -0.5099111|                   -0.7733383|       -0.6279684|       -0.3922341|       -0.4710689|           -0.5898653|           -0.8074334|           -0.6647907|                       -0.4495829|                          -0.4495829|                           -0.6131523|               -0.3994404|                   -0.7868504|               -0.3761470|               -0.1091405|               -0.1765622|                   -0.6199329|                   -0.5089029|                   -0.7924406|       -0.6568261|       -0.2939874|       -0.5035068|                       -0.5303886|                               -0.6701432|                   -0.4106451|                       -0.8277476|         25| WALKING\_UPSTAIRS |
| 6852 |               0.2692475|               0.0107031|              -0.1329940|                 -0.2032451|                  0.5270537|                  0.8467546|                   0.0731823|                   0.0021203|                   0.0039450|      -0.0295675|      -0.0651386|       0.0879317|          -0.1051900|          -0.0392410|          -0.0477477|                      -0.9604963|                         -0.9604963|                          -0.9894384|              -0.9918253|                  -0.9952046|              -0.9934018|              -0.9875276|              -0.9883578|                  -0.9916512|                  -0.9883086|                  -0.9857677|      -0.9878850|      -0.9951716|      -0.9926690|                      -0.9897322|                              -0.9902768|                  -0.9908266|                      -0.9952591|               -0.9943083|               -0.9910592|               -0.9895031|                  -0.9923578|                  -0.9418349|                  -0.9573701|                   -0.9916269|                   -0.9882855|                   -0.9868532|       -0.9885035|       -0.9955964|       -0.9934315|           -0.9923332|           -0.9944890|           -0.9961996|                       -0.9894411|                          -0.9894411|                           -0.9912132|               -0.9877566|                   -0.9950910|               -0.9946591|               -0.9928002|               -0.9902588|                   -0.9923321|                   -0.9890841|                   -0.9863203|       -0.9886633|       -0.9958473|       -0.9942295|                       -0.9898596|                               -0.9911097|                   -0.9875341|                       -0.9947553|         17| LAYING            |
| 5390 |               0.2779092|              -0.0193767|              -0.1083079|                  0.9771281|                 -0.0263101|                  0.0448190|                   0.0769255|                   0.0103663|                   0.0049853|      -0.0306331|      -0.0806475|       0.0871290|          -0.0951223|          -0.0433962|          -0.0457661|                      -0.9964644|                         -0.9964644|                          -0.9956644|              -0.9940030|                  -0.9957900|              -0.9982093|              -0.9923239|              -0.9913548|                  -0.9967819|                  -0.9921834|                  -0.9915088|      -0.9930441|      -0.9963261|      -0.9882144|                      -0.9951063|                              -0.9934983|                  -0.9947541|                      -0.9967977|               -0.9985281|               -0.9918536|               -0.9899193|                  -0.9994369|                  -0.9950625|                  -0.9952994|                   -0.9967375|                   -0.9920206|                   -0.9926664|       -0.9949980|       -0.9965140|       -0.9905965|           -0.9932376|           -0.9974376|           -0.9923672|                       -0.9946188|                          -0.9946188|                           -0.9938708|               -0.9946443|                   -0.9972800|               -0.9986619|               -0.9909878|               -0.9888559|                   -0.9969599|                   -0.9923585|                   -0.9923000|       -0.9956006|       -0.9965871|       -0.9923581|                       -0.9941567|                               -0.9930877|                   -0.9953368|                       -0.9979598|         29| STANDING          |
| 5758 |               0.2774500|              -0.0182818|              -0.1099744|                  0.9031822|                 -0.3141973|                 -0.1876924|                   0.0767475|                   0.0108432|                   0.0043230|      -0.0302981|      -0.0676517|       0.0869540|          -0.0976205|          -0.0390782|          -0.0573978|                      -0.9963995|                         -0.9963995|                          -0.9947347|              -0.9941711|                  -0.9972188|              -0.9972747|              -0.9888083|              -0.9932496|                  -0.9972501|                  -0.9871502|                  -0.9946460|      -0.9943060|      -0.9952025|      -0.9927568|                      -0.9962614|                              -0.9982816|                  -0.9954429|                      -0.9979413|               -0.9972340|               -0.9916498|               -0.9915818|                  -0.9982777|                  -0.9975586|                  -0.9956516|                   -0.9967694|                   -0.9879264|                   -0.9960188|       -0.9957999|       -0.9939728|       -0.9929304|           -0.9957335|           -0.9974801|           -0.9952126|                       -0.9963953|                          -0.9963953|                           -0.9988621|               -0.9942139|                   -0.9982205|               -0.9971216|               -0.9928561|               -0.9902338|                   -0.9964423|                   -0.9898926|                   -0.9960107|       -0.9962441|       -0.9931858|       -0.9935164|                       -0.9961933|                               -0.9987408|                   -0.9940940|                       -0.9984625|         21| STANDING          |
| 6600 |               0.2761757|              -0.0154954|              -0.1120245|                 -0.4838982|                  0.9645788|                  0.2216541|                   0.0553487|                   0.0122150|                   0.0021539|      -0.0266885|      -0.0698158|       0.0856078|          -0.0850676|          -0.0387812|          -0.0522265|                      -0.9895352|                         -0.9895352|                          -0.9898250|              -0.9840606|                  -0.9896360|              -0.9875973|              -0.9748827|              -0.9901781|                  -0.9849731|                  -0.9653293|                  -0.9951956|      -0.9828020|      -0.9802688|      -0.9854403|                      -0.9847756|                              -0.9734481|                  -0.9791234|                      -0.9818296|               -0.9885888|               -0.9844314|               -0.9859514|                  -0.9925588|                  -0.9989918|                  -0.9925472|                   -0.9861352|                   -0.9706161|                   -0.9961720|       -0.9877549|       -0.9806666|       -0.9870116|           -0.9876542|           -0.9851322|           -0.9876712|                       -0.9876380|                          -0.9876380|                           -0.9781696|               -0.9823007|                   -0.9825086|               -0.9888988|               -0.9916899|               -0.9835692|                   -0.9889358|                   -0.9811036|                   -0.9956716|       -0.9893316|       -0.9809613|       -0.9886736|                       -0.9907600|                               -0.9851341|                   -0.9883882|                       -0.9842954|          5| LAYING            |

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

|  SubjectID| ActivityName      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|----------:|:------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
|         10| LAYING            |               0.2802306|              -0.0242945|              -0.1171686|                 -0.4530697|                 -0.1392977|                 -0.0311216|                   0.0738151|                   0.0156990|                   0.0071669|      -0.0195559|      -0.0770326|       0.1047205|          -0.1003083|          -0.0388798|          -0.0590745|                      -0.9567818|                         -0.9567818|                          -0.9762344|              -0.9375910|                  -0.9708308|              -0.9691842|              -0.9543418|              -0.9643008|                  -0.9790147|                  -0.9680392|                  -0.9725922|      -0.9537939|      -0.9546700|      -0.9697558|                      -0.9508481|                              -0.9685611|                  -0.9376926|                      -0.9609768|               -0.9682837|               -0.9464543|               -0.9594715|                  -0.9545319|                  -0.9667012|                  -0.9630456|                   -0.9780075|                   -0.9669308|                   -0.9762567|       -0.9617132|       -0.9536602|       -0.9719406|           -0.9659006|           -0.9666210|           -0.9839493|                       -0.9403017|                          -0.9403017|                           -0.9675570|               -0.9274712|                   -0.9596329|               -0.9679680|               -0.9462291|               -0.9598137|                   -0.9789044|                   -0.9681207|                   -0.9785823|       -0.9645446|       -0.9534535|       -0.9752988|                       -0.9443050|                               -0.9653776|                   -0.9337013|                       -0.9607729|
|         23| WALKING           |               0.2732119|              -0.0183619|              -0.1133830|                  0.9398097|                 -0.1617614|                 -0.1607634|                   0.0987319|                   0.0148956|                  -0.0019081|      -0.0631157|      -0.0640198|       0.1077005|          -0.0578128|          -0.0516705|          -0.0903003|                      -0.0988770|                         -0.0988770|                          -0.0670820|              -0.0120968|                   0.0115305|              -0.2754042|              -0.0724367|               0.0814081|                  -0.2904105|                  -0.1554887|                  -0.0572021|      -0.3376192|       0.1955695|      -0.1949704|                      -0.0942606|                              -0.0180706|                   0.1850782|                       0.1466186|               -0.3135218|               -0.1190206|                0.1642207|                  -0.9772309|                  -0.9665507|                  -0.9329813|                   -0.2293281|                   -0.0805017|                   -0.0293115|       -0.4943226|        0.2594572|       -0.2096349|           -0.3639694|            0.2959459|           -0.3744568|                       -0.2099894|                          -0.2099894|                           -0.0268194|                0.1633465|                    0.2501732|               -0.3298073|               -0.2025241|                0.1161434|                   -0.2351730|                   -0.0609753|                   -0.0062365|       -0.5450517|        0.2865815|       -0.2878209|                       -0.4075775|                               -0.0457372|                   -0.0614766|                        0.2878346|
|         26| SITTING           |               0.2582435|              -0.0071336|              -0.0974449|                  0.7829556|                  0.2231056|                  0.3143876|                   0.0764443|                   0.0069224|                  -0.0078024|      -0.0370217|      -0.0840649|       0.0711109|          -0.0959848|          -0.0403070|          -0.0487627|                      -0.9530800|                         -0.9530800|                          -0.9908984|              -0.9540529|                  -0.9944664|              -0.9825795|              -0.9542994|              -0.9675191|                  -0.9920254|                  -0.9858629|                  -0.9879900|      -0.9901449|      -0.9817408|      -0.9704237|                      -0.9524110|                              -0.9894819|                  -0.9764639|                      -0.9939854|               -0.9797690|               -0.9407990|               -0.9500044|                  -0.9650829|                  -0.9492867|                  -0.9445809|                   -0.9922584|                   -0.9862152|                   -0.9900087|       -0.9910277|       -0.9734448|       -0.9664413|           -0.9958825|           -0.9931398|           -0.9919298|                       -0.9336028|                          -0.9336028|                           -0.9899861|               -0.9647420|                   -0.9940332|               -0.9787552|               -0.9377835|               -0.9447813|                   -0.9932999|                   -0.9877546|                   -0.9906931|       -0.9913184|       -0.9694882|       -0.9682667|                       -0.9345877|                               -0.9895213|                   -0.9636507|                       -0.9942098|
|         26| WALKING\_UPSTAIRS |               0.2726914|              -0.0281634|              -0.1219435|                  0.9420953|                 -0.2461697|                 -0.0019931|                   0.0755645|                   0.0020917|                  -0.0117089|      -0.0247951|      -0.0657602|       0.0721459|          -0.0975590|          -0.0386244|          -0.0595558|                      -0.1428745|                         -0.1428745|                          -0.4044639|              -0.3444270|                  -0.6480999|              -0.2428208|              -0.1855283|              -0.4995028|                  -0.3045406|                  -0.4193447|                  -0.6397413|      -0.4276866|      -0.6171125|      -0.3427039|                      -0.1675664|                              -0.2949705|                  -0.5560848|                      -0.6735807|               -0.1690070|               -0.0491726|               -0.4045969|                  -0.9620114|                  -0.9378582|                  -0.9296368|                   -0.2908800|                   -0.3997715|                   -0.6779956|       -0.5502744|       -0.6030971|       -0.3090881|           -0.5158294|           -0.7252103|           -0.5563902|                       -0.1507071|                          -0.1507071|                           -0.3345313|               -0.5140324|                   -0.6618297|               -0.1428438|               -0.0439473|               -0.4009023|                   -0.3420754|                   -0.4200558|                   -0.7157269|       -0.5908123|       -0.5982366|       -0.3620522|                       -0.2742262|                               -0.3937154|                   -0.5696320|                       -0.6698463|
|         10| SITTING           |               0.2706121|              -0.0150427|              -0.1042532|                  0.7918872|                 -0.0412608|                  0.2025346|                   0.0775373|                   0.0089788|                  -0.0049957|      -0.0432432|      -0.0679994|       0.0745959|          -0.0931555|          -0.0411217|          -0.0489412|                      -0.9607572|                         -0.9607572|                          -0.9880542|              -0.9442020|                  -0.9937075|              -0.9849431|              -0.9404502|              -0.9746447|                  -0.9893650|                  -0.9809629|                  -0.9860568|      -0.9864774|      -0.9861792|      -0.9653955|                      -0.9552810|                              -0.9859008|                  -0.9744597|                      -0.9921915|               -0.9829018|               -0.9179795|               -0.9678270|                  -0.9731284|                  -0.9356900|                  -0.9668985|                   -0.9889464|                   -0.9807568|                   -0.9882558|       -0.9888731|       -0.9843733|       -0.9604460|           -0.9923267|           -0.9925845|           -0.9902598|                       -0.9396696|                          -0.9396696|                           -0.9852099|               -0.9630646|                   -0.9916962|               -0.9822424|               -0.9128381|               -0.9661210|                   -0.9895509|                   -0.9820456|                   -0.9891109|       -0.9897124|       -0.9835796|       -0.9624186|                       -0.9415120|                               -0.9832667|                   -0.9624600|                       -0.9914091|
|         16| WALKING           |               0.2760236|              -0.0204287|              -0.1088040|                  0.9259813|                 -0.0668246|                 -0.2173512|                   0.0770224|                   0.0096844|                   0.0036080|      -0.0151722|      -0.0695956|       0.0818651|          -0.1109173|          -0.0433877|          -0.0532987|                      -0.2587667|                         -0.2587667|                          -0.3631445|              -0.4859319|                  -0.6715418|              -0.3947904|              -0.3215007|              -0.2443630|                  -0.4414062|                  -0.4542708|                  -0.4223324|      -0.5957465|      -0.6197319|      -0.4328853|                      -0.4104632|                              -0.3782785|                  -0.6692285|                      -0.7206823|               -0.4046925|               -0.3145698|               -0.1597998|                  -0.9824696|                  -0.9737848|                  -0.9613873|                   -0.3962237|                   -0.4255639|                   -0.4402582|       -0.6541718|       -0.6125936|       -0.3654895|           -0.6758897|           -0.7122378|           -0.5712648|                       -0.4718093|                          -0.4718093|                           -0.4033866|               -0.6650784|                   -0.7228084|               -0.4090705|               -0.3543707|               -0.1805013|                   -0.4028841|                   -0.4336127|                   -0.4566363|       -0.6737411|       -0.6119409|       -0.4032198|                       -0.5921510|                               -0.4414478|                   -0.7211370|                       -0.7457269|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE)
```
