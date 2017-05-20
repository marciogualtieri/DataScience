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

    ## [1] "fBodyBodyGyroMag-min()"       "fBodyAcc-bandsEnergy()-49,56"
    ## [3] "tBodyAccJerk-entropy()-Z"     "tBodyAccMag-min()"           
    ## [5] "fBodyAcc-bandsEnergy()-33,40" "tBodyAccJerkMag-iqr()"

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

    ## [1] "fBodyAcc-bandsEnergy()-17,32"     "fBodyAccMag-max()"               
    ## [3] "tBodyAccJerk-iqr()-X"             "tBodyGyroJerkMag-entropy()"      
    ## [5] "fBodyAccJerk-bandsEnergy()-41,48" "tBodyGyro-entropy()-Z"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyro-mean()-Z"     "tBodyAccJerkMag-mean()"
    ## [3] "tBodyGyroMag-mean()"    "fBodyAcc-mean()-Y"     
    ## [5] "tBodyGyroJerk-mean()-X" "tGravityAcc-mean()-Z"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyGyro-std()-Z"      "tBodyGyroJerk-std()-Z" 
    ## [3] "fBodyGyro-std()-Y"      "tBodyGyroJerkMag-std()"
    ## [5] "tBodyAccJerk-std()-X"   "tGravityAcc-std()-X"

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

    ## [1] "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mad()" 
    ## [3] "tGravityAcc-arCoeff()-X,4"   "fBodyGyro-energy()-Z"       
    ## [5] "tBodyGyroJerk-arCoeff()-Z,3" "tBodyGyro-arCoeff()-Y,1"

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
| 2118 |               0.2640983|              -0.0183000|              -0.1046518|                 -0.2087194|                  0.5285877|                  0.8474578|                   0.0670960|                   0.0202800|                  -0.0120010|      -0.0325619|      -0.0520776|       0.0690722|          -0.0935611|          -0.0431205|          -0.0459464|                      -0.9788238|                         -0.9788238|                          -0.9724294|              -0.9751512|                  -0.9823327|              -0.9717180|              -0.9699305|              -0.9720303|                  -0.9685357|                  -0.9745400|                  -0.9710700|      -0.9832914|      -0.9596933|      -0.9821383|                      -0.9617119|                              -0.9622768|                  -0.9584351|                      -0.9680394|               -0.9768757|               -0.9710846|               -0.9743124|                  -0.9946328|                  -0.9918574|                  -0.9930034|                   -0.9654365|                   -0.9733666|                   -0.9715971|       -0.9868738|       -0.9611621|       -0.9871604|           -0.9895308|           -0.9699139|           -0.9840863|                       -0.9681508|                          -0.9681508|                           -0.9613524|               -0.9561674|                   -0.9661079|               -0.9792185|               -0.9724598|               -0.9770698|                   -0.9650970|                   -0.9737616|                   -0.9704029|       -0.9879467|       -0.9622928|       -0.9904998|                       -0.9767050|                               -0.9586075|                   -0.9619183|                       -0.9655269|           6|
| 887  |               0.1756404|              -0.0370761|              -0.0812766|                  0.8650070|                  0.1093554|                 -0.3737907|                  -0.1623275|                   0.1261425|                   0.0087471|      -0.6620260|       0.0317180|       0.5256766|           0.4082985|          -0.3198038|          -0.1555002|                      -0.1228173|                         -0.1228173|                          -0.3489265|               0.1297856|                  -0.6095571|              -0.2217048|              -0.5058024|              -0.3896400|                  -0.3402346|                  -0.6049348|                  -0.6573555|      -0.1920802|      -0.3572196|      -0.2630199|                      -0.3215116|                              -0.3999037|                  -0.5388225|                      -0.6651968|               -0.1817443|               -0.4793113|               -0.1173588|                  -0.8646120|                  -0.9425366|                  -0.8436677|                   -0.2050214|                   -0.5931842|                   -0.6656331|       -0.3727707|       -0.2110516|       -0.1800193|           -0.6073328|           -0.6402872|           -0.6025501|                       -0.3709659|                          -0.3709659|                           -0.4220980|               -0.4437370|                   -0.6910390|               -0.1664415|               -0.4978351|               -0.0557288|                   -0.1435737|                   -0.6080663|                   -0.6717733|       -0.4300442|       -0.1383798|       -0.2294654|                       -0.4981342|                               -0.4553088|                   -0.4764544|                       -0.7523195|           2|
| 2251 |               0.2285333|               0.0855130|              -0.0452300|                  0.8825972|                  0.1167872|                  0.3138642|                   0.1263749|                  -0.3878326|                  -0.2898022|      -0.0366585|      -0.2919409|       0.3447834|          -0.0996261|          -0.0236603|          -0.0437349|                      -0.6549599|                         -0.6549599|                          -0.9642142|              -0.8340943|                  -0.9822749|              -0.9410401|              -0.4317794|              -0.6759550|                  -0.9730790|                  -0.9371416|                  -0.9763051|      -0.9764171|      -0.9490870|      -0.9283376|                      -0.4681307|                              -0.9548995|                  -0.9471258|                      -0.9838068|               -0.9276004|               -0.2638655|               -0.5244166|                  -0.8869164|                  -0.3910564|                  -0.4744386|                   -0.9739547|                   -0.9352344|                   -0.9782654|       -0.9759694|       -0.9283429|       -0.8896369|           -0.9874876|           -0.9823714|           -0.9731137|                       -0.3854996|                          -0.3854996|                           -0.9515105|               -0.9078127|                   -0.9841553|               -0.9225813|               -0.2332523|               -0.4884157|                   -0.9774198|                   -0.9374804|                   -0.9786026|       -0.9759995|       -0.9183394|       -0.8892611|                       -0.4385546|                               -0.9458168|                   -0.9017072|                       -0.9853030|           4|
| 385  |               0.3091540|               0.0460809|              -0.0984161|                  0.9652376|                 -0.1368131|                  0.1480570|                   0.3347958|                  -0.0629238|                   0.0794469|      -0.2520436|       0.0271988|      -0.0496601|          -0.0714277|          -0.0270497|           0.1399443|                      -0.4214858|                         -0.4214858|                          -0.4980485|              -0.5339307|                  -0.7338656|              -0.4385988|              -0.3501213|              -0.6188078|                  -0.4130347|                  -0.5302113|                  -0.7274779|      -0.5653412|      -0.7425160|      -0.5652233|                      -0.5303499|                              -0.3911774|                  -0.6409762|                      -0.7983645|               -0.5277761|               -0.2705913|               -0.5737605|                  -0.9826984|                  -0.8731078|                  -0.9287349|                   -0.3761940|                   -0.4952134|                   -0.7401925|       -0.6195202|       -0.6863227|       -0.6549465|           -0.6508779|           -0.8066263|           -0.6865271|                       -0.5694686|                          -0.5694686|                           -0.4025767|               -0.5849949|                   -0.8011374|               -0.5678562|               -0.2766423|               -0.5819889|                   -0.3925560|                   -0.4899849|                   -0.7506255|       -0.6377293|       -0.6582046|       -0.7216137|                       -0.6596047|                               -0.4199930|                   -0.6182778|                       -0.8188453|           1|
| 105  |               0.1844141|              -0.0148179|              -0.0899920|                  0.9261126|                 -0.3548413|                  0.0233719|                  -0.1287982|                   0.0319305|                   0.1913706|      -0.0670622|      -0.0056268|       0.1261364|          -0.0834902|          -0.1740704|          -0.1208502|                      -0.2956644|                         -0.2956644|                          -0.3365339|              -0.4852432|                  -0.6528186|              -0.3164953|              -0.1086630|              -0.4293593|                  -0.3057132|                  -0.1532754|                  -0.5687611|      -0.5646965|      -0.5929677|      -0.4558270|                      -0.3911505|                              -0.2279587|                  -0.6191281|                      -0.7019066|               -0.4224949|               -0.1432774|               -0.4027901|                  -0.9690812|                  -0.9567231|                  -0.9868208|                   -0.3055466|                   -0.1282333|                   -0.6179659|       -0.6067851|       -0.5482719|       -0.5152900|           -0.5234706|           -0.7431781|           -0.5603396|                       -0.4628134|                          -0.4628134|                           -0.2287282|               -0.6054764|                   -0.6920269|               -0.4699836|               -0.2167005|               -0.4350706|                   -0.3692242|                   -0.1604314|                   -0.6667684|       -0.6218668|       -0.5258062|       -0.5807255|                       -0.5910066|                               -0.2347810|                   -0.6640574|                       -0.7006225|           1|
| 637  |               0.2828743|              -0.0142516|              -0.1164122|                  0.9603631|                 -0.0377584|                  0.1635651|                   0.0747525|                   0.0102065|                  -0.0021666|      -0.0702632|      -0.0632065|       0.0650331|          -0.2331238|          -0.0420983|          -0.0970252|                      -0.9709342|                         -0.9709342|                          -0.9854829|              -0.8080415|                  -0.9718590|              -0.9908360|              -0.9490828|              -0.9809357|                  -0.9890090|                  -0.9740273|                  -0.9842477|      -0.7127756|      -0.9771864|      -0.9124434|                      -0.9657701|                              -0.9854056|                  -0.7535393|                      -0.9710036|               -0.9927223|               -0.9167183|               -0.9783484|                  -0.9944052|                  -0.9850297|                  -0.9884996|                   -0.9885647|                   -0.9762652|                   -0.9871631|       -0.6881395|       -0.9687260|       -0.8740078|           -0.9372448|           -0.9901160|           -0.9833286|                       -0.9492845|                          -0.9492845|                           -0.9868791|               -0.6052608|                   -0.9691833|               -0.9935988|               -0.9073753|               -0.9775291|                   -0.9890363|                   -0.9812369|                   -0.9888142|       -0.6863378|       -0.9644534|       -0.8748542|                       -0.9479043|                               -0.9878718|                   -0.5891105|                       -0.9685610|           5|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 1649 |               0.2770200|              -0.0199000|              -0.1007201|                  0.9568341|                  0.1076679|                  0.0529396|                   0.0787492|                  -0.0006465|                  -0.0373478|      -0.0251511|      -0.0895570|       0.0879358|          -0.1029283|          -0.0345281|          -0.0442392|                      -0.9652047|                         -0.9652047|                          -0.9891845|              -0.9723894|                  -0.9859799|              -0.9898958|              -0.9580616|              -0.9527015|                  -0.9886910|                  -0.9793993|                  -0.9839736|      -0.9715814|      -0.9767624|      -0.9634885|                      -0.9694437|                              -0.9833506|                  -0.9708372|                      -0.9886152|               -0.9918447|               -0.9457158|               -0.9338428|                  -0.9949108|                  -0.9862838|                  -0.9552447|                   -0.9890048|                   -0.9812316|                   -0.9867920|       -0.9770787|       -0.9717077|       -0.9602685|           -0.9789514|           -0.9894634|           -0.9808904|                       -0.9538793|                          -0.9538793|                           -0.9823281|               -0.9581275|                   -0.9872692|               -0.9927304|               -0.9422432|               -0.9281800|                   -0.9903884|                   -0.9852681|                   -0.9883061|       -0.9787524|       -0.9689974|       -0.9626602|                       -0.9522185|                               -0.9793510|                   -0.9572252|                       -0.9859877| SITTING             |
| 2    |               0.3030672|               0.0127648|              -0.1033752|                  0.9674838|                 -0.1680465|                 -0.0282326|                   0.2775016|                  -0.1256202|                   0.0735889|      -0.1411640|       0.0498838|       0.1397864|           0.0932458|           0.0355635|          -0.2788687|                      -0.0568100|                         -0.0568100|                          -0.1394843|              -0.3650093|                  -0.4726148|               0.0155167|              -0.0140541|              -0.6324985|                  -0.0161298|                  -0.0745953|                  -0.6811182|      -0.3390762|      -0.4432528|      -0.4167212|                      -0.1773898|                               0.0447923|                  -0.3998214|                      -0.4889963|               -0.0660317|               -0.0304508|               -0.5827277|                  -0.9901322|                  -0.9448946|                  -0.9612657|                   -0.0010316|                    0.0431680|                   -0.7065072|       -0.5552255|       -0.3272860|       -0.5306225|           -0.1887758|           -0.5883038|           -0.5108557|                       -0.2331146|                          -0.2331146|                           -0.0331408|               -0.3977941|                   -0.4970244|               -0.1001234|               -0.1007077|               -0.5877984|                   -0.0749342|                    0.1020370|                   -0.7297922|       -0.6278379|       -0.2693344|       -0.6176036|                       -0.3854335|                               -0.1488781|                   -0.5019008|                       -0.5433076| WALKING             |
| 1291 |               0.5783997|               0.0098835|              -0.1308594|                  0.9010351|                  0.0592145|                  0.0724969|                   0.0981013|                  -0.0888774|                   0.2670294|      -0.6851467|      -0.2701138|       0.0423196|          -0.1145099|           0.0266305|          -0.3730920|                       0.2914567|                          0.2914567|                           0.1245564|               0.0454257|                  -0.3965600|               0.3253335|              -0.0281339|              -0.2061462|                   0.2888282|                  -0.1039586|                  -0.3103089|      -0.3399216|      -0.2745545|      -0.0020636|                       0.2763527|                               0.2227717|                  -0.3260614|                      -0.4732019|                0.3419237|               -0.0629206|               -0.1305350|                  -0.9069324|                  -0.9201511|                  -0.9486942|                    0.3631455|                   -0.0723166|                   -0.3886364|       -0.3767024|       -0.3150234|       -0.1515589|           -0.4538176|           -0.4530337|           -0.2464869|                        0.1812834|                           0.1812834|                            0.1613692|               -0.2093813|                   -0.5110510|                0.3483506|               -0.1415574|               -0.1572932|                    0.3207850|                   -0.1005633|                   -0.4671490|       -0.3930187|       -0.3461442|       -0.2843423|                       -0.0595864|                                0.0689565|                   -0.2670052|                       -0.6030139| WALKING\_DOWNSTAIRS |
| 2622 |               0.2756931|              -0.0183959|              -0.1043269|                 -0.1123235|                  0.4460589|                  0.8643144|                   0.0793901|                   0.0144016|                  -0.0244688|      -0.0268256|      -0.0779136|       0.0858935|          -0.1006037|          -0.0332946|          -0.0552068|                      -0.9519534|                         -0.9519534|                          -0.9903802|              -0.9641085|                  -0.9881257|              -0.9865055|              -0.9788041|              -0.9744769|                  -0.9908520|                  -0.9902241|                  -0.9867610|      -0.9830291|      -0.9758547|      -0.9917194|                      -0.9812045|                              -0.9935797|                  -0.9778357|                      -0.9842574|               -0.9678665|               -0.9385734|               -0.9360722|                  -0.9743483|                  -0.9763935|                  -0.9643092|                   -0.9913254|                   -0.9900949|                   -0.9889189|       -0.9734780|       -0.9595157|       -0.9832131|           -0.9900566|           -0.9815092|           -0.9953005|                       -0.9631437|                          -0.9631437|                           -0.9936469|               -0.9712566|                   -0.9815613|               -0.9622038|               -0.9270764|               -0.9233089|                   -0.9927162|                   -0.9906182|                   -0.9896700|       -0.9717488|       -0.9520469|       -0.9821860|                       -0.9593374|                               -0.9922167|                   -0.9716210|                       -0.9791176| LAYING              |
| 1586 |               0.2646360|              -0.0097173|              -0.0884756|                  0.9256172|                  0.2374117|                  0.0045924|                   0.0756988|                   0.0331986|                  -0.0576041|      -0.0307199|      -0.0492745|       0.2768148|          -0.0946482|          -0.0325173|          -0.0637650|                      -0.9550375|                         -0.9550375|                          -0.9641684|              -0.8698077|                  -0.9357010|              -0.9808034|              -0.9489525|              -0.8554219|                  -0.9755375|                  -0.9583912|                  -0.8834313|      -0.7511952|      -0.8358029|      -0.9515926|                      -0.8765786|                              -0.8763564|                  -0.7051466|                      -0.7903111|               -0.9852903|               -0.9487512|               -0.8681567|                  -0.9828529|                  -0.9713114|                  -0.9065134|                   -0.9762429|                   -0.9611920|                   -0.8953357|       -0.8371970|       -0.8425848|       -0.9487955|           -0.7582030|           -0.8843804|           -0.9699498|                       -0.8836525|                          -0.8836525|                           -0.8767729|               -0.6978618|                   -0.7683376|               -0.9874828|               -0.9507984|               -0.8867600|                   -0.9792802|                   -0.9679826|                   -0.9057576|       -0.8666406|       -0.8479774|       -0.9523711|                       -0.9049810|                               -0.8765391|                   -0.7451183|                       -0.7574827| SITTING             |
| 270  |               0.1954962|              -0.0163771|              -0.1263810|                  0.9133091|                 -0.3406597|                  0.1486640|                  -0.1121209|                   0.7340113|                   0.1760015|       0.0018247|      -0.0976069|       0.0936832|          -0.1717286|          -0.1738956|           0.0174952|                      -0.2202447|                         -0.2202447|                          -0.1341374|              -0.4335160|                  -0.4256594|              -0.3054099|               0.3139400|              -0.4027151|                  -0.2067719|                   0.3385402|                  -0.5258661|      -0.4366337|      -0.4658566|      -0.3374709|                      -0.1096499|                               0.1552709|                  -0.4578748|                      -0.3809261|               -0.3978746|                0.1227831|               -0.3820220|                  -0.9865661|                  -0.9877652|                  -0.9589762|                   -0.1479221|                    0.3469120|                   -0.5670573|       -0.5656224|       -0.4729061|       -0.4330137|           -0.2603478|           -0.4876133|           -0.2083956|                       -0.3186564|                          -0.3186564|                            0.1014263|               -0.4732268|                   -0.3555808|               -0.4384017|               -0.0673479|               -0.4194536|                   -0.1614951|                    0.2595076|                   -0.6062493|       -0.6065863|       -0.4810084|       -0.5199458|                       -0.5807500|                                0.0218691|                   -0.5782692|                       -0.3673962| WALKING             |

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
| 6999 |               0.2413012|              -0.0105622|              -0.1185498|                 -0.1053275|                  0.9198483|                  0.2306417|                   0.0507715|                   0.0392977|                  -0.0030519|      -0.0165238|      -0.0120416|       0.0699470|          -0.1013743|          -0.0573414|          -0.0345729|                      -0.9645375|                         -0.9645375|                          -0.9675649|              -0.9432441|                  -0.9629681|              -0.9280642|              -0.9468212|              -0.9297283|                  -0.9283691|                  -0.9516170|                  -0.9254497|      -0.9498213|      -0.8414032|      -0.9340768|                      -0.8980731|                              -0.8778546|                  -0.8046191|                      -0.8523648|               -0.9448700|               -0.9572578|               -0.9415666|                  -0.9950371|                  -0.9969695|                  -0.9878508|                   -0.9315437|                   -0.9523704|                   -0.9331737|       -0.9702550|       -0.8593362|       -0.9529559|           -0.9446745|           -0.8891769|           -0.9503614|                       -0.8950690|                          -0.8950690|                           -0.8805433|               -0.8079555|                   -0.8451945|               -0.9530985|               -0.9656129|               -0.9542508|                   -0.9418172|                   -0.9568244|                   -0.9393928|       -0.9778518|       -0.8726258|       -0.9654643|                       -0.9085337|                               -0.8834528|                   -0.8442683|                       -0.8465363| LAYING              |
| 2208 |               0.2945636|              -0.0083555|              -0.0865990|                  0.6412620|                 -0.3349832|                 -0.5306584|                   0.1284293|                  -0.2124770|                   0.0180871|      -0.2051883|       0.1073000|       0.3410366|          -0.0322899|           0.0721595|          -0.2492724|                       0.0095084|                          0.0095084|                          -0.3374730|               0.1581982|                  -0.4359506|              -0.3969200|              -0.2176179|               0.1461520|                  -0.3945027|                  -0.4554313|                  -0.2358726|      -0.5146318|      -0.0083692|       0.1330319|                      -0.1379816|                              -0.3238216|                  -0.0813488|                      -0.5141780|               -0.3795096|                0.0781885|                0.5405601|                  -0.9550032|                  -0.9586732|                  -0.8720314|                   -0.4119684|                   -0.4293236|                   -0.3492642|       -0.4866886|        0.2861694|        0.3564477|           -0.6655448|           -0.4361784|           -0.3438669|                       -0.0369068|                          -0.0369068|                           -0.3772027|                0.1689406|                   -0.5517843|               -0.3726808|                0.1404752|                0.6150423|                   -0.4875212|                   -0.4387571|                   -0.4696158|       -0.4865592|        0.4293425|        0.2979304|                       -0.1343558|                               -0.4535722|                    0.1279216|                       -0.6411003| WALKING\_UPSTAIRS   |
| 1097 |               0.3233685|              -0.0423929|              -0.0913820|                  0.9065336|                 -0.2203429|                 -0.2710663|                   0.0416913|                  -0.2748496|                  -0.1747980|      -0.0603549|      -0.0869651|       0.1561429|           0.1157623|           0.0963585|          -0.0656176|                      -0.2384286|                         -0.2384286|                          -0.2617439|              -0.4859794|                  -0.6545330|              -0.3878216|              -0.1631276|              -0.1892034|                  -0.4328658|                  -0.3405685|                  -0.3059614|      -0.5055152|      -0.6291349|      -0.4282475|                      -0.3440891|                              -0.2816754|                  -0.6736889|                      -0.6913864|               -0.3967535|               -0.2390315|               -0.1335288|                  -0.9746442|                  -0.9825138|                  -0.9906013|                   -0.3594338|                   -0.3151442|                   -0.2994872|       -0.6252820|       -0.6466070|       -0.3481162|           -0.6367441|           -0.6967491|           -0.5600399|                       -0.4213160|                          -0.4213160|                           -0.3258477|               -0.6661336|                   -0.6998250|               -0.4002270|               -0.3314343|               -0.1710935|                   -0.3411453|                   -0.3333530|                   -0.2925580|       -0.6633987|       -0.6602739|       -0.3833881|                       -0.5596568|                               -0.3910284|                   -0.7187488|                       -0.7324952| WALKING             |
| 4712 |               0.2727558|              -0.0089249|              -0.0905481|                  0.9703698|                 -0.0161654|                  0.1027960|                   0.0748180|                   0.0086022|                   0.0076883|      -0.0440204|      -0.0732541|       0.0799760|          -0.1097010|          -0.0506757|          -0.0533324|                      -0.9754067|                         -0.9754067|                          -0.9888234|              -0.9671350|                  -0.9898962|              -0.9951314|              -0.9716332|              -0.9813385|                  -0.9936006|                  -0.9781299|                  -0.9892595|      -0.9629736|      -0.9818720|      -0.9834668|                      -0.9815015|                              -0.9894402|                  -0.9681052|                      -0.9891984|               -0.9960222|               -0.9699950|               -0.9633492|                  -0.9964985|                  -0.9860967|                  -0.9615628|                   -0.9921204|                   -0.9792266|                   -0.9906742|       -0.9545350|       -0.9800753|       -0.9823010|           -0.9822448|           -0.9910273|           -0.9917031|                       -0.9755783|                          -0.9755783|                           -0.9908799|               -0.9409426|                   -0.9895855|               -0.9964117|               -0.9699195|               -0.9563341|                   -0.9911199|                   -0.9822612|                   -0.9905734|       -0.9531234|       -0.9790420|       -0.9833434|                       -0.9748965|                               -0.9919316|                   -0.9360439|                       -0.9904443| STANDING            |
| 5839 |               0.2581994|              -0.0367702|              -0.0521056|                  0.9693699|                 -0.1788963|                  0.0404377|                   0.0828129|                   0.0030044|                  -0.0401566|      -0.0027065|      -0.1022959|       0.0020901|          -0.1534594|          -0.0249279|          -0.0467435|                      -0.8939568|                         -0.8939568|                          -0.9399721|              -0.8248955|                  -0.9523964|              -0.9312638|              -0.9184843|              -0.9035874|                  -0.9289064|                  -0.9393473|                  -0.9548386|      -0.8372017|      -0.9342273|      -0.9007438|                      -0.9156542|                              -0.9268735|                  -0.8919150|                      -0.9620807|               -0.9444187|               -0.9082049|               -0.8443241|                  -0.9822658|                  -0.9523894|                  -0.9176617|                   -0.9286712|                   -0.9297145|                   -0.9628432|       -0.8109240|       -0.9215834|       -0.8830984|           -0.9310339|           -0.9657559|           -0.9453783|                       -0.8921678|                          -0.8921678|                           -0.9314178|               -0.8473312|                   -0.9612022|               -0.9505165|               -0.9077909|               -0.8276199|                   -0.9348990|                   -0.9237311|                   -0.9701679|       -0.8074547|       -0.9150713|       -0.8882664|                       -0.8961049|                               -0.9368326|                   -0.8462697|                       -0.9621639| STANDING            |
| 2976 |               0.2936944|              -0.0635544|              -0.1821307|                  0.9565309|                 -0.1065744|                 -0.0695820|                   0.2222784|                   0.0758567|                   0.2903491|      -0.3593532|      -0.0467594|       0.0879315|          -0.0014743|           0.2176140|          -0.0648416|                       0.0087573|                          0.0087573|                          -0.0736820|              -0.1172550|                  -0.2303114|               0.1450016|               0.0450985|               0.0555950|                   0.1068310|                  -0.0926151|                  -0.0651923|      -0.4779502|       0.1719035|      -0.3632722|                       0.3405976|                               0.3052502|                   0.0018973|                      -0.0696908|                0.0055630|               -0.0031117|                0.0731982|                  -0.9698661|                  -0.9426100|                  -0.9233145|                    0.0612548|                   -0.0957651|                   -0.2133997|       -0.5365664|        0.0103095|       -0.4094864|           -0.6089577|           -0.0135513|           -0.5733797|                        0.2622977|                           0.2622977|                            0.1883653|               -0.1113385|                   -0.0855276|               -0.0549699|               -0.0933540|               -0.0036189|                   -0.0930636|                   -0.1658383|                   -0.3731742|       -0.5567643|       -0.1112520|       -0.4793717|                        0.0193294|                                0.0121819|                   -0.3707403|                       -0.1720904| WALKING\_DOWNSTAIRS |

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

Saving Clean Data to Disk
-------------------------

Let's finally save our clean data-sets to `*.csv` files:

``` r
write.csv(all_data, "./tidy_data/activity_data.csv")
write.csv(averages_data, "./tidy_data/activity_averages_data.csv")
```
