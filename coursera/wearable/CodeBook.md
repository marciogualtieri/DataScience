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

    ## [1] "tBodyGyroJerk-mean()-X"         "tGravityAcc-arCoeff()-Z,3"     
    ## [3] "tGravityAcc-min()-X"            "tGravityAcc-arCoeff()-X,4"     
    ## [5] "fBodyBodyGyroJerkMag-entropy()" "tBodyGyro-arCoeff()-Z,2"

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

    ## [1] "tGravityAcc-iqr()-X"          "fBodyBodyGyroJerkMag-maxInds"
    ## [3] "tGravityAcc-arCoeff()-X,3"    "fBodyBodyAccJerkMag-energy()"
    ## [5] "tBodyAccJerk-iqr()-X"         "tBodyGyro-std()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyroJerkMag-mean()" "tBodyGyro-mean()-X"     
    ## [3] "fBodyAccJerk-mean()-Z"   "fBodyAcc-mean()-X"      
    ## [5] "fBodyAccMag-mean()"      "tBodyAccJerk-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "tGravityAcc-std()-X"   "fBodyGyro-std()-Z"     "tBodyGyroJerk-std()-X"
    ## [4] "tBodyAcc-std()-Y"      "tBodyGyro-std()-Y"     "tBodyAccJerk-std()-X"

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

    ## [1] "fBodyAcc-max()-Z"          "tBodyGyroJerkMag-sma()"   
    ## [3] "tGravityAccMag-arCoeff()1" "tBodyAccJerk-std()-Y"     
    ## [5] "tGravityAcc-energy()-X"    "fBodyAcc-max()-Y"

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
| 364  |               0.2764281|              -0.0166219|              -0.1091813|                 -0.4358038|                  0.8748380|                  0.4645182|                   0.0717087|                   0.0035040|                   0.0080267|      -0.0285126|      -0.0681482|       0.0835327|          -0.0978523|          -0.0430676|          -0.0506685|                      -0.9890297|                         -0.9890297|                          -0.9904445|              -0.9793959|                  -0.9959243|              -0.9921443|              -0.9843748|              -0.9878957|                  -0.9944484|                  -0.9826906|                  -0.9897249|      -0.9921258|      -0.9855868|      -0.9957620|                      -0.9905412|                              -0.9923977|                  -0.9876293|                      -0.9960011|               -0.9884484|               -0.9880544|               -0.9834039|                  -0.9928084|                  -0.9981123|                  -0.9930036|                   -0.9940157|                   -0.9824252|                   -0.9911925|       -0.9909995|       -0.9703497|       -0.9968163|           -0.9950187|           -0.9946235|           -0.9970939|                       -0.9905337|                          -0.9905337|                           -0.9931286|               -0.9810877|                   -0.9963409|               -0.9868565|               -0.9900383|               -0.9810794|                   -0.9939990|                   -0.9833220|                   -0.9911654|       -0.9906846|       -0.9637732|       -0.9975379|                       -0.9910036|                               -0.9929638|                   -0.9800080|                       -0.9967997|           6|
| 1440 |               0.3101509|              -0.0193809|              -0.1245277|                 -0.3898287|                  0.9654301|                 -0.2017490|                   0.0867090|                  -0.0088666|                   0.0092497|      -0.0117866|      -0.0723190|       0.1879241|          -0.1250290|          -0.0475644|          -0.1026299|                      -0.9634195|                         -0.9634195|                          -0.9609237|              -0.9353714|                  -0.9657130|              -0.9657583|              -0.9498915|              -0.9630029|                  -0.9603088|                  -0.9452981|                  -0.9594244|      -0.9532447|      -0.9512470|      -0.9122810|                      -0.9623935|                              -0.9554944|                  -0.9363539|                      -0.9613492|               -0.9732241|               -0.9590301|               -0.9663660|                  -0.9779661|                  -0.9923420|                  -0.9824149|                   -0.9631093|                   -0.9483421|                   -0.9655114|       -0.9681313|       -0.9570005|       -0.9116424|           -0.9706306|           -0.9600218|           -0.9687916|                       -0.9697854|                          -0.9697854|                           -0.9563445|               -0.9207041|                   -0.9625867|               -0.9767947|               -0.9663430|               -0.9705317|                   -0.9701376|                   -0.9563605|                   -0.9704470|       -0.9730687|       -0.9612286|       -0.9193194|                       -0.9789725|                               -0.9561746|                   -0.9238086|                       -0.9660458|           6|
| 2049 |               0.2754460|              -0.0213429|              -0.1085156|                  0.9391022|                 -0.2100177|                 -0.1791656|                   0.0703805|                   0.0249381|                   0.0076044|      -0.0150660|      -0.0759667|       0.0832001|          -0.1044768|          -0.0372731|          -0.0528742|                      -0.9810894|                         -0.9810894|                          -0.9908625|              -0.9767862|                  -0.9925176|              -0.9916793|              -0.9794653|              -0.9831750|                  -0.9900563|                  -0.9858675|                  -0.9913183|      -0.9862426|      -0.9827400|      -0.9852292|                      -0.9858211|                              -0.9922533|                  -0.9848462|                      -0.9937427|               -0.9922899|               -0.9745036|               -0.9642744|                  -0.9948355|                  -0.9840307|                  -0.9772819|                   -0.9903874|                   -0.9857081|                   -0.9927639|       -0.9851623|       -0.9766278|       -0.9842859|           -0.9928134|           -0.9919053|           -0.9914776|                       -0.9796041|                          -0.9796041|                           -0.9934412|               -0.9792299|                   -0.9943319|               -0.9924500|               -0.9725538|               -0.9568832|                   -0.9916683|                   -0.9865091|                   -0.9927476|       -0.9849292|       -0.9734628|       -0.9852236|                       -0.9781575|                               -0.9937010|                   -0.9789000|                       -0.9953403|           5|
| 1051 |               0.3686838|               0.0042524|              -0.1574773|                  0.9278786|                 -0.2780127|                  0.0286913|                   0.3251510|                  -0.2523396|                  -0.0111135|       0.0498686|      -0.1962954|       0.0993927|          -0.2491385|           0.0234477|          -0.0737290|                      -0.1082864|                         -0.1082864|                          -0.3475623|              -0.0786705|                  -0.5718183|              -0.1499970|              -0.0157387|              -0.5077995|                  -0.2482967|                  -0.2108307|                  -0.6890252|      -0.2474457|      -0.3771794|      -0.1996146|                      -0.2347854|                              -0.1871636|                  -0.3071777|                      -0.6842392|               -0.2238081|                0.0380033|               -0.2799751|                  -0.9761235|                  -0.9667923|                  -0.9113891|                   -0.2695742|                   -0.1655233|                   -0.7255495|       -0.3589787|       -0.0740186|       -0.1396246|           -0.4728352|           -0.6897266|           -0.5023472|                       -0.2609545|                          -0.2609545|                           -0.2501294|               -0.1695747|                   -0.7229947|               -0.2548199|                0.0004185|               -0.2271923|                   -0.3627849|                   -0.1711569|                   -0.7615217|       -0.3953751|        0.0649159|       -0.1994344|                       -0.3907228|                               -0.3436118|                   -0.2210664|                       -0.8015481|           2|
| 414  |               0.2840204|              -0.0157178|              -0.0873318|                  0.9584667|                 -0.1152078|                  0.1313813|                   0.0519019|                   0.2337285|                  -0.1435989|       0.0157220|      -0.1106603|       0.0663449|          -0.1002906|          -0.1094106|          -0.0571980|                      -0.3321678|                         -0.3321678|                          -0.3972728|              -0.5544935|                  -0.6920850|              -0.4331622|              -0.2172194|              -0.5825495|                  -0.3382736|                  -0.3030135|                  -0.7041658|      -0.4733357|      -0.6814635|      -0.5566647|                      -0.5036298|                              -0.2927297|                  -0.6704985|                      -0.7326364|               -0.4573512|               -0.1524857|               -0.5439532|                  -0.9845208|                  -0.9836388|                  -0.9881282|                   -0.3235516|                   -0.2989389|                   -0.7165567|       -0.5869800|       -0.6604946|       -0.6440863|           -0.5273815|           -0.8051928|           -0.6267160|                       -0.5830618|                          -0.5830618|                           -0.3541700|               -0.6205917|                   -0.7365315|               -0.4671034|               -0.1726862|               -0.5580076|                   -0.3686687|                   -0.3447509|                   -0.7266700|       -0.6230229|       -0.6504606|       -0.7105344|                       -0.7001741|                               -0.4429774|                   -0.6516980|                       -0.7604300|           1|
| 2676 |               0.2736793|              -0.0226344|              -0.1015416|                  0.9669988|                 -0.1011350|                 -0.1246482|                   0.1147401|                  -0.0137722|                   0.0424547|      -0.0395180|      -0.0769023|       0.1098940|          -0.0754520|          -0.0840171|          -0.1009850|                      -0.3234178|                         -0.3234178|                          -0.4149264|              -0.4401830|                  -0.5651959|              -0.5676400|              -0.2976396|              -0.3774359|                  -0.5500562|                  -0.4524386|                  -0.4694687|      -0.5628251|      -0.5076829|      -0.4798338|                      -0.4587416|                              -0.4294931|                  -0.6162855|                      -0.6327846|               -0.4866976|               -0.1694495|               -0.2890834|                  -0.9873698|                  -0.9686669|                  -0.9769189|                   -0.4860632|                   -0.3842211|                   -0.4467971|       -0.6102974|       -0.4998604|       -0.4420611|           -0.6412348|           -0.5333435|           -0.6312834|                       -0.4535165|                          -0.4535165|                           -0.3960820|               -0.6303322|                   -0.5937596|               -0.4579031|               -0.1598568|               -0.2968077|                   -0.4666296|                   -0.3507405|                   -0.4258689|       -0.6267750|       -0.4985764|       -0.4810907|                       -0.5349736|                               -0.3593644|                   -0.7068136|                       -0.5712634|           1|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel     |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 882  |               0.2708122|              -0.0357390|              -0.0770988|                  0.9399274|                 -0.2691961|                  0.0139472|                  -0.1513061|                   0.0071824|                  -0.1344923|       0.2673928|      -0.2949259|       0.1435523|          -0.1858254|          -0.0208436|          -0.3783820|                      -0.0597472|                         -0.0597472|                          -0.3210986|               0.1230732|                  -0.5036327|              -0.1793944|              -0.0429947|              -0.4130055|                  -0.2566368|                  -0.2643506|                  -0.6224381|      -0.1295500|      -0.3048524|      -0.1132805|                      -0.1470443|                              -0.1385232|                  -0.1654658|                      -0.6187392|               -0.1981690|                0.0731391|               -0.1526957|                  -0.9652525|                  -0.9534068|                  -0.9094823|                   -0.2259274|                   -0.1893630|                   -0.6655988|       -0.1323277|        0.0269617|       -0.0968411|           -0.3353035|           -0.6364037|           -0.4616761|                       -0.2229149|                          -0.2229149|                           -0.2198685|                0.0170958|                   -0.6344017|               -0.2056384|                0.0632633|               -0.0938484|                   -0.2622040|                   -0.1606757|                   -0.7082289|       -0.1434542|        0.1794162|       -0.1739866|                       -0.3899168|                               -0.3423641|                   -0.0380522|                       -0.6828683| WALKING\_UPSTAIRS |
| 347  |               0.3578298|              -0.0135190|              -0.1312716|                  0.9175639|                 -0.3476580|                  0.0247333|                   0.1670412|                  -0.2494590|                  -0.0203950|      -0.0247019|      -0.0884329|       0.0275960|          -0.2090761|           0.1212508|          -0.2661790|                      -0.3219591|                         -0.3219591|                          -0.3156813|              -0.5078510|                  -0.6205158|              -0.3605449|              -0.1200438|              -0.4438267|                  -0.3100527|                  -0.2176860|                  -0.5615223|      -0.5213903|      -0.6232268|      -0.3559163|                      -0.3910312|                              -0.2214231|                  -0.6191444|                      -0.7052561|               -0.4524211|               -0.1497959|               -0.4016534|                  -0.9546441|                  -0.9674112|                  -0.9772299|                   -0.2847004|                   -0.1662301|                   -0.6007529|       -0.6313242|       -0.6077765|       -0.4494047|           -0.4960690|           -0.7489839|           -0.4929908|                       -0.4523385|                          -0.4523385|                           -0.2660081|               -0.6442109|                   -0.7124614|               -0.4931278|               -0.2199579|               -0.4251551|                   -0.3215543|                   -0.1648317|                   -0.6381317|       -0.6662322|       -0.6011945|       -0.5340678|                       -0.5749828|                               -0.3298675|                   -0.7281045|                       -0.7415100| WALKING           |
| 871  |               0.3492413|              -0.0096153|              -0.1086138|                  0.9115734|                 -0.2240710|                 -0.2365209|                  -0.0191936|                  -0.5067258|                  -0.1372521|      -0.0577370|      -0.1046518|       0.2949491|          -0.1991355|          -0.0491046|          -0.0907053|                      -0.2204354|                         -0.2204354|                          -0.4980906|              -0.5001413|                  -0.6494810|              -0.4539318|              -0.0976979|              -0.3124988|                  -0.5780672|                  -0.5098281|                  -0.4361141|      -0.5836278|      -0.5639806|      -0.4100566|                      -0.3629786|                              -0.4640309|                  -0.6162065|                      -0.6334398|               -0.3815359|               -0.0207746|               -0.2653186|                  -0.9734033|                  -0.9116978|                  -0.9560680|                   -0.5674606|                   -0.4994555|                   -0.4992568|       -0.6768748|       -0.5838692|       -0.3752657|           -0.6614222|           -0.6442927|           -0.5943067|                       -0.3535070|                          -0.3535070|                           -0.4816908|               -0.5995190|                   -0.6428144|               -0.3550848|               -0.0431998|               -0.2970052|                   -0.5949539|                   -0.5227983|                   -0.5621459|       -0.7064435|       -0.5995717|       -0.4212686|                       -0.4482502|                               -0.5059767|                   -0.6568528|                       -0.6804831| WALKING\_UPSTAIRS |
| 724  |               0.2587512|              -0.0184846|              -0.1200327|                  0.9407900|                 -0.1494667|                 -0.1764073|                  -0.1866124|                   0.1290696|                   0.0895915|      -0.3983830|       0.0503031|       0.2384666|          -0.0117734|          -0.0056383|          -0.0999537|                      -0.4048874|                         -0.4048874|                          -0.5337189|              -0.2288774|                  -0.7158180|              -0.4690980|              -0.4364857|              -0.5519912|                  -0.4913694|                  -0.6058333|                  -0.6635717|      -0.5515989|      -0.6167732|      -0.4667937|                      -0.4486804|                              -0.4393261|                  -0.6207083|                      -0.7762683|               -0.4990374|               -0.2676332|               -0.4457524|                  -0.9912728|                  -0.9478340|                  -0.9294282|                   -0.4166975|                   -0.5886447|                   -0.6967505|       -0.5647388|       -0.5169502|       -0.1085935|           -0.6732672|           -0.7526176|           -0.6914993|                       -0.4554393|                          -0.4554393|                           -0.4330129|               -0.5403523|                   -0.7659598|               -0.5112292|               -0.2365711|               -0.4333492|                   -0.3928442|                   -0.5973408|                   -0.7284721|       -0.5730155|       -0.4677295|       -0.1008283|                       -0.5434053|                               -0.4283461|                   -0.5662916|                       -0.7688021| WALKING\_UPSTAIRS |
| 2464 |               0.2947908|              -0.0224683|              -0.1232778|                 -0.3802240|                  0.9641601|                 -0.2058526|                   0.0548419|                   0.0110209|                   0.0014831|      -0.0355709|      -0.0949116|       0.0819192|          -0.1160821|          -0.0397027|          -0.0618749|                      -0.9695844|                         -0.9695844|                          -0.9714191|              -0.9603851|                  -0.9713813|              -0.9645578|              -0.9687292|              -0.9735191|                  -0.9700548|                  -0.9646474|                  -0.9752173|      -0.9646482|      -0.9634970|      -0.9410838|                      -0.9728813|                              -0.9707657|                  -0.9597775|                      -0.9747211|               -0.9710484|               -0.9740654|               -0.9759496|                  -0.9648527|                  -0.9902150|                  -0.9698829|                   -0.9697456|                   -0.9633187|                   -0.9799562|       -0.9752086|       -0.9683537|       -0.9395395|           -0.9724033|           -0.9713622|           -0.9677187|                       -0.9761218|                          -0.9761218|                           -0.9731331|               -0.9589190|                   -0.9746678|               -0.9740062|               -0.9779205|               -0.9786915|                   -0.9721105|                   -0.9642540|                   -0.9836865|       -0.9786427|       -0.9719407|       -0.9443696|                       -0.9810407|                               -0.9751842|                   -0.9652755|                       -0.9758511| LAYING            |
| 2109 |               0.2781106|              -0.0155696|              -0.1130526|                  0.9393606|                 -0.2111589|                 -0.1772955|                   0.0817314|                   0.0022816|                  -0.0130002|      -0.0298879|      -0.0799156|       0.0842839|          -0.0966941|          -0.0450527|          -0.0531629|                      -0.9929674|                         -0.9929674|                          -0.9921215|              -0.9901481|                  -0.9940139|              -0.9924753|              -0.9822356|              -0.9902852|                  -0.9900587|                  -0.9849926|                  -0.9930363|      -0.9873025|      -0.9892124|      -0.9942380|                      -0.9916795|                              -0.9931347|                  -0.9908172|                      -0.9905459|               -0.9939937|               -0.9856840|               -0.9900436|                  -0.9950556|                  -0.9921604|                  -0.9891153|                   -0.9908989|                   -0.9855603|                   -0.9947795|       -0.9885433|       -0.9916232|       -0.9955305|           -0.9924473|           -0.9915475|           -0.9942974|                       -0.9924047|                          -0.9924047|                           -0.9935192|               -0.9901487|                   -0.9913473|               -0.9946922|               -0.9876174|               -0.9897598|                   -0.9928385|                   -0.9873827|                   -0.9951999|       -0.9888793|       -0.9935258|       -0.9964450|                       -0.9931928|                               -0.9927446|                   -0.9911631|                       -0.9928347| STANDING          |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 7043 |               0.1927777|              -0.0321007|              -0.0979518|                 -0.6176453|                  0.4277900|                  0.9250111|                   0.0880930|                   0.0049736|                  -0.0385136|      -0.0017479|      -0.0238998|       0.1006324|          -0.1055954|          -0.0714495|          -0.0430052|                      -0.9186787|                         -0.9186787|                          -0.9616820|              -0.9191537|                  -0.9672488|              -0.9593891|              -0.9017094|              -0.9515849|                  -0.9706184|                  -0.9471867|                  -0.9640488|      -0.9341957|      -0.9372021|      -0.9542701|                      -0.9268927|                              -0.9634766|                  -0.9355322|                      -0.9551903|               -0.9600085|               -0.8613917|               -0.9535996|                  -0.8983418|                  -0.9048820|                  -0.9449175|                   -0.9726966|                   -0.9399127|                   -0.9693720|       -0.9319600|       -0.9337161|       -0.9522105|           -0.9482766|           -0.9646891|           -0.9724833|                       -0.9107390|                          -0.9107390|                           -0.9630172|               -0.9283643|                   -0.9554736|               -0.9600832|               -0.8513239|               -0.9578026|                   -0.9779142|                   -0.9357370|                   -0.9734815|       -0.9321144|       -0.9319958|       -0.9557101|                       -0.9151216|                               -0.9609598|                   -0.9354669|                       -0.9586332| LAYING              |
| 2756 |               0.2077579|              -0.0083759|              -0.0983270|                  0.9462867|                 -0.2305354|                 -0.0692752|                  -0.3430520|                   0.1137843|                   0.1040574|       0.0886841|      -0.1708923|       0.0754432|           0.0440543|          -0.0731414|           0.0409137|                       0.0583703|                          0.0583703|                          -0.3638405|              -0.1078496|                  -0.6233163|              -0.0535680|              -0.1709842|              -0.4571601|                  -0.2933292|                  -0.4452391|                  -0.5888715|      -0.2662089|      -0.5009853|      -0.3263205|                      -0.0473842|                              -0.3070439|                  -0.4485446|                      -0.6452637|                0.0724841|               -0.0010964|               -0.4391792|                  -0.9557709|                  -0.9278544|                  -0.9594695|                   -0.2400389|                   -0.4290218|                   -0.6499456|       -0.0995882|       -0.4519690|       -0.4186546|           -0.6068037|           -0.6727916|           -0.4839508|                       -0.0854231|                          -0.0854231|                           -0.3336153|               -0.3114088|                   -0.6598532|                0.1183220|                0.0168082|               -0.4735286|                   -0.2513348|                   -0.4502821|                   -0.7139780|       -0.0761251|       -0.4275468|       -0.5054878|                       -0.2497039|                               -0.3735670|                   -0.3409406|                       -0.7048244| WALKING\_DOWNSTAIRS |
| 2200 |               0.0479261|              -0.0668853|              -0.0819557|                  0.7075597|                 -0.2811303|                 -0.5363142|                   0.1584796|                   0.0926321|                  -0.0343943|       0.3585465|      -0.3611395|      -0.4232647|          -0.2828362|          -0.0798068|           0.1413323|                       0.2156691|                          0.2156691|                          -0.3162610|               0.3656803|                  -0.3813360|              -0.3861604|               0.0100258|               0.2739887|                  -0.4292641|                  -0.4307780|                  -0.2371175|      -0.4307022|       0.1211937|       0.1580248|                      -0.0410028|                              -0.2991412|                   0.0540917|                      -0.4680323|               -0.3067434|                0.3497995|                0.7740259|                  -0.8283053|                  -0.8332498|                  -0.8180784|                   -0.4138724|                   -0.4169725|                   -0.3042663|       -0.4720120|        0.4975649|        0.4232703|           -0.5958247|           -0.3764042|           -0.3034812|                        0.0147652|                           0.0147652|                           -0.3583842|                0.2851452|                   -0.4908327|               -0.2777157|                0.4164697|                0.8778262|                   -0.4499527|                   -0.4420676|                   -0.3692124|       -0.4883525|        0.6782131|        0.3697528|                       -0.1130600|                               -0.4474653|                    0.2155843|                       -0.5599635| WALKING\_UPSTAIRS   |
| 4124 |               0.2647107|              -0.0085731|              -0.0850964|                  0.9321882|                  0.1145528|                  0.2148802|                   0.0748268|                   0.0153306|                   0.0198009|      -0.0277957|      -0.0579460|       0.0797453|          -0.0981168|          -0.0497149|          -0.0469465|                      -0.9715334|                         -0.9715334|                          -0.9937683|              -0.9824378|                  -0.9963476|              -0.9949115|              -0.9856175|              -0.9778606|                  -0.9950059|                  -0.9916921|                  -0.9901576|      -0.9981274|      -0.9831158|      -0.9891057|                      -0.9781224|                              -0.9937977|                  -0.9901364|                      -0.9964675|               -0.9941160|               -0.9750083|               -0.9572021|                  -0.9891171|                  -0.9834055|                  -0.9616114|                   -0.9951936|                   -0.9911494|                   -0.9912312|       -0.9989246|       -0.9761712|       -0.9868619|           -0.9976249|           -0.9950407|           -0.9949115|                       -0.9707375|                          -0.9707375|                           -0.9939324|               -0.9842769|                   -0.9966859|               -0.9936166|               -0.9708398|               -0.9494853|                   -0.9958639|                   -0.9910492|                   -0.9907430|       -0.9992299|       -0.9726460|       -0.9871301|                       -0.9700943|                               -0.9926999|                   -0.9830879|                       -0.9969038| SITTING             |
| 1330 |               0.3935921|              -0.0287921|              -0.1400612|                  0.9024400|                 -0.3209572|                  0.0988327|                  -0.4314904|                  -0.0639754|                   0.3016814|      -0.4242029|       0.4145585|      -0.0253435|          -0.3556140|           0.2878947|           0.1191863|                       0.0599692|                          0.0599692|                          -0.2219177|              -0.1283485|                  -0.5915103|               0.0436819|              -0.1304576|              -0.4719243|                  -0.1807871|                  -0.2399426|                  -0.6826788|      -0.3321361|      -0.3347896|      -0.5298074|                      -0.1383022|                              -0.2357490|                  -0.3586858|                      -0.6895482|                0.0568259|               -0.0926677|               -0.2996889|                  -0.9527988|                  -0.9875705|                  -0.9566168|                   -0.1290419|                   -0.2058792|                   -0.7155443|       -0.5054838|       -0.1014115|       -0.5941987|           -0.4267135|           -0.6951503|           -0.6314760|                       -0.1305386|                          -0.1305386|                           -0.3253407|               -0.1635305|                   -0.6976165|                0.0620046|               -0.1300341|               -0.2677265|                   -0.1515822|                   -0.2216622|                   -0.7471421|       -0.5610425|        0.0102117|       -0.6547319|                       -0.2611228|                               -0.4655835|                   -0.1843046|                       -0.7301211| WALKING\_UPSTAIRS   |
| 2637 |               0.2064892|              -0.0418149|              -0.1000732|                  0.8984892|                 -0.0475094|                  0.3329084|                   0.0563893|                  -0.1486170|                  -0.1004459|      -0.3211405|       0.0605765|      -0.0900574|          -0.1504226|           0.1112298|          -0.2335192|                      -0.2819021|                         -0.2819021|                          -0.5405096|              -0.3512487|                  -0.7180363|              -0.5191246|              -0.1446704|              -0.5377258|                  -0.6469426|                  -0.3378857|                  -0.6670694|      -0.3964832|      -0.6927464|      -0.5058793|                      -0.3419774|                              -0.4752561|                  -0.5713424|                      -0.7480033|               -0.3466796|               -0.1664352|               -0.4590039|                  -0.9664904|                  -0.9548266|                  -0.9705161|                   -0.6090827|                   -0.3007801|                   -0.6897389|       -0.4736928|       -0.5895067|       -0.5188353|           -0.5004786|           -0.8631663|           -0.6618294|                       -0.3574250|                          -0.3574250|                           -0.4618731|               -0.5144177|                   -0.7360056|               -0.2898882|               -0.2309996|               -0.4587720|                   -0.6044201|                   -0.3064506|                   -0.7101237|       -0.4995498|       -0.5397537|       -0.5670199|                       -0.4657903|                               -0.4480284|                   -0.5588642|                       -0.7389292| WALKING\_DOWNSTAIRS |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

Here's a full description of the variables from the clean data-set:

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

> **Note:**
>
> Acceleration Units: Number of g's.
>
> Prefix 't' stands for "time domain signal", 'f' for "frequency domain signal".

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

> **Note:**
>
> "Acceleration Jerk" or simply [jerk](https://en.wikipedia.org/wiki/Jerk_(physics)) is the rate of change of the acceleration.
>
> Jerk Units: Number of g's per second.

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

> **Note:**
>
> Giro (Angular Velocity) Units: radians per second.

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
