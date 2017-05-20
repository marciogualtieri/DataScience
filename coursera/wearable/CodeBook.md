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

    ## [1] "fBodyAccJerk-energy()-Z"       "tBodyAcc-iqr()-Y"             
    ## [3] "tBodyGyro-arCoeff()-X,4"       "fBodyGyro-bandsEnergy()-17,32"
    ## [5] "fBodyAcc-mean()-X"             "tGravityAccMag-arCoeff()1"

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

    ## [1] "fBodyGyro-mad()-Y"       "fBodyAcc-std()-Z"       
    ## [3] "tBodyGyro-entropy()-X"   "tBodyAcc-mad()-Y"       
    ## [5] "tBodyGyro-arCoeff()-X,3" "tGravityAcc-iqr()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyBodyGyroJerkMag-mean()" "tBodyGyro-mean()-Y"         
    ## [3] "fBodyGyro-mean()-Z"          "fBodyAccJerk-mean()-Y"      
    ## [5] "tBodyGyroJerkMag-mean()"     "tBodyGyroMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyGyro-std()-X"     "tBodyAccJerk-std()-Z"  "tBodyGyroJerk-std()-X"
    ## [4] "tBodyAccJerk-std()-X"  "tBodyAccJerk-std()-Y"  "tBodyGyroJerk-std()-Z"

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

    ## [1] "fBodyAcc-maxInds-X"    "fBodyAccJerk-mad()-X"  "tBodyAcc-iqr()-Y"     
    ## [4] "fBodyGyro-entropy()-X" "tBodyAccJerk-mad()-Z"  "tBodyAccJerkMag-min()"

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
| 405  |               0.2641377|              -0.0546549|              -0.1110134|                  0.9598510|                 -0.1091563|                  0.1400058|                   0.1074303|                   0.1145023|                  -0.1591320|      -0.0581108|      -0.0730075|       0.0711921|           0.1193434|          -0.1742035|          -0.1307436|                      -0.3512214|                         -0.3512214|                          -0.3982708|              -0.5442318|                  -0.6970095|              -0.4513402|              -0.1862851|              -0.5886816|                  -0.3784225|                  -0.2623854|                  -0.6897189|      -0.4376779|      -0.7077765|      -0.4820996|                      -0.4727352|                              -0.3534551|                  -0.6437444|                      -0.7266056|               -0.4705818|               -0.1424962|               -0.5441817|                  -0.9912066|                  -0.9534236|                  -0.9749317|                   -0.3398787|                   -0.2134073|                   -0.7128441|       -0.5750578|       -0.6949017|       -0.5890085|           -0.5505680|           -0.8200337|           -0.5336622|                       -0.5091266|                          -0.5091266|                           -0.2965909|               -0.6470845|                   -0.7109242|               -0.4782722|               -0.1736786|               -0.5550235|                   -0.3576615|                   -0.2115769|                   -0.7338380|       -0.6188292|       -0.6892493|       -0.6684781|                       -0.6067160|                               -0.2333290|                   -0.7116519|                       -0.7110522|           1|
| 2638 |               0.2932802|              -0.0155786|              -0.1113484|                 -0.3967447|                  0.7314866|                  0.6967293|                   0.0655356|                   0.0038574|                  -0.0022641|      -0.0387723|      -0.0622523|       0.0579205|          -0.1010003|          -0.0375974|          -0.0545585|                      -0.9801711|                         -0.9801711|                          -0.9916035|              -0.9650490|                  -0.9889036|              -0.9823319|              -0.9887156|              -0.9895139|                  -0.9897355|                  -0.9895155|                  -0.9903969|      -0.9881987|      -0.9757714|      -0.9912759|                      -0.9869141|                              -0.9927298|                  -0.9827414|                      -0.9918519|               -0.9747472|               -0.9906686|               -0.9894899|                  -0.9834509|                  -0.9972361|                  -0.9983180|                   -0.9904156|                   -0.9899407|                   -0.9913988|       -0.9913138|       -0.9576142|       -0.9940962|           -0.9880725|           -0.9888249|           -0.9894620|                       -0.9870595|                          -0.9870595|                           -0.9930586|               -0.9788723|                   -0.9922054|               -0.9718625|               -0.9913169|               -0.9894017|                   -0.9921766|                   -0.9912547|                   -0.9908288|       -0.9922739|       -0.9494705|       -0.9959320|                       -0.9881347|                               -0.9920906|                   -0.9796118|                       -0.9928413|           6|
| 1557 |               0.2784643|              -0.0168905|              -0.1070468|                  0.8937376|                  0.1773440|                  0.2559646|                   0.0729495|                   0.0129820|                   0.0104538|      -0.0276529|      -0.0671041|       0.0805937|          -0.0986716|          -0.0411568|          -0.0531701|                      -0.9961490|                         -0.9961490|                          -0.9922394|              -0.9953180|                  -0.9952853|              -0.9962499|              -0.9924848|              -0.9853751|                  -0.9943922|                  -0.9904970|                  -0.9865472|      -0.9936436|      -0.9933622|      -0.9953352|                      -0.9957074|                              -0.9918452|                  -0.9935174|                      -0.9945447|               -0.9975699|               -0.9951798|               -0.9884707|                  -0.9996025|                  -0.9991035|                  -0.9980781|                   -0.9945851|                   -0.9908190|                   -0.9887798|       -0.9957242|       -0.9944777|       -0.9968824|           -0.9935530|           -0.9942205|           -0.9947161|                       -0.9963306|                          -0.9963306|                           -0.9925892|               -0.9943885|                   -0.9946684|               -0.9983311|               -0.9961190|               -0.9908505|                   -0.9953154|                   -0.9919225|                   -0.9896208|       -0.9964089|       -0.9952780|       -0.9978854|                       -0.9965948|                               -0.9924295|                   -0.9960991|                       -0.9948413|           4|
| 512  |               0.2778048|              -0.0363238|              -0.1044729|                  0.9767756|                 -0.0307699|                  0.0320873|                   0.0751169|                   0.0347098|                   0.0018910|      -0.0571509|      -0.0839815|       0.0921816|          -0.0751087|          -0.0382961|          -0.0654855|                      -0.9609332|                         -0.9609332|                          -0.9572331|              -0.9444888|                  -0.9770963|              -0.9816491|              -0.8972278|              -0.9735315|                  -0.9763237|                  -0.9027250|                  -0.9738039|      -0.9466530|      -0.9741986|      -0.9272455|                      -0.9357565|                              -0.9379828|                  -0.9551335|                      -0.9772310|               -0.9854165|               -0.9133614|               -0.9771936|                  -0.9969578|                  -0.9428106|                  -0.9941983|                   -0.9745548|                   -0.9009011|                   -0.9783856|       -0.9530997|       -0.9683742|       -0.9302570|           -0.9686636|           -0.9868123|           -0.9516476|                       -0.9425768|                          -0.9425768|                           -0.9348657|               -0.9337707|                   -0.9736724|               -0.9871796|               -0.9279056|               -0.9807902|                   -0.9748114|                   -0.9057554|                   -0.9818560|       -0.9551806|       -0.9652847|       -0.9374993|                       -0.9548672|                               -0.9296184|                   -0.9320606|                       -0.9707431|           4|
| 209  |               0.2707704|              -0.0188854|              -0.1040902|                 -0.4593212|                  0.7332384|                  0.6783482|                   0.0755252|                   0.0105757|                  -0.0114940|      -0.0283931|      -0.0570248|       0.0499493|          -0.0990160|          -0.0367509|          -0.0499940|                      -0.9909906|                         -0.9909906|                          -0.9904951|              -0.9804604|                  -0.9946827|              -0.9908491|              -0.9880871|              -0.9874424|                  -0.9922056|                  -0.9866888|                  -0.9867369|      -0.9931800|      -0.9887286|      -0.9892076|                      -0.9944646|                              -0.9910488|                  -0.9917205|                      -0.9952993|               -0.9902649|               -0.9902661|               -0.9896069|                  -0.9947991|                  -0.9971174|                  -0.9948662|                   -0.9922895|                   -0.9868130|                   -0.9893584|       -0.9942761|       -0.9856854|       -0.9893559|           -0.9951429|           -0.9938448|           -0.9928804|                       -0.9954516|                          -0.9954516|                           -0.9923320|               -0.9893827|                   -0.9954619|               -0.9898520|               -0.9910880|               -0.9911432|                   -0.9930783|                   -0.9879206|                   -0.9907064|       -0.9945542|       -0.9839857|       -0.9902382|                       -0.9961417|                               -0.9932257|                   -0.9893451|                       -0.9956519|           6|
| 852  |               0.2956966|              -0.0323754|              -0.1126734|                  0.9152734|                  0.0442359|                 -0.2448515|                   0.0519369|                  -0.0477233|                   0.1202490|      -0.4104918|      -0.0475123|       0.3789626|           0.2214342|          -0.0822536|          -0.2237600|                      -0.0301836|                         -0.0301836|                          -0.1657409|              -0.1864709|                  -0.4253172|              -0.3207025|              -0.2975185|              -0.1999731|                  -0.3355508|                  -0.3825851|                  -0.3548410|      -0.3133305|      -0.3187586|      -0.2514793|                      -0.3526410|                              -0.3353668|                  -0.4304645|                      -0.4744801|               -0.1818442|               -0.2300163|                0.0652704|                  -0.9748505|                  -0.9653738|                  -0.9823780|                   -0.1728865|                   -0.2815821|                   -0.3480680|       -0.5206291|       -0.3781887|       -0.2310244|           -0.4595982|           -0.4118944|           -0.4674818|                       -0.3622867|                          -0.3622867|                           -0.2941802|               -0.4422900|                   -0.4683046|               -0.1330887|               -0.2441477|                0.1142520|                   -0.0911262|                   -0.2214302|                   -0.3408324|       -0.5887753|       -0.4223797|       -0.2946400|                       -0.4664967|                               -0.2481342|                   -0.5497887|                       -0.4950934|           1|

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
| 2721 |               0.2857677|              -0.0630353|              -0.0074548|                 -0.4573016|                  0.8499338|                  0.5510535|                   0.1051072|                   0.0315005|                  -0.1107544|       0.1664038|      -0.1490503|       0.3144883|          -0.0934151|          -0.0370321|          -0.0962127|                      -0.8470551|                         -0.8470551|                          -0.9356053|              -0.7587659|                  -0.9655152|              -0.9386888|              -0.8298002|              -0.8449903|                  -0.9384576|                  -0.8916621|                  -0.9446861|      -0.9193110|      -0.9388435|      -0.9222423|                      -0.8323882|                              -0.9137326|                  -0.9203434|                      -0.9608406|               -0.9501049|               -0.7741139|               -0.7868692|                  -0.8795852|                  -0.8585278|                  -0.7922790|                   -0.9428178|                   -0.8957562|                   -0.9507168|       -0.8917249|       -0.9337193|       -0.9218289|           -0.9632180|           -0.9636125|           -0.9627433|                       -0.7582678|                          -0.7582678|                           -0.9167735|               -0.8285078|                   -0.9635480|               -0.9553555|               -0.7622288|               -0.7735367|                   -0.9537598|                   -0.9088949|                   -0.9552713|       -0.8873617|       -0.9310773|       -0.9286504|                       -0.7613397|                               -0.9199446|                   -0.8116722|                       -0.9696831| LAYING            |
| 1423 |               0.2767329|              -0.0215761|              -0.1103425|                  0.7812271|                  0.3171604|                  0.3531460|                   0.0873920|                   0.0255470|                   0.0250936|      -0.0584905|      -0.2856322|       0.2789970|          -0.0953402|          -0.0249762|          -0.0916126|                      -0.9740161|                         -0.9740161|                          -0.9863523|              -0.8671050|                  -0.9917610|              -0.9824826|              -0.9679112|              -0.9752058|                  -0.9830429|                  -0.9786808|                  -0.9895838|      -0.9841434|      -0.9756387|      -0.9484855|                      -0.9728824|                              -0.9832583|                  -0.9532172|                      -0.9890724|               -0.9866002|               -0.9592053|               -0.9563328|                  -0.9714368|                  -0.9638535|                  -0.9408215|                   -0.9804562|                   -0.9810569|                   -0.9909956|       -0.9870472|       -0.9731072|       -0.9442921|           -0.9883630|           -0.9903628|           -0.9920208|                       -0.9679938|                          -0.9679938|                           -0.9826234|               -0.9345327|                   -0.9897286|               -0.9886130|               -0.9565101|               -0.9493297|                   -0.9793401|                   -0.9859902|                   -0.9908950|       -0.9878970|       -0.9716991|       -0.9478331|                       -0.9690046|                               -0.9801655|                   -0.9339820|                       -0.9910864| SITTING           |
| 2514 |               0.2719252|              -0.0173087|              -0.1067741|                 -0.4000404|                  0.9623633|                 -0.2203401|                   0.0816580|                   0.0025551|                   0.0081604|      -0.0298670|      -0.0597412|       0.0894424|          -0.0905125|          -0.0389881|          -0.0577293|                      -0.9795972|                         -0.9795972|                          -0.9869191|              -0.9790737|                  -0.9857962|              -0.9832636|              -0.9825137|              -0.9816550|                  -0.9850138|                  -0.9825959|                  -0.9902782|      -0.9765584|      -0.9788074|      -0.9738845|                      -0.9852885|                              -0.9901302|                  -0.9743963|                      -0.9875324|               -0.9821973|               -0.9868995|               -0.9671110|                  -0.9783614|                  -0.9965819|                  -0.9889724|                   -0.9850414|                   -0.9823342|                   -0.9917954|       -0.9794222|       -0.9775520|       -0.9746595|           -0.9840794|           -0.9857873|           -0.9849121|                       -0.9842167|                          -0.9842167|                           -0.9915408|               -0.9653202|                   -0.9878151|               -0.9815773|               -0.9894560|               -0.9612401|                   -0.9864154|                   -0.9832369|                   -0.9918406|       -0.9802869|       -0.9768469|       -0.9770849|                       -0.9848932|                               -0.9925416|                   -0.9652196|                       -0.9886887| LAYING            |
| 660  |               0.3031577|              -0.0561523|              -0.1737002|                  0.8384558|                 -0.2938702|                 -0.3447863|                  -0.1708101|                  -0.3279542|                  -0.0103464|       0.1867483|      -0.2058336|       0.0387084|          -0.2183058|           0.1443181|          -0.3740059|                      -0.2622264|                         -0.2622264|                          -0.5585216|              -0.2737906|                  -0.6490175|              -0.3879509|              -0.2575683|              -0.4540719|                  -0.5024705|                  -0.5819874|                  -0.6508643|      -0.5299424|      -0.4357554|      -0.3172994|                      -0.4373394|                              -0.4797553|                  -0.5129882|                      -0.6500598|               -0.4148757|               -0.1749731|               -0.1916033|                  -0.9718055|                  -0.9353622|                  -0.9124774|                   -0.4984430|                   -0.5779662|                   -0.6613518|       -0.5260458|       -0.4231586|       -0.1767357|           -0.6936375|           -0.6096969|           -0.7201334|                       -0.3646408|                          -0.3646408|                           -0.4852662|               -0.4712625|                   -0.6394037|               -0.4257411|               -0.1853097|               -0.1301391|                   -0.5398020|                   -0.6035522|                   -0.6695883|       -0.5307886|       -0.4195324|       -0.2107956|                       -0.4255373|                               -0.4952211|                   -0.5331086|                       -0.6498042| WALKING\_UPSTAIRS |
| 38   |               0.2409014|              -0.0247903|              -0.1131304|                  0.9441640|                 -0.2377381|                  0.0989030|                   0.0340761|                   0.3292747|                   0.2252930|      -0.0477398|       0.0148103|       0.0295721|          -0.0357102|          -0.0863980|           0.1599277|                      -0.3616579|                         -0.3616579|                          -0.4438938|              -0.5231851|                  -0.6620826|              -0.4311131|              -0.2594080|              -0.5715853|                  -0.4594508|                  -0.3842871|                  -0.6651078|      -0.5826335|      -0.6749559|      -0.5167108|                      -0.4845472|                              -0.4952130|                  -0.6652558|                      -0.7809343|               -0.4332419|               -0.2603923|               -0.5659554|                  -0.9814735|                  -0.9927648|                  -0.9749916|                   -0.4361904|                   -0.3642209|                   -0.7119687|       -0.6800089|       -0.5308266|       -0.5566982|           -0.5238157|           -0.7655106|           -0.7058152|                       -0.5265091|                          -0.5265091|                           -0.5122768|               -0.6235746|                   -0.7917987|               -0.4339862|               -0.3073505|               -0.5972903|                   -0.4616232|                   -0.3854796|                   -0.7601211|       -0.7109465|       -0.4637554|       -0.6110485|                       -0.6249736|                               -0.5376400|                   -0.6595255|                       -0.8219670| WALKING           |
| 2063 |               0.2775314|              -0.0052639|              -0.0875871|                  0.9621052|                 -0.2050368|                  0.0687491|                   0.0769767|                   0.0172515|                   0.0111455|      -0.0185880|      -0.0586638|       0.0619912|          -0.1066706|          -0.0428473|          -0.0531478|                      -0.9668814|                         -0.9668814|                          -0.9708068|              -0.9531696|                  -0.9746168|              -0.9857911|              -0.9379921|              -0.9769402|                  -0.9801583|                  -0.9491267|                  -0.9806384|      -0.9238552|      -0.9790225|      -0.9666514|                      -0.9639218|                              -0.9695803|                  -0.9388535|                      -0.9695790|               -0.9893459|               -0.9340469|               -0.9761963|                  -0.9993668|                  -0.9807406|                  -0.9760868|                   -0.9804924|                   -0.9434964|                   -0.9827068|       -0.9345868|       -0.9789505|       -0.9714220|           -0.9395703|           -0.9871027|           -0.9756688|                       -0.9588418|                          -0.9588418|                           -0.9691515|               -0.9234658|                   -0.9640904|               -0.9911252|               -0.9350857|               -0.9767079|                   -0.9826640|                   -0.9408434|                   -0.9832244|       -0.9380254|       -0.9789575|       -0.9757172|                       -0.9611956|                               -0.9670706|                   -0.9263097|                       -0.9596741| STANDING          |

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
| 3633 |               0.2785833|              -0.0097765|              -0.1034639|                  0.8189727|                  0.3307127|                  0.2470286|                   0.0743854|                   0.0158069|                  -0.0137821|      -0.0481870|      -0.0629497|       0.2268403|          -0.0902473|          -0.0431416|          -0.0961978|                      -0.9878558|                         -0.9878558|                          -0.9946246|              -0.9352313|                  -0.9971308|              -0.9960339|              -0.9798608|              -0.9948355|                  -0.9958294|                  -0.9869983|                  -0.9942095|      -0.9891227|      -0.9936215|      -0.9488618|                      -0.9920992|                              -0.9951636|                  -0.9645171|                      -0.9963183|               -0.9965290|               -0.9709772|               -0.9956304|                  -0.9958866|                  -0.9705910|                  -0.9824360|                   -0.9959393|                   -0.9864870|                   -0.9955056|       -0.9900201|       -0.9935224|       -0.9483367|           -0.9974338|           -0.9960767|           -0.9941229|                       -0.9908970|                          -0.9908970|                           -0.9951994|               -0.9508847|                   -0.9959187|               -0.9967005|               -0.9676035|               -0.9956635|                   -0.9964377|                   -0.9867676|                   -0.9953791|       -0.9902458|       -0.9934116|       -0.9526916|                       -0.9904713|                               -0.9936564|                   -0.9505343|                       -0.9952092| SITTING             |
| 817  |               0.2959585|              -0.0147006|              -0.1134236|                  0.9271949|                 -0.1685741|                 -0.1678744|                   0.6729306|                  -0.0727133|                  -0.0364116|      -0.1851934|      -0.0633199|       0.1131542|           0.3390388|           0.2038182|           0.4351184|                       0.1298033|                          0.1298033|                           0.2534949|               0.3282657|                   0.0828918|               0.1193218|               0.2920361|               0.0538729|                   0.1325081|                   0.1725483|                   0.0472085|       0.3782230|       0.2844820|       0.1193428|                       0.2167606|                               0.2853454|                   0.2245392|                       0.1382318|                0.0005031|                0.2549591|                0.0231641|                  -0.9867175|                  -0.9865286|                  -0.9815143|                    0.2473206|                    0.2687478|                   -0.0139786|        0.0913075|        0.2599613|       -0.0653265|            0.1151215|            0.1485653|           -0.1293711|                        0.0151176|                           0.0151176|                            0.2508125|                0.1879322|                    0.1017317|               -0.0502704|                0.1547034|               -0.0800144|                    0.2558985|                    0.2906549|                   -0.0712003|        0.0002400|        0.2355776|       -0.2199624|                       -0.2764344|                                0.1956165|                   -0.0502808|                       -0.0228867| WALKING             |
| 2444 |               0.3597172|              -0.0470390|              -0.2034393|                  0.8432148|                 -0.2688316|                 -0.3729390|                   0.0460508|                  -0.0033197|                   0.1995952|      -0.3036744|       0.0312553|       0.2626218|           0.0597360|           0.2958850|          -0.1603841|                       0.1622144|                          0.1622144|                           0.0493650|               0.2841305|                  -0.2549128|               0.1866806|               0.3737641|               0.3450629|                   0.1828935|                   0.2187313|                   0.0483001|      -0.1078051|       0.2656518|       0.3913309|                       0.5565055|                               0.3937277|                   0.1199514|                       0.0166887|               -0.0067600|                0.3885544|                0.4351335|                  -0.9519666|                  -0.9476966|                  -0.9204094|                    0.1212393|                    0.2311276|                   -0.1110049|       -0.1636101|        0.2521619|        0.2520733|           -0.3930223|           -0.0856902|           -0.0107132|                        0.4312318|                           0.4312318|                            0.3715287|                0.1127970|                    0.0492660|               -0.0942198|                0.3082890|                0.3709463|                   -0.0599612|                    0.1571852|                   -0.2816815|       -0.1871552|        0.2348961|        0.0883727|                        0.1323450|                                0.3321561|                   -0.0883979|                        0.0181002| WALKING\_DOWNSTAIRS |
| 3755 |               0.2793224|              -0.0181304|              -0.1058189|                  0.8392390|                  0.1760858|                  0.3851819|                   0.0781868|                   0.0116966|                  -0.0011593|      -0.0267431|      -0.0695640|       0.0815886|          -0.0988174|          -0.0431863|          -0.0552914|                      -0.9958019|                         -0.9958019|                          -0.9948813|              -0.9967969|                  -0.9980096|              -0.9973304|              -0.9877332|              -0.9928160|                  -0.9964503|                  -0.9884408|                  -0.9944566|      -0.9963947|      -0.9965248|      -0.9949424|                      -0.9952550|                              -0.9966458|                  -0.9985695|                      -0.9977943|               -0.9978027|               -0.9890416|               -0.9914746|                  -0.9982104|                  -0.9974129|                  -0.9944939|                   -0.9964965|                   -0.9875690|                   -0.9956197|       -0.9975481|       -0.9970252|       -0.9956341|           -0.9966678|           -0.9977965|           -0.9961745|                       -0.9958752|                          -0.9958752|                           -0.9966696|               -0.9978808|                   -0.9982097|               -0.9980021|               -0.9893796|               -0.9903431|                   -0.9968598|                   -0.9873124|                   -0.9953340|       -0.9979193|       -0.9973438|       -0.9962402|                       -0.9961676|                               -0.9953058|                   -0.9975198|                       -0.9986631| SITTING             |
| 4567 |               0.2827730|              -0.0146648|              -0.0834082|                  0.9660039|                  0.0506238|                 -0.0904628|                   0.0763038|                   0.0084129|                  -0.0289793|      -0.0278575|      -0.0872034|       0.0896185|          -0.0993316|          -0.0472367|          -0.0526724|                      -0.9558826|                         -0.9558826|                          -0.9874105|              -0.9802819|                  -0.9884184|              -0.9952128|              -0.9857508|              -0.9520620|                  -0.9947199|                  -0.9883052|                  -0.9783161|      -0.9926152|      -0.9758712|      -0.9924134|                      -0.9590741|                              -0.9862959|                  -0.9800420|                      -0.9854829|               -0.9955097|               -0.9844573|               -0.9024471|                  -0.9930185|                  -0.9871430|                  -0.9108154|                   -0.9942084|                   -0.9888490|                   -0.9802948|       -0.9947441|       -0.9710406|       -0.9938185|           -0.9934316|           -0.9827938|           -0.9926732|                       -0.9443280|                          -0.9443280|                           -0.9870414|               -0.9809136|                   -0.9842508|               -0.9955497|               -0.9836353|               -0.8870089|                   -0.9940813|                   -0.9904109|                   -0.9806768|       -0.9954089|       -0.9684402|       -0.9948921|                       -0.9443599|                               -0.9867586|                   -0.9848462|                       -0.9833134| SITTING             |
| 497  |               0.2786868|              -0.0186642|              -0.1201425|                  0.9437249|                 -0.2287607|                 -0.1227394|                  -0.1204058|                   0.0529623|                   0.2911675|      -0.1152374|       0.0138105|       0.1466181|          -0.0976121|          -0.0322147|           0.2899869|                      -0.2996089|                         -0.2996089|                          -0.3945943|              -0.4095513|                  -0.6126819|              -0.3736962|              -0.2557877|              -0.4737803|                  -0.4254014|                  -0.3930038|                  -0.6318043|      -0.4067381|      -0.5986361|      -0.2779059|                      -0.4575710|                              -0.4915294|                  -0.5918478|                      -0.6042023|               -0.4038941|               -0.2221204|               -0.4202889|                  -0.9855943|                  -0.9725215|                  -0.9564168|                   -0.3969421|                   -0.3242752|                   -0.6780178|       -0.5375897|       -0.5705621|       -0.3547340|           -0.3831352|           -0.7386720|           -0.5352366|                       -0.5168344|                          -0.5168344|                           -0.5011745|               -0.5851980|                   -0.6237723|               -0.4161250|               -0.2533590|               -0.4360133|                   -0.4202785|                   -0.2938583|                   -0.7243729|       -0.5791119|       -0.5570389|       -0.4409295|                       -0.6284941|                               -0.5102541|                   -0.6523496|                       -0.6782838| WALKING             |

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

Saving Resulting Data to Disk
-----------------------------

Let's finally save our clean data-sets to `*.csv` files:

``` r
write.csv(all_data, "./tidy_data/activity_data.csv")
write.csv(averages_data, "./tidy_data/activity_averages_data.csv")
```
