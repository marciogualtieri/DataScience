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

    ## [1] "fBodyBodyGyroMag-maxInds"         "fBodyAccJerk-bandsEnergy()-33,40"
    ## [3] "fBodyGyro-bandsEnergy()-33,48"    "fBodyBodyAccJerkMag-max()"       
    ## [5] "tBodyAccJerkMag-sma()"            "fBodyAcc-mad()-Z"

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

#### Activity Label Data

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

    ## [1] "fBodyGyro-bandsEnergy()-33,40"    "tGravityAcc-std()-Y"             
    ## [3] "tGravityAcc-energy()-X"           "tBodyAccJerk-max()-Y"            
    ## [5] "fBodyAccJerk-bandsEnergy()-33,48" "fBodyAcc-bandsEnergy()-1,24"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAccJerkMag-mean()"      "tGravityAcc-mean()-X"       
    ## [3] "fBodyBodyGyroJerkMag-mean()" "tBodyGyroJerk-mean()-Y"     
    ## [5] "fBodyGyro-mean()-Y"          "tBodyAcc-mean()-Z"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyGyroMag-std()"    "fBodyAcc-std()-Y"      "tBodyGyro-std()-Y"    
    ## [4] "tGravityAcc-std()-X"   "tBodyAcc-std()-Y"      "tBodyGyroJerk-std()-X"

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

    ## [1] "tBodyGyro-arCoeff()-Y,4"          "tBodyGyroJerkMag-sma()"          
    ## [3] "tBodyGyroJerkMag-std()"           "fBodyAccJerk-bandsEnergy()-1,16" 
    ## [5] "fBodyAccMag-maxInds"              "fBodyAccJerk-bandsEnergy()-49,56"

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
| 2399 |               0.2546126|              -0.0413276|              -0.1479953|                  0.8640062|                 -0.4331616|                  0.0776936|                   0.0955891|                   0.0428330|                   0.0336889|      -0.0339389|      -0.1092155|       0.0812889|          -0.1374570|           0.0242586|          -0.0878588|                      -0.9004631|                         -0.9004631|                          -0.9411998|              -0.8907340|                  -0.9497932|              -0.9078849|              -0.8876254|              -0.9207652|                  -0.9158050|                  -0.9291814|                  -0.9469918|      -0.8952182|      -0.8919762|      -0.8492897|                      -0.8917658|                              -0.9099302|                  -0.8700317|                      -0.9393220|               -0.9176881|               -0.8783380|               -0.9029742|                  -0.9786177|                  -0.9528240|                  -0.9248206|                   -0.9140372|                   -0.9312677|                   -0.9553323|       -0.9086978|       -0.9001601|       -0.8388507|           -0.9461812|           -0.9467510|           -0.9133201|                       -0.8760882|                          -0.8760882|                           -0.9004702|               -0.8428383|                   -0.9297004|               -0.9217897|               -0.8802388|               -0.8999832|                   -0.9198252|                   -0.9390836|                   -0.9627921|       -0.9131119|       -0.9062007|       -0.8500866|                       -0.8859629|                               -0.8880946|                   -0.8515659|                       -0.9227926|           5|
| 1666 |               0.2276426|               0.0292979|              -0.0946946|                  0.8202173|                 -0.3194776|                 -0.3578914|                   0.0512257|                   0.0672673|                   0.2394947|       0.1401918|      -0.0910828|      -0.1517864|           0.3125676|          -0.2293984|          -0.0043614|                      -0.2727190|                         -0.2727190|                          -0.5765726|              -0.3434776|                  -0.6658412|              -0.4952133|              -0.3353533|              -0.3395600|                  -0.5811924|                  -0.6120037|                  -0.5813312|      -0.3631480|      -0.4956158|      -0.4452776|                      -0.4903484|                              -0.5584057|                  -0.5295548|                      -0.6208787|               -0.4483624|               -0.1881880|               -0.2187736|                  -0.9464634|                  -0.9270366|                  -0.9102960|                   -0.5746645|                   -0.5901033|                   -0.6253856|       -0.5325519|       -0.4799275|       -0.3095495|           -0.7321918|           -0.6143795|           -0.7186197|                       -0.4768018|                          -0.4768018|                           -0.5432561|               -0.5032497|                   -0.6333949|               -0.4308114|               -0.1696402|               -0.2155565|                   -0.6061322|                   -0.5931980|                   -0.6683917|       -0.5869394|       -0.4740742|       -0.3335546|                       -0.5500391|                               -0.5267254|                   -0.5704419|                       -0.6769732|           2|
| 890  |               0.2227807|              -0.0274194|              -0.0827375|                  0.8205542|                  0.0657744|                 -0.4189982|                  -0.0714473|                  -0.3315231|                   0.1617938|       0.0675037|      -0.1271565|       0.1346699|          -0.1891395|          -0.0838572|          -0.2046051|                      -0.2261363|                         -0.2261363|                          -0.4177943|              -0.0179890|                  -0.6103213|              -0.3408431|              -0.3839126|              -0.3401078|                  -0.4319651|                  -0.6268852|                  -0.6611101|      -0.3184324|      -0.3660935|      -0.3112840|                      -0.3589431|                              -0.4674348|                  -0.4724993|                      -0.6290336|               -0.3171852|               -0.4079309|               -0.1331767|                  -0.9657229|                  -0.9316858|                  -0.8909870|                   -0.2927601|                   -0.6085563|                   -0.6731746|       -0.1845615|       -0.1864284|       -0.2767716|           -0.6011053|           -0.6331975|           -0.5754626|                       -0.3774991|                          -0.3774991|                           -0.4516588|               -0.3619481|                   -0.6584186|               -0.3079776|               -0.4583114|               -0.0967123|                   -0.2226239|                   -0.6144903|                   -0.6829329|       -0.1664302|       -0.0986313|       -0.3318236|                       -0.4845542|                               -0.4350732|                   -0.3986050|                       -0.7265699|           2|
| 300  |               0.2768585|               0.0110565|              -0.1272291|                  0.8358315|                 -0.4994073|                  0.0310059|                   0.1846999|                   0.0002590|                   0.0389392|       0.1623394|      -0.2635815|       0.1071267|          -0.1065429|          -0.1124798|           0.0185143|                      -0.1408762|                         -0.1408762|                          -0.3691119|              -0.2675804|                  -0.6314039|              -0.2436778|               0.0199201|              -0.4516590|                  -0.2565220|                  -0.1447752|                  -0.6748759|      -0.3810041|      -0.4880048|      -0.4302948|                      -0.2001453|                              -0.2118435|                  -0.4722383|                      -0.6986219|               -0.2775426|                0.0945755|               -0.2390091|                  -0.9577178|                  -0.9483227|                  -0.9482760|                   -0.2843648|                   -0.1545039|                   -0.7050663|       -0.4083341|       -0.3754000|       -0.4253275|           -0.5341567|           -0.7129919|           -0.5357078|                       -0.1986624|                          -0.1986624|                           -0.2076644|               -0.3758611|                   -0.6873050|               -0.2912762|                0.0637371|               -0.1941137|                   -0.3848164|                   -0.2289744|                   -0.7335868|       -0.4219426|       -0.3192766|       -0.4761262|                       -0.3220918|                               -0.2074843|                   -0.4186970|                       -0.6940708|           2|
| 513  |               0.2772595|              -0.0048039|              -0.0987441|                  0.9767870|                 -0.0411739|                  0.0339165|                   0.0733702|                   0.0480117|                  -0.0055815|      -0.0164033|      -0.0682281|       0.0731372|          -0.0892435|          -0.0445726|          -0.0561227|                      -0.9581870|                         -0.9581870|                          -0.9834290|              -0.9667824|                  -0.9900646|              -0.9908260|              -0.9254742|              -0.9805240|                  -0.9884851|                  -0.9651610|                  -0.9877280|      -0.9776174|      -0.9850365|      -0.9601482|                      -0.9581108|                              -0.9863731|                  -0.9797920|                      -0.9911806|               -0.9932139|               -0.8999840|               -0.9758036|                  -0.9977712|                  -0.9719859|                  -0.9869621|                   -0.9885786|                   -0.9675075|                   -0.9906887|       -0.9815620|       -0.9781696|       -0.9477779|           -0.9867997|           -0.9944822|           -0.9810401|                       -0.9484480|                          -0.9484480|                           -0.9867502|               -0.9723376|                   -0.9922473|               -0.9944269|               -0.8936376|               -0.9739613|                   -0.9897118|                   -0.9732053|                   -0.9925539|       -0.9827415|       -0.9747124|       -0.9487198|                       -0.9501276|                               -0.9858524|                   -0.9720578|                       -0.9941721|           4|
| 2926 |               0.3443282|               0.0047928|              -0.1224525|                  0.8849913|                 -0.2800785|                 -0.2238929|                   0.1681282|                  -0.0716060|                  -0.1289928|      -0.1131090|       0.0635940|       0.2124169|          -0.3959698|          -0.0211226|           0.0286870|                      -0.1898855|                         -0.1898855|                          -0.4446947|              -0.2983583|                  -0.6412869|              -0.4852902|              -0.2886600|              -0.3003323|                  -0.5652012|                  -0.4910722|                  -0.4422303|      -0.3485616|      -0.5428018|      -0.3540804|                      -0.3529637|                              -0.4370804|                  -0.6437871|                      -0.6648270|               -0.3199874|               -0.0666766|               -0.1818030|                  -0.9713021|                  -0.9556957|                  -0.9485374|                   -0.4900234|                   -0.4349435|                   -0.4718773|       -0.4347396|       -0.5378543|       -0.2478967|           -0.6690204|           -0.6173332|           -0.5876257|                       -0.2586165|                          -0.2586165|                           -0.4060590|               -0.5800900|                   -0.6076110|               -0.2647624|               -0.0249175|               -0.1824140|                   -0.4603290|                   -0.4108614|                   -0.4985710|       -0.4633771|       -0.5380403|       -0.2848783|                       -0.3255465|                               -0.3671063|                   -0.6094622|                       -0.5682993|           2|

