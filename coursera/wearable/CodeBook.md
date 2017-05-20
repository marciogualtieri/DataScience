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
        -   [Activity Names Data](#activity-names-data)
    -   [Pertinent Variables (Mean, Standard Deviation & Activity)](#pertinent-variables-mean-standard-deviation-activity)
    -   [Binding Feature and Label Data Together](#binding-feature-and-label-data-together)
    -   [Re-Naming the Data-set Variables](#re-naming-the-data-set-variables)
    -   [Filtering Out Non-Pertinent Variables](#filtering-out-non-pertinent-variables)
    -   [Normalizing Variable Names](#normalizing-variable-names)
    -   [Joining with Activity Names Data](#joining-with-activity-names-data)
    -   [Putting All Transformations Together](#putting-all-transformations-together)
    -   [Resulting Clean Data-set](#resulting-clean-data-set)
-   [Computing Averages per Activity](#computing-averages-per-activity)
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

For the purpose of this data exploration, we are not interested in the pre-processed data nor the subject id's, thus, we're going to work with the following files:

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

    ## [1] "fBodyAccMag-entropy()"       "tBodyAccMag-iqr()"          
    ## [3] "fBodyBodyGyroMag-kurtosis()" "tGravityAcc-sma()"          
    ## [5] "tBodyGyroJerk-max()-Z"       "tBodyAccMag-min()"

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

Later on we will bind feature and label data together in a single data-set.

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
variables <- c(feature_names, "ActivityID")
```

The variable name for activity is my own choice. I believe is descriptive enough.

Let's also create a list of the variables we are interested in exploring (means and standard deviations at the moment):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "tBodyGyroJerk-min()-Y"            "fBodyAccJerk-bandsEnergy()-17,32"
    ## [3] "fBodyAccJerk-iqr()-Z"             "fBodyAccJerk-bandsEnergy()-17,24"
    ## [5] "tBodyAccJerk-arCoeff()-X,3"       "fBodyBodyGyroMag-maxInds"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyro-mean()-X"          "fBodyBodyGyroJerkMag-mean()"
    ## [3] "fBodyGyro-mean()-Z"          "tGravityAcc-mean()-X"       
    ## [5] "tGravityAcc-mean()-Z"        "fBodyGyro-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAcc-std()-Z"           "fBodyBodyGyroMag-std()"    
    ## [3] "tBodyAcc-std()-Y"           "fBodyBodyGyroJerkMag-std()"
    ## [5] "tBodyGyroJerkMag-std()"     "tBodyAccMag-std()"

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

    ## [1] "tBodyAccJerk-entropy()-Y"    "fBodyGyro-max()-Y"          
    ## [3] "fBodyAccJerk-kurtosis()-Y"   "tBodyGyroJerk-entropy()-Y"  
    ## [5] "fBodyGyro-mad()-X"           "fBodyGyro-bandsEnergy()-1,8"

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
| 576  |               0.3640324|              -0.0420513|              -0.1039141|                  0.9567724|                 -0.0102303|                  0.1301970|                  -0.4331501|                  -0.0780930|                  -0.2960143|      -0.4929976|      -0.1128790|      -0.0889097|          -0.0446564|          -0.0944666|           0.0369001|                       0.0015979|                          0.0015979|                          -0.2177241|              -0.2445171|                  -0.5937769|               0.0596246|               0.0916509|              -0.4511638|                  -0.1876839|                   0.0412174|                  -0.5776928|      -0.2309254|      -0.7415925|      -0.2461722|                       0.1057800|                              -0.0958618|                  -0.3906757|                      -0.6017837|                0.0521838|               -0.0083813|               -0.4490830|                  -0.9568930|                  -0.9447095|                  -0.9498718|                   -0.1897191|                    0.0520827|                   -0.6293213|       -0.3286571|       -0.7030946|       -0.4463351|           -0.3938442|           -0.8347421|           -0.2502891|                        0.0448326|                           0.0448326|                           -0.1311149|               -0.2422675|                   -0.5988788|                0.0492793|               -0.1299773|               -0.4922470|                   -0.2666304|                   -0.0107548|                   -0.6811880|       -0.3614618|       -0.6835760|       -0.5814426|                       -0.1535289|                               -0.1821922|                   -0.2761696|                       -0.6219962|           3|
| 2023 |               0.2734975|              -0.0226945|              -0.1395428|                  0.9497892|                 -0.2241534|                  0.0994191|                   0.3396124|                  -0.1477796|                  -0.0382398|      -0.1698186|       0.0742406|      -0.0358345|          -0.1534274|          -0.0310140|          -0.0789810|                      -0.3049778|                         -0.3049778|                          -0.5053557|              -0.3020504|                  -0.7567854|              -0.3244676|              -0.1636964|              -0.6278596|                  -0.4199764|                  -0.3887290|                  -0.7230056|      -0.3815376|      -0.6964824|      -0.5479941|                      -0.1547858|                              -0.4218304|                  -0.5568157|                      -0.8107877|               -0.3185603|               -0.1389236|               -0.5751221|                  -0.9708274|                  -0.9117748|                  -0.9320838|                   -0.4595500|                   -0.3600881|                   -0.7355672|       -0.2509606|       -0.6168649|       -0.5306698|           -0.6479966|           -0.8362377|           -0.7363817|                       -0.2485475|                          -0.2485475|                           -0.4148698|               -0.3203211|                   -0.8191560|               -0.3160972|               -0.1800313|               -0.5792443|                   -0.5601455|                   -0.3714577|                   -0.7458745|       -0.2328749|       -0.5775802|       -0.5678902|                       -0.4238600|                               -0.4078132|                   -0.3006940|                       -0.8438573|           3|
| 2588 |               0.2744153|              -0.0443325|              -0.0807122|                  0.9687427|                 -0.1377833|                 -0.0722079|                   0.0747878|                   0.0134194|                   0.0112729|      -0.0111138|      -0.0841133|       0.1157754|          -0.1046109|          -0.0423890|          -0.0659112|                      -0.9506650|                         -0.9506650|                          -0.9808600|              -0.9612121|                  -0.9882153|              -0.9842408|              -0.9630148|              -0.9710346|                  -0.9801136|                  -0.9753189|                  -0.9807383|      -0.9698563|      -0.9787347|      -0.9757303|                      -0.9688822|                              -0.9839560|                  -0.9767594|                      -0.9833835|               -0.9882393|               -0.9502465|               -0.9510337|                  -0.9945363|                  -0.9429799|                  -0.9585004|                   -0.9818416|                   -0.9756508|                   -0.9842125|       -0.9659128|       -0.9810277|       -0.9688265|           -0.9850638|           -0.9842899|           -0.9914210|                       -0.9520561|                          -0.9520561|                           -0.9853399|               -0.9711845|                   -0.9831763|               -0.9902516|               -0.9463767|               -0.9438705|                   -0.9858158|                   -0.9778437|                   -0.9864737|       -0.9652803|       -0.9826699|       -0.9693710|                       -0.9501610|                               -0.9860705|                   -0.9721444|                       -0.9836344|           5|
| 2760 |               0.2809236|              -0.0053527|              -0.1244134|                  0.9679608|                 -0.1665865|                 -0.0282185|                   0.0786191|                   0.0055499|                  -0.0088015|      -0.0260484|      -0.0871363|       0.0843895|          -0.0935401|          -0.0337789|          -0.0620487|                      -0.9691487|                         -0.9691487|                          -0.9859899|              -0.9770181|                  -0.9930207|              -0.9934134|              -0.9648591|              -0.9776696|                  -0.9909930|                  -0.9761730|                  -0.9846566|      -0.9807360|      -0.9862997|      -0.9827083|                      -0.9762055|                              -0.9889300|                  -0.9874824|                      -0.9948666|               -0.9949922|               -0.9505293|               -0.9658122|                  -0.9951374|                  -0.9703857|                  -0.9671666|                   -0.9912440|                   -0.9770795|                   -0.9872799|       -0.9780166|       -0.9824644|       -0.9781405|           -0.9904099|           -0.9933994|           -0.9932629|                       -0.9736738|                          -0.9736738|                           -0.9900083|               -0.9787865|                   -0.9952411|               -0.9957684|               -0.9460505|               -0.9611696|                   -0.9923450|                   -0.9799799|                   -0.9885633|       -0.9775033|       -0.9803747|       -0.9785056|                       -0.9751037|                               -0.9903888|                   -0.9770162|                       -0.9958028|           5|
| 1885 |               0.2795480|              -0.0144182|              -0.1021833|                  0.9568126|                 -0.2227794|                  0.0500691|                   0.0769302|                   0.0069463|                   0.0078195|      -0.0074344|      -0.0666901|       0.0796726|          -0.0996497|          -0.0450263|          -0.0397149|                      -0.9853600|                         -0.9853600|                          -0.9936917|              -0.9752927|                  -0.9952184|              -0.9979106|              -0.9792967|              -0.9812458|                  -0.9974265|                  -0.9848020|                  -0.9912756|      -0.9834161|      -0.9925300|      -0.9761086|                      -0.9877130|                              -0.9927641|                  -0.9836393|                      -0.9960909|               -0.9984350|               -0.9782091|               -0.9716841|                  -0.9976258|                  -0.9900841|                  -0.9802038|                   -0.9974823|                   -0.9860499|                   -0.9923946|       -0.9814104|       -0.9896437|       -0.9736035|           -0.9907544|           -0.9968725|           -0.9935985|                       -0.9860288|                          -0.9860288|                           -0.9935393|               -0.9703883|                   -0.9961271|               -0.9986974|               -0.9778931|               -0.9676922|                   -0.9977742|                   -0.9888638|                   -0.9919794|       -0.9810124|       -0.9880364|       -0.9750004|                       -0.9860382|                               -0.9934959|                   -0.9677120|                       -0.9959601|           5|
| 38   |               0.2750530|              -0.0240594|              -0.1058970|                  0.9584190|                 -0.1158856|                  0.1660208|                   0.0746945|                   0.0156466|                   0.0139524|      -0.0255112|      -0.0715034|       0.0913172|          -0.0977998|          -0.0413392|          -0.0615493|                      -0.9859046|                         -0.9859046|                          -0.9894428|              -0.9849539|                  -0.9930119|              -0.9934261|              -0.9755832|              -0.9842683|                  -0.9907331|                  -0.9816001|                  -0.9886634|      -0.9942987|      -0.9889412|      -0.9735208|                      -0.9869334|                              -0.9897813|                  -0.9866731|                      -0.9939875|               -0.9952584|               -0.9719087|               -0.9836064|                  -0.9988895|                  -0.9804214|                  -0.9959686|                   -0.9906104|                   -0.9819855|                   -0.9914178|       -0.9962362|       -0.9840247|       -0.9739216|           -0.9941658|           -0.9943302|           -0.9859357|                       -0.9866453|                          -0.9866453|                           -0.9915886|               -0.9840915|                   -0.9946828|               -0.9962162|               -0.9707059|               -0.9835642|                   -0.9912876|                   -0.9838022|                   -0.9930314|       -0.9968849|       -0.9814695|       -0.9762764|                       -0.9874747|                               -0.9934574|                   -0.9847835|                       -0.9958281|           4|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 1030 |               0.3290066|              -0.0356844|              -0.1496451|                  0.9385438|                  0.0063673|                 -0.1789332|                  -0.4242391|                   0.0848721|                   0.4454491|      -0.3460062|      -0.1001175|       0.2558733|          -0.3987835|           0.0155311|           0.3131104|                       0.1337537|                          0.1337537|                          -0.1366176|              -0.2165200|                  -0.4640142|               0.1168108|              -0.3693914|               0.0438754|                  -0.0090716|                  -0.3948996|                  -0.2087566|      -0.2985454|      -0.3705377|      -0.2312237|                       0.2952835|                              -0.0254448|                  -0.4006508|                      -0.4993842|                0.2144904|               -0.3838790|                0.1322622|                  -0.9625478|                  -0.9765238|                  -0.9645855|                    0.0172334|                   -0.3678014|                   -0.2810535|       -0.4299082|       -0.3725540|       -0.3507926|           -0.4684106|           -0.4606929|           -0.4270322|                        0.2940260|                           0.2940260|                            0.0138030|               -0.3767587|                   -0.4737004|                0.2508982|               -0.4304124|                0.0915440|                   -0.0459856|                   -0.3804333|                   -0.3514508|       -0.4716962|       -0.3782066|       -0.4545078|                        0.0917138|                                0.0556383|                   -0.4677934|                       -0.4777480| WALKING\_DOWNSTAIRS |
| 723  |               0.2450766|              -0.0112263|              -0.1122059|                  0.9424548|                 -0.1559041|                 -0.1628738|                   0.3263952|                  -0.1927669|                   0.0863368|      -0.2333316|      -0.1057100|       0.2809105|          -0.2994960|          -0.0831902|          -0.0389447|                      -0.3216986|                         -0.3216986|                          -0.4353429|              -0.2422873|                  -0.6878955|              -0.3371090|              -0.3078113|              -0.4582316|                  -0.3151970|                  -0.5792644|                  -0.6202618|      -0.4871846|      -0.5613366|      -0.3662308|                      -0.3746212|                              -0.3527168|                  -0.6240294|                      -0.7300738|               -0.4322492|               -0.1850795|               -0.3723775|                  -0.9880562|                  -0.9503342|                  -0.9641103|                   -0.3087263|                   -0.5247898|                   -0.6592149|       -0.5738205|       -0.4673338|       -0.0067681|           -0.6753346|           -0.7054248|           -0.6827062|                       -0.4132909|                          -0.4132909|                           -0.3756605|               -0.5957593|                   -0.7323371|               -0.4743814|               -0.1769292|               -0.3750638|                   -0.3646896|                   -0.4970209|                   -0.6969353|       -0.6015932|       -0.4203888|       -0.0054859|                       -0.5270844|                               -0.4100446|                   -0.6454583|                       -0.7541193| WALKING\_UPSTAIRS   |
| 1283 |               0.4824902|              -0.0214894|              -0.1549800|                  0.9450757|                 -0.0814604|                  0.1611886|                   0.2279236|                  -0.1017598|                  -0.3234628|      -0.2383162|      -0.0627629|       0.1530523|          -0.5712742|           0.0032601|          -0.0766953|                       0.0076877|                          0.0076877|                          -0.2139693|              -0.2514669|                  -0.6179976|              -0.0506126|              -0.1986470|              -0.4147994|                  -0.1999269|                  -0.2438070|                  -0.6180477|       0.0118755|      -0.7017727|      -0.3299915|                      -0.0466688|                              -0.1876181|                  -0.2728524|                      -0.6783514|                0.0696075|               -0.2440873|               -0.4139813|                  -0.9610426|                  -0.9801873|                  -0.9494022|                   -0.1474590|                   -0.1501522|                   -0.6321930|       -0.1003871|       -0.6888138|       -0.5192014|           -0.5394365|           -0.8064924|           -0.2763547|                       -0.0552233|                          -0.0552233|                           -0.2751365|               -0.0764337|                   -0.6665517|                0.1134537|               -0.3174897|               -0.4608283|                   -0.1676589|                   -0.1045696|                   -0.6439367|       -0.1392436|       -0.6831814|       -0.6449734|                       -0.2069380|                               -0.4103358|                   -0.1094780|                       -0.6742635| WALKING\_DOWNSTAIRS |
| 14   |               0.2745455|               0.0104932|              -0.1431733|                  0.9739773|                 -0.0630243|                  0.1133876|                   0.1102247|                   0.0182087|                   0.2093829|       0.0753581|      -0.0664821|       0.1183577|          -0.3245140|           0.0653960|          -0.0470753|                      -0.2740105|                         -0.2740105|                          -0.3426767|              -0.4775961|                  -0.7042815|              -0.4044431|              -0.2389650|              -0.6364617|                  -0.3058288|                  -0.3461437|                  -0.7680086|      -0.3051275|      -0.6777442|      -0.6742097|                      -0.4093700|                              -0.3503689|                  -0.6293791|                      -0.7273484|               -0.3655394|               -0.1084159|               -0.6156348|                  -0.9759530|                  -0.9319836|                  -0.9647702|                   -0.2238971|                   -0.2775756|                   -0.7964965|       -0.4819998|       -0.6687851|       -0.6961071|           -0.5115689|           -0.8220385|           -0.6765882|                       -0.5078326|                          -0.5078326|                           -0.3188363|               -0.6132904|                   -0.7390730|               -0.3507370|               -0.1012446|               -0.6338413|                   -0.2083796|                   -0.2502140|                   -0.8244275|       -0.5385761|       -0.6656171|       -0.7313186|                       -0.6493840|                               -0.2830627|                   -0.6687230|                       -0.7730915| WALKING             |
| 2500 |               0.2462130|              -0.0159062|              -0.0984837|                 -0.4074765|                 -0.9457844|                  0.4271784|                   0.0794914|                   0.0024062|                  -0.0056687|      -0.0291054|      -0.0706635|       0.0876518|          -0.0895974|          -0.0497279|          -0.0566653|                      -0.9707426|                         -0.9707426|                          -0.9804433|              -0.9645028|                  -0.9711902|              -0.9726067|              -0.9789319|              -0.9818018|                  -0.9768584|                  -0.9804453|                  -0.9815922|      -0.9829568|      -0.9432990|      -0.9815500|                      -0.9764239|                              -0.9805572|                  -0.9453116|                      -0.9610044|               -0.9684202|               -0.9835842|               -0.9846911|                  -0.9572060|                  -0.9954746|                  -0.9811221|                   -0.9768781|                   -0.9802168|                   -0.9850672|       -0.9889503|       -0.9420095|       -0.9790744|           -0.9841221|           -0.9603130|           -0.9900205|                       -0.9758822|                          -0.9758822|                           -0.9837320|               -0.9457547|                   -0.9642148|               -0.9666190|               -0.9864853|               -0.9871499|                   -0.9789880|                   -0.9813258|                   -0.9873597|       -0.9910044|       -0.9415321|       -0.9799824|                       -0.9781774|                               -0.9878911|                   -0.9554537|                       -0.9713851| LAYING              |
| 118  |               0.2716253|              -0.0014598|              -0.1109923|                  0.9750397|                 -0.0848485|                 -0.0081634|                  -0.0016386|                  -0.1763964|                  -0.0811264|       0.0243686|      -0.1120053|       0.0872245|          -0.2387578|          -0.0273831|          -0.1290240|                      -0.1446517|                         -0.1446517|                          -0.3206078|              -0.3760977|                  -0.5874736|              -0.4050352|              -0.2963220|              -0.4234236|                  -0.4281748|                  -0.4616276|                  -0.5541057|      -0.4102885|      -0.5460901|      -0.2546193|                      -0.4434852|                              -0.4428304|                  -0.5930869|                      -0.7022642|               -0.2990956|               -0.2502984|               -0.0867516|                  -0.9921954|                  -0.9647390|                  -0.9798289|                   -0.3339572|                   -0.3791100|                   -0.4798502|       -0.5153778|       -0.5573359|       -0.2884570|           -0.5656877|           -0.6668109|           -0.4601215|                       -0.4868438|                          -0.4868438|                           -0.4243205|               -0.5926685|                   -0.6907256|               -0.2613583|               -0.2735346|               -0.0035158|                   -0.2987500|                   -0.3316669|                   -0.4196404|       -0.5489340|       -0.5675309|       -0.3648894|                       -0.5923390|                               -0.4047867|                   -0.6636480|                       -0.6973131| WALKING             |

We also remove "ActivityID", given that "ActivityName" is better suited for data exploration (more readable).

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels) {
  data <- add_labels(data, labels)
  data <- add_variable_names(data)
  data <- select_mean_and_std_variables(data)
  data <- normalize_variable_names(data)
  add_activity_name_variable(data, activities)
}
```

Which we can apply to the training data-set as well:

``` r
train_data <- cleanup_data(train_data, train_labels)
sample_data_frame(train_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 2036 |               0.2777111|              -0.0089315|              -0.0811814|                  0.8910283|                 -0.3671336|                 -0.0687685|                   0.0520277|                  -0.1042386|                  -0.0909499|      -0.2279948|       0.0052525|       0.1103678|           0.1218118|          -0.0213294|          -0.2090879|                      -0.2358045|                         -0.2358045|                          -0.5954524|              -0.2943468|                  -0.6742344|              -0.5742091|              -0.3848421|              -0.4859365|                  -0.6595434|                  -0.5670730|                  -0.7342482|      -0.5760956|      -0.4390538|      -0.6233700|                      -0.4516140|                              -0.6585611|                  -0.4278146|                      -0.6960186|               -0.4575580|               -0.2095642|                0.0072308|                  -0.9822345|                  -0.9844643|                  -0.9143448|                   -0.6179577|                   -0.5570419|                   -0.7467593|       -0.7038730|       -0.0855186|       -0.6634658|           -0.6714688|           -0.6716154|           -0.7399010|                       -0.3743270|                          -0.3743270|                           -0.6854429|               -0.2586867|                   -0.7121446|               -0.4177294|               -0.1787859|                0.1353357|                   -0.6089764|                   -0.5765788|                   -0.7570314|       -0.7458276|        0.0701691|       -0.7083922|                       -0.4316121|                               -0.7237921|                   -0.2790319|                       -0.7559810| WALKING\_UPSTAIRS   |
| 4729 |               0.2721000|              -0.0266719|              -0.0993193|                  0.9276938|                 -0.3059925|                 -0.0609608|                   0.0776091|                   0.0100408|                   0.0083771|      -0.0249567|      -0.0699707|       0.0931713|          -0.1005706|          -0.0403615|          -0.0588741|                      -0.9817762|                         -0.9817762|                          -0.9941765|              -0.9875934|                  -0.9966211|              -0.9968369|              -0.9867106|              -0.9832324|                  -0.9957169|                  -0.9902690|                  -0.9904148|      -0.9914652|      -0.9919408|      -0.9922156|                      -0.9874146|                              -0.9947916|                  -0.9935142|                      -0.9977818|               -0.9972134|               -0.9832463|               -0.9708188|                  -0.9931547|                  -0.9839053|                  -0.9807537|                   -0.9952495|                   -0.9904135|                   -0.9929087|       -0.9934605|       -0.9846624|       -0.9910162|           -0.9941745|           -0.9971221|           -0.9955377|                       -0.9857814|                          -0.9857814|                           -0.9953964|               -0.9908287|                   -0.9979253|               -0.9973348|               -0.9814555|               -0.9656125|                   -0.9950791|                   -0.9912922|                   -0.9942501|       -0.9940447|       -0.9812480|       -0.9912516|                       -0.9858609|                               -0.9950206|                   -0.9903432|                       -0.9979509| STANDING            |
| 3030 |               0.3894154|               0.0173679|               0.0370204|                  0.8211477|                 -0.3768333|                 -0.2070077|                   0.1509998|                  -0.2840906|                  -0.1901228|       0.3460882|      -0.5095541|      -0.3353357|          -0.3592360|          -0.1485603|          -0.0478913|                       0.3017131|                          0.3017131|                          -0.0931897|              -0.1321304|                  -0.3377628|              -0.0394049|               0.1012849|              -0.2053868|                  -0.1475674|                  -0.2889000|                  -0.3206519|      -0.2435270|      -0.2993208|      -0.2643159|                       0.0902752|                              -0.0893941|                  -0.3988729|                      -0.5117632|                0.3057882|                0.3079556|               -0.1546092|                  -0.8584734|                  -0.8462319|                  -0.7039219|                    0.0366406|                   -0.1998298|                   -0.3448587|       -0.4719878|       -0.3128546|       -0.3383676|           -0.4518092|           -0.3638992|           -0.4578548|                        0.2872734|                           0.2872734|                           -0.0098538|               -0.3981866|                   -0.5736841|                0.4189533|                0.3243980|               -0.1932345|                    0.1231725|                   -0.1559825|                   -0.3661322|       -0.5471114|       -0.3261943|       -0.4249968|                        0.1846556|                                0.0792086|                   -0.5032871|                       -0.7016986| WALKING\_DOWNSTAIRS |
| 211  |               0.2656136|              -0.0197637|              -0.1339970|                  0.9284600|                 -0.2559715|                 -0.1758436|                   0.1308725|                   0.1450059|                   0.1653887|      -0.0165832|      -0.0753408|       0.0931364|          -0.0919661|          -0.0195043|          -0.0334624|                      -0.2895340|                         -0.2895340|                          -0.2985880|              -0.4802331|                  -0.5882429|              -0.3879860|              -0.0875590|              -0.4446713|                  -0.3667504|                  -0.1150776|                  -0.5335549|      -0.5565687|      -0.5650151|      -0.4746545|                      -0.3070933|                              -0.1865134|                  -0.6159940|                      -0.6243527|               -0.4109811|               -0.0434450|               -0.4018242|                  -0.9918597|                  -0.9702630|                  -0.9657012|                   -0.3126027|                    0.0106106|                   -0.5399832|       -0.6088993|       -0.5487346|       -0.4831763|           -0.4787140|           -0.6136047|           -0.5531553|                       -0.3316912|                          -0.3316912|                           -0.1233889|               -0.6126823|                   -0.5690798|               -0.4202159|               -0.0807454|               -0.4249165|                   -0.3167942|                    0.0791238|                   -0.5444450|       -0.6267027|       -0.5420858|       -0.5331382|                       -0.4495050|                               -0.0535756|                   -0.6779765|                       -0.5340528| WALKING             |
| 11   |               0.3637475|              -0.0222834|              -0.1467803|                  0.9692942|                 -0.1817363|                  0.0131707|                  -0.1056500|                  -0.0835477|                  -0.2890772|      -0.0222872|      -0.0727086|       0.1116055|          -0.1361884|          -0.0262412|          -0.1406746|                      -0.1329420|                         -0.1329420|                          -0.1921320|              -0.3140335|                  -0.3411615|              -0.2902101|               0.0074296|              -0.0390279|                  -0.3112929|                  -0.1250208|                  -0.1897174|      -0.2805707|      -0.2214401|      -0.4071584|                      -0.1112546|                              -0.0260428|                  -0.3386921|                      -0.2565278|               -0.3267845|                0.0129155|                0.0033174|                  -0.9742230|                  -0.9900207|                  -0.9593428|                   -0.2933211|                   -0.0316393|                   -0.2376140|       -0.4733249|       -0.3133069|       -0.4261190|           -0.2526529|           -0.2695911|           -0.3781099|                       -0.1928198|                          -0.1928198|                           -0.0639180|               -0.3519403|                   -0.2008588|               -0.3416909|               -0.0481722|               -0.0530073|                   -0.3375696|                    0.0064877|                   -0.2821244|       -0.5353933|       -0.3817539|       -0.4848425|                       -0.3679189|                               -0.1200711|                   -0.4764938|                       -0.1873506| WALKING             |
| 4090 |               0.2561543|              -0.0342659|              -0.1460272|                  0.6909804|                  0.4799600|                  0.3141746|                   0.1053574|                   0.0538693|                  -0.0283712|      -0.0309818|      -0.1917132|       0.3747510|          -0.1014851|          -0.0196939|          -0.1176504|                      -0.8560875|                         -0.8560875|                          -0.9030416|              -0.8142642|                  -0.9225246|              -0.9128895|              -0.7761544|              -0.8681838|                  -0.9160320|                  -0.8532772|                  -0.9223067|      -0.8772000|      -0.8746015|      -0.8232573|                      -0.8460066|                              -0.8869073|                  -0.8486005|                      -0.9096755|               -0.9251222|               -0.7678643|               -0.8283586|                  -0.9207962|                  -0.9026991|                  -0.9642295|                   -0.9176630|                   -0.8501818|                   -0.9327352|       -0.9105171|       -0.8637200|       -0.8451214|           -0.8906577|           -0.9301329|           -0.8918239|                       -0.8453534|                          -0.8453534|                           -0.8899936|               -0.8265838|                   -0.9060809|               -0.9304586|               -0.7772723|               -0.8202982|                   -0.9271871|                   -0.8571221|                   -0.9421222|       -0.9212269|       -0.8582459|       -0.8670796|                       -0.8679601|                               -0.8933507|                   -0.8411735|                       -0.9076418| SITTING             |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

The following tables describe all the variables in the clean data-set:

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
<td>ActivityName</td>
<td>A descriptive name for the activity, i.e.: LAYING, SITTING, WALKING, WALKING_UPSTAIRS or WALKING_DOWNSTAIRS.</td>
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

The following data-set has been grouped by activity and all columns summarised into their respective means:

``` r
averages_data <- all_data %>% group_by(ActivityName) %>% summarise_each(funs(mean))
averages_data
```

| ActivityName        |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|:--------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
| LAYING              |               0.2686486|              -0.0183177|              -0.1074356|                 -0.3750213|                  0.6222704|                  0.5556125|                   0.0818474|                   0.0111724|                  -0.0048598|      -0.0167253|      -0.0934107|       0.1258851|          -0.1018643|          -0.0381981|          -0.0638498|                      -0.9411107|                         -0.9411107|                          -0.9792088|              -0.9384360|                  -0.9827266|              -0.9668121|              -0.9526784|              -0.9600180|                  -0.9801977|                  -0.9713836|                  -0.9766145|      -0.9629150|      -0.9675821|      -0.9641844|                      -0.9476727|                              -0.9743001|                  -0.9548545|                      -0.9779682|               -0.9609324|               -0.9435072|               -0.9480693|                  -0.9433197|                  -0.9631917|                  -0.9518687|                   -0.9803818|                   -0.9711476|                   -0.9794766|       -0.9678924|       -0.9631925|       -0.9635092|           -0.9761248|           -0.9804736|           -0.9847825|                       -0.9321600|                          -0.9321600|                           -0.9742406|               -0.9405961|                   -0.9767550|               -0.9590315|               -0.9424610|               -0.9456436|                   -0.9824596|                   -0.9730512|                   -0.9809719|       -0.9697473|       -0.9613654|       -0.9667252|                       -0.9349167|                               -0.9731834|                   -0.9421157|                       -0.9766482|
| SITTING             |               0.2730596|              -0.0126896|              -0.1055170|                  0.8797312|                  0.1087135|                  0.1537741|                   0.0758788|                   0.0050469|                  -0.0024867|      -0.0384313|      -0.0721208|       0.0777771|          -0.0956521|          -0.0407798|          -0.0507555|                      -0.9546439|                         -0.9546439|                          -0.9824444|              -0.9467241|                  -0.9878801|              -0.9830920|              -0.9479180|              -0.9570310|                  -0.9851888|                  -0.9739882|                  -0.9795620|      -0.9772673|      -0.9724576|      -0.9610287|                      -0.9524104|                              -0.9786844|                  -0.9642961|                      -0.9853356|               -0.9834462|               -0.9348806|               -0.9389816|                  -0.9796822|                  -0.9576727|                  -0.9473574|                   -0.9849972|                   -0.9738832|                   -0.9822965|       -0.9810222|       -0.9667081|       -0.9580075|           -0.9857051|           -0.9865023|           -0.9838055|                       -0.9393242|                          -0.9393242|                           -0.9789071|               -0.9511990|                   -0.9846076|               -0.9837473|               -0.9325335|               -0.9343367|                   -0.9861850|                   -0.9757509|                   -0.9836708|       -0.9823333|       -0.9640337|       -0.9610302|                       -0.9420002|                               -0.9781548|                   -0.9516417|                       -0.9844914|
| STANDING            |               0.2791535|              -0.0161519|              -0.1065869|                  0.9414796|                 -0.1842465|                 -0.0140520|                   0.0750279|                   0.0088053|                  -0.0045821|      -0.0266871|      -0.0677119|       0.0801422|          -0.0997293|          -0.0423171|          -0.0520955|                      -0.9541797|                         -0.9541797|                          -0.9771180|              -0.9421525|                  -0.9786971|              -0.9816223|              -0.9431324|              -0.9573597|                  -0.9800087|                  -0.9645474|                  -0.9761578|      -0.9436543|      -0.9653028|      -0.9583850|                      -0.9558681|                              -0.9710904|                  -0.9479085|                      -0.9748860|               -0.9844347|               -0.9325087|               -0.9399135|                  -0.9880152|                  -0.9693518|                  -0.9530825|                   -0.9799686|                   -0.9643428|                   -0.9794859|       -0.9455284|       -0.9612933|       -0.9570531|           -0.9669579|           -0.9802633|           -0.9770671|                       -0.9465348|                          -0.9465348|                           -0.9714530|               -0.9295312|                   -0.9735286|               -0.9858598|               -0.9311330|               -0.9354396|                   -0.9818261|                   -0.9668316|                   -0.9815093|       -0.9469716|       -0.9594986|       -0.9606892|                       -0.9496016|                               -0.9709480|                   -0.9306367|                       -0.9734611|
| WALKING             |               0.2763369|              -0.0179068|              -0.1088817|                  0.9349916|                 -0.1967135|                 -0.0538251|                   0.0767187|                   0.0115062|                  -0.0023194|      -0.0347276|      -0.0694200|       0.0863626|          -0.0943007|          -0.0445701|          -0.0540065|                      -0.1679379|                         -0.1679379|                          -0.2414520|              -0.2748660|                  -0.4605115|              -0.2978909|              -0.0423392|              -0.3418407|                  -0.3111274|                  -0.1703951|                  -0.4510105|      -0.3482374|      -0.3883849|      -0.3104062|                      -0.2755581|                              -0.2146540|                  -0.4091730|                      -0.5155168|               -0.3146445|               -0.0235829|               -0.2739208|                  -0.9776121|                  -0.9669039|                  -0.9545976|                   -0.2672882|                   -0.1031411|                   -0.4791471|       -0.4699148|       -0.3479218|       -0.3384486|           -0.3762214|           -0.5126191|           -0.4474272|                       -0.3377540|                          -0.3377540|                           -0.2145559|               -0.3826290|                   -0.4988410|               -0.3228358|               -0.0772063|               -0.2960783|                   -0.2878977|                   -0.0908699|                   -0.5063291|       -0.5104320|       -0.3319615|       -0.4105691|                       -0.4800023|                               -0.2216178|                   -0.4738331|                       -0.5144048|
| WALKING\_DOWNSTAIRS |               0.2881372|              -0.0163119|              -0.1057616|                  0.9264574|                 -0.1685072|                 -0.0479709|                   0.0892267|                   0.0007467|                  -0.0087286|      -0.0840345|      -0.0529929|       0.0946782|          -0.0728532|          -0.0512640|          -0.0546962|                       0.1012497|                          0.1012497|                          -0.1118018|              -0.1297856|                  -0.4168916|               0.0352597|               0.0566827|              -0.2137292|                  -0.0722968|                  -0.1163806|                  -0.3331903|      -0.2179229|      -0.3175927|      -0.1656251|                       0.1428494|                               0.0047625|                  -0.2895258|                      -0.4380073|                0.1007663|                0.0595486|               -0.1908045|                  -0.9497488|                  -0.9342661|                  -0.9124606|                   -0.0338826|                   -0.0736744|                   -0.3886661|       -0.3338175|       -0.3396314|       -0.2728099|           -0.3826898|           -0.4659438|           -0.3264560|                        0.1164889|                           0.1164889|                           -0.0112207|               -0.2514278|                   -0.4409293|                0.1219380|               -0.0082337|               -0.2458729|                   -0.0821905|                   -0.0914165|                   -0.4435547|       -0.3751275|       -0.3618537|       -0.3804100|                       -0.0754252|                               -0.0422714|                   -0.3612310|                       -0.4864430|
| WALKING\_UPSTAIRS   |               0.2622946|              -0.0259233|              -0.1205379|                  0.8750034|                 -0.2813772|                 -0.1407957|                   0.0767293|                   0.0087589|                  -0.0060095|       0.0068245|      -0.0885225|       0.0598938|          -0.1121175|          -0.0386193|          -0.0525810|                      -0.1002041|                         -0.1002041|                          -0.3909386|              -0.1782811|                  -0.6080471|              -0.2934068|              -0.1349505|              -0.3681221|                  -0.3898968|                  -0.3646668|                  -0.5916701|      -0.3942482|      -0.4592535|      -0.2968577|                      -0.2620281|                              -0.3539620|                  -0.4497814|                      -0.6586945|               -0.2379897|               -0.0160325|               -0.1754497|                  -0.9481913|                  -0.9255493|                  -0.9019056|                   -0.3608634|                   -0.3392265|                   -0.6270636|       -0.4676071|       -0.3442318|       -0.2371368|           -0.5531328|           -0.6673392|           -0.5609892|                       -0.2498752|                          -0.2498752|                           -0.3854004|               -0.3371421|                   -0.6668367|               -0.2188880|               -0.0218110|               -0.1466018|                   -0.3889928|                   -0.3576329|                   -0.6615908|       -0.4952540|       -0.2931818|       -0.2920413|                       -0.3617535|                               -0.4342067|                   -0.3814064|                       -0.7030835|

Saving Resulting Data to Disk
-----------------------------

Let's finally save our clean data-sets to `*.csv` files:

``` r
dir.create("./tidy_data")
write.csv(all_data, "./tidy_data/activity_data.csv")
write.csv(averages_data, "./tidy_data/activity_averages_data.csv")
```
