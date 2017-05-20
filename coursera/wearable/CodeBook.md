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

    ## [1] "tBodyGyroJerk-min()-X"         "tBodyGyroMag-energy()"        
    ## [3] "fBodyGyro-bandsEnergy()-49,64" "tBodyAcc-max()-Z"             
    ## [5] "fBodyGyro-bandsEnergy()-57,64" "fBodyGyro-bandsEnergy()-49,56"

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

    ## [1] "tBodyGyroJerk-max()-Z"  "tBodyGyroJerk-mad()-X" 
    ## [3] "tBodyAccJerk-mad()-X"   "tBodyAccMag-arCoeff()2"
    ## [5] "tBodyGyroMag-mad()"     "tGravityAccMag-mean()"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-X"           "fBodyAcc-mean()-Z"          
    ## [3] "tBodyGyroJerkMag-mean()"     "fBodyBodyGyroJerkMag-mean()"
    ## [5] "tBodyGyroMag-mean()"         "tBodyAcc-mean()-Z"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyGyroJerkMag-std()"     "fBodyAccJerk-std()-Y"      
    ## [3] "tBodyGyroMag-std()"         "fBodyBodyGyroJerkMag-std()"
    ## [5] "tGravityAcc-std()-Z"        "tBodyAccJerk-std()-X"

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

    ## [1] "tBodyGyro-correlation()-X,Z" "angle(X,gravityMean)"       
    ## [3] "tBodyAccJerk-mean()-X"       "tBodyGyro-std()-Y"          
    ## [5] "tBodyGyro-std()-Z"           "fBodyBodyAccJerkMag-max()"

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
| 2765 |               0.2731218|              -0.0211591|              -0.1423142|                  0.9698538|                 -0.1525972|                 -0.0313514|                   0.0779531|                   0.0121463|                   0.0134850|      -0.0507244|      -0.0741673|       0.1027454|          -0.0941862|          -0.0329900|          -0.0529528|                      -0.9560391|                         -0.9560391|                          -0.9820960|              -0.9210008|                  -0.9851662|              -0.9884144|              -0.9454341|              -0.9700933|                  -0.9844783|                  -0.9686438|                  -0.9794498|      -0.9389507|      -0.9727343|      -0.9680748|                      -0.9687631|                              -0.9777303|                  -0.9634408|                      -0.9873696|               -0.9913747|               -0.9262123|               -0.9658763|                  -0.9966048|                  -0.9832448|                  -0.9510970|                   -0.9853778|                   -0.9709274|                   -0.9830658|       -0.9151872|       -0.9583504|       -0.9571623|           -0.9749776|           -0.9881099|           -0.9858052|                       -0.9655858|                          -0.9655858|                           -0.9798622|               -0.9313281|                   -0.9857101|               -0.9928684|               -0.9210167|               -0.9651211|                   -0.9878717|                   -0.9763111|                   -0.9854678|       -0.9113545|       -0.9515254|       -0.9576757|                       -0.9679075|                               -0.9818389|                   -0.9255695|                       -0.9841458|           5|
| 2263 |               0.2756698|              -0.0138313|              -0.1041062|                  0.8633774|                  0.1700799|                  0.3470093|                   0.0782219|                   0.0179355|                  -0.0092025|      -0.0262784|      -0.0788405|       0.0822628|          -0.0982764|          -0.0405516|          -0.0484212|                      -0.9946331|                         -0.9946331|                          -0.9929458|              -0.9956311|                  -0.9979939|              -0.9935034|              -0.9889344|              -0.9896288|                  -0.9913518|                  -0.9913388|                  -0.9909928|      -0.9978411|      -0.9956635|      -0.9896581|                      -0.9923758|                              -0.9944578|                  -0.9949083|                      -0.9982164|               -0.9955757|               -0.9916419|               -0.9898329|                  -0.9996433|                  -0.9946543|                  -0.9906718|                   -0.9918484|                   -0.9914224|                   -0.9928878|       -0.9984996|       -0.9949859|       -0.9904460|           -0.9981197|           -0.9974662|           -0.9955827|                       -0.9933212|                          -0.9933212|                           -0.9953665|               -0.9934472|                   -0.9983418|               -0.9967232|               -0.9927509|               -0.9898772|                   -0.9932286|                   -0.9921414|                   -0.9934351|       -0.9987025|       -0.9945031|       -0.9914939|                       -0.9941936|                               -0.9956904|                   -0.9933001|                       -0.9983111|           4|
| 1230 |               0.2767329|              -0.0215761|              -0.1103425|                  0.7812271|                  0.3171604|                  0.3531460|                   0.0873920|                   0.0255470|                   0.0250936|      -0.0584905|      -0.2856322|       0.2789970|          -0.0953402|          -0.0249762|          -0.0916126|                      -0.9740161|                         -0.9740161|                          -0.9863523|              -0.8671050|                  -0.9917610|              -0.9824826|              -0.9679112|              -0.9752058|                  -0.9830429|                  -0.9786808|                  -0.9895838|      -0.9841434|      -0.9756387|      -0.9484855|                      -0.9728824|                              -0.9832583|                  -0.9532172|                      -0.9890724|               -0.9866002|               -0.9592053|               -0.9563328|                  -0.9714368|                  -0.9638535|                  -0.9408215|                   -0.9804562|                   -0.9810569|                   -0.9909956|       -0.9870472|       -0.9731072|       -0.9442921|           -0.9883630|           -0.9903628|           -0.9920208|                       -0.9679938|                          -0.9679938|                           -0.9826234|               -0.9345327|                   -0.9897286|               -0.9886130|               -0.9565101|               -0.9493297|                   -0.9793401|                   -0.9859902|                   -0.9908950|       -0.9878970|       -0.9716991|       -0.9478331|                       -0.9690046|                               -0.9801655|                   -0.9339820|                       -0.9910864|           4|
| 255  |               0.2880686|              -0.0322015|              -0.1159674|                  0.8912263|                 -0.3468530|                  0.1478968|                  -0.2862811|                   0.2584808|                   0.3281411|      -0.0571240|      -0.0237822|       0.0533680|          -0.0349386|          -0.0723111|           0.0865569|                      -0.3146061|                         -0.3146061|                          -0.3152234|              -0.4209095|                  -0.4758180|              -0.2968475|              -0.0453985|              -0.4137022|                  -0.3220167|                  -0.1453627|                  -0.5191696|      -0.4234164|      -0.4430428|      -0.3034626|                      -0.3010853|                              -0.1361905|                  -0.4859978|                      -0.4423515|               -0.4151643|               -0.1253553|               -0.4446514|                  -0.9848334|                  -0.9812990|                  -0.9886829|                   -0.2700794|                   -0.0824588|                   -0.5422113|       -0.5663406|       -0.4771591|       -0.4384064|           -0.3748969|           -0.5063449|           -0.2809625|                       -0.3867882|                          -0.3867882|                           -0.1182092|               -0.5351089|                   -0.4061702|               -0.4688589|               -0.2272161|               -0.5097551|                   -0.2801454|                   -0.0739138|                   -0.5625567|       -0.6119645|       -0.5031064|       -0.5419101|                       -0.5361154|                               -0.1016772|                   -0.6604437|                       -0.4022907|           1|
| 1225 |               0.2837340|              -0.0124608|              -0.0788817|                  0.9524401|                 -0.2137754|                 -0.1274057|                   0.0817169|                  -0.0042185|                  -0.0323901|       0.1461687|      -0.1529760|       0.0326714|          -0.1647805|          -0.0253405|          -0.0400058|                      -0.9623150|                         -0.9623150|                          -0.9716348|              -0.6893655|                  -0.9716261|              -0.9838525|              -0.9524118|              -0.9538533|                  -0.9798210|                  -0.9672336|                  -0.9649930|      -0.8122145|      -0.9523694|      -0.9483765|                      -0.9630396|                              -0.9737042|                  -0.8611455|                      -0.9766797|               -0.9882138|               -0.9509249|               -0.9516418|                  -0.9941011|                  -0.9912650|                  -0.9716750|                   -0.9792556|                   -0.9671334|                   -0.9702229|       -0.6491679|       -0.9165403|       -0.9315628|           -0.9545335|           -0.9785052|           -0.9812669|                       -0.9628438|                          -0.9628438|                           -0.9760488|               -0.6243846|                   -0.9775761|               -0.9904622|               -0.9521477|               -0.9532509|                   -0.9804404|                   -0.9693615|                   -0.9742429|       -0.6253011|       -0.9008584|       -0.9327652|                       -0.9673682|                               -0.9780664|                   -0.5796080|                       -0.9798878|           5|
| 1854 |               0.2796899|              -0.0126843|              -0.1030692|                  0.9654469|                 -0.1604085|                  0.0855367|                   0.0738459|                   0.0165065|                   0.0222780|      -0.0241412|      -0.0661986|       0.0810735|          -0.0946292|          -0.0387076|          -0.0497598|                      -0.9906847|                         -0.9906847|                          -0.9937197|              -0.9935438|                  -0.9968603|              -0.9968122|              -0.9791122|              -0.9892106|                  -0.9971414|                  -0.9840401|                  -0.9944796|      -0.9914926|      -0.9966997|      -0.9930030|                      -0.9911114|                              -0.9964859|                  -0.9948155|                      -0.9968236|               -0.9972123|               -0.9776689|               -0.9893131|                  -0.9990537|                  -0.9974393|                  -0.9968060|                   -0.9972198|                   -0.9841070|                   -0.9958832|       -0.9938028|       -0.9960254|       -0.9945056|           -0.9941587|           -0.9983558|           -0.9930760|                       -0.9899530|                          -0.9899530|                           -0.9970619|               -0.9944321|                   -0.9971949|               -0.9973475|               -0.9772028|               -0.9893224|                   -0.9975653|                   -0.9853301|                   -0.9959088|       -0.9945121|       -0.9955374|       -0.9955864|                       -0.9896985|                               -0.9967859|                   -0.9949214|                       -0.9976653|           5|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName      |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 2021 |               0.2738738|              -0.0140176|              -0.1002585|                  0.9619350|                 -0.0557269|                  0.1566570|                   0.0792935|                   0.0049249|                   0.0031894|      -0.0293481|      -0.0696025|       0.0847886|          -0.1070135|          -0.0425383|          -0.0565242|                      -0.9843278|                         -0.9843278|                          -0.9851216|              -0.9705106|                  -0.9853451|              -0.9856173|              -0.9887976|              -0.9770287|                  -0.9841461|                  -0.9879443|                  -0.9795209|      -0.9632943|      -0.9807245|      -0.9823381|                      -0.9842524|                              -0.9839247|                  -0.9757207|                      -0.9838629|               -0.9876678|               -0.9914762|               -0.9738439|                  -0.9952120|                  -0.9939580|                  -0.9778187|                   -0.9837135|                   -0.9888354|                   -0.9811344|       -0.9690639|       -0.9792473|       -0.9795852|           -0.9681023|           -0.9898978|           -0.9914079|                       -0.9876801|                          -0.9876801|                           -0.9822312|               -0.9755937|                   -0.9826006|               -0.9885176|               -0.9925750|               -0.9730390|                   -0.9846462|                   -0.9909200|                   -0.9811215|       -0.9708414|       -0.9784011|       -0.9803595|                       -0.9914236|                               -0.9782170|                   -0.9796071|                       -0.9817168| STANDING          |
| 2655 |               0.2795622|              -0.0184240|              -0.1072702|                 -0.2792072|                  0.9069473|                  0.3648179|                   0.0752298|                   0.0129701|                  -0.0014186|      -0.0334498|      -0.0867231|       0.0582499|          -0.0984204|          -0.0393383|          -0.0482088|                      -0.9954276|                         -0.9954276|                          -0.9902143|              -0.9844148|                  -0.9953688|              -0.9935485|              -0.9880391|              -0.9883891|                  -0.9918138|                  -0.9873522|                  -0.9856029|      -0.9944856|      -0.9902102|      -0.9910384|                      -0.9918646|                              -0.9890034|                  -0.9931921|                      -0.9939367|               -0.9948716|               -0.9912429|               -0.9898566|                  -0.9980180|                  -0.9973056|                  -0.9990292|                   -0.9921654|                   -0.9875029|                   -0.9875119|       -0.9949182|       -0.9886047|       -0.9892677|           -0.9965497|           -0.9930253|           -0.9929127|                       -0.9928032|                          -0.9928032|                           -0.9901748|               -0.9890949|                   -0.9930903|               -0.9954826|               -0.9927321|               -0.9908308|                   -0.9933200|                   -0.9885979|                   -0.9879308|       -0.9949829|       -0.9876361|       -0.9894689|                       -0.9937316|                               -0.9907379|                   -0.9880877|                       -0.9920035| LAYING            |
| 871  |               0.3492413|              -0.0096153|              -0.1086138|                  0.9115734|                 -0.2240710|                 -0.2365209|                  -0.0191936|                  -0.5067258|                  -0.1372521|      -0.0577370|      -0.1046518|       0.2949491|          -0.1991355|          -0.0491046|          -0.0907053|                      -0.2204354|                         -0.2204354|                          -0.4980906|              -0.5001413|                  -0.6494810|              -0.4539318|              -0.0976979|              -0.3124988|                  -0.5780672|                  -0.5098281|                  -0.4361141|      -0.5836278|      -0.5639806|      -0.4100566|                      -0.3629786|                              -0.4640309|                  -0.6162065|                      -0.6334398|               -0.3815359|               -0.0207746|               -0.2653186|                  -0.9734033|                  -0.9116978|                  -0.9560680|                   -0.5674606|                   -0.4994555|                   -0.4992568|       -0.6768748|       -0.5838692|       -0.3752657|           -0.6614222|           -0.6442927|           -0.5943067|                       -0.3535070|                          -0.3535070|                           -0.4816908|               -0.5995190|                   -0.6428144|               -0.3550848|               -0.0431998|               -0.2970052|                   -0.5949539|                   -0.5227983|                   -0.5621459|       -0.7064435|       -0.5995717|       -0.4212686|                       -0.4482502|                               -0.5059767|                   -0.6568528|                       -0.6804831| WALKING\_UPSTAIRS |
| 2636 |               0.2809226|              -0.0192177|              -0.1131460|                 -0.3950540|                 -0.9985734|                  0.2913221|                   0.0759289|                   0.0062326|                  -0.0031659|      -0.0281944|      -0.0748154|       0.0878736|          -0.0963620|          -0.0366774|          -0.0495080|                      -0.9814601|                         -0.9814601|                          -0.9907009|              -0.9782759|                  -0.9761625|              -0.9857478|              -0.9871168|              -0.9902616|                  -0.9857976|                  -0.9895549|                  -0.9950836|      -0.9909234|      -0.9723104|      -0.9911543|                      -0.9899168|                              -0.9898297|                  -0.9743774|                      -0.9772945|               -0.9828656|               -0.9856794|               -0.9742786|                  -0.9850682|                  -0.9917259|                  -0.9787218|                   -0.9837176|                   -0.9900203|                   -0.9960257|       -0.9909895|       -0.9679889|       -0.9891611|           -0.9919958|           -0.9682317|           -0.9946830|                       -0.9880242|                          -0.9880242|                           -0.9910937|               -0.9760802|                   -0.9755452|               -0.9815459|               -0.9847063|               -0.9675041|                   -0.9828324|                   -0.9913874|                   -0.9954757|       -0.9909762|       -0.9656476|       -0.9892995|                       -0.9875927|                               -0.9914616|                   -0.9815987|                       -0.9745152| LAYING            |
| 703  |               0.2090638|              -0.0493596|              -0.3145038|                  0.8618297|                 -0.4282013|                 -0.1392346|                  -0.0236153|                   0.3708130|                   0.4786402|      -0.2305680|       0.2477127|       0.1113683|          -0.0478051|          -0.0984995|          -0.0316873|                      -0.1348180|                         -0.1348180|                          -0.3469736|              -0.2954055|                  -0.6030343|              -0.3623730|               0.0323619|              -0.3254301|                  -0.3653808|                  -0.1423484|                  -0.5652200|      -0.5482178|      -0.4999416|      -0.2123896|                      -0.1513545|                              -0.3038361|                  -0.5127914|                      -0.6684074|               -0.3386485|                0.1344836|               -0.2312694|                  -0.9025848|                  -0.9501223|                  -0.5115199|                   -0.3721204|                   -0.1349623|                   -0.6319444|       -0.6525703|       -0.4005210|       -0.0942685|           -0.5667256|           -0.6859136|           -0.4446508|                       -0.2417437|                          -0.2417437|                           -0.3292350|               -0.4342238|                   -0.6777748|               -0.3294357|                0.1144071|               -0.2403741|                   -0.4379691|                   -0.1885998|                   -0.7026087|       -0.6857151|       -0.3507104|       -0.1415270|                       -0.4157344|                               -0.3663196|                   -0.4783746|                       -0.7129962| WALKING\_UPSTAIRS |
| 35   |               0.2055929|              -0.0290839|              -0.1350928|                  0.9436514|                 -0.2290274|                  0.0968594|                   0.1944872|                   0.3798136|                  -0.0752204|       0.0489574|      -0.1726454|       0.1336779|          -0.2146085|          -0.0343041|           0.0075690|                      -0.3072036|                         -0.3072036|                          -0.4414072|              -0.4620866|                  -0.6286166|              -0.4080612|              -0.1258261|              -0.6246305|                  -0.4576323|                  -0.2899596|                  -0.7477131|      -0.4820880|      -0.6280891|      -0.5580852|                      -0.4752806|                              -0.4048544|                  -0.6419369|                      -0.7056334|               -0.4088154|               -0.1579405|               -0.5310708|                  -0.9842778|                  -0.9435166|                  -0.9570703|                   -0.4317048|                   -0.2511596|                   -0.7706519|       -0.6201617|       -0.4871782|       -0.5572619|           -0.4179467|           -0.7537747|           -0.7108217|                       -0.5121467|                          -0.5121467|                           -0.4261604|               -0.6041770|                   -0.7309548|               -0.4090202|               -0.2288606|               -0.5186491|                   -0.4546660|                   -0.2582255|                   -0.7918463|       -0.6645679|       -0.4202922|       -0.5973299|                       -0.6095478|                               -0.4568000|                   -0.6459987|                       -0.7889218| WALKING           |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:-------------|
| 1079 |               0.1961865|              -0.0160303|              -0.2104497|                  0.9512652|                 -0.1685783|                 -0.1137729|                  -0.1030570|                   0.2429192|                   0.4018416|      -0.4299086|       0.1689285|       0.2628274|           0.0671477|          -0.3276891|           0.0448478|                      -0.1385387|                         -0.1385387|                          -0.1896997|              -0.0128675|                  -0.0421402|              -0.3045186|              -0.1376798|              -0.0264174|                  -0.3616915|                  -0.2610371|                  -0.2057755|      -0.4088724|       0.0936555|      -0.2426283|                      -0.1711184|                              -0.0696453|                   0.1170429|                       0.1477070|               -0.3147697|               -0.1557307|                0.0359041|                  -0.9586227|                  -0.9762790|                  -0.8303071|                   -0.3165399|                   -0.1212965|                   -0.1965708|       -0.6004593|        0.1915136|       -0.3003874|           -0.4706343|            0.2489590|           -0.3658299|                       -0.2533732|                          -0.2533732|                           -0.1283135|                0.0915624|                    0.2149372|               -0.3187756|               -0.2188871|               -0.0115582|                   -0.3295183|                   -0.0326006|                   -0.1872926|       -0.6646468|        0.2397443|       -0.3843104|                       -0.4200812|                               -0.2158425|                   -0.1207099|                        0.2151310| WALKING      |
| 5432 |               0.2762101|              -0.0217179|              -0.1099980|                  0.9622095|                 -0.1970078|                  0.0782086|                   0.0719375|                  -0.0105135|                   0.0178355|      -0.0336741|      -0.0860377|       0.0999651|          -0.1185408|          -0.0369818|          -0.0550464|                      -0.9839728|                         -0.9839728|                          -0.9898434|              -0.9786201|                  -0.9905779|              -0.9941745|              -0.9588545|              -0.9891334|                  -0.9936801|                  -0.9675299|                  -0.9928874|      -0.9586619|      -0.9913339|      -0.9836088|                      -0.9827962|                              -0.9793583|                  -0.9651124|                      -0.9853324|               -0.9954796|               -0.9584710|               -0.9867191|                  -0.9976963|                  -0.9879184|                  -0.9918064|                   -0.9933281|                   -0.9688609|                   -0.9947871|       -0.9688386|       -0.9894313|       -0.9833292|           -0.9724693|           -0.9958265|           -0.9891909|                       -0.9820669|                          -0.9820669|                           -0.9819307|               -0.9606804|                   -0.9829248|               -0.9961033|               -0.9597966|               -0.9853092|                   -0.9934733|                   -0.9729516|                   -0.9954162|       -0.9720300|       -0.9883019|       -0.9845891|                       -0.9832941|                               -0.9848031|                   -0.9641112|                       -0.9807116| STANDING     |
| 3844 |               0.2765920|              -0.0115606|              -0.1001216|                  0.9720147|                 -0.0608795|                 -0.0972454|                   0.0787775|                  -0.0206093|                  -0.0387999|      -0.0379642|      -0.1231841|       0.1096867|          -0.1061470|          -0.0547878|          -0.0665787|                      -0.9653387|                         -0.9653387|                          -0.9738078|              -0.9533725|                  -0.9772710|              -0.9829362|              -0.9460468|              -0.9564130|                  -0.9799428|                  -0.9641909|                  -0.9726401|      -0.9642021|      -0.9649229|      -0.9573641|                      -0.9669401|                              -0.9763947|                  -0.9656504|                      -0.9819124|               -0.9867352|               -0.9464233|               -0.9487491|                  -0.9982427|                  -0.9759026|                  -0.9901506|                   -0.9806600|                   -0.9636144|                   -0.9769020|       -0.9746632|       -0.9584393|       -0.9553866|           -0.9693436|           -0.9827111|           -0.9734142|                       -0.9690295|                          -0.9690295|                           -0.9790390|               -0.9595981|                   -0.9835866|               -0.9885598|               -0.9489388|               -0.9474522|                   -0.9833190|                   -0.9654799|                   -0.9799111|       -0.9780478|       -0.9550071|       -0.9586228|                       -0.9741126|                               -0.9818822|                   -0.9621670|                       -0.9870268| SITTING      |
| 1039 |               0.2826491|              -0.0110858|              -0.0847763|                  0.9385656|                 -0.0724195|                 -0.2430557|                   0.1009701|                  -0.0398006|                   0.0461825|      -0.0317982|      -0.0858499|       0.0865489|          -0.0610983|          -0.0483154|          -0.0390211|                      -0.1691763|                         -0.1691763|                          -0.2994257|              -0.3912453|                  -0.4815860|              -0.4607386|              -0.1019876|              -0.3901172|                  -0.4873635|                  -0.1878197|                  -0.5219155|      -0.5899610|      -0.4659779|      -0.5033322|                      -0.4751995|                              -0.3064700|                  -0.5449268|                      -0.5378350|               -0.3678893|               -0.0405162|               -0.2210080|                  -0.9795732|                  -0.9817517|                  -0.9506929|                   -0.4084996|                   -0.0355011|                   -0.5082222|       -0.6085418|       -0.4150014|       -0.4222231|           -0.5607911|           -0.4171032|           -0.5779996|                       -0.5383697|                          -0.5383697|                           -0.2788047|               -0.6021840|                   -0.4576129|               -0.3346855|               -0.0693499|               -0.1953330|                   -0.3814851|                    0.0608240|                   -0.4948589|       -0.6176173|       -0.3896660|       -0.4506866|                       -0.6496143|                               -0.2491176|                   -0.7248599|                       -0.4026154| WALKING      |
| 4493 |               0.2888771|              -0.0227092|              -0.1453041|                  0.9546752|                 -0.0305234|                  0.1918680|                   0.0776255|                   0.0147901|                  -0.0247683|      -0.0282559|      -0.0994692|       0.0882934|          -0.0980495|          -0.0359593|          -0.0571941|                      -0.9637382|                         -0.9637382|                          -0.9855324|              -0.9782002|                  -0.9921684|              -0.9916873|              -0.9721826|              -0.9586984|                  -0.9919929|                  -0.9836078|                  -0.9777142|      -0.9894420|      -0.9739878|      -0.9754689|                      -0.9657471|                              -0.9875556|                  -0.9723722|                      -0.9905875|               -0.9930100|               -0.9682032|               -0.9475015|                  -0.9918996|                  -0.9922765|                  -0.9582110|                   -0.9924183|                   -0.9835200|                   -0.9815391|       -0.9910468|       -0.9652759|       -0.9733936|           -0.9919653|           -0.9902262|           -0.9873102|                       -0.9539672|                          -0.9539672|                           -0.9888091|               -0.9566445|                   -0.9889083|               -0.9935647|               -0.9670834|               -0.9444721|                   -0.9936498|                   -0.9845759|                   -0.9841537|       -0.9914837|       -0.9608490|       -0.9749498|                       -0.9538502|                               -0.9891741|                   -0.9545435|                       -0.9871387| SITTING      |
| 4929 |               0.2773184|              -0.0168131|              -0.1087897|                  0.9634392|                 -0.2015838|                 -0.0185690|                   0.0719152|                   0.0134831|                   0.0049146|      -0.0276069|      -0.0701646|       0.0842534|          -0.0963464|          -0.0399323|          -0.0545074|                      -0.9904224|                         -0.9904224|                          -0.9916168|              -0.9910394|                  -0.9962287|              -0.9954059|              -0.9887511|              -0.9834016|                  -0.9954049|                  -0.9893905|                  -0.9863534|      -0.9883478|      -0.9937467|      -0.9945033|                      -0.9916558|                              -0.9931849|                  -0.9928172|                      -0.9965819|               -0.9964570|               -0.9904554|               -0.9776080|                  -0.9981411|                  -0.9951904|                  -0.9884261|                   -0.9956877|                   -0.9884977|                   -0.9881640|       -0.9888627|       -0.9929485|       -0.9949358|           -0.9935988|           -0.9960318|           -0.9964604|                       -0.9922591|                          -0.9922591|                           -0.9922799|               -0.9908190|                   -0.9968906|               -0.9969624|               -0.9909562|               -0.9750440|                   -0.9964466|                   -0.9881482|                   -0.9884800|       -0.9889914|       -0.9924087|       -0.9954720|                       -0.9929417|                               -0.9893730|                   -0.9907606|                       -0.9972533| STANDING     |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

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