I could have expanded 't' to something like "TimeDomainSignal" and 'f' to "FrequencyDomainSignal", but I think that's unnecessary and make the variable names too big.

### Joining with Activity Label Data

Here we join the measurements data with the activity label data by "ActivityID":

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
| 1451 |               0.2709761|              -0.0151565|              -0.0961236|                  0.8885458|                  0.0022465|                  0.3530681|                   0.0847032|                   0.0302062|                  -0.0217378|      -0.0285609|      -0.0905368|       0.0826583|          -0.1036505|          -0.0367294|          -0.0502459|                      -0.9837328|                         -0.9837328|                          -0.9898154|              -0.9772222|                  -0.9893036|              -0.9910250|              -0.9743256|              -0.9788140|                  -0.9931738|                  -0.9774893|                  -0.9886620|      -0.9880114|      -0.9698527|      -0.9814365|                      -0.9779974|                              -0.9865739|                  -0.9697617|                      -0.9833788|               -0.9902946|               -0.9808110|               -0.9709411|                  -0.9864242|                  -0.9973270|                  -0.9670140|                   -0.9930085|                   -0.9789273|                   -0.9906182|       -0.9915500|       -0.9627125|       -0.9831810|           -0.9905318|           -0.9844153|           -0.9876102|                       -0.9772550|                          -0.9772550|                           -0.9884917|               -0.9619938|                   -0.9831004|               -0.9898165|               -0.9852209|               -0.9678174|                   -0.9934132|                   -0.9824871|                   -0.9911690|       -0.9926791|       -0.9589752|       -0.9852331|                       -0.9792108|                               -0.9901597|                   -0.9631336|                       -0.9834712| SITTING             |
| 1608 |               0.2772573|              -0.0122933|              -0.0986027|                  0.9754025|                 -0.0809076|                 -0.0465435|                   0.0735548|                   0.0082419|                  -0.0032270|      -0.0159694|      -0.0850997|       0.1243376|          -0.0985113|          -0.0413638|          -0.0568678|                      -0.9871488|                         -0.9871488|                          -0.9921686|              -0.9767683|                  -0.9943072|              -0.9948281|              -0.9793302|              -0.9881059|                  -0.9938826|                  -0.9847025|                  -0.9917424|      -0.9888530|      -0.9896854|      -0.9851446|                      -0.9879254|                              -0.9916033|                  -0.9892745|                      -0.9942533|               -0.9953224|               -0.9756736|               -0.9822776|                  -0.9985366|                  -0.9850840|                  -0.9742174|                   -0.9928875|                   -0.9846739|                   -0.9932806|       -0.9911273|       -0.9864365|       -0.9843624|           -0.9914521|           -0.9951832|           -0.9906559|                       -0.9836972|                          -0.9836972|                           -0.9927786|               -0.9865502|                   -0.9944552|               -0.9954657|               -0.9742491|               -0.9793348|                   -0.9923320|                   -0.9857257|                   -0.9933904|       -0.9917846|       -0.9846424|       -0.9853496|                       -0.9826067|                               -0.9934865|                   -0.9867412|                       -0.9947341| SITTING             |
| 646  |               0.3148784|              -0.0345590|              -0.1099582|                  0.8492103|                 -0.3250270|                 -0.3013384|                   0.0374088|                  -0.0740977|                  -0.0378406|      -0.3245475|       0.1186772|       0.3836276|          -0.0026740|           0.0308574|          -0.1536094|                      -0.3165072|                         -0.3165072|                          -0.6239091|              -0.4486783|                  -0.8028255|              -0.5521118|              -0.4427522|              -0.4955064|                  -0.6235813|                  -0.6584008|                  -0.6707907|      -0.7519135|      -0.6957736|      -0.5830065|                      -0.4379729|                              -0.5731887|                  -0.7751559|                      -0.8457762|               -0.4014348|               -0.2548143|               -0.2797070|                  -0.9796289|                  -0.9724968|                  -0.9660329|                   -0.5862786|                   -0.6455741|                   -0.6984150|       -0.7911948|       -0.6218568|       -0.4345948|           -0.8314527|           -0.8139022|           -0.7881127|                       -0.3216467|                          -0.3216467|                           -0.5775330|               -0.7124894|                   -0.8526565|               -0.3513458|               -0.2172414|               -0.2314651|                   -0.5840454|                   -0.6553989|                   -0.7240879|       -0.8038259|       -0.5851647|       -0.4453364|                       -0.3694448|                               -0.5850636|                   -0.7216584|                       -0.8726520| WALKING\_UPSTAIRS   |
| 667  |               0.2493467|              -0.0189993|              -0.0653885|                  0.9352309|                 -0.2514568|                  0.0800747|                   0.1476059|                  -0.1153832|                  -0.1314775|       0.0734204|      -0.1822848|       0.1307728|          -0.0718773|          -0.0943405|           0.0709532|                      -0.1088585|                         -0.1088585|                          -0.4052235|              -0.2649362|                  -0.6730573|              -0.3496204|              -0.0710725|              -0.4951535|                  -0.4385854|                  -0.2934289|                  -0.6769917|      -0.3578062|      -0.6633963|      -0.3299503|                      -0.2876958|                              -0.3731298|                  -0.5404778|                      -0.7206895|               -0.2114850|                0.0311110|               -0.2889874|                  -0.9691026|                  -0.9727003|                  -0.8847108|                   -0.3933635|                   -0.2597819|                   -0.6985024|       -0.3487431|       -0.5560378|       -0.2642356|           -0.5222995|           -0.8076309|           -0.5646720|                       -0.2451631|                          -0.2451631|                           -0.4100516|               -0.5125773|                   -0.7437637|               -0.1631529|                0.0173236|               -0.2439767|                   -0.3996196|                   -0.2723431|                   -0.7177420|       -0.3544891|       -0.5040469|       -0.3110927|                       -0.3393022|                               -0.4639187|                   -0.5769958|                       -0.7959012| WALKING\_UPSTAIRS   |
| 1107 |               0.4601335|               0.0234881|              -0.1101610|                  0.8718660|                 -0.3282849|                 -0.1409930|                   0.5074715|                  -0.2434803|                  -0.0330920|      -0.2314286|       0.2392234|       0.2098913|          -0.1332102|           0.1315154|          -0.0770466|                       0.1270443|                          0.1270443|                          -0.1155980|              -0.1259705|                  -0.2974734|               0.0423258|               0.4154223|              -0.1878274|                  -0.2210038|                   0.1639667|                  -0.4008252|      -0.2520368|      -0.1504447|      -0.0473748|                       0.1756283|                               0.0618578|                  -0.1669584|                      -0.3689618|                0.0127809|                0.4734930|               -0.1314476|                  -0.8878839|                  -0.7915148|                  -0.9249168|                   -0.1687624|                    0.2901214|                   -0.4423484|       -0.4225974|       -0.1787688|       -0.0677088|           -0.2958822|           -0.3134274|           -0.2182995|                        0.1892422|                           0.1892422|                            0.0584687|               -0.1648539|                   -0.3324596|                0.0009669|                0.4103923|               -0.1687821|                   -0.1873028|                    0.3426756|                   -0.4809997|       -0.4767876|       -0.2025895|       -0.1596552|                        0.0116286|                                0.0462778|                   -0.3098471|                       -0.3306662| WALKING\_DOWNSTAIRS |
| 1477 |               0.2782734|              -0.0172224|              -0.1127566|                  0.9141105|                  0.1714807|                  0.2254323|                   0.0778831|                   0.0122094|                   0.0070454|      -0.0280037|      -0.0647859|       0.0796986|          -0.1027001|          -0.0378636|          -0.0508315|                      -0.9942295|                         -0.9942295|                          -0.9934699|              -0.9936556|                  -0.9949945|              -0.9957690|              -0.9900898|              -0.9870576|                  -0.9937498|                  -0.9890757|                  -0.9916778|      -0.9919044|      -0.9925646|      -0.9956506|                      -0.9919579|                              -0.9945045|                  -0.9930933|                      -0.9961115|               -0.9969308|               -0.9927660|               -0.9840454|                  -0.9983492|                  -0.9990854|                  -0.9846446|                   -0.9940442|                   -0.9890287|                   -0.9930778|       -0.9948513|       -0.9922922|       -0.9970964|           -0.9925312|           -0.9950319|           -0.9951246|                       -0.9908434|                          -0.9908434|                           -0.9948842|               -0.9924094|                   -0.9963852|               -0.9975344|               -0.9937996|               -0.9825051|                   -0.9949600|                   -0.9897404|                   -0.9930136|       -0.9958757|       -0.9920774|       -0.9980330|                       -0.9904726|                               -0.9940378|                   -0.9930152|                       -0.9967210| SITTING             |

