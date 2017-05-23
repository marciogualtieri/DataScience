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

    ## [1] "fBodyAccJerk-bandsEnergy()-33,48" "tBodyGyroJerk-mad()-Y"           
    ## [3] "tBodyAccJerk-arCoeff()-Y,3"       "fBodyAccJerk-mean()-X"           
    ## [5] "tBodyGyroJerkMag-max()"           "fBodyAcc-mean()-X"

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

    ## [1] "tBodyGyroMag-entropy()"   "fBodyAcc-std()-Y"        
    ## [3] "tBodyGyro-energy()-Y"     "tGravityAcc-min()-Y"     
    ## [5] "tBodyGyroJerk-max()-Y"    "tBodyGyroJerk-energy()-Z"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAccJerk-mean()-X"   "tBodyAccMag-mean()"     
    ## [3] "tBodyAccJerk-mean()-Z"   "tGravityAcc-mean()-Z"   
    ## [5] "tBodyGyroJerk-mean()-Z"  "tBodyGyroJerkMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "tGravityAcc-std()-X"        "fBodyBodyGyroJerkMag-std()"
    ## [3] "fBodyBodyGyroMag-std()"     "tBodyGyroJerk-std()-Z"     
    ## [5] "tBodyAcc-std()-Y"           "fBodyAccJerk-std()-Z"

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

    ## [1] "fBodyAccJerk-bandsEnergy()-33,40" "fBodyAccJerk-bandsEnergy()-49,56"
    ## [3] "angle(tBodyAccMean,gravity)"      "fBodyBodyGyroJerkMag-min()"      
    ## [5] "tBodyGyro-max()-Y"                "fBodyAcc-sma()"

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
| 2603 |               0.2688368|              -0.0146530|              -0.1003211|                  0.9105530|                  0.2351088|                  0.1457010|                   0.0683783|                   0.0233071|                   0.0349784|      -0.0292886|      -0.0829629|       0.1100284|          -0.0980147|          -0.0275566|          -0.0783937|                      -0.9496435|                         -0.9496435|                          -0.9579714|              -0.9399270|                  -0.9698179|              -0.9661261|              -0.9241861|              -0.9288950|                  -0.9595098|                  -0.9351452|                  -0.9568914|      -0.9621705|      -0.9324715|      -0.9383740|                      -0.9321318|                              -0.9441081|                  -0.9438951|                      -0.9695778|               -0.9746928|               -0.9257415|               -0.9085159|                  -0.9945775|                  -0.9939868|                  -0.9808409|                   -0.9618675|                   -0.9337696|                   -0.9647985|       -0.9697483|       -0.9214577|       -0.9439120|           -0.9701970|           -0.9661066|           -0.9643997|                       -0.9277473|                          -0.9277473|                           -0.9462044|               -0.9252942|                   -0.9646600|               -0.9790010|               -0.9302480|               -0.9038808|                   -0.9683875|                   -0.9367953|                   -0.9720853|       -0.9720833|       -0.9157499|       -0.9508643|                       -0.9353372|                               -0.9472893|                   -0.9261119|                       -0.9607464|           4|         24|
| 2736 |               0.1876800|               0.0255053|              -0.1117447|                  0.9029709|                 -0.2226780|                 -0.2466555|                   0.1910728|                  -0.0411965|                   0.2441430|       0.2617113|      -0.1585421|      -0.0957827|          -0.0321868|          -0.1972742|           0.2245327|                      -0.2740086|                         -0.2740086|                          -0.5668000|              -0.4255379|                  -0.7232872|              -0.5116093|              -0.3552164|              -0.3945847|                  -0.6496696|                  -0.5501344|                  -0.6169388|      -0.5884131|      -0.6493471|      -0.4531502|                      -0.4466766|                              -0.5801921|                  -0.6778342|                      -0.7642702|               -0.3839410|               -0.2128394|               -0.3245261|                  -0.9791673|                  -0.9540641|                  -0.9602080|                   -0.5970553|                   -0.5379702|                   -0.6561488|       -0.6730891|       -0.6558681|       -0.3245198|           -0.6532373|           -0.7637742|           -0.7343006|                       -0.4218802|                          -0.4218802|                           -0.5979764|               -0.6117500|                   -0.7728080|               -0.3401655|               -0.1949492|               -0.3389808|                   -0.5795350|                   -0.5562809|                   -0.6940932|       -0.6999300|       -0.6623237|       -0.3490097|                       -0.4977128|                               -0.6239181|                   -0.6346351|                       -0.8006282|           2|         24|
| 1587 |               0.1582671|              -0.1126279|               0.0408376|                 -0.0622987|                  0.5154415|                  0.7975496|                   0.2886267|                  -0.0428740|                  -0.2944970|       0.1539593|      -0.5263900|       0.4634327|          -0.0516055|          -0.0656887|          -0.1222177|                      -0.6440554|                         -0.6440554|                          -0.9548256|              -0.6605454|                  -0.9568159|              -0.7142035|              -0.8670456|              -0.6425591|                  -0.9515953|                  -0.9366882|                  -0.9502262|      -0.8980882|      -0.9235650|      -0.8972157|                      -0.5461026|                              -0.9395258|                  -0.9019739|                      -0.9384373|               -0.6883408|               -0.7635630|               -0.5095982|                  -0.3647062|                  -0.7882720|                  -0.3452428|                   -0.9555134|                   -0.9366154|                   -0.9528351|       -0.9241332|       -0.9235321|       -0.8858915|           -0.9349548|           -0.9471394|           -0.9691612|                       -0.4577876|                          -0.4577876|                           -0.9284415|               -0.8597456|                   -0.9340762|               -0.6784772|               -0.7367488|               -0.4815844|                   -0.9647655|                   -0.9410808|                   -0.9536922|       -0.9324156|       -0.9239567|       -0.8925821|                       -0.4975682|                               -0.9142661|                   -0.8581326|                       -0.9327038|           6|         13|
| 2873 |               0.2820648|              -0.0012130|              -0.1078898|                  0.9596862|                 -0.1326659|                 -0.1501880|                   0.2547660|                   0.0662130|                   0.0310573|      -0.0093886|      -0.1014514|       0.1099991|          -0.2000746|           0.0929295|          -0.0256730|                      -0.2735564|                         -0.2735564|                          -0.4122540|              -0.4216810|                  -0.4807685|              -0.4347026|              -0.1895151|              -0.4122941|                  -0.5108580|                  -0.3247845|                  -0.5510592|      -0.4391518|      -0.4390319|      -0.4037402|                      -0.4830140|                              -0.4426080|                  -0.5159618|                      -0.5261029|               -0.4140209|               -0.1585365|               -0.3387988|                  -0.9600262|                  -0.9806201|                  -0.9783730|                   -0.4586455|                   -0.3128709|                   -0.5799941|       -0.5808597|       -0.4753598|       -0.4550147|           -0.4044726|           -0.5020573|           -0.5464609|                       -0.4946637|                          -0.4946637|                           -0.4535916|               -0.5860986|                   -0.5267735|               -0.4059446|               -0.1951992|               -0.3503762|                   -0.4524889|                   -0.3478536|                   -0.6063748|       -0.6261679|       -0.5028278|       -0.5226828|                       -0.5792887|                               -0.4662289|                   -0.7259471|                       -0.5612112|           1|         24|
| 1086 |               0.2784112|              -0.0146255|              -0.1070860|                  0.6834326|                 -0.5696506|                  0.3254866|                   0.0768231|                   0.0146900|                  -0.0016981|      -0.0267769|      -0.0737226|       0.0825875|          -0.0987887|          -0.0415748|          -0.0537710|                      -0.9954116|                         -0.9954116|                          -0.9940412|              -0.9974946|                  -0.9984785|              -0.9943623|              -0.9910523|              -0.9902056|                  -0.9933801|                  -0.9943516|                  -0.9868395|      -0.9976998|      -0.9980899|      -0.9947316|                      -0.9926287|                              -0.9899312|                  -0.9983416|                      -0.9987304|               -0.9950571|               -0.9916115|               -0.9910653|                  -0.9973246|                  -0.9972418|                  -0.9994093|                   -0.9936417|                   -0.9943324|                   -0.9887261|       -0.9984950|       -0.9985573|       -0.9930645|           -0.9972812|           -0.9978836|           -0.9973088|                       -0.9942980|                          -0.9942980|                           -0.9893292|               -0.9975958|                   -0.9985142|               -0.9953060|               -0.9913383|               -0.9914891|                   -0.9945471|                   -0.9947019|                   -0.9891417|       -0.9987610|       -0.9988768|       -0.9929531|                       -0.9957558|                               -0.9868976|                   -0.9972412|                       -0.9978849|           4|         10|
| 2309 |               0.2779802|              -0.0172211|              -0.1076112|                 -0.5144648|                  0.8219175|                  0.5950942|                   0.0772284|                   0.0055129|                   0.0006554|      -0.0365653|      -0.0803387|       0.0819583|          -0.0962498|          -0.0326165|          -0.0496370|                      -0.9939466|                         -0.9939466|                          -0.9923449|              -0.9899136|                  -0.9965010|              -0.9919669|              -0.9875293|              -0.9946212|                  -0.9938885|                  -0.9850324|                  -0.9926534|      -0.9952715|      -0.9900155|      -0.9943610|                      -0.9949306|                              -0.9933492|                  -0.9940415|                      -0.9966488|               -0.9907182|               -0.9915436|               -0.9936430|                  -0.9867785|                  -0.9979936|                  -0.9950780|                   -0.9938313|                   -0.9849871|                   -0.9930524|       -0.9963446|       -0.9898351|       -0.9961004|           -0.9966517|           -0.9954799|           -0.9953638|                       -0.9957064|                          -0.9957064|                           -0.9934531|               -0.9919340|                   -0.9969286|               -0.9900240|               -0.9936437|               -0.9925699|                   -0.9942985|                   -0.9859943|                   -0.9918291|       -0.9966395|       -0.9896945|       -0.9972372|                       -0.9961574|                               -0.9921852|                   -0.9916194|                       -0.9971674|           6|         20|

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
| 1407 |               0.2752821|               0.1266792|               0.0788793|                  0.9675016|                 -0.0528092|                  0.0153903|                   0.1459016|                  -0.2850272|                  -0.4798045|      -0.3788234|      -0.2822398|      -0.3679626|          -0.2490047|          -0.0578874|          -0.0006007|                      -0.5480427|                         -0.5480427|                          -0.8829035|              -0.5274652|                  -0.9050702|              -0.8861880|              -0.5178117|              -0.3761672|                  -0.9028471|                  -0.7479855|                  -0.8593980|      -0.6451179|      -0.8885935|      -0.6811341|                      -0.3926251|                              -0.8013120|                  -0.6694478|                      -0.8041919|               -0.9088667|               -0.4206935|               -0.1470817|                  -0.9314645|                  -0.6731040|                  -0.3112047|                   -0.9033765|                   -0.7775857|                   -0.8809491|       -0.7505851|       -0.8752769|       -0.5795567|           -0.7409466|           -0.9420323|           -0.8591560|                       -0.2435014|                          -0.2435014|                           -0.7886687|               -0.5157071|                   -0.8082625|               -0.9194959|               -0.4103290|               -0.1006088|                   -0.9128506|                   -0.8394582|                   -0.9026748|       -0.7850967|       -0.8684509|       -0.5894502|                       -0.2888682|                               -0.7731451|                   -0.5078660|                       -0.8271375|          4| SITTING             |
| 1075 |               0.4013010|              -0.0443396|              -0.0969099|                  0.9178314|                 -0.2400846|                 -0.1910633|                   0.1208819|                   0.1899088|                   0.1442779|       0.3864913|      -0.3667561|      -0.1006714|          -0.1356049|          -0.1043326|           0.1631717|                      -0.1951872|                         -0.1951872|                          -0.3445659|              -0.3674280|                  -0.6547619|              -0.2020174|              -0.1680903|              -0.4109820|                  -0.2899016|                  -0.3023737|                  -0.5440062|      -0.5962231|      -0.5738689|      -0.4454844|                      -0.0522090|                              -0.1872021|                  -0.5795192|                      -0.7010673|               -0.1872975|               -0.1870710|               -0.3573853|                  -0.9787209|                  -0.9631899|                  -0.9553433|                   -0.2422221|                   -0.3058287|                   -0.6105283|       -0.6640317|       -0.6011104|       -0.5079613|           -0.6923957|           -0.6705415|           -0.6286160|                       -0.1171447|                          -0.1171447|                           -0.2574147|               -0.5226555|                   -0.7223299|               -0.1815138|               -0.2487575|               -0.3781230|                   -0.2590653|                   -0.3609300|                   -0.6801833|       -0.6857779|       -0.6217238|       -0.5751831|                       -0.2931892|                               -0.3632836|                   -0.5657542|                       -0.7737427|         18| WALKING\_DOWNSTAIRS |
| 787  |               0.2829297|              -0.0494816|              -0.0901386|                  0.9171210|                  0.1562111|                  0.0135992|                   0.2689123|                  -0.0949959|                  -0.1459791|      -0.0867772|      -0.1688901|       0.0648453|           0.1235419|           0.1544538|          -0.3006588|                      -0.0113780|                         -0.0113780|                          -0.2748789|              -0.1061231|                  -0.5499864|              -0.2231044|              -0.0542794|              -0.0942055|                  -0.2767862|                  -0.2461915|                  -0.4056253|      -0.2939461|      -0.3609507|      -0.4125598|                      -0.1549884|                              -0.2077868|                  -0.4048852|                      -0.5939069|               -0.2242268|                0.0374263|                0.1707216|                  -0.9745254|                  -0.9441945|                  -0.8617970|                   -0.2714148|                   -0.1461601|                   -0.4932194|       -0.4116714|       -0.0159189|       -0.4996051|           -0.3469360|           -0.6500724|           -0.5290727|                       -0.1522390|                          -0.1522390|                           -0.2259163|               -0.2983223|                   -0.5885442|               -0.2246065|                0.0183337|                0.2131544|                   -0.3321081|                   -0.0943543|                   -0.5856701|       -0.4495010|        0.1397815|       -0.5774116|                       -0.2823280|                               -0.2516048|                   -0.3476094|                       -0.6084391|         10| WALKING\_UPSTAIRS   |
| 2736 |               0.2858806|              -0.0207566|              -0.1064331|                 -0.2114231|                  0.5307329|                  0.8465909|                   0.0715892|                   0.0164028|                   0.0087787|      -0.0389316|      -0.0570357|       0.0633104|          -0.0973989|          -0.0418681|          -0.0489552|                      -0.9755624|                         -0.9755624|                          -0.9692750|              -0.9682102|                  -0.9790933|              -0.9692677|              -0.9681242|              -0.9653937|                  -0.9662006|                  -0.9721894|                  -0.9662231|      -0.9822320|      -0.9574988|      -0.9801302|                      -0.9609685|                              -0.9625034|                  -0.9606124|                      -0.9676625|               -0.9749455|               -0.9699973|               -0.9694676|                  -0.9815876|                  -0.9902011|                  -0.9932050|                   -0.9636655|                   -0.9723130|                   -0.9699335|       -0.9832020|       -0.9589001|       -0.9846158|           -0.9887560|           -0.9685033|           -0.9803864|                       -0.9686285|                          -0.9686285|                           -0.9628424|               -0.9592431|                   -0.9668342|               -0.9775369|               -0.9718630|               -0.9739377|                   -0.9640751|                   -0.9744633|                   -0.9721268|       -0.9835084|       -0.9599998|       -0.9878040|                       -0.9781989|                               -0.9618463|                   -0.9651353|                       -0.9676477|         18| LAYING              |
| 2171 |               0.2711783|              -0.0306683|              -0.1058844|                  0.9619251|                 -0.2237274|                  0.0083669|                   0.0736825|                  -0.0006388|                  -0.0158855|      -0.0310419|      -0.0793678|       0.0870504|          -0.0947153|          -0.0399774|          -0.0596975|                      -0.9823383|                         -0.9823383|                          -0.9931884|              -0.9879874|                  -0.9955247|              -0.9959812|              -0.9797896|              -0.9866532|                  -0.9955675|                  -0.9883007|                  -0.9882110|      -0.9857805|      -0.9953865|      -0.9875813|                      -0.9883092|                              -0.9913446|                  -0.9900970|                      -0.9965594|               -0.9964796|               -0.9743335|               -0.9865829|                  -0.9946539|                  -0.9718188|                  -0.9904531|                   -0.9959826|                   -0.9883730|                   -0.9899212|       -0.9849483|       -0.9942891|       -0.9888632|           -0.9923706|           -0.9971861|           -0.9925171|                       -0.9855515|                          -0.9855515|                           -0.9913717|               -0.9862148|                   -0.9968267|               -0.9966517|               -0.9721777|               -0.9866945|                   -0.9969052|                   -0.9892970|                   -0.9901560|       -0.9847770|       -0.9935724|       -0.9902509|                       -0.9849911|                               -0.9899143|                   -0.9857694|                       -0.9971074|         12| STANDING            |
| 173  |               0.3428095|              -0.0222710|              -0.0879301|                  0.9403752|                 -0.2464863|                  0.0993903|                   0.1103753|                  -0.2616432|                  -0.1609170|      -0.0235167|      -0.0754340|       0.1051099|          -0.1093897|          -0.0215704|          -0.0825145|                      -0.2985853|                         -0.2985853|                          -0.3871931|              -0.4981021|                  -0.6331120|              -0.4027800|              -0.1662246|              -0.5277494|                  -0.4321877|                  -0.3055413|                  -0.6315583|      -0.5643508|      -0.6121594|      -0.5465867|                      -0.4762157|                              -0.4191004|                  -0.6627493|                      -0.7238632|               -0.4019395|               -0.1637563|               -0.5110347|                  -0.9816084|                  -0.9834161|                  -0.9728043|                   -0.4080064|                   -0.2592407|                   -0.6726264|       -0.6763600|       -0.4950134|       -0.5543511|           -0.5047455|           -0.7166482|           -0.6827818|                       -0.5214933|                          -0.5214933|                           -0.4642913|               -0.6379611|                   -0.7407376|               -0.4015140|               -0.2150743|               -0.5402167|                   -0.4349448|                   -0.2573196|                   -0.7129219|       -0.7122281|       -0.4380127|       -0.5975474|                       -0.6229660|                               -0.5311729|                   -0.6827213|                       -0.7840877|         18| WALKING             |

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
| 4699 |               0.2790315|              -0.0061922|              -0.1231245|                  0.9571328|                  0.0010310|                  0.1626766|                   0.0731618|                  -0.0040108|                   0.0563055|      -0.0408256|      -0.0277722|       0.1007190|          -0.0992186|          -0.0244289|          -0.0403951|                      -0.9497598|                         -0.9497598|                          -0.9793163|              -0.9617449|                  -0.9813425|              -0.9888486|              -0.9432913|              -0.9278651|                  -0.9853579|                  -0.9619660|                  -0.9748200|      -0.9752804|      -0.9670888|      -0.9572642|                      -0.9468274|                              -0.9724976|                  -0.9677170|                      -0.9727539|               -0.9920933|               -0.9243583|               -0.9007172|                  -0.9908587|                  -0.9506936|                  -0.9110406|                   -0.9860488|                   -0.9632818|                   -0.9774303|       -0.9807903|       -0.9700826|       -0.9595319|           -0.9768418|           -0.9777315|           -0.9765446|                       -0.9219459|                          -0.9219459|                           -0.9711656|               -0.9657929|                   -0.9734467|               -0.9938199|               -0.9193609|               -0.8935476|                   -0.9881976|                   -0.9677262|                   -0.9784817|       -0.9824784|       -0.9722418|       -0.9638629|                       -0.9211216|                               -0.9675052|                   -0.9701248|                       -0.9759026|          5| STANDING     |
| 3460 |               0.2864774|              -0.0209134|              -0.1265602|                  0.8888844|                  0.2268815|                  0.2360090|                   0.0785584|                   0.0002347|                  -0.0103838|      -0.0269321|      -0.0875226|       0.0913963|          -0.0994938|          -0.0408847|          -0.0553072|                      -0.9670115|                         -0.9670115|                          -0.9769520|              -0.9657103|                  -0.9837234|              -0.9829207|              -0.9416735|              -0.9662197|                  -0.9841784|                  -0.9629765|                  -0.9780190|      -0.9821690|      -0.9687599|      -0.9481529|                      -0.9573486|                              -0.9758339|                  -0.9701475|                      -0.9824796|               -0.9844251|               -0.9290557|               -0.9586174|                  -0.9967972|                  -0.9919406|                  -0.9856496|                   -0.9844025|                   -0.9589460|                   -0.9813210|       -0.9860768|       -0.9618105|       -0.9464914|           -0.9849495|           -0.9846472|           -0.9705206|                       -0.9446526|                          -0.9446526|                           -0.9758360|               -0.9576480|                   -0.9820239|               -0.9849586|               -0.9263718|               -0.9565811|                   -0.9860833|                   -0.9570271|                   -0.9832721|       -0.9872555|       -0.9581602|       -0.9506464|                       -0.9455200|                               -0.9743211|                   -0.9569157|                       -0.9822435|         19| SITTING      |
| 1179 |               0.3141566|              -0.0309760|              -0.0754378|                  0.9643415|                 -0.1583969|                  0.0136535|                  -0.2074954|                   0.1189505|                  -0.0832559|      -0.0236357|      -0.0937752|       0.0586738|           0.0108355|          -0.6117237|          -0.3419218|                      -0.1417599|                         -0.1417599|                          -0.2773846|               0.0907412|                  -0.3600572|              -0.2234475|              -0.1267857|              -0.3288072|                  -0.2340803|                  -0.2257457|                  -0.5008848|      -0.2178087|       0.0271424|      -0.1347075|                      -0.1887932|                              -0.2179482|                  -0.2378448|                      -0.5401894|               -0.2648545|               -0.0975784|               -0.0974618|                  -0.9695311|                  -0.9775973|                  -0.9486927|                   -0.2352230|                   -0.2037218|                   -0.5380766|       -0.2348204|        0.0925350|       -0.0910101|           -0.2976321|           -0.4382576|           -0.4344594|                       -0.2250807|                          -0.2250807|                           -0.2529720|               -0.1297197|                   -0.5540104|               -0.2817054|               -0.1390485|               -0.0529469|                   -0.3066378|                   -0.2339745|                   -0.5727157|       -0.2480299|        0.1235085|       -0.1601488|                       -0.3665523|                               -0.3053872|                   -0.2057455|                       -0.6016226|         30| WALKING      |
| 4915 |               0.2836352|              -0.0031854|              -0.1115261|                  0.9396574|                 -0.2564574|                  0.1185745|                   0.0780489|                   0.0048395|                  -0.0090929|      -0.0241756|      -0.0843120|       0.0773864|          -0.1109567|          -0.0401244|          -0.0590413|                      -0.9486061|                         -0.9486061|                          -0.9762322|              -0.9542612|                  -0.9791864|              -0.9889947|              -0.9209426|              -0.9582644|                  -0.9872286|                  -0.9520116|                  -0.9769924|      -0.9425994|      -0.9803895|      -0.9589632|                      -0.9588836|                              -0.9713261|                  -0.9641480|                      -0.9823840|               -0.9915577|               -0.9089732|               -0.9394656|                  -0.9968241|                  -0.9714336|                  -0.9777901|                   -0.9872886|                   -0.9531497|                   -0.9805518|       -0.9476648|       -0.9770724|       -0.9635880|           -0.9653833|           -0.9878198|           -0.9723550|                       -0.9588844|                          -0.9588844|                           -0.9723168|               -0.9536978|                   -0.9818364|               -0.9928058|               -0.9077367|               -0.9334734|                   -0.9884979|                   -0.9580781|                   -0.9828003|       -0.9494216|       -0.9752344|       -0.9684759|                       -0.9641393|                               -0.9723268|                   -0.9546189|                       -0.9819512|         19| STANDING     |
| 579  |               0.3285896|              -0.0233033|              -0.0818356|                  0.9129452|                 -0.3227620|                 -0.1243090|                  -0.1776736|                  -0.2437936|                  -0.3132609|      -0.0884036|      -0.0190290|       0.1644377|          -0.1846258|          -0.2366686|           0.0084187|                      -0.1068829|                         -0.1068829|                          -0.0698647|              -0.1568324|                  -0.2011025|              -0.1648630|               0.1729400|              -0.3029619|                  -0.1408716|                   0.0519641|                  -0.4598053|      -0.3173776|      -0.0072923|      -0.1806619|                      -0.0128099|                               0.0787171|                  -0.0658385|                      -0.1627377|               -0.2693532|                0.2670636|               -0.2443148|                  -0.9866964|                  -0.9809160|                  -0.9665473|                   -0.0695199|                    0.2611025|                   -0.4338619|       -0.4448301|       -0.0216590|       -0.3226729|           -0.0879637|           -0.1711732|           -0.3238836|                       -0.0983470|                          -0.0983470|                            0.0803859|               -0.0880327|                   -0.1567409|               -0.3148308|                0.2349313|               -0.2712846|                   -0.0772137|                    0.3960847|                   -0.4102151|       -0.4854176|       -0.0375898|       -0.4383216|                       -0.2906362|                                0.0813791|                   -0.2662746|                       -0.2081949|          1| WALKING      |
| 5468 |               0.2837098|              -0.0196560|              -0.1074244|                  0.9486032|                  0.0646937|                 -0.1611333|                   0.0725924|                   0.0206865|                  -0.0150404|      -0.0275032|      -0.0740045|       0.0804292|          -0.0963779|          -0.0391688|          -0.0571139|                      -0.9863064|                         -0.9863064|                          -0.9905453|              -0.9867906|                  -0.9957098|              -0.9951420|              -0.9863522|              -0.9753807|                  -0.9939923|                  -0.9922148|                  -0.9836601|      -0.9906853|      -0.9901499|      -0.9903878|                      -0.9859768|                              -0.9904870|                  -0.9914921|                      -0.9965460|               -0.9959562|               -0.9848638|               -0.9702117|                  -0.9935440|                  -0.9903838|                  -0.9838486|                   -0.9936587|                   -0.9919651|                   -0.9858433|       -0.9884999|       -0.9850128|       -0.9922785|           -0.9954316|           -0.9956585|           -0.9929245|                       -0.9860212|                          -0.9860212|                           -0.9914037|               -0.9874551|                   -0.9967885|               -0.9962970|               -0.9839154|               -0.9685687|                   -0.9937953|                   -0.9921904|                   -0.9865522|       -0.9879777|       -0.9823845|       -0.9936910|                       -0.9871679|                               -0.9914665|                   -0.9867351|                       -0.9970156|         16| STANDING     |

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

