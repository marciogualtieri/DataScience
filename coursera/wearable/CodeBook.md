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
        -   [Activity Label Data](#activity-label-data)
    -   [Pertinent Variables (Mean, Standard Deviation & Activity)](#pertinent-variables-mean-standard-deviation-activity)
    -   [Binding Feature and Label Data Together](#binding-feature-and-label-data-together)
    -   [Re-Naming the Data-set Variables](#re-naming-the-data-set-variables)
    -   [Filtering Out Non-Pertinent Variables](#filtering-out-non-pertinent-variables)
    -   [Normalizing Variable Names](#normalizing-variable-names)
    -   [Joining with Activity Label Data](#joining-with-activity-label-data)
    -   [Putting All Transformations Together](#putting-all-transformations-together)
    -   [Resulting Clean Data-set](#resulting-clean-data-set)
-   [Computing Averages per Activity](#computing-averages-per-activity)
-   [Saving Clean Data to Disk](#saving-clean-data-to-disk)

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

Here's a list of the the unzipped files:

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

The pre-processed data ("Inertial Signals" folders) has been collected from human subjects carrying cellphones equipped with built-in accelerometers and gyroscopes. The purpose of the experiment that collected this data is to use these measurements to classify different categories of human activities performed by human subjects (walking, sitting, standing, etc).

The accelerometers and gyroscopes produce tri-axial measurements (carthesian X, Y & Z components) for the acceleration (in number of g's, where "g" is the Earth's gravitational acceleration, that is, ~ 9.764 m/s2) and angular velocity (in radians per second) respectively.

These measurements are collected overtime at a constant rate of 50 Hz, that is, a measurement is performed every 1/50 seconds (thus, the respective variables prefixed with 't', which stands for "time domain signal").

The acceleration measured has components due to the Earth's gravity and due to the subject's body motion. Given that the Earth's gravity is constant (therefore low frequency), a low-pass filter was used to separate the action due to the Earth's gravity from the action due to body motion. The body variables are infixed with "body", while gravity variables are infixed with "gravity".

A Fast Fourier Transform for the given sampling frequency of 50 Hz and with a number of bins equal to the number of observations was applied to the time based signal variables, generationg the "frequency domain signal" variables (which are prefixed with 'f').

Finally, these measurements were used to estimate variables for mean, standard deviation, median, max, min, etc (you will find the full list of estimated variables in `features_info.txt`). These estimated variables comprise the data for the given training and testing data-sets.

For the purpose of data exploration, we are not interested in the pre-processed data nor the subject id's, thus, we're going to work with the following files:

<table style="width:100%;">
<colgroup>
<col width="25%" />
<col width="74%" />
</colgroup>
<thead>
<tr class="header">
<th>File</th>
<th>Commentary</th>
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

#### Feature Names

The feature data contains 561 feature variables and 1122 observations (adding up testing and training data-sets).

``` r
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
str(features)
```

    ## 'data.frame':    561 obs. of  2 variables:
    ##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

As expected, the list of feature names contains 2 entries, which matches with the number of columns in the feature data.

Given that we only need the feature names, let's create a new variable without the indexes (columns in the feature data are ordered in the same way as feature names, thus indexes are not necessary):

``` r
feature_names <- features[, 2]
sample(feature_names, 6)
```

    ## [1] "fBodyAcc-bandsEnergy()-49,56" "tBodyGyroMag-iqr()"          
    ## [3] "fBodyAcc-maxInds-Z"           "fBodyAcc-bandsEnergy()-1,8"  
    ## [5] "tBodyGyro-energy()-Y"         "tGravityAccMag-entropy()"

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

#### Activity Label Data

``` r
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
dim(activities)
```

    ## [1] 6 2

### Pertinent Variables (Mean, Standard Deviation & Activity)

Let's create a list of all variables, which include the features names and label name:

``` r
variables <- c(feature_names, "ActivityID")
```

Let's also create a list of the variables we are interested in (means and standard deviations):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "tBodyAcc-arCoeff()-Z,4"       "fBodyGyro-kurtosis()-Z"      
    ## [3] "tBodyGyroJerkMag-std()"       "fBodyGyro-mean()-X"          
    ## [5] "tBodyGyro-arCoeff()-X,4"      "fBodyAcc-bandsEnergy()-25,48"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyroJerkMag-mean()" "tBodyGyro-mean()-X"     
    ## [3] "tBodyAcc-mean()-Y"       "fBodyAccJerk-mean()-Z"  
    ## [5] "fBodyAccJerk-mean()-Y"   "tBodyAccMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyGyro-std()-X"    "tBodyGyro-std()-Z"    "fBodyAcc-std()-X"    
    ## [4] "fBodyAcc-std()-Z"     "tGravityAccMag-std()" "fBodyGyro-std()-Z"

### Binding Feature and Label Data Together

``` r
add_labels <- function(data, labels) {
  data <- cbind(data, labels)
  data
}

test_data <- add_labels(test_data, test_labels)
dim(test_data)
```

    ## [1] 2947  562

### Re-Naming the Data-set Variables

``` r
add_variable_names <- function(data) {
  names(data) <- variables
  data
}

test_data <- add_variable_names(test_data)
sample(names(test_data), 6)
```

    ## [1] "fBodyGyro-skewness()-Z"      "fBodyAcc-bandsEnergy()-9,16"
    ## [3] "tGravityAccMag-sma()"        "fBodyBodyGyroMag-kurtosis()"
    ## [5] "fBodyAcc-entropy()-Y"        "tGravityAccMag-energy()"

### Filtering Out Non-Pertinent Variables

``` r
select_mean_and_std_variables <- function(data)
  data[, c(mean_variables, std_variables, "ActivityID")]


test_data <- select_mean_and_std_variables(test_data)
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
    ## [67] "ActivityID"

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  ActivityID|
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|-----------:|
| 131  |               0.4108594|              -0.0248544|              -0.1489872|                  0.7997087|                 -0.2682071|                 -0.4029328|                   0.0164685|                   0.0126299|                   0.0830602|      -0.1126957|       0.0350873|       0.1390810|          -0.2599475|          -0.2985758|          -0.0764624|                       0.2056674|                          0.2056674|                           0.1415392|              -0.0510022|                  -0.4245420|               0.2575762|               0.3390097|               0.1501182|                   0.2448727|                   0.1161636|                  -0.0768369|      -0.1012648|      -0.3134963|      -0.0367008|                       0.4737514|                               0.2928808|                  -0.4138851|                      -0.5101061|                0.1348854|                0.3178837|                0.3034215|                  -0.8722623|                  -0.9164501|                  -0.9471843|                    0.2898105|                    0.1088030|                   -0.1896794|       -0.1252662|       -0.3918863|       -0.1553400|           -0.3478956|           -0.5040921|           -0.2884026|                        0.4493288|                           0.4493288|                            0.2813751|               -0.3365187|                   -0.4928678|                0.0827236|                0.2225739|                0.2837147|                    0.2224406|                    0.0182755|                   -0.3048764|       -0.1414812|       -0.4501506|       -0.2753297|                        0.2095845|                                0.2589665|                   -0.3974395|                       -0.5031671|           3|
| 140  |               0.1821957|              -0.0016885|              -0.0898050|                  0.8096558|                 -0.4179786|                 -0.2927227|                   0.3209552|                  -0.0066668|                  -0.2080512|       0.0680791|      -0.1265756|      -0.0749617|          -0.2745648|          -0.2739903|          -0.1807373|                      -0.2313004|                         -0.2313004|                          -0.3981772|              -0.1973780|                  -0.5679069|              -0.3271662|              -0.1586235|              -0.4059695|                  -0.2560644|                  -0.3799111|                  -0.5382349|      -0.2682436|      -0.4596083|      -0.1759754|                      -0.2559079|                              -0.2971073|                  -0.4466959|                      -0.6054928|               -0.3896966|                0.0199423|               -0.3236023|                  -0.9560048|                  -0.9495148|                  -0.9011688|                   -0.3168533|                   -0.3710876|                   -0.6155186|       -0.3928004|       -0.4994685|        0.0793365|           -0.3838898|           -0.6615080|           -0.5198368|                       -0.3342828|                          -0.3342828|                           -0.3263700|               -0.3864765|                   -0.5982458|               -0.4161094|                0.0403094|               -0.3317543|                   -0.4601750|                   -0.4057035|                   -0.6994420|       -0.4327552|       -0.5292889|        0.0520026|                       -0.4861364|                               -0.3682460|                   -0.4503476|                       -0.6169343|           2|
| 535  |               0.2694246|              -0.0105516|              -0.1172020|                 -0.4295182|                  0.9576199|                  0.2227362|                   0.0683289|                   0.0000281|                   0.0056733|      -0.0058467|      -0.1283584|       0.2753904|          -0.1175276|          -0.0332225|          -0.1146032|                      -0.9824785|                         -0.9824785|                          -0.9928239|              -0.9057572|                  -0.9949712|              -0.9904298|              -0.9829780|              -0.9880402|                  -0.9932211|                  -0.9853007|                  -0.9934220|      -0.9696734|      -0.9843396|      -0.9109376|                      -0.9878048|                              -0.9946057|                  -0.9390178|                      -0.9946508|               -0.9877322|               -0.9841971|               -0.9764440|                  -0.9746746|                  -0.9820686|                  -0.9684544|                   -0.9936573|                   -0.9857826|                   -0.9939538|       -0.9717361|       -0.9715693|       -0.9044726|           -0.9919241|           -0.9949954|           -0.9955311|                       -0.9858981|                          -0.9858981|                           -0.9942464|               -0.9071792|                   -0.9951943|               -0.9864823|               -0.9847806|               -0.9712428|                   -0.9948018|                   -0.9874680|                   -0.9928885|       -0.9724470|       -0.9657927|       -0.9109393|                       -0.9857885|                               -0.9922146|                   -0.9041539|                       -0.9959970|           6|
| 57   |               0.3009048|              -0.0236104|              -0.0968907|                 -0.7276293|                  0.7174348|                  0.6807919|                   0.0841728|                   0.0134294|                  -0.0088534|      -0.0315334|      -0.2452833|       0.1565622|          -0.0986483|          -0.0088691|          -0.0982582|                      -0.9812262|                         -0.9812262|                          -0.9858654|              -0.9142557|                  -0.9865465|              -0.9835060|              -0.9759716|              -0.9859004|                  -0.9828648|                  -0.9797115|                  -0.9877974|      -0.9840422|      -0.9569330|      -0.9364265|                      -0.9798187|                              -0.9863168|                  -0.9398944|                      -0.9885428|               -0.9868121|               -0.9748740|               -0.9869338|                  -0.9753902|                  -0.9853860|                  -0.9764926|                   -0.9835636|                   -0.9799629|                   -0.9897563|       -0.9872061|       -0.9511295|       -0.9415235|           -0.9861121|           -0.9867281|           -0.9836751|                       -0.9790816|                          -0.9790816|                           -0.9864083|               -0.9192642|                   -0.9883955|               -0.9883438|               -0.9747672|               -0.9878016|                   -0.9859386|                   -0.9817359|                   -0.9902873|       -0.9881415|       -0.9480445|       -0.9485109|                       -0.9807536|                               -0.9849702|                   -0.9199083|                       -0.9884786|           6|
| 1344 |               0.2381380|              -0.0175424|              -0.1214816|                  0.9382219|                 -0.2373375|                 -0.1266093|                   0.0919730|                   0.0036354|                  -0.1428539|      -0.0956853|      -0.1053771|       0.1263031|           0.1419213|          -0.1815023|          -0.0560606|                      -0.3194953|                         -0.3194953|                          -0.5271540|              -0.4419335|                  -0.7335667|              -0.4363162|              -0.4195440|              -0.5381242|                  -0.4368802|                  -0.5943876|                  -0.6840988|      -0.5285387|      -0.6148200|      -0.5035569|                      -0.3922488|                              -0.4495613|                  -0.6886604|                      -0.8046611|               -0.3729288|               -0.2599911|               -0.4518203|                  -0.9692819|                  -0.9441634|                  -0.9176302|                   -0.4176998|                   -0.5628017|                   -0.7208120|       -0.6281667|       -0.5949168|       -0.2867964|           -0.6655534|           -0.7918668|           -0.7160911|                       -0.3972423|                          -0.3972423|                           -0.4513748|               -0.6670453|                   -0.8052946|               -0.3495062|               -0.2328562|               -0.4484011|                   -0.4492594|                   -0.5568392|                   -0.7569236|       -0.6597087|       -0.5858589|       -0.2940266|                       -0.4933124|                               -0.4556454|                   -0.7091625|                       -0.8197074|           2|
| 541  |               0.2765721|              -0.0158978|              -0.1115209|                 -0.4305192|                  0.9612920|                  0.2152364|                   0.0738349|                   0.0166036|                   0.0013494|      -0.0288650|      -0.0589171|       0.0815158|          -0.0975899|          -0.0459924|          -0.0500543|                      -0.9957590|                         -0.9957590|                          -0.9953159|              -0.9784230|                  -0.9955054|              -0.9932752|              -0.9905339|              -0.9959421|                  -0.9941725|                  -0.9906536|                  -0.9953300|      -0.9921658|      -0.9838452|      -0.9952048|                      -0.9975448|                              -0.9973823|                  -0.9851186|                      -0.9955092|               -0.9931601|               -0.9935626|               -0.9949460|                  -0.9957382|                  -0.9978579|                  -0.9954971|                   -0.9943600|                   -0.9898575|                   -0.9969766|       -0.9943735|       -0.9688987|       -0.9953040|           -0.9934847|           -0.9944481|           -0.9975936|                       -0.9971746|                          -0.9971746|                           -0.9976475|               -0.9800858|                   -0.9959612|               -0.9929696|               -0.9948200|               -0.9937542|                   -0.9951025|                   -0.9895294|                   -0.9973669|       -0.9950587|       -0.9623190|       -0.9956636|                       -0.9964594|                               -0.9967995|                   -0.9799448|                       -0.9966033|           6|

### Joining with Activity Label Data

``` r
names(activities) <- c("ActivityID", "ActivityLabel")
str(activities)
```

    ## 'data.frame':    6 obs. of  2 variables:
    ##  $ ActivityID   : int  1 2 3 4 5 6
    ##  $ ActivityLabel: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1

``` r
add_activity_label_variable <- function(data, activities) {
  data <- merge(data, activities)
  data <- data[, !names(data) %in% c("ActivityID")]
  data
}

test_data <- add_activity_label_variable(test_data, activities)
sample_data_frame(test_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------|
| 2838 |               0.2730132|              -0.0194510|              -0.1044676|                 -0.7049189|                  0.7892344|                  0.6222578|                   0.0783333|                   0.0214048|                  -0.0106857|      -0.0260767|      -0.0796972|       0.0890856|          -0.0988294|          -0.0430630|          -0.0587268|                      -0.9913958|                         -0.9913958|                          -0.9879435|              -0.9924377|                  -0.9963793|              -0.9912011|              -0.9800729|              -0.9896951|                  -0.9917122|                  -0.9797244|                  -0.9869508|      -0.9926172|      -0.9938698|      -0.9909127|                      -0.9882184|                              -0.9880852|                  -0.9952292|                      -0.9970526|               -0.9912855|               -0.9835262|               -0.9907332|                  -0.9898594|                  -0.9953302|                  -0.9924153|                   -0.9914156|                   -0.9800322|                   -0.9879980|       -0.9936484|       -0.9934669|       -0.9907414|           -0.9945771|           -0.9964951|           -0.9946557|                       -0.9907353|                          -0.9907353|                           -0.9890128|               -0.9942852|                   -0.9971483|               -0.9911793|               -0.9855780|               -0.9913154|                   -0.9918041|                   -0.9818808|                   -0.9874345|       -0.9939032|       -0.9931614|       -0.9913784|                       -0.9932749|                               -0.9890645|                   -0.9943574|                       -0.9971189| LAYING        |
| 2272 |               0.2299716|              -0.0503255|              -0.1692054|                  0.9684362|                 -0.2133418|                 -0.0129632|                   0.1064400|                  -0.0119508|                   0.0441664|      -0.1010008|       0.0913579|      -0.0557145|           0.0042064|           0.0100331|          -0.0174104|                      -0.7053031|                         -0.7053031|                          -0.9154203|              -0.7074224|                  -0.8314234|              -0.9193247|              -0.9021593|              -0.6447544|                  -0.9217393|                  -0.9417133|                  -0.8361975|      -0.8417649|      -0.4639803|      -0.8532281|                      -0.7476605|                              -0.8501701|                  -0.3905539|                      -0.6625559|               -0.9223616|               -0.8821592|               -0.3447385|                  -0.8834377|                  -0.9280566|                  -0.7034434|                   -0.9202142|                   -0.9408408|                   -0.8618680|       -0.8951644|       -0.3998666|       -0.8622873|           -0.9168133|           -0.7023567|           -0.9144413|                       -0.6048802|                          -0.6048802|                           -0.8479575|               -0.2569018|                   -0.6535401|               -0.9234375|               -0.8789404|               -0.2661343|                   -0.9256994|                   -0.9439779|                   -0.8882019|       -0.9132522|       -0.3676182|       -0.8778484|                       -0.6042475|                               -0.8446653|                   -0.2969267|                       -0.6658836| STANDING      |
| 1528 |               0.2787997|              -0.0156331|              -0.1066477|                  0.8941330|                 -0.0000363|                  0.3433797|                   0.0892345|                   0.0080375|                  -0.0199086|      -0.0283907|      -0.0758995|       0.0821160|          -0.0999529|          -0.0180828|          -0.0654997|                      -0.9927293|                         -0.9927293|                          -0.9885041|              -0.9928788|                  -0.9917340|              -0.9907560|              -0.9824401|              -0.9786899|                  -0.9856807|                  -0.9815904|                  -0.9804005|      -0.9859878|      -0.9797067|      -0.9879171|                      -0.9831588|                              -0.9779680|                  -0.9753323|                      -0.9826570|               -0.9952276|               -0.9864036|               -0.9832447|                  -0.9974477|                  -0.9914529|                  -0.9938800|                   -0.9882775|                   -0.9844850|                   -0.9838996|       -0.9919428|       -0.9858042|       -0.9931768|           -0.9820974|           -0.9893231|           -0.9888610|                       -0.9877031|                          -0.9877031|                           -0.9814192|               -0.9802560|                   -0.9828151|               -0.9985214|               -0.9886681|               -0.9871846|                   -0.9932919|                   -0.9901825|                   -0.9861743|       -0.9942237|       -0.9913801|       -0.9967114|                       -0.9925476|                               -0.9855747|                   -0.9888614|                       -0.9838441| SITTING       |
| 1737 |               0.2802686|              -0.0188783|              -0.1078300|                  0.8480420|                  0.3433976|                  0.1303332|                   0.0753040|                   0.0215943|                   0.0042556|      -0.0278870|      -0.0743652|       0.0838861|          -0.0967049|          -0.0430850|          -0.0539250|                      -0.9924005|                         -0.9924005|                          -0.9916681|              -0.9934510|                  -0.9966436|              -0.9938623|              -0.9885329|              -0.9894752|                  -0.9935724|                  -0.9945681|                  -0.9851857|      -0.9949513|      -0.9951418|      -0.9916578|                      -0.9924491|                              -0.9931275|                  -0.9959964|                      -0.9972084|               -0.9951847|               -0.9798118|               -0.9917686|                  -0.9958445|                  -0.9932111|                  -0.9972070|                   -0.9943452|                   -0.9953445|                   -0.9867327|       -0.9963374|       -0.9956068|       -0.9868683|           -0.9952413|           -0.9965484|           -0.9948655|                       -0.9928852|                          -0.9928852|                           -0.9932094|               -0.9958201|                   -0.9972963|               -0.9958072|               -0.9761082|               -0.9932698|                   -0.9959290|                   -0.9968488|                   -0.9867162|       -0.9967550|       -0.9958882|       -0.9864054|                       -0.9933794|                               -0.9918909|                   -0.9962526|                       -0.9972217| SITTING       |
| 1676 |               0.2904457|              -0.0302192|              -0.1473060|                  0.9405308|                 -0.0260267|                  0.2401851|                   0.0805768|                   0.0016637|                  -0.0293207|      -0.0193548|      -0.1281186|       0.1332346|          -0.0745106|          -0.0365767|          -0.0858506|                      -0.9208798|                         -0.9208798|                          -0.9602710|              -0.9333651|                  -0.9756039|              -0.9601730|              -0.8853660|              -0.9209885|                  -0.9522288|                  -0.9362196|                  -0.9589657|      -0.9491590|      -0.9525530|      -0.8798059|                      -0.9035606|                              -0.9360005|                  -0.9273478|                      -0.9631271|               -0.9692178|               -0.8481038|               -0.8739133|                  -0.9959797|                  -0.9811695|                  -0.9788114|                   -0.9509892|                   -0.9355368|                   -0.9636310|       -0.9613959|       -0.9468249|       -0.8738471|           -0.9695801|           -0.9717900|           -0.9418852|                       -0.8568107|                          -0.8568107|                           -0.9290758|               -0.8934900|                   -0.9532953|               -0.9736042|               -0.8397297|               -0.8603096|                   -0.9539902|                   -0.9393162|                   -0.9668249|       -0.9652368|       -0.9437998|       -0.8832745|                       -0.8567228|                               -0.9192299|                   -0.8913020|                       -0.9451811| SITTING       |
| 200  |               0.3024745|              -0.0153515|              -0.1284459|                  0.9667836|                 -0.0596369|                  0.1093626|                   0.0976011|                  -0.3113961|                  -0.1264731|       0.0004959|      -0.1381493|       0.0842510|          -0.1975488|          -0.0076879|          -0.1417850|                      -0.2808458|                         -0.2808458|                          -0.3240827|              -0.5138002|                  -0.6770779|              -0.3992416|              -0.1091930|              -0.6516182|                  -0.3269111|                  -0.1934037|                  -0.7685244|      -0.4099395|      -0.6977935|      -0.6287284|                      -0.4100664|                              -0.2164898|                  -0.5710167|                      -0.6959011|               -0.4094373|               -0.0099336|               -0.6347918|                  -0.9840507|                  -0.9735169|                  -0.9635668|                   -0.2727178|                   -0.1339591|                   -0.8000030|       -0.5066822|       -0.6473162|       -0.6970291|           -0.4651020|           -0.8148435|           -0.6425217|                       -0.5029860|                          -0.5029860|                           -0.3165616|               -0.5537370|                   -0.7236571|               -0.4134203|               -0.0225835|               -0.6537578|                   -0.2802788|                   -0.1256481|                   -0.8315810|       -0.5378304|       -0.6218029|       -0.7508238|                       -0.6414194|                               -0.4661506|                   -0.6184571|                       -0.7847139| WALKING       |

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels) {
  data <- add_labels(data, labels)
  data <- add_variable_names(data)
  data <- select_mean_and_std_variables(data)
  data <- normalize_variable_names(data)
  add_activity_label_variable(data, activities)
}
```

Which we can apply to the training data-set as well:

``` r
train_data <- cleanup_data(train_data, train_labels)
sample_data_frame(train_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel     |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 4100 |               0.2792612|              -0.0175476|              -0.1111347|                  0.9148541|                  0.1922708|                  0.2013252|                   0.0751330|                   0.0048028|                  -0.0005298|      -0.0280406|      -0.0719371|       0.0872429|          -0.0971782|          -0.0403435|          -0.0536791|                      -0.9994288|                         -0.9994288|                          -0.9949553|              -0.9985018|                  -0.9976448|              -0.9977512|              -0.9926794|              -0.9956845|                  -0.9965965|                  -0.9915644|                  -0.9924312|      -0.9984818|      -0.9952593|      -0.9987205|                      -0.9977324|                              -0.9960224|                  -0.9981947|                      -0.9968957|               -0.9981390|               -0.9960522|               -0.9959830|                  -0.9977556|                  -0.9987713|                  -0.9968593|                   -0.9967225|                   -0.9910951|                   -0.9933303|       -0.9989644|       -0.9963097|       -0.9990319|           -0.9982087|           -0.9954347|           -0.9986008|                       -0.9979132|                          -0.9979132|                           -0.9963244|               -0.9984450|                   -0.9968593|               -0.9982994|               -0.9975036|               -0.9956154|                   -0.9971727|                   -0.9910919|                   -0.9926757|       -0.9991159|       -0.9970973|       -0.9992457|                       -0.9976056|                               -0.9951231|                   -0.9988820|                       -0.9966119| SITTING           |
| 4471 |               0.2756137|              -0.0098050|              -0.1037286|                  0.9617918|                 -0.0240357|                  0.1641610|                   0.0741724|                   0.0070294|                  -0.0057609|      -0.0274759|      -0.0770689|       0.0868326|          -0.0991424|          -0.0438500|          -0.0505566|                      -0.9921029|                         -0.9921029|                          -0.9940773|              -0.9933586|                  -0.9970831|              -0.9963251|              -0.9891101|              -0.9907314|                  -0.9958497|                  -0.9913744|                  -0.9906841|      -0.9978352|      -0.9935148|      -0.9886882|                      -0.9928456|                              -0.9922891|                  -0.9947310|                      -0.9975448|               -0.9969469|               -0.9892366|               -0.9908092|                  -0.9988826|                  -0.9856876|                  -0.9905513|                   -0.9964461|                   -0.9920594|                   -0.9902681|       -0.9986998|       -0.9915758|       -0.9885490|           -0.9978377|           -0.9971326|           -0.9924146|                       -0.9935746|                          -0.9935746|                           -0.9933744|               -0.9934449|                   -0.9971796|               -0.9972056|               -0.9888669|               -0.9906864|                   -0.9976065|                   -0.9936203|                   -0.9881733|       -0.9990171|       -0.9904268|       -0.9893923|                       -0.9942326|                               -0.9939370|                   -0.9934147|                       -0.9964419| SITTING           |
| 750  |               0.3099286|              -0.0295296|              -0.1120827|                  0.9139414|                 -0.1025076|                  0.3040917|                   0.0500689|                   0.0766246|                  -0.0806870|       0.0787109|      -0.1158911|       0.1507332|          -0.1513977|           0.0370981|          -0.0894058|                      -0.4397990|                         -0.4397990|                          -0.5620495|              -0.4113493|                  -0.6843624|              -0.6259239|              -0.3412504|              -0.5201481|                  -0.6311091|                  -0.5054013|                  -0.6330552|      -0.4428029|      -0.6953539|      -0.5592196|                      -0.5924757|                              -0.5883496|                  -0.5543950|                      -0.7765842|               -0.6231030|               -0.2181092|               -0.4338143|                  -0.9781444|                  -0.9653618|                  -0.9694927|                   -0.6230042|                   -0.4333049|                   -0.6640796|       -0.4173880|       -0.6245412|       -0.5207066|           -0.5043534|           -0.8026068|           -0.6848983|                       -0.5769580|                          -0.5769580|                           -0.5528128|               -0.4719462|                   -0.7573142|               -0.6218602|               -0.2079531|               -0.4316937|                   -0.6482483|                   -0.3931296|                   -0.6931037|       -0.4186402|       -0.5892798|       -0.5523973|                       -0.6334669|                               -0.5117869|                   -0.5075038|                       -0.7501389| WALKING           |
| 6339 |               0.3208020|              -0.0059943|              -0.1164869|                 -0.6710098|                 -0.4299661|                 -0.9229764|                   0.0760507|                  -0.0028732|                  -0.0050308|      -0.0370464|      -0.0562191|       0.1063726|          -0.1064252|          -0.0428210|          -0.0428952|                      -0.9610326|                         -0.9610326|                          -0.9877511|              -0.9575976|                  -0.9797500|              -0.9831643|              -0.9653850|              -0.9752860|                  -0.9890531|                  -0.9824423|                  -0.9788008|      -0.9256786|      -0.9683869|      -0.9727197|                      -0.9730632|                              -0.9821185|                  -0.9280671|                      -0.9675209|               -0.9710101|               -0.9416620|               -0.9706490|                  -0.9459367|                  -0.9625038|                  -0.9783314|                   -0.9901965|                   -0.9838706|                   -0.9827379|       -0.9397744|       -0.9599542|       -0.9688089|           -0.9438477|           -0.9838536|           -0.9871703|                       -0.9469694|                          -0.9469694|                           -0.9829254|               -0.9100539|                   -0.9610471|               -0.9668414|               -0.9343146|               -0.9692687|                   -0.9926540|                   -0.9871050|                   -0.9855426|       -0.9441865|       -0.9556010|       -0.9702092|                       -0.9425663|                               -0.9826848|                   -0.9135034|                       -0.9557849| LAYING            |
| 767  |               0.3394683|              -0.0092693|              -0.0988033|                  0.9554216|                 -0.2354233|                  0.0914159|                   0.2327644|                  -0.5397328|                  -0.3468209|      -0.0415470|      -0.1244080|       0.1258355|           0.0828975|          -0.0533089|           0.0610278|                      -0.2075130|                         -0.2075130|                          -0.3965067|              -0.3465122|                  -0.5944534|              -0.3738665|               0.0177656|              -0.4928540|                  -0.4514660|                  -0.2072248|                  -0.6426061|      -0.2903561|      -0.6641811|      -0.4152395|                      -0.4014922|                              -0.3852777|                  -0.5441483|                      -0.6913197|               -0.3576698|                0.0256039|               -0.4091418|                  -0.9631474|                  -0.9735229|                  -0.9521514|                   -0.4428583|                   -0.1836905|                   -0.6717140|       -0.3758858|       -0.6272246|       -0.3449629|           -0.3354860|           -0.7789226|           -0.5494071|                       -0.4208210|                          -0.4208210|                           -0.4088776|               -0.4870155|                   -0.6750480|               -0.3513004|               -0.0349136|               -0.4100901|                   -0.4840390|                   -0.2137306|                   -0.6987741|       -0.4049092|       -0.6086389|       -0.3832724|                       -0.5215219|                               -0.4439672|                   -0.5358575|                       -0.6765176| WALKING           |
| 1575 |               0.3530850|              -0.0071438|              -0.1841520|                  0.8162531|                  0.1718072|                 -0.3883204|                  -0.1598143|                   0.2472865|                  -0.1694422|      -0.1118715|      -0.0788167|       0.0918366|          -0.2302571|           0.1543077|           0.0541629|                      -0.1721815|                         -0.1721815|                          -0.4211601|              -0.1180978|                  -0.6883490|              -0.3903779|              -0.2075341|              -0.0979121|                  -0.5008322|                  -0.4595035|                  -0.3654699|      -0.4344714|      -0.4986559|      -0.2586797|                      -0.2702035|                              -0.4094831|                  -0.5491154|                      -0.7409110|               -0.3852491|               -0.1144708|                0.0776044|                  -0.9460048|                  -0.9263027|                  -0.8278328|                   -0.5150193|                   -0.4237904|                   -0.4264813|       -0.3261391|       -0.3908854|        0.1169438|           -0.7055741|           -0.7200418|           -0.6354095|                       -0.2249027|                          -0.2249027|                           -0.4292666|               -0.3288385|                   -0.7602575|               -0.3831369|               -0.1236576|                0.0857666|                   -0.5770200|                   -0.4226001|                   -0.4859700|       -0.3115444|       -0.3370816|        0.1127416|                       -0.3208100|                               -0.4571111|                   -0.3150921|                       -0.8062097| WALKING\_UPSTAIRS |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

The following tables describe all the variables on the clean data-set:

<table>
<colgroup>
<col width="14%" />
<col width="85%" />
</colgroup>
<thead>
<tr class="header">
<th>Activity Variable</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ActivityLabel</td>
<td>A descriptive label for the activity, i.e.: LAYING, SITTING, WALKING, WALKING_UPSTAIRS or WALKING_DOWNSTAIRS.</td>
</tr>
</tbody>
</table>

<br/>

> **Note:**
>
> Acceleration Units: Number of g's.
>
> Prefix 't' stands for "time domain signal", 'f' for "frequency domain signal".

<br/>

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

<br/>

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

<br/>

> **Note:**
>
> "Acceleration Jerk" or simply [jerk](https://en.wikipedia.org/wiki/Jerk_(physics)) is the rate of change of the acceleration.
>
> Jerk Units: Number of g's per second.

<br/>

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

<br/>

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

<br/>

> **Note:**
>
> Giro (Angular Velocity) Units: radians per second.

<br/>

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

<br/>

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

<br/>

Computing Averages per Activity
-------------------------------

The following data-set has been grouped by activity and all columns summarised into means:

``` r
averages_data <- all_data %>% group_by(ActivityLabel) %>% summarise_each(funs(mean))
averages_data
```

| ActivityLabel       |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|:--------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
| LAYING              |               0.2686486|              -0.0183177|              -0.1074356|                 -0.3750213|                  0.6222704|                  0.5556125|                   0.0818474|                   0.0111724|                  -0.0048598|      -0.0167253|      -0.0934107|       0.1258851|          -0.1018643|          -0.0381981|          -0.0638498|                      -0.9411107|                         -0.9411107|                          -0.9792088|              -0.9384360|                  -0.9827266|              -0.9668121|              -0.9526784|              -0.9600180|                  -0.9801977|                  -0.9713836|                  -0.9766145|      -0.9629150|      -0.9675821|      -0.9641844|                      -0.9476727|                              -0.9743001|                  -0.9548545|                      -0.9779682|               -0.9609324|               -0.9435072|               -0.9480693|                  -0.9433197|                  -0.9631917|                  -0.9518687|                   -0.9803818|                   -0.9711476|                   -0.9794766|       -0.9678924|       -0.9631925|       -0.9635092|           -0.9761248|           -0.9804736|           -0.9847825|                       -0.9321600|                          -0.9321600|                           -0.9742406|               -0.9405961|                   -0.9767550|               -0.9590315|               -0.9424610|               -0.9456436|                   -0.9824596|                   -0.9730512|                   -0.9809719|       -0.9697473|       -0.9613654|       -0.9667252|                       -0.9349167|                               -0.9731834|                   -0.9421157|                       -0.9766482|
| SITTING             |               0.2730596|              -0.0126896|              -0.1055170|                  0.8797312|                  0.1087135|                  0.1537741|                   0.0758788|                   0.0050469|                  -0.0024867|      -0.0384313|      -0.0721208|       0.0777771|          -0.0956521|          -0.0407798|          -0.0507555|                      -0.9546439|                         -0.9546439|                          -0.9824444|              -0.9467241|                  -0.9878801|              -0.9830920|              -0.9479180|              -0.9570310|                  -0.9851888|                  -0.9739882|                  -0.9795620|      -0.9772673|      -0.9724576|      -0.9610287|                      -0.9524104|                              -0.9786844|                  -0.9642961|                      -0.9853356|               -0.9834462|               -0.9348806|               -0.9389816|                  -0.9796822|                  -0.9576727|                  -0.9473574|                   -0.9849972|                   -0.9738832|                   -0.9822965|       -0.9810222|       -0.9667081|       -0.9580075|           -0.9857051|           -0.9865023|           -0.9838055|                       -0.9393242|                          -0.9393242|                           -0.9789071|               -0.9511990|                   -0.9846076|               -0.9837473|               -0.9325335|               -0.9343367|                   -0.9861850|                   -0.9757509|                   -0.9836708|       -0.9823333|       -0.9640337|       -0.9610302|                       -0.9420002|                               -0.9781548|                   -0.9516417|                       -0.9844914|
| STANDING            |               0.2791535|              -0.0161519|              -0.1065869|                  0.9414796|                 -0.1842465|                 -0.0140520|                   0.0750279|                   0.0088053|                  -0.0045821|      -0.0266871|      -0.0677119|       0.0801422|          -0.0997293|          -0.0423171|          -0.0520955|                      -0.9541797|                         -0.9541797|                          -0.9771180|              -0.9421525|                  -0.9786971|              -0.9816223|              -0.9431324|              -0.9573597|                  -0.9800087|                  -0.9645474|                  -0.9761578|      -0.9436543|      -0.9653028|      -0.9583850|                      -0.9558681|                              -0.9710904|                  -0.9479085|                      -0.9748860|               -0.9844347|               -0.9325087|               -0.9399135|                  -0.9880152|                  -0.9693518|                  -0.9530825|                   -0.9799686|                   -0.9643428|                   -0.9794859|       -0.9455284|       -0.9612933|       -0.9570531|           -0.9669579|           -0.9802633|           -0.9770671|                       -0.9465348|                          -0.9465348|                           -0.9714530|               -0.9295312|                   -0.9735286|               -0.9858598|               -0.9311330|               -0.9354396|                   -0.9818261|                   -0.9668316|                   -0.9815093|       -0.9469716|       -0.9594986|       -0.9606892|                       -0.9496016|                               -0.9709480|                   -0.9306367|                       -0.9734611|
| WALKING             |               0.2763369|              -0.0179068|              -0.1088817|                  0.9349916|                 -0.1967135|                 -0.0538251|                   0.0767187|                   0.0115062|                  -0.0023194|      -0.0347276|      -0.0694200|       0.0863626|          -0.0943007|          -0.0445701|          -0.0540065|                      -0.1679379|                         -0.1679379|                          -0.2414520|              -0.2748660|                  -0.4605115|              -0.2978909|              -0.0423392|              -0.3418407|                  -0.3111274|                  -0.1703951|                  -0.4510105|      -0.3482374|      -0.3883849|      -0.3104062|                      -0.2755581|                              -0.2146540|                  -0.4091730|                      -0.5155168|               -0.3146445|               -0.0235829|               -0.2739208|                  -0.9776121|                  -0.9669039|                  -0.9545976|                   -0.2672882|                   -0.1031411|                   -0.4791471|       -0.4699148|       -0.3479218|       -0.3384486|           -0.3762214|           -0.5126191|           -0.4474272|                       -0.3377540|                          -0.3377540|                           -0.2145559|               -0.3826290|                   -0.4988410|               -0.3228358|               -0.0772063|               -0.2960783|                   -0.2878977|                   -0.0908699|                   -0.5063291|       -0.5104320|       -0.3319615|       -0.4105691|                       -0.4800023|                               -0.2216178|                   -0.4738331|                       -0.5144048|
| WALKING\_DOWNSTAIRS |               0.2881372|              -0.0163119|              -0.1057616|                  0.9264574|                 -0.1685072|                 -0.0479709|                   0.0892267|                   0.0007467|                  -0.0087286|      -0.0840345|      -0.0529929|       0.0946782|          -0.0728532|          -0.0512640|          -0.0546962|                       0.1012497|                          0.1012497|                          -0.1118018|              -0.1297856|                  -0.4168916|               0.0352597|               0.0566827|              -0.2137292|                  -0.0722968|                  -0.1163806|                  -0.3331903|      -0.2179229|      -0.3175927|      -0.1656251|                       0.1428494|                               0.0047625|                  -0.2895258|                      -0.4380073|                0.1007663|                0.0595486|               -0.1908045|                  -0.9497488|                  -0.9342661|                  -0.9124606|                   -0.0338826|                   -0.0736744|                   -0.3886661|       -0.3338175|       -0.3396314|       -0.2728099|           -0.3826898|           -0.4659438|           -0.3264560|                        0.1164889|                           0.1164889|                           -0.0112207|               -0.2514278|                   -0.4409293|                0.1219380|               -0.0082337|               -0.2458729|                   -0.0821905|                   -0.0914165|                   -0.4435547|       -0.3751275|       -0.3618537|       -0.3804100|                       -0.0754252|                               -0.0422714|                   -0.3612310|                       -0.4864430|
| WALKING\_UPSTAIRS   |               0.2622946|              -0.0259233|              -0.1205379|                  0.8750034|                 -0.2813772|                 -0.1407957|                   0.0767293|                   0.0087589|                  -0.0060095|       0.0068245|      -0.0885225|       0.0598938|          -0.1121175|          -0.0386193|          -0.0525810|                      -0.1002041|                         -0.1002041|                          -0.3909386|              -0.1782811|                  -0.6080471|              -0.2934068|              -0.1349505|              -0.3681221|                  -0.3898968|                  -0.3646668|                  -0.5916701|      -0.3942482|      -0.4592535|      -0.2968577|                      -0.2620281|                              -0.3539620|                  -0.4497814|                      -0.6586945|               -0.2379897|               -0.0160325|               -0.1754497|                  -0.9481913|                  -0.9255493|                  -0.9019056|                   -0.3608634|                   -0.3392265|                   -0.6270636|       -0.4676071|       -0.3442318|       -0.2371368|           -0.5531328|           -0.6673392|           -0.5609892|                       -0.2498752|                          -0.2498752|                           -0.3854004|               -0.3371421|                   -0.6668367|               -0.2188880|               -0.0218110|               -0.1466018|                   -0.3889928|                   -0.3576329|                   -0.6615908|       -0.4952540|       -0.2931818|       -0.2920413|                       -0.3617535|                               -0.4342067|                   -0.3814064|                       -0.7030835|

Saving Clean Data to Disk
-------------------------

Let's finally save our clean data-sets to `*.csv` files:

``` r
write.csv(all_data, "./tidy_data/activity_data.csv")
write.csv(averages_data, "./tidy_data/activity_averages_data.csv")
```