We also remove "ActivityID", given that "ActivityLabel" is better suited for data exploration.

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
| 1559 |               0.1751063|              -0.0660731|              -0.2033070|                  0.9381380|                 -0.3052938|                  0.0151046|                   0.1575448|                  -0.1302381|                   0.0004589|      -0.4675828|       0.0894120|       0.0341000|           0.0673435|          -0.0584995|          -0.1177902|                       0.0019406|                          0.0019406|                          -0.2585014|              -0.2264742|                  -0.4980206|              -0.0669535|               0.0820617|              -0.4802160|                  -0.1443850|                  -0.1865530|                  -0.6092326|      -0.3837718|      -0.4711201|      -0.0481930|                      -0.0000453|                              -0.0488101|                  -0.3698671|                      -0.5105359|               -0.0298925|                0.2380555|               -0.4115807|                  -0.9289829|                  -0.8179715|                  -0.8353813|                   -0.0895797|                   -0.1180200|                   -0.6478131|       -0.5583237|       -0.4707440|       -0.1537980|           -0.4513337|           -0.5881491|           -0.1788027|                        0.0661208|                           0.0661208|                           -0.0462081|               -0.3297067|                   -0.4867817|               -0.0156457|                0.2364328|               -0.4200618|                   -0.1124455|                   -0.1009132|                   -0.6849650|       -0.6149973|       -0.4742206|       -0.2688145|                       -0.0643793|                               -0.0480621|                   -0.4169617|                       -0.4921682| WALKING\_UPSTAIRS |
| 6737 |               0.4034743|              -0.0150744|              -0.1181674|                 -0.2550438|                  0.7746587|                  0.5897766|                   0.0234469|                   0.0008133|                   0.0528113|       0.0315520|      -0.1319951|       0.5432788|          -0.1190664|          -0.0487861|          -0.1554495|                      -0.9051229|                         -0.9051229|                          -0.9603565|              -0.7775618|                  -0.9732644|              -0.9263140|              -0.8869485|              -0.9287921|                  -0.9491758|                  -0.8980041|                  -0.9729599|      -0.9521760|      -0.9331338|      -0.8355401|                      -0.8751096|                              -0.9102897|                  -0.8759977|                      -0.9524838|               -0.9148112|               -0.8952311|               -0.8917481|                  -0.7837423|                  -0.9889256|                  -0.8953808|                   -0.9474534|                   -0.8972260|                   -0.9781684|       -0.9551393|       -0.9336056|       -0.8118869|           -0.9697420|           -0.9531439|           -0.9721019|                       -0.8316961|                          -0.8316961|                           -0.9022409|               -0.8116484|                   -0.9403461|               -0.9103749|               -0.9056274|               -0.8810446|                   -0.9502229|                   -0.9036754|                   -0.9824606|       -0.9562644|       -0.9342784|       -0.8216842|                       -0.8361963|                               -0.8914699|                   -0.8062476|                       -0.9305440| LAYING            |
| 1565 |               0.2102592|              -0.0389435|              -0.1048268|                  0.9050940|                 -0.3299893|                 -0.0310154|                  -0.0997351|                   0.1158571|                   0.2824299|      -0.0071091|       0.0134605|       0.0614816|          -0.2201299|          -0.2418700|          -0.2215702|                      -0.0054181|                         -0.0054181|                          -0.2847082|              -0.0846497|                  -0.4916124|              -0.0395541|               0.0226685|              -0.3609334|                  -0.1822034|                  -0.1932448|                  -0.5345397|      -0.1340383|      -0.3226870|       0.0059493|                      -0.0810729|                              -0.0538606|                  -0.2279978|                      -0.5258990|               -0.0704522|                0.1866665|               -0.3352611|                  -0.9692568|                  -0.9712176|                  -0.9163511|                   -0.1391074|                   -0.1571434|                   -0.5952758|       -0.1833801|       -0.2792000|       -0.1419795|           -0.3337326|           -0.5902796|           -0.2967055|                       -0.0606182|                          -0.0606182|                           -0.0762085|               -0.1737539|                   -0.4879149|               -0.0828744|                0.1915560|               -0.3735595|                   -0.1698322|                   -0.1740360|                   -0.6572355|       -0.2050849|       -0.2586226|       -0.2749200|                       -0.1953028|                               -0.1105594|                   -0.2781542|                       -0.4765536| WALKING\_UPSTAIRS |
| 7226 |               0.2729400|              -0.0192653|              -0.1026033|                 -0.4359217|                  0.7791011|                  0.6419048|                   0.0729320|                   0.0007466|                  -0.0003736|      -0.0273547|      -0.0650348|       0.0870935|          -0.0959686|          -0.0466244|          -0.0497627|                      -0.9913070|                         -0.9913070|                          -0.9929223|              -0.9898848|                  -0.9964943|              -0.9936229|              -0.9866246|              -0.9868083|                  -0.9951415|                  -0.9892896|                  -0.9858055|      -0.9916602|      -0.9905274|      -0.9917663|                      -0.9927476|                              -0.9883056|                  -0.9910593|                      -0.9970202|               -0.9937142|               -0.9867171|               -0.9870628|                  -0.9960472|                  -0.9914773|                  -0.9864700|                   -0.9956854|                   -0.9903617|                   -0.9879726|       -0.9925282|       -0.9874692|       -0.9935773|           -0.9950240|           -0.9968205|           -0.9939094|                       -0.9929712|                          -0.9929712|                           -0.9899561|               -0.9898484|                   -0.9972696|               -0.9936275|               -0.9864897|               -0.9873629|                   -0.9968246|                   -0.9926323|                   -0.9887085|       -0.9927333|       -0.9857689|       -0.9948698|                       -0.9932871|                               -0.9914120|                   -0.9905015|                       -0.9974743| LAYING            |
| 5564 |               0.2812170|              -0.0373264|              -0.1483023|                  0.9647485|                 -0.1097100|                  0.1258544|                   0.0726641|                   0.0068590|                  -0.0001153|      -0.0383619|      -0.0873377|       0.1024336|          -0.1021452|          -0.0407471|          -0.0549390|                      -0.9554513|                         -0.9554513|                          -0.9841428|              -0.9743908|                  -0.9894113|              -0.9936518|              -0.9615624|              -0.9705799|                  -0.9905268|                  -0.9742082|                  -0.9779283|      -0.9690757|      -0.9868232|      -0.9838842|                      -0.9636035|                              -0.9816533|                  -0.9752875|                      -0.9897818|               -0.9956679|               -0.9497584|               -0.9537889|                  -0.9963426|                  -0.9565123|                  -0.9352617|                   -0.9906365|                   -0.9738412|                   -0.9809680|       -0.9704341|       -0.9831427|       -0.9800004|           -0.9806411|           -0.9912276|           -0.9909064|                       -0.9432158|                          -0.9432158|                           -0.9801692|               -0.9622649|                   -0.9890949|               -0.9967826|               -0.9462953|               -0.9477701|                   -0.9916070|                   -0.9752324|                   -0.9825911|       -0.9709785|       -0.9811299|       -0.9803959|                       -0.9411915|                               -0.9765543|                   -0.9606577|                       -0.9884972| STANDING          |
| 6097 |               0.2714520|              -0.0165485|              -0.1080521|                 -0.2247099|                  0.7293879|                  0.6751672|                   0.0743655|                   0.0118974|                   0.0026991|      -0.0275623|      -0.0701007|       0.0874760|          -0.0965018|          -0.0409939|          -0.0558846|                      -0.9939384|                         -0.9939384|                          -0.9903215|              -0.9934180|                  -0.9958069|              -0.9917753|              -0.9878800|              -0.9887375|                  -0.9900932|                  -0.9865779|                  -0.9890177|      -0.9942633|      -0.9898320|      -0.9953737|                      -0.9914453|                              -0.9924573|                  -0.9918868|                      -0.9935339|               -0.9929853|               -0.9901176|               -0.9894131|                  -0.9956156|                  -0.9983196|                  -0.9950860|                   -0.9897752|                   -0.9866554|                   -0.9910505|       -0.9951832|       -0.9894940|       -0.9967422|           -0.9958951|           -0.9935191|           -0.9944452|                       -0.9919854|                          -0.9919854|                           -0.9922042|               -0.9912316|                   -0.9936131|               -0.9934766|               -0.9909868|               -0.9898288|                   -0.9902884|                   -0.9877063|                   -0.9917112|       -0.9954072|       -0.9892580|       -0.9976436|                       -0.9926817|                               -0.9903258|                   -0.9920650|                       -0.9937615| LAYING            |

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

The following data-set has been grouped by activity and all columns summarised into their respective means:

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