|  SubjectID| ActivityName |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|----------:|:-------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
|          8| SITTING      |               0.2674915|              -0.0067255|              -0.1044610|                  0.8324539|                  0.2400951|                  0.2638952|                   0.0786714|                  -0.0065752|                  -0.0106809|      -0.0547397|      -0.0955089|       0.0716049|          -0.0923150|          -0.0402674|          -0.0445732|                      -0.9521397|                         -0.9521397|                          -0.9860615|              -0.9326822|                  -0.9918074|              -0.9811429|              -0.9442197|              -0.9594363|                  -0.9849773|                  -0.9802211|                  -0.9829953|      -0.9822003|      -0.9765899|      -0.9617987|                      -0.9479818|                              -0.9809323|                  -0.9658068|                      -0.9877306|               -0.9790262|               -0.9273320|               -0.9395530|                  -0.9667580|                  -0.9374623|                  -0.9354753|                   -0.9851888|                   -0.9807846|                   -0.9852858|       -0.9845241|       -0.9715007|       -0.9596235|           -0.9932646|           -0.9888763|           -0.9852414|                       -0.9299436|                          -0.9299436|                           -0.9806674|               -0.9530016|                   -0.9867567|               -0.9782567|               -0.9238300|               -0.9338898|                   -0.9869136|                   -0.9830388|                   -0.9861853|       -0.9853393|       -0.9689244|       -0.9626323|                       -0.9317212|                               -0.9793202|                   -0.9532512|                       -0.9861473|
|         16| WALKING      |               0.2760236|              -0.0204287|              -0.1088040|                  0.9259813|                 -0.0668246|                 -0.2173512|                   0.0770224|                   0.0096844|                   0.0036080|      -0.0151722|      -0.0695956|       0.0818651|          -0.1109173|          -0.0433877|          -0.0532987|                      -0.2587667|                         -0.2587667|                          -0.3631445|              -0.4859319|                  -0.6715418|              -0.3947904|              -0.3215007|              -0.2443630|                  -0.4414062|                  -0.4542708|                  -0.4223324|      -0.5957465|      -0.6197319|      -0.4328853|                      -0.4104632|                              -0.3782785|                  -0.6692285|                      -0.7206823|               -0.4046925|               -0.3145698|               -0.1597998|                  -0.9824696|                  -0.9737848|                  -0.9613873|                   -0.3962237|                   -0.4255639|                   -0.4402582|       -0.6541718|       -0.6125936|       -0.3654895|           -0.6758897|           -0.7122378|           -0.5712648|                       -0.4718093|                          -0.4718093|                           -0.4033866|               -0.6650784|                   -0.7228084|               -0.4090705|               -0.3543707|               -0.1805013|                   -0.4028841|                   -0.4336127|                   -0.4566363|       -0.6737411|       -0.6119409|       -0.4032198|                       -0.5921510|                               -0.4414478|                   -0.7211370|                       -0.7457269|
|         18| STANDING     |               0.2784588|              -0.0166354|              -0.1084534|                  0.9475732|                 -0.2042063|                 -0.0485767|                   0.0753539|                   0.0104699|                  -0.0018164|      -0.0265873|      -0.0732260|       0.0843191|          -0.0987174|          -0.0406573|          -0.0532384|                      -0.9726075|                         -0.9726075|                          -0.9859653|              -0.9630068|                  -0.9886860|              -0.9904099|              -0.9612391|              -0.9757728|                  -0.9895450|                  -0.9752437|                  -0.9862657|      -0.9644289|      -0.9835612|      -0.9742944|                      -0.9767976|                              -0.9849871|                  -0.9723526|                      -0.9889607|               -0.9920198|               -0.9542234|               -0.9618739|                  -0.9942701|                  -0.9813359|                  -0.9760443|                   -0.9894367|                   -0.9752778|                   -0.9884552|       -0.9622542|       -0.9804171|       -0.9728204|           -0.9819710|           -0.9911520|           -0.9862590|                       -0.9722855|                          -0.9722855|                           -0.9860153|               -0.9597971|                   -0.9885197|               -0.9927891|               -0.9529120|               -0.9572162|                   -0.9902879|                   -0.9771790|                   -0.9892758|       -0.9622727|       -0.9788018|       -0.9748226|                       -0.9732649|                               -0.9862774|                   -0.9591135|                       -0.9884075|
|         17| WALKING      |               0.2723419|              -0.0184875|              -0.1097921|                  0.9281124|                 -0.1799274|                 -0.1902659|                   0.0773189|                   0.0130099|                   0.0243753|      -0.0092227|      -0.0839773|       0.0757133|          -0.1099592|          -0.0379251|          -0.0513807|                      -0.1511515|                         -0.1511515|                          -0.3010933|              -0.3350098|                  -0.5171674|              -0.3609917|              -0.0650268|              -0.3828328|                  -0.4234461|                  -0.1942327|                  -0.5234271|      -0.4077167|      -0.4901663|      -0.3988092|                      -0.4293800|                              -0.3359389|                  -0.5186181|                      -0.5827119|               -0.3195002|               -0.0175798|               -0.2658245|                  -0.9809834|                  -0.9686132|                  -0.9569032|                   -0.3554926|                   -0.0935385|                   -0.5343033|       -0.4798135|       -0.4549329|       -0.3860444|           -0.4312961|           -0.5602035|           -0.5244229|                       -0.4618379|                          -0.4618379|                           -0.2756728|               -0.5224948|                   -0.5397085|               -0.3048063|               -0.0556138|               -0.2623916|                   -0.3438661|                   -0.0470379|                   -0.5438730|       -0.5048493|       -0.4392388|       -0.4387687|                       -0.5651625|                               -0.2112319|                   -0.6153201|                       -0.5203855|
|         22| LAYING       |               0.2799597|              -0.0142630|              -0.1108009|                 -0.4184946|                  0.6324841|                  0.7719039|                   0.0752202|                   0.0045983|                  -0.0046744|      -0.0208311|      -0.0925723|       0.1450039|          -0.1002039|          -0.0376087|          -0.0702724|                      -0.9349938|                         -0.9349938|                          -0.9711698|              -0.9266164|                  -0.9817169|              -0.9537585|              -0.9255247|              -0.9542192|                  -0.9695703|                  -0.9548333|                  -0.9709189|      -0.9533669|      -0.9646983|      -0.9425702|                      -0.9298190|                              -0.9626548|                  -0.9460558|                      -0.9766390|               -0.9477353|               -0.9132763|               -0.9429458|                  -0.9287812|                  -0.9588269|                  -0.9524354|                   -0.9703552|                   -0.9551515|                   -0.9745270|       -0.9566419|       -0.9618850|       -0.9332519|           -0.9720926|           -0.9804842|           -0.9786363|                       -0.9094078|                          -0.9094078|                           -0.9598498|               -0.9239116|                   -0.9742017|               -0.9456568|               -0.9125629|               -0.9411640|                   -0.9741261|                   -0.9589610|                   -0.9768332|       -0.9580310|       -0.9607113|       -0.9369656|                       -0.9132673|                               -0.9556356|                   -0.9235524|                       -0.9727890|
|          4| LAYING       |               0.2635592|              -0.0150032|              -0.1106882|                 -0.4206647|                  0.9151651|                  0.3415313|                   0.0934494|                   0.0069331|                  -0.0064105|      -0.0092316|      -0.0930128|       0.1697204|          -0.1050199|          -0.0381230|          -0.0712156|                      -0.9545576|                         -0.9545576|                          -0.9700958|              -0.9302365|                  -0.9850685|              -0.9588021|              -0.9388834|              -0.9675043|                  -0.9785425|                  -0.9439700|                  -0.9753833|      -0.9672037|      -0.9721878|      -0.9614793|                      -0.9393897|                              -0.9622871|                  -0.9615567|                      -0.9836091|               -0.9541937|               -0.9417140|               -0.9626673|                  -0.9212000|                  -0.9698166|                  -0.9761766|                   -0.9783028|                   -0.9422095|                   -0.9785120|       -0.9731024|       -0.9611093|       -0.9620738|           -0.9751032|           -0.9868556|           -0.9839654|                       -0.9312922|                          -0.9312922|                           -0.9607864|               -0.9470318|                   -0.9826982|               -0.9524649|               -0.9463810|               -0.9621545|                   -0.9800793|                   -0.9443669|                   -0.9802612|       -0.9750947|       -0.9561825|       -0.9658075|                       -0.9371880|                               -0.9580371|                   -0.9471003|                       -0.9825436|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE)
```
