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

    ## [1] "tBodyAcc-arCoeff()-Y,3"           "tBodyAccMag-entropy()"           
    ## [3] "tBodyGyro-mean()-X"               "fBodyAccJerk-bandsEnergy()-33,40"
    ## [5] "fBodyAcc-meanFreq()-X"            "tBodyGyroMag-arCoeff()2"

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

    ## [1] "tGravityAcc-max()-X"              "fBodyAcc-iqr()-Z"                
    ## [3] "fBodyAccMag-skewness()"           "tGravityAccMag-arCoeff()4"       
    ## [5] "fBodyAccJerk-bandsEnergy()-49,64" "fBodyAcc-energy()-Z"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyroJerk-mean()-X"      "fBodyAccMag-mean()"         
    ## [3] "tBodyAccJerk-mean()-Z"       "tGravityAccMag-mean()"      
    ## [5] "fBodyBodyGyroJerkMag-mean()" "fBodyAccJerk-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccJerkMag-std()"      "fBodyGyro-std()-X"         
    ## [3] "tBodyAccMag-std()"          "fBodyAcc-std()-Y"          
    ## [5] "fBodyBodyGyroJerkMag-std()" "tBodyGyroJerk-std()-Z"

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

    ## [1] "fBodyAccJerk-bandsEnergy()-1,24" "tGravityAcc-std()-Z"            
    ## [3] "fBodyBodyAccJerkMag-mean()"      "tBodyAccMag-mad()"              
    ## [5] "tGravityAcc-arCoeff()-X,2"       "tBodyGyro-entropy()-X"

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
| 2324 |               0.3237798|              -0.0247650|              -0.1335376|                  0.9019776|                 -0.3261508|                 -0.0989183|                  -0.1366062|                   0.2188563|                  -0.2329434|      -0.0570689|      -0.1025802|      -0.0237551|          -0.3582474|           0.2468708|           0.2864703|                      -0.0402965|                         -0.0402965|                          -0.1350501|              -0.0704793|                  -0.3125796|              -0.1688051|               0.1867532|              -0.1512798|                  -0.1906810|                  -0.0353045|                  -0.3219738|      -0.2233372|      -0.0691774|      -0.0124725|                      -0.0693612|                              -0.0348608|                  -0.1773501|                      -0.1920552|               -0.2794259|                0.2870097|               -0.1246340|                  -0.9784746|                  -0.9755765|                  -0.9676844|                   -0.1702216|                    0.0373941|                   -0.3693117|       -0.3136249|       -0.0885919|       -0.0407385|           -0.2957808|           -0.2058721|           -0.3309716|                       -0.2436363|                          -0.2436363|                           -0.0947812|               -0.0663857|                   -0.1421778|               -0.3279397|                0.2566050|               -0.1796886|                   -0.2229317|                    0.0487792|                   -0.4137397|       -0.3445108|       -0.1072560|       -0.1377983|                       -0.4814916|                               -0.1841662|                   -0.1510587|                       -0.1396437|           1|
| 1856 |               0.2767237|              -0.0252458|              -0.1034355|                  0.9664799|                 -0.1532515|                  0.0907984|                   0.1047361|                   0.0160160|                   0.0351968|       0.0207796|      -0.0993385|       0.1205512|          -0.0914271|          -0.0305359|          -0.0603229|                      -0.9425279|                         -0.9425279|                          -0.9826035|              -0.9184203|                  -0.9841748|              -0.9794043|              -0.9502400|              -0.9402515|                  -0.9756174|                  -0.9734794|                  -0.9844623|      -0.9346383|      -0.9760225|      -0.9580058|                      -0.9469869|                              -0.9755238|                  -0.9438218|                      -0.9867040|               -0.9849131|               -0.9195618|               -0.8957797|                  -0.9982966|                  -0.9842938|                  -0.9743294|                   -0.9755293|                   -0.9742032|                   -0.9883000|       -0.9075206|       -0.9664921|       -0.9512507|           -0.9743485|           -0.9888090|           -0.9785147|                       -0.9330257|                          -0.9330257|                           -0.9745514|               -0.8830210|                   -0.9845504|               -0.9877332|               -0.9106651|               -0.8821901|                   -0.9776288|                   -0.9770496|                   -0.9912510|       -0.9031721|       -0.9617389|       -0.9534005|                       -0.9350520|                               -0.9717082|                   -0.8717997|                       -0.9823550|           5|
| 1838 |               0.2591750|              -0.0207522|              -0.0943003|                  0.8674222|                 -0.4202581|                 -0.0140922|                  -0.0633534|                   0.1069810|                  -0.0629634|       0.0924626|      -0.1619043|       0.0461507|          -0.2146539|           0.0168395|          -0.0152386|                      -0.0444182|                         -0.0444182|                          -0.3967748|              -0.3129451|                  -0.6472516|              -0.4758788|               0.0238706|              -0.6036555|                  -0.5390643|                  -0.1983945|                  -0.7285811|      -0.4462984|      -0.6438681|      -0.3161280|                      -0.3667194|                              -0.3619552|                  -0.5648922|                      -0.7299873|               -0.3078040|                0.4520718|               -0.4125186|                  -0.9855908|                  -0.9733962|                  -0.9499162|                   -0.5028774|                   -0.0459356|                   -0.7633980|       -0.5482812|       -0.4206926|       -0.2311512|           -0.5414356|           -0.8055106|           -0.4261319|                       -0.3271443|                          -0.3271443|                           -0.3924507|               -0.5343460|                   -0.7241571|               -0.2516423|                0.5456858|               -0.3671326|                   -0.5088371|                    0.0509985|                   -0.7981566|       -0.5807631|       -0.3221831|       -0.2754694|                       -0.4100823|                               -0.4372669|                   -0.5931185|                       -0.7357030|           2|
| 2099 |               0.2589709|              -0.0199899|              -0.1017124|                 -0.2544590|                  0.5273755|                  0.8545238|                   0.0924301|                   0.0021643|                  -0.0049387|      -0.0197391|      -0.1108130|       0.0859331|          -0.1030059|          -0.0310329|          -0.0667070|                      -0.9891540|                         -0.9891540|                          -0.9914628|              -0.9805745|                  -0.9922563|              -0.9862871|              -0.9867576|              -0.9957794|                  -0.9884864|                  -0.9889813|                  -0.9938067|      -0.9912783|      -0.9838163|      -0.9811050|                      -0.9927135|                              -0.9929346|                  -0.9789329|                      -0.9918837|               -0.9897354|               -0.9873044|               -0.9958976|                  -0.9740356|                  -0.9940038|                  -0.9903370|                   -0.9881156|                   -0.9890368|                   -0.9943253|       -0.9928657|       -0.9837145|       -0.9801498|           -0.9962920|           -0.9899252|           -0.9918746|                       -0.9927537|                          -0.9927537|                           -0.9937818|               -0.9754845|                   -0.9926546|               -0.9914582|               -0.9872974|               -0.9954043|                   -0.9887170|                   -0.9898887|                   -0.9932498|       -0.9933007|       -0.9836670|       -0.9814588|                       -0.9929542|                               -0.9938882|                   -0.9770656|                       -0.9940391|           6|
| 2289 |               0.2486676|              -0.0167895|              -0.1052273|                 -0.6862925|                  0.7881654|                  0.6237672|                   0.0326624|                   0.0195809|                   0.0198235|      -0.0456383|      -0.1970469|       0.2504483|          -0.0908809|          -0.0459467|          -0.0857643|                      -0.9627415|                         -0.9627415|                          -0.9779878|              -0.9055348|                  -0.9912672|              -0.9467291|              -0.9715258|              -0.9733986|                  -0.9637706|                  -0.9749202|                  -0.9760475|      -0.9849019|      -0.9678994|      -0.9358138|                      -0.9444647|                              -0.9565282|                  -0.9508461|                      -0.9794218|               -0.9537965|               -0.9734783|               -0.9737366|                  -0.9249473|                  -0.9853101|                  -0.9843388|                   -0.9623428|                   -0.9736234|                   -0.9773962|       -0.9883802|       -0.9631032|       -0.9181068|           -0.9921659|           -0.9839991|           -0.9845396|                       -0.9515019|                          -0.9515019|                           -0.9530968|               -0.9118404|                   -0.9791764|               -0.9568125|               -0.9751737|               -0.9751672|                   -0.9640888|                   -0.9738502|                   -0.9770662|       -0.9894289|       -0.9605252|       -0.9202174|                       -0.9626763|                               -0.9473342|                   -0.9054496|                       -0.9797561|           6|
| 1434 |               0.2724773|              -0.0177509|              -0.1092898|                 -0.3460922|                  0.9744717|                 -0.1142602|                   0.0776488|                   0.0078397|                   0.0008560|      -0.0299339|      -0.0618566|       0.0879949|          -0.0994436|          -0.0423298|          -0.0567831|                      -0.9792590|                         -0.9792590|                          -0.9806718|              -0.9779067|                  -0.9804680|              -0.9712620|              -0.9752963|              -0.9760528|                  -0.9710576|                  -0.9750283|                  -0.9775880|      -0.9748739|      -0.9754372|      -0.9295566|                      -0.9670178|                              -0.9712130|                  -0.9542321|                      -0.9688500|               -0.9761480|               -0.9796627|               -0.9666726|                  -0.9948969|                  -0.9985867|                  -0.9819801|                   -0.9713346|                   -0.9742630|                   -0.9800150|       -0.9845180|       -0.9802236|       -0.9379345|           -0.9710464|           -0.9766652|           -0.9529749|                       -0.9664794|                          -0.9664794|                           -0.9638850|               -0.9458398|                   -0.9596317|               -0.9783276|               -0.9825508|               -0.9631257|                   -0.9742688|                   -0.9751102|                   -0.9809009|       -0.9879775|       -0.9839558|       -0.9465288|                       -0.9702229|                               -0.9537779|                   -0.9492014|                       -0.9518691|           6|

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
| 2327 |               0.2561393|               0.0173353|              -0.0773785|                  0.9619056|                  0.0722477|                  0.0681480|                   0.1192742|                   0.0047381|                  -0.1818835|       0.1290453|      -0.4783305|       0.3080522|          -0.1772365|          -0.0359901|          -0.0668007|                      -0.8448218|                         -0.8448218|                          -0.9087718|              -0.6832925|                  -0.8872945|              -0.8945092|              -0.9235559|              -0.7861108|                  -0.8505405|                  -0.9317186|                  -0.9111939|      -0.8035260|      -0.7905533|      -0.9015584|                      -0.8021010|                              -0.8504942|                  -0.8077662|                      -0.8413808|               -0.9261848|               -0.9134382|               -0.6769052|                  -0.9041093|                  -0.9295000|                  -0.7011078|                   -0.8624076|                   -0.9350220|                   -0.9275561|       -0.8518665|       -0.7966081|       -0.9258769|           -0.8632963|           -0.8609019|           -0.9163413|                       -0.7783977|                          -0.7783977|                           -0.8534695|               -0.7658604|                   -0.8414678|               -0.9432780|               -0.9127817|               -0.6494746|                   -0.8906240|                   -0.9443230|                   -0.9444851|       -0.8672349|       -0.8018019|       -0.9426585|                       -0.7993642|                               -0.8563334|                   -0.7783118|                       -0.8522757| STANDING            |
| 2821 |               0.2792947|              -0.0175238|              -0.1098599|                 -0.3852955|                  0.7362334|                  0.6896439|                   0.0873275|                   0.0144198|                  -0.0060084|      -0.0282329|      -0.0850037|       0.0843260|          -0.0990208|          -0.0285136|          -0.0538973|                      -0.9778477|                         -0.9778477|                          -0.9890307|              -0.9736958|                  -0.9856897|              -0.9828543|              -0.9885690|              -0.9843613|                  -0.9909871|                  -0.9879788|                  -0.9851882|      -0.9823721|      -0.9705148|      -0.9955860|                      -0.9891849|                              -0.9932796|                  -0.9761629|                      -0.9852445|               -0.9726667|               -0.9911358|               -0.9812230|                  -0.9711484|                  -0.9955302|                  -0.9891831|                   -0.9918571|                   -0.9878609|                   -0.9872565|       -0.9886323|       -0.9617030|       -0.9961050|           -0.9807981|           -0.9843874|           -0.9951149|                       -0.9871990|                          -0.9871990|                           -0.9932809|               -0.9723094|                   -0.9864005|               -0.9690298|               -0.9921734|               -0.9798393|                   -0.9937757|                   -0.9885602|                   -0.9878548|       -0.9907902|       -0.9571932|       -0.9965960|                       -0.9868226|                               -0.9917366|                   -0.9741613|                       -0.9887943| LAYING              |
| 2203 |               0.2800860|              -0.0163587|              -0.1082512|                  0.9505376|                 -0.2263716|                 -0.1243233|                   0.0754007|                   0.0074543|                   0.0186198|      -0.0319008|      -0.0593078|       0.0774397|          -0.1058924|          -0.0328371|          -0.0412997|                      -0.9847241|                         -0.9847241|                          -0.9897280|              -0.9734641|                  -0.9906441|              -0.9933664|              -0.9861731|              -0.9729381|                  -0.9906708|                  -0.9901366|                  -0.9864511|      -0.9683116|      -0.9848348|      -0.9844306|                      -0.9860523|                              -0.9907461|                  -0.9787564|                      -0.9900203|               -0.9949227|               -0.9828845|               -0.9672034|                  -0.9981982|                  -0.9949402|                  -0.9834327|                   -0.9908603|                   -0.9897992|                   -0.9872760|       -0.9674108|       -0.9847123|       -0.9861161|           -0.9841381|           -0.9906272|           -0.9952697|                       -0.9852069|                          -0.9852069|                           -0.9914350|               -0.9679526|                   -0.9904078|               -0.9956814|               -0.9811953|               -0.9654895|                   -0.9919150|                   -0.9900629|                   -0.9864620|       -0.9674370|       -0.9846453|       -0.9878961|                       -0.9858790|                               -0.9911509|                   -0.9666242|                       -0.9912792| STANDING            |
| 2416 |               0.2747539|              -0.0194994|              -0.1089683|                 -0.4381017|                  0.8854893|                  0.4448825|                   0.0743215|                   0.0062005|                  -0.0026058|      -0.0279887|      -0.0726899|       0.0884390|          -0.0980091|          -0.0369807|          -0.0544476|                      -0.9884118|                         -0.9884118|                          -0.9912243|              -0.9812454|                  -0.9959785|              -0.9928803|              -0.9897563|              -0.9849674|                  -0.9949394|                  -0.9861147|                  -0.9871630|      -0.9891085|      -0.9859046|      -0.9956456|                      -0.9936712|                              -0.9942136|                  -0.9893621|                      -0.9967238|               -0.9884262|               -0.9929582|               -0.9821295|                  -0.9931336|                  -0.9971550|                  -0.9917247|                   -0.9951212|                   -0.9863932|                   -0.9902702|       -0.9868274|       -0.9741890|       -0.9960802|           -0.9947744|           -0.9951326|           -0.9962656|                       -0.9941914|                          -0.9941914|                           -0.9950384|               -0.9793309|                   -0.9966743|               -0.9865946|               -0.9943731|               -0.9808486|                   -0.9957893|                   -0.9877355|                   -0.9923070|       -0.9863045|       -0.9688713|       -0.9965329|                       -0.9945898|                               -0.9951585|                   -0.9769512|                       -0.9964288| LAYING              |
| 2337 |               0.2805822|              -0.0029885|              -0.0773256|                  0.9663798|                 -0.1444823|                 -0.0919943|                   0.0471452|                  -0.0200006|                  -0.0067910|      -0.0284560|      -0.0537555|       0.0914424|          -0.1129805|          -0.0806920|          -0.0183479|                      -0.9520063|                         -0.9520063|                          -0.9849855|              -0.9634828|                  -0.9835215|              -0.9767218|              -0.9436174|              -0.9687031|                  -0.9851851|                  -0.9514333|                  -0.9856035|      -0.9488627|      -0.9715123|      -0.9569334|                      -0.9546415|                              -0.9638982|                  -0.9610531|                      -0.9788549|               -0.9822631|               -0.9224550|               -0.9460407|                  -0.9927306|                  -0.9939837|                  -0.9460944|                   -0.9855370|                   -0.9581009|                   -0.9881430|       -0.9569583|       -0.9742961|       -0.9603187|           -0.9667959|           -0.9838176|           -0.9838984|                       -0.9390033|                          -0.9390033|                           -0.9664724|               -0.9445360|                   -0.9744202|               -0.9849812|               -0.9167040|               -0.9381077|                   -0.9872761|                   -0.9715910|                   -0.9893476|       -0.9594870|       -0.9762815|       -0.9649938|                       -0.9394330|                               -0.9689450|                   -0.9436552|                       -0.9705582| STANDING            |
| 1054 |               0.3203880|              -0.0181894|              -0.0999930|                  0.9345370|                 -0.2057149|                 -0.1833289|                  -0.1344570|                   0.0308289|                  -0.0452809|      -0.1266898|      -0.0208660|       0.0887401|          -0.0031771|           0.0013408|          -0.0266955|                      -0.0591765|                         -0.0591765|                          -0.1182861|               0.0994846|                  -0.2049493|              -0.1071163|               0.1665098|              -0.1321699|                  -0.1004307|                   0.0374910|                  -0.2861230|      -0.2262260|       0.2139053|      -0.1724931|                       0.0677874|                               0.0463976|                   0.0207246|                      -0.0180023|               -0.1430295|                0.1004238|               -0.0991291|                  -0.9785770|                  -0.9215382|                  -0.9410492|                   -0.0864760|                    0.1050719|                   -0.3618374|       -0.1186696|        0.0742443|       -0.2593304|           -0.5309581|            0.0318691|           -0.3969943|                        0.0104278|                           0.0104278|                            0.0686902|               -0.0355752|                    0.0235361|               -0.1575680|               -0.0069239|               -0.1525223|                   -0.1541699|                    0.1061638|                   -0.4369691|       -0.1062436|       -0.0297404|       -0.3578295|                       -0.1805525|                                0.0892421|                   -0.2525670|                        0.0052579| WALKING\_DOWNSTAIRS |

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
| 6550 |               0.2930399|              -0.0223892|              -0.1127611|                 -0.3696303|                 -0.4641177|                  0.9113417|                   0.0865487|                   0.0013731|                   0.0028638|      -0.0313915|      -0.0850090|       0.0841636|          -0.0980053|          -0.0405488|          -0.0532403|                      -0.9643643|                         -0.9643643|                          -0.9928640|              -0.9800021|                  -0.9944898|              -0.9787991|              -0.9798942|              -0.9856723|                  -0.9925192|                  -0.9926437|                  -0.9916315|      -0.9880292|      -0.9847270|      -0.9980607|                      -0.9824730|                              -0.9949504|                  -0.9856106|                      -0.9936125|               -0.9634598|               -0.9624383|               -0.9767243|                  -0.9743939|                  -0.9879117|                  -0.9881851|                   -0.9912972|                   -0.9916648|                   -0.9930707|       -0.9873959|       -0.9744144|       -0.9977916|           -0.9914338|           -0.9927522|           -0.9986450|                       -0.9739548|                          -0.9739548|                           -0.9952706|               -0.9827704|                   -0.9935046|               -0.9583466|               -0.9564698|               -0.9726680|                   -0.9906393|                   -0.9909794|                   -0.9930543|       -0.9872434|       -0.9695699|       -0.9977942|                       -0.9723123|                               -0.9943742|                   -0.9835198|                       -0.9933562| LAYING              |
| 350  |               0.2668696|              -0.0454716|              -0.1300397|                  0.9554933|                 -0.1324559|                  0.1245786|                  -0.4014005|                   0.3320963|                   0.2048826|       0.1070638|      -0.0467005|       0.1204187|          -0.3789309|          -0.0560805|           0.0885480|                      -0.0855514|                         -0.0855514|                          -0.2397960|              -0.2110706|                  -0.4961710|              -0.1271286|               0.0742481|              -0.2111862|                  -0.2870230|                  -0.0014705|                  -0.3382734|      -0.3201215|      -0.3583993|      -0.2308695|                      -0.1749125|                              -0.0571181|                  -0.4542284|                      -0.6020032|               -0.1895960|               -0.0109332|               -0.1762262|                  -0.9513035|                  -0.9354488|                  -0.9134014|                   -0.2780225|                   -0.0023276|                   -0.3860839|       -0.5315130|       -0.1938023|       -0.3005415|           -0.3708856|           -0.6105412|           -0.3903551|                       -0.2078723|                          -0.2078723|                           -0.0731140|               -0.4241855|                   -0.5984874|               -0.2154656|               -0.1229799|               -0.2221704|                   -0.3338950|                   -0.0762470|                   -0.4310995|       -0.6015062|       -0.1126969|       -0.3888577|                       -0.3499736|                               -0.1006564|                   -0.5024028|                       -0.6213410| WALKING             |
| 2609 |               0.1892823|              -0.0222539|              -0.0708852|                  0.8978831|                 -0.1831005|                 -0.2915701|                   0.5257602|                  -0.1069960|                  -0.2731166|      -0.0886547|      -0.1440153|       0.0928394|           0.0468168|           0.0550202|          -0.1073290|                      -0.0458476|                         -0.0458476|                          -0.1817275|              -0.1027342|                  -0.4391222|               0.1132225|               0.1664490|              -0.1329457|                  -0.0279593|                   0.0085310|                  -0.3285602|      -0.2298156|      -0.2945490|      -0.2220542|                       0.2261469|                               0.2191168|                  -0.2286982|                      -0.2969200|               -0.0450388|                0.0510031|               -0.1345216|                  -0.9291212|                  -0.9144842|                  -0.9359192|                   -0.0544428|                    0.0237192|                   -0.3961921|       -0.1264263|       -0.3601958|       -0.3211730|           -0.4793889|           -0.3351829|           -0.3974564|                        0.1593956|                           0.1593956|                            0.1453982|               -0.2234838|                   -0.2776308|               -0.1150700|               -0.0839879|               -0.2059709|                   -0.1739122|                   -0.0315720|                   -0.4626929|       -0.1147426|       -0.4089459|       -0.4190839|                       -0.0604563|                                0.0363337|                   -0.3553287|                       -0.3026835| WALKING\_DOWNSTAIRS |
| 4495 |               0.2789334|              -0.0152172|              -0.1072884|                  0.8839465|                 -0.0374580|                 -0.3617538|                   0.0806997|                   0.0129513|                  -0.0046698|      -0.0283756|      -0.0749377|       0.0847065|          -0.0991207|          -0.0415831|          -0.0550688|                      -0.9973972|                         -0.9973972|                          -0.9946582|              -0.9977769|                  -0.9990087|              -0.9969403|              -0.9925028|              -0.9907096|                  -0.9968433|                  -0.9950070|                  -0.9896318|      -0.9988803|      -0.9967592|      -0.9962060|                      -0.9948291|                              -0.9947412|                  -0.9989861|                      -0.9995263|               -0.9979946|               -0.9921951|               -0.9926611|                  -0.9990187|                  -0.9963863|                  -0.9957676|                   -0.9969451|                   -0.9950824|                   -0.9908269|       -0.9983757|       -0.9966657|       -0.9961366|           -0.9997780|           -0.9981355|           -0.9972930|                       -0.9955859|                          -0.9955859|                           -0.9958690|               -0.9980919|                   -0.9995458|               -0.9985950|               -0.9913954|               -0.9938217|                   -0.9973465|                   -0.9955330|                   -0.9904718|       -0.9981432|       -0.9965399|       -0.9963569|                       -0.9960481|                               -0.9964579|                   -0.9975397|                       -0.9992410| SITTING             |
| 1602 |               0.1792038|              -0.0290008|              -0.0479590|                  0.8660963|                 -0.3331466|                 -0.2409581|                  -0.0095185|                   0.1801098|                   0.3145481|       0.0754971|      -0.1176412|       0.0250077|          -0.1497912|          -0.0422870|          -0.2273046|                      -0.2681805|                         -0.2681805|                          -0.4844566|              -0.4274690|                  -0.7008382|              -0.2795508|              -0.2576300|              -0.4017996|                  -0.3316020|                  -0.4147042|                  -0.6498312|      -0.5363118|      -0.6026165|      -0.3951042|                      -0.1894587|                              -0.2581983|                  -0.6678224|                      -0.7059119|               -0.2920661|               -0.2452725|               -0.2987382|                  -0.9732184|                  -0.9457468|                  -0.8852358|                   -0.3202634|                   -0.4140216|                   -0.7117778|       -0.6105136|       -0.5666005|       -0.2849712|           -0.5741028|           -0.7474550|           -0.6507764|                       -0.1802069|                          -0.1802069|                           -0.2582192|               -0.5901318|                   -0.6864349|               -0.2969903|               -0.2860754|               -0.2982977|                   -0.3695440|                   -0.4558513|                   -0.7798998|       -0.6344501|       -0.5487378|       -0.3176539|                       -0.3022890|                               -0.2629241|                   -0.6096718|                       -0.6836249| WALKING\_UPSTAIRS   |
| 5218 |               0.2803607|              -0.0144713|              -0.1049229|                  0.9394909|                 -0.2687850|                 -0.0896085|                   0.0806110|                   0.0113707|                   0.0079914|      -0.0208693|      -0.0758529|       0.0780709|          -0.1057018|          -0.0395083|          -0.0512196|                      -0.9833800|                         -0.9833800|                          -0.9828211|              -0.9763999|                  -0.9855886|              -0.9907272|              -0.9716351|              -0.9758374|                  -0.9888638|                  -0.9755013|                  -0.9805285|      -0.9671184|      -0.9786717|      -0.9841023|                      -0.9823682|                              -0.9814468|                  -0.9716289|                      -0.9826914|               -0.9934711|               -0.9721530|               -0.9733642|                  -0.9979907|                  -0.9937437|                  -0.9945858|                   -0.9889145|                   -0.9737359|                   -0.9817558|       -0.9749326|       -0.9751696|       -0.9857343|           -0.9699600|           -0.9887136|           -0.9887680|                       -0.9856788|                          -0.9856788|                           -0.9830309|               -0.9655506|                   -0.9817986|               -0.9949414|               -0.9730997|               -0.9730243|                   -0.9899643|                   -0.9733887|                   -0.9813294|       -0.9773643|       -0.9732393|       -0.9875269|                       -0.9894942|                               -0.9840333|                   -0.9671155|                       -0.9814352| STANDING            |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

The following tables describe all the variables in the clean data-set:

> **Notes: **
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

Let's finally save our clean data-sets to `*.txt` files:

``` r
dir.create("./tidy_data")
```

    ## Warning in dir.create("./tidy_data"): './tidy_data' already exists

``` r
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
