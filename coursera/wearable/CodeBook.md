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
-   [Saving the Resulting Data to Disk](#saving-the-resulting-data-to-disk)

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

    ## [1] "tBodyAcc-entropy()-Y"             "fBodyAccJerk-bandsEnergy()-17,32"
    ## [3] "fBodyAcc-kurtosis()-Y"            "tGravityAccMag-iqr()"            
    ## [5] "fBodyAcc-maxInds-Y"               "fBodyAcc-bandsEnergy()-41,48"

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

Let's create a list of all variables, which include the features names and label name:

``` r
variables <- c(feature_names, "ActivityID", "SubjectID")
```

The variable name for activity is my own choice. I believe is descriptive enough.

Let's also create a list of the variables we are interested in exploring (means and standard deviations at the moment):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "fBodyAccJerk-bandsEnergy()-1,24"  "fBodyAccJerk-bandsEnergy()-49,64"
    ## [3] "fBodyAccJerk-bandsEnergy()-33,48" "tBodyGyro-iqr()-Z"               
    ## [5] "tBodyAccJerk-iqr()-X"             "fBodyGyro-meanFreq()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "tGravityAccMag-mean()"   "tBodyGyroJerk-mean()-Z" 
    ## [3] "tBodyGyro-mean()-X"      "tBodyGyroJerkMag-mean()"
    ## [5] "fBodyGyro-mean()-X"      "tGravityAcc-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyAcc-std()-Y"      "fBodyGyro-std()-Z"     "tBodyAccJerk-std()-X" 
    ## [4] "tBodyGyroJerk-std()-Y" "tBodyGyroJerk-std()-Z" "tBodyAcc-std()-Y"

### Binding Feature, Label and Subject Data Together

``` r
add_labels <- function(data, labels) {
  data <- cbind(data, labels)
  data
}

add_subjects <- function(data, subjects) {
  data <- cbind(data, subjects)
  data
}

test_data <- add_labels(test_data, test_labels)
test_data <- add_subjects(test_data, test_subjects)
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

    ## [1] "fBodyAcc-mean()-X"             "fBodyGyro-bandsEnergy()-17,32"
    ## [3] "tBodyGyroJerk-std()-Y"         "tBodyGyroMag-arCoeff()3"      
    ## [5] "tGravityAccMag-arCoeff()1"     "fBodyAccJerk-std()-Z"

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
| 949  |               0.2771807|              -0.0162176|              -0.1099086|                  0.8878824|                  0.2699610|                  0.1319810|                   0.0735636|                   0.0171177|                  -0.0008419|      -0.0219784|      -0.0716098|       0.1110772|          -0.0995332|          -0.0406553|          -0.0611537|                      -0.9968051|                         -0.9968051|                          -0.9936332|              -0.9897687|                  -0.9972084|              -0.9957500|              -0.9835067|              -0.9951060|                  -0.9948672|                  -0.9857048|                  -0.9927728|      -0.9967189|      -0.9971460|      -0.9903378|                      -0.9926638|                              -0.9935772|                  -0.9948655|                      -0.9983486|               -0.9966676|               -0.9848760|               -0.9964313|                  -0.9979199|                  -0.9947436|                  -0.9969211|                   -0.9946779|                   -0.9868176|                   -0.9940208|       -0.9973545|       -0.9974782|       -0.9923216|           -0.9981442|           -0.9975249|           -0.9929855|                       -0.9928752|                          -0.9928752|                           -0.9944675|               -0.9940150|                   -0.9983410|               -0.9970986|               -0.9855079|               -0.9968295|                   -0.9949005|                   -0.9893736|                   -0.9937949|       -0.9975053|       -0.9976653|       -0.9937766|                       -0.9931846|                               -0.9947031|                   -0.9942077|                       -0.9980734|           4|         10|
| 1083 |               0.2782864|              -0.0181156|              -0.1069704|                  0.6814109|                 -0.5696251|                  0.3258255|                   0.0737382|                   0.0151825|                  -0.0007963|      -0.0282522|      -0.0702282|       0.0984791|          -0.0981104|          -0.0405650|          -0.0560159|                      -0.9975376|                         -0.9975376|                          -0.9978206|              -0.9958222|                  -0.9991414|              -0.9971341|              -0.9898748|              -0.9984716|                  -0.9960321|                  -0.9921016|                  -0.9981273|      -0.9984680|      -0.9989767|      -0.9950692|                      -0.9979968|                              -0.9986675|                  -0.9984578|                      -0.9994577|               -0.9979633|               -0.9867575|               -0.9986182|                  -0.9987307|                  -0.9941250|                  -0.9972867|                   -0.9960865|                   -0.9933214|                   -0.9984963|       -0.9990234|       -0.9988141|       -0.9927277|           -0.9983624|           -0.9987357|           -0.9976107|                       -0.9975195|                          -0.9975195|                           -0.9989055|               -0.9966686|                   -0.9995370|               -0.9984035|               -0.9849158|               -0.9979375|                   -0.9964986|                   -0.9956758|                   -0.9973192|       -0.9992145|       -0.9986306|       -0.9924304|                       -0.9966790|                               -0.9980936|                   -0.9957756|                       -0.9993138|           4|         10|
| 2611 |               0.2654279|              -0.0078813|              -0.0899143|                  0.8911868|                  0.2616255|                  0.1784501|                   0.0713034|                   0.0089000|                   0.0210065|      -0.0290489|      -0.0593545|       0.0739075|          -0.0975583|          -0.0385804|          -0.0563890|                      -0.9777221|                         -0.9777221|                          -0.9858157|              -0.9873362|                  -0.9923272|              -0.9906190|              -0.9797446|              -0.9710475|                  -0.9914065|                  -0.9829367|                  -0.9773219|      -0.9926584|      -0.9850342|      -0.9823610|                      -0.9791244|                              -0.9859558|                  -0.9834012|                      -0.9922136|               -0.9917528|               -0.9773344|               -0.9697562|                  -0.9946015|                  -0.9907204|                  -0.9855835|                   -0.9916172|                   -0.9831890|                   -0.9817618|       -0.9948558|       -0.9834182|       -0.9822464|           -0.9927297|           -0.9917581|           -0.9888932|                       -0.9733886|                          -0.9733886|                           -0.9871760|               -0.9784280|                   -0.9927641|               -0.9921788|               -0.9764037|               -0.9704461|                   -0.9926324|                   -0.9847311|                   -0.9851909|       -0.9955528|       -0.9824693|       -0.9836638|                       -0.9731367|                               -0.9876775|                   -0.9785831|                       -0.9937733|           4|         24|
| 140  |               0.1821957|              -0.0016885|              -0.0898050|                  0.8096558|                 -0.4179786|                 -0.2927227|                   0.3209552|                  -0.0066668|                  -0.2080512|       0.0680791|      -0.1265756|      -0.0749617|          -0.2745648|          -0.2739903|          -0.1807373|                      -0.2313004|                         -0.2313004|                          -0.3981772|              -0.1973780|                  -0.5679069|              -0.3271662|              -0.1586235|              -0.4059695|                  -0.2560644|                  -0.3799111|                  -0.5382349|      -0.2682436|      -0.4596083|      -0.1759754|                      -0.2559079|                              -0.2971073|                  -0.4466959|                      -0.6054928|               -0.3896966|                0.0199423|               -0.3236023|                  -0.9560048|                  -0.9495148|                  -0.9011688|                   -0.3168533|                   -0.3710876|                   -0.6155186|       -0.3928004|       -0.4994685|        0.0793365|           -0.3838898|           -0.6615080|           -0.5198368|                       -0.3342828|                          -0.3342828|                           -0.3263700|               -0.3864765|                   -0.5982458|               -0.4161094|                0.0403094|               -0.3317543|                   -0.4601750|                   -0.4057035|                   -0.6994420|       -0.4327552|       -0.5292889|        0.0520026|                       -0.4861364|                               -0.3682460|                   -0.4503476|                       -0.6169343|           2|          2|
| 900  |               0.2811443|              -0.0126048|              -0.0786130|                  0.8222042|                  0.0913168|                 -0.4199640|                  -0.1934268|                   0.0493222|                   0.4589081|      -0.4986505|      -0.1695059|       0.4580065|          -0.0059845|          -0.0101049|          -0.2342238|                      -0.2092223|                         -0.2092223|                          -0.3847280|              -0.0039456|                  -0.6202616|              -0.2510932|              -0.5406830|              -0.2454108|                  -0.3516271|                  -0.6929422|                  -0.5817353|      -0.4888031|      -0.3442165|      -0.4085000|                      -0.2891511|                              -0.4413763|                  -0.5521799|                      -0.6771778|               -0.2731511|               -0.4714138|               -0.0696077|                  -0.9753292|                  -0.9514194|                  -0.8755944|                   -0.2656357|                   -0.6664545|                   -0.6258919|       -0.3470263|       -0.1931185|       -0.4304899|           -0.6685284|           -0.6218204|           -0.6526969|                       -0.2705949|                          -0.2705949|                           -0.4692087|               -0.3749882|                   -0.6922122|               -0.2819409|               -0.4702170|               -0.0509177|                   -0.2430162|                   -0.6592286|                   -0.6690038|       -0.3262171|       -0.1180931|       -0.4898332|                       -0.3734404|                               -0.5095463|                   -0.3748280|                       -0.7357877|           2|          9|
| 1466 |               0.2054150|               0.0013428|              -0.1089804|                  0.9644596|                 -0.1752488|                 -0.0258181|                   0.1167590|                   0.4303002|                   0.0991833|      -0.2640575|       0.0966043|       0.1387944|          -0.2188684|           0.0722686|           0.1079505|                      -0.0585222|                         -0.0585222|                          -0.1282127|              -0.3460437|                  -0.4872868|              -0.0335877|               0.1061530|              -0.5841867|                  -0.0766339|                   0.0070488|                  -0.6512580|      -0.3156872|      -0.4443994|      -0.4777303|                      -0.0958592|                              -0.0229756|                  -0.3680263|                      -0.4940226|               -0.0750563|                0.0081408|               -0.5423622|                  -0.9855582|                  -0.9659423|                  -0.9738782|                    0.0308942|                    0.0008807|                   -0.6651129|       -0.5232129|       -0.3545499|       -0.5896868|           -0.2591006|           -0.5709310|           -0.5381743|                       -0.1945928|                          -0.1945928|                           -0.0181342|               -0.3563793|                   -0.5146061|               -0.0918978|               -0.1130022|               -0.5547940|                    0.0501564|                   -0.0799889|                   -0.6766007|       -0.5915546|       -0.3092587|       -0.6714535|                       -0.3812578|                               -0.0183462|                   -0.4602375|                       -0.5783480|           1|         12|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName      |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:------------------|
| 2400 |               0.2744153|              -0.0443325|              -0.0807122|                  0.9687427|                 -0.1377833|                 -0.0722079|                   0.0747878|                   0.0134194|                   0.0112729|      -0.0111138|      -0.0841133|       0.1157754|          -0.1046109|          -0.0423890|          -0.0659112|                      -0.9506650|                         -0.9506650|                          -0.9808600|              -0.9612121|                  -0.9882153|              -0.9842408|              -0.9630148|              -0.9710346|                  -0.9801136|                  -0.9753189|                  -0.9807383|      -0.9698563|      -0.9787347|      -0.9757303|                      -0.9688822|                              -0.9839560|                  -0.9767594|                      -0.9833835|               -0.9882393|               -0.9502465|               -0.9510337|                  -0.9945363|                  -0.9429799|                  -0.9585004|                   -0.9818416|                   -0.9756508|                   -0.9842125|       -0.9659128|       -0.9810277|       -0.9688265|           -0.9850638|           -0.9842899|           -0.9914210|                       -0.9520561|                          -0.9520561|                           -0.9853399|               -0.9711845|                   -0.9831763|               -0.9902516|               -0.9463767|               -0.9438705|                   -0.9858158|                   -0.9778437|                   -0.9864737|       -0.9652803|       -0.9826699|       -0.9693710|                       -0.9501610|                               -0.9860705|                   -0.9721444|                       -0.9836344|         24| STANDING          |
| 1981 |               0.3671248|               0.2461058|               0.3393122|                  0.9365010|                 -0.2058505|                  0.0131827|                  -0.0938512|                  -0.3077570|                   0.0098810|      -0.0589500|       0.6991406|      -0.4841371|          -0.0982717|          -0.1168434|           0.0087378|                      -0.2874264|                         -0.2874264|                          -0.8743292|              -0.5144272|                  -0.8180242|              -0.7663054|              -0.4444695|              -0.7656017|                  -0.8468931|                  -0.8536191|                  -0.8670454|      -0.8861156|      -0.6555104|      -0.4218570|                      -0.5384911|                              -0.8450858|                  -0.5471056|                      -0.7396123|               -0.7443056|               -0.1381121|               -0.5333094|                  -0.5709318|                  -0.1300454|                  -0.2862849|                   -0.8650885|                   -0.8613089|                   -0.8908403|       -0.9303594|       -0.6145636|       -0.4716564|           -0.8680194|           -0.7978168|           -0.6615396|                       -0.3023910|                          -0.3023910|                           -0.8427752|               -0.3510472|                   -0.7407244|               -0.7358813|               -0.0650959|               -0.4713664|                   -0.9031210|                   -0.8821112|                   -0.9159847|       -0.9463429|       -0.5938961|       -0.5372892|                       -0.3081753|                               -0.8393932|                   -0.3452970|                       -0.7601381|          4| STANDING          |
| 164  |               0.3152011|              -0.0609885|              -0.1284408|                  0.9756870|                 -0.0826299|                  0.0205911|                   0.0349077|                   0.1525724|                  -0.0928432|      -0.1202543|      -0.0409896|       0.1144628|           0.1575562|           0.0723525|          -0.3221533|                      -0.1484177|                         -0.1484177|                          -0.2494563|              -0.3830414|                  -0.6011298|              -0.4133666|              -0.2466045|              -0.3297248|                  -0.4276862|                  -0.2801874|                  -0.4383193|      -0.3624012|      -0.5961889|      -0.2525729|                      -0.4828793|                              -0.3555971|                  -0.5887109|                      -0.7455389|               -0.3073044|               -0.2122684|               -0.1225170|                  -0.9933765|                  -0.9860543|                  -0.9703943|                   -0.3180294|                   -0.2229950|                   -0.4193643|       -0.4989660|       -0.5996131|       -0.2848905|           -0.5856990|           -0.6829286|           -0.5064376|                       -0.4943851|                          -0.4943851|                           -0.3701067|               -0.5636492|                   -0.7371828|               -0.2695757|               -0.2437940|               -0.0865923|                   -0.2705855|                   -0.2112761|                   -0.4015615|       -0.5422562|       -0.6045158|       -0.3610854|                       -0.5790161|                               -0.3931396|                   -0.6212456|                       -0.7445689|          9| WALKING           |
| 772  |               0.3590745|               0.0115324|              -0.0985197|                  0.9006689|                 -0.2318656|                 -0.2468884|                   0.0075272|                  -0.2351823|                   0.0007294|      -0.3067900|       0.1000089|       0.3658309|          -0.3422796|           0.0211856|          -0.1674034|                      -0.2243632|                         -0.2243632|                          -0.4869123|              -0.3792537|                  -0.6879319|              -0.4542428|              -0.2321562|              -0.3181964|                  -0.5292283|                  -0.5254963|                  -0.4624073|      -0.4820366|      -0.5926749|      -0.3815505|                      -0.3591767|                              -0.4809158|                  -0.5890277|                      -0.6451922|               -0.3736606|               -0.0578325|               -0.2530053|                  -0.9618461|                  -0.8970384|                  -0.9724240|                   -0.5096867|                   -0.4874245|                   -0.5241977|       -0.5973302|       -0.6175901|       -0.2665873|           -0.7177512|           -0.6713397|           -0.5849490|                       -0.3410601|                          -0.3410601|                           -0.4455201|               -0.4851612|                   -0.6444447|               -0.3444670|               -0.0350536|               -0.2757386|                   -0.5324911|                   -0.4793216|                   -0.5859240|       -0.6338686|       -0.6365173|       -0.2995951|                       -0.4331023|                               -0.4061808|                   -0.5064497|                       -0.6682781|         24| WALKING\_UPSTAIRS |
| 954  |               0.3151317|              -0.0661014|              -0.0964563|                  0.8964080|                 -0.3860280|                 -0.0002849|                  -0.0085545|                  -0.1629605|                  -0.0920471|      -0.3772623|       0.1332712|       0.0949428|           0.2920125|          -0.3733186|          -0.1810915|                       0.0051165|                          0.0051165|                          -0.2473878|              -0.1584266|                  -0.5957658|              -0.2279893|               0.2034703|              -0.4624369|                  -0.2919794|                  -0.0569910|                  -0.6341428|      -0.2665448|      -0.4374214|      -0.1324150|                      -0.2624487|                              -0.2342424|                  -0.4694981|                      -0.6737106|               -0.1601505|                0.3560881|               -0.3191593|                  -0.9221443|                  -0.8849417|                  -0.7576382|                   -0.3127283|                    0.0663817|                   -0.6698987|       -0.4564212|       -0.3412584|       -0.1666806|           -0.5358160|           -0.7731436|           -0.2837002|                       -0.1508163|                          -0.1508163|                           -0.2745317|               -0.3717256|                   -0.6830935|               -0.1348067|                0.3459711|               -0.2985084|                   -0.4014311|                    0.1294237|                   -0.7041815|       -0.5172339|       -0.2927937|       -0.2543532|                       -0.2259595|                               -0.3337704|                   -0.4144075|                       -0.7187467|         13| WALKING\_UPSTAIRS |
| 1532 |               0.3095067|              -0.0870077|              -0.1226419|                  0.9649673|                  0.0140315|                 -0.0705586|                   0.0834583|                   0.0667679|                   0.0167353|      -0.2047906|      -0.1931198|      -0.3059521|          -0.0510645|           0.0429426|          -0.0320128|                      -0.8634498|                         -0.8634498|                          -0.9616207|              -0.7232841|                  -0.9676633|              -0.9627190|              -0.8714930|              -0.9205534|                  -0.9603566|                  -0.9586671|                  -0.9629111|      -0.9198982|      -0.8871216|      -0.9207551|                      -0.9005372|                              -0.9558575|                  -0.8619668|                      -0.9712795|               -0.9670649|               -0.7819788|               -0.8501043|                  -0.9702083|                  -0.7953198|                  -0.9204130|                   -0.9539850|                   -0.9613551|                   -0.9700250|       -0.9236169|       -0.8756131|       -0.8954769|           -0.9708539|           -0.9670466|           -0.9637701|                       -0.8079212|                          -0.8079212|                           -0.9571808|               -0.8203112|                   -0.9702717|               -0.9688560|               -0.7587509|               -0.8295311|                   -0.9513974|                   -0.9679733|                   -0.9764992|       -0.9252881|       -0.8697279|       -0.8976195|                       -0.7996158|                               -0.9569803|                   -0.8245215|                       -0.9705953|         12| SITTING           |

We also remove "ActivityID", given that "ActivityName" is better suited for data exploration (more readable).

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels, subjects) {
  data <- add_labels(data, labels)
  data <- add_subjects(data, subjects)
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
| 4027 |               0.2874335|              -0.0197751|              -0.1206185|                  0.8938600|                  0.1458508|                  0.2972741|                   0.0755327|                   0.0170331|                   0.0045278|      -0.0246056|      -0.0811351|       0.0923573|          -0.0988408|          -0.0346160|          -0.0605847|                      -0.9845234|                         -0.9845234|                          -0.9921011|              -0.9828031|                  -0.9967089|              -0.9905773|              -0.9877170|              -0.9852450|                  -0.9898228|                  -0.9898506|                  -0.9928580|      -0.9950773|      -0.9866878|      -0.9880501|                      -0.9879565|                              -0.9971444|                  -0.9902085|                      -0.9960483|               -0.9905826|               -0.9855782|               -0.9708195|                  -0.9940752|                  -0.9962896|                  -0.9875229|                   -0.9901089|                   -0.9910636|                   -0.9940626|       -0.9952637|       -0.9766808|       -0.9871169|           -0.9968606|           -0.9958946|           -0.9942728|                       -0.9769315|                          -0.9769315|                           -0.9972298|               -0.9854952|                   -0.9966510|               -0.9904361|               -0.9842648|               -0.9647924|                   -0.9913579|                   -0.9935208|                   -0.9937859|       -0.9952520|       -0.9720279|       -0.9877999|                       -0.9738318|                               -0.9960318|                   -0.9847081|                       -0.9975563|         22| SITTING      |
| 1120 |               0.1879198|              -0.0224931|              -0.1143201|                  0.9369151|                 -0.1676261|                 -0.1390609|                   0.1432282|                   0.3039270|                   0.0318385|      -0.2131941|      -0.1300126|       0.1952768|          -0.0567401|           0.2041466|           0.0534322|                      -0.0573758|                         -0.0573758|                          -0.0587709|               0.0398075|                   0.1712716|              -0.2523686|               0.0147747|               0.0731209|                  -0.2968450|                  -0.1429118|                  -0.1154228|      -0.3959179|       0.3016638|      -0.1546426|                      -0.1205900|                              -0.0648976|                   0.3482994|                       0.2506060|               -0.2852029|               -0.0014381|                0.1633969|                  -0.9610821|                  -0.9829648|                  -0.9129127|                   -0.2335374|                    0.0229575|                   -0.0779703|       -0.5620073|        0.4095383|       -0.1977061|           -0.3956448|            0.4704051|           -0.2765681|                       -0.1871119|                          -0.1871119|                           -0.0386654|                0.2983294|                    0.3456549|               -0.2985076|               -0.0734661|                0.1211780|                   -0.2353048|                    0.1290638|                   -0.0446640|       -0.6156804|        0.4622937|       -0.2856341|                       -0.3532369|                               -0.0124135|                    0.0293861|                        0.3710715|         23| WALKING      |
| 835  |               0.2619265|              -0.0080836|              -0.1344801|                  0.9775489|                 -0.0769166|                 -0.0213860|                  -0.2357008|                   0.0084119|                   0.2011174|      -0.0626717|      -0.0359833|       0.1287795|          -0.0820363|          -0.0457705|           0.1974045|                      -0.3430516|                         -0.3430516|                          -0.4234768|              -0.4013897|                  -0.4905233|              -0.4524431|              -0.0426412|              -0.5247898|                  -0.5134785|                  -0.2104949|                  -0.6571429|      -0.4950795|      -0.5246341|      -0.1275355|                      -0.2754229|                              -0.3265516|                  -0.5130345|                      -0.5965996|               -0.5240875|                0.0116655|               -0.4487050|                  -0.9932543|                  -0.9613913|                  -0.9762378|                   -0.4886213|                   -0.1120550|                   -0.6706956|       -0.5379414|       -0.5096641|       -0.3028207|           -0.4197312|           -0.6244770|           -0.1647515|                       -0.3924286|                          -0.3924286|                           -0.3295435|               -0.4692857|                   -0.5278464|               -0.5553366|               -0.0240075|               -0.4505511|                   -0.5075570|                   -0.0638284|                   -0.6818843|       -0.5539619|       -0.5040439|       -0.4347968|                       -0.5644984|                               -0.3376951|                   -0.5301083|                       -0.4812536|          5| WALKING      |
| 4617 |               0.2706240|              -0.0220440|              -0.1273985|                  0.9396641|                 -0.1836420|                 -0.2161249|                   0.0754021|                   0.0110512|                   0.0034385|      -0.0285011|      -0.0794899|       0.0930916|          -0.0951325|          -0.0370473|          -0.0553380|                      -0.9813168|                         -0.9813168|                          -0.9952907|              -0.9890972|                  -0.9976772|              -0.9965135|              -0.9860582|              -0.9880057|                  -0.9966056|                  -0.9889589|                  -0.9947980|      -0.9937655|      -0.9914376|      -0.9948058|                      -0.9906790|                              -0.9965052|                  -0.9940727|                      -0.9976512|               -0.9965855|               -0.9844905|               -0.9743636|                  -0.9931203|                  -0.9891542|                  -0.9651862|                   -0.9963688|                   -0.9891477|                   -0.9954044|       -0.9940590|       -0.9859080|       -0.9941795|           -0.9968378|           -0.9968373|           -0.9967707|                       -0.9863459|                          -0.9863459|                           -0.9967399|               -0.9924945|                   -0.9978014|               -0.9965227|               -0.9835274|               -0.9684556|                   -0.9963773|                   -0.9901786|                   -0.9944471|       -0.9940847|       -0.9831488|       -0.9943393|                       -0.9847971|                               -0.9957894|                   -0.9924306|                       -0.9978453|         14| STANDING     |
| 3458 |               0.2761877|              -0.0178671|              -0.1114290|                  0.8333673|                  0.2899633|                  0.2734518|                   0.0749077|                   0.0194207|                   0.0121100|      -0.0292066|      -0.0778850|       0.0803230|          -0.0962899|          -0.0419380|          -0.0582901|                      -0.9853060|                         -0.9853060|                          -0.9759715|              -0.9832948|                  -0.9822267|              -0.9815382|              -0.9733244|              -0.9828635|                  -0.9749129|                  -0.9721543|                  -0.9794766|      -0.9817632|      -0.9813301|      -0.9812804|                      -0.9842433|                              -0.9787567|                  -0.9823310|                      -0.9841233|               -0.9854697|               -0.9769983|               -0.9833822|                  -0.9981033|                  -0.9982007|                  -0.9937826|                   -0.9730367|                   -0.9706327|                   -0.9837929|       -0.9872794|       -0.9811161|       -0.9836857|           -0.9773054|           -0.9830366|           -0.9831731|                       -0.9853309|                          -0.9853309|                           -0.9787017|               -0.9818036|                   -0.9844452|               -0.9873313|               -0.9795626|               -0.9841618|                   -0.9733126|                   -0.9707991|                   -0.9871349|       -0.9890678|       -0.9810178|       -0.9859744|                       -0.9873368|                               -0.9771353|                   -0.9843985|                       -0.9855623|          3| SITTING      |
| 5199 |               0.2711671|              -0.0335383|              -0.1293495|                  0.9684289|                 -0.1703277|                 -0.0176043|                   0.0726941|                   0.0033312|                  -0.0173350|      -0.0188007|      -0.0885015|       0.0983130|          -0.1057111|          -0.0402873|          -0.0547453|                      -0.9413456|                         -0.9413456|                          -0.9542965|              -0.9224740|                  -0.9671021|              -0.9805424|              -0.8348207|              -0.9576273|                  -0.9691726|                  -0.8852098|                  -0.9701824|      -0.8580804|      -0.9677861|      -0.9699686|                      -0.8830551|                              -0.9104942|                  -0.8742833|                      -0.9456279|               -0.9844678|               -0.8240637|               -0.9550672|                  -0.9963320|                  -0.9767286|                  -0.9748357|                   -0.9661845|                   -0.8779666|                   -0.9727870|       -0.8701982|       -0.9639554|       -0.9739884|           -0.9024468|           -0.9789410|           -0.9781848|                       -0.8656048|                          -0.8656048|                           -0.9041635|               -0.8347159|                   -0.9336463|               -0.9862959|               -0.8286535|               -0.9561838|                   -0.9658934|                   -0.8779520|                   -0.9737775|       -0.8746256|       -0.9618839|       -0.9777546|                       -0.8762312|                               -0.8952466|                   -0.8379260|                       -0.9242475|         27| STANDING     |

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

|  SubjectID| ActivityName        |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|----------:|:--------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
|         11| WALKING\_DOWNSTAIRS |               0.2916056|              -0.0178098|              -0.1110701|                  0.9417464|                 -0.2003219|                  0.1323717|                   0.0897169|                   0.0252274|                  -0.0225209|      -0.1250687|      -0.0262775|       0.0575245|          -0.0220916|          -0.0520273|          -0.0373048|                       0.1262277|                          0.1262277|                          -0.1982061|              -0.1978834|                  -0.5992948|               0.0351937|               0.0247508|              -0.3776248|                  -0.1204630|                  -0.1774792|                  -0.5302255|      -0.3187770|      -0.5282545|      -0.2734591|                       0.0902808|                              -0.0974550|                  -0.4561701|                      -0.6683405|                0.1424566|                0.0708123|               -0.3240269|                  -0.9544975|                  -0.9263105|                  -0.9258149|                   -0.0834213|                   -0.1268167|                   -0.5797105|       -0.3740690|       -0.4959117|       -0.3189596|           -0.5343749|           -0.6845933|           -0.4805592|                        0.0507744|                           0.0507744|                           -0.1270172|               -0.3393498|                   -0.6777506|                0.1799068|                0.0262777|               -0.3486266|                   -0.1283416|                   -0.1304438|                   -0.6289027|       -0.3977228|       -0.4811275|       -0.3972205|                       -0.1371231|                               -0.1736618|                   -0.3805594|                       -0.7142297|
|          2| WALKING\_DOWNSTAIRS |               0.2776153|              -0.0226614|              -0.1168129|                  0.8618313|                 -0.3257801|                 -0.0438890|                   0.1100406|                  -0.0032796|                  -0.0209352|      -0.1159474|      -0.0048233|       0.0971738|          -0.0581038|          -0.0421470|          -0.0710230|                       0.0899511|                          0.0899511|                           0.0056552|              -0.1621886|                  -0.4108727|               0.1128412|               0.2783450|              -0.1312908|                   0.1381207|                   0.0962092|                  -0.2714987|      -0.1457760|      -0.3619138|      -0.0874945|                       0.2934248|                               0.2222474|                  -0.3208385|                      -0.3801753|                0.0463667|                0.2628818|               -0.1028379|                  -0.9403618|                  -0.9400685|                  -0.9314383|                    0.1472491|                    0.1268280|                   -0.3401220|       -0.3207892|       -0.4157391|       -0.2794184|           -0.2439406|           -0.4693967|           -0.2182663|                        0.2155863|                           0.2155863|                            0.2296172|               -0.2748441|                   -0.3431879|                0.0161046|                0.1719740|               -0.1620329|                    0.0499591|                    0.0808333|                   -0.4082274|       -0.3794367|       -0.4587327|       -0.4229877|                       -0.0214788|                                0.2274807|                   -0.3725768|                       -0.3436990|
|         19| WALKING\_DOWNSTAIRS |               0.2626881|              -0.0145942|              -0.1336952|                  0.8819409|                 -0.2150180|                 -0.1261469|                   0.0730930|                  -0.0386872|                  -0.0095520|      -0.2057754|       0.0274708|       0.1639625|          -0.0337430|          -0.0394613|          -0.0545566|                       0.6446043|                          0.6446043|                           0.4344904|               0.4180046|                   0.0875817|               0.5370120|               0.4944578|               0.1106592|                   0.4743173|                   0.2767169|                   0.0595906|       0.4749624|       0.1470831|       0.2106731|                       0.5866376|                               0.5384048|                   0.2039798|                      -0.0229045|                0.6269171|                0.5148164|                0.0493225|                  -0.8997261|                  -0.9178809|                  -0.8993631|                    0.5442730|                    0.3553067|                   -0.0200111|        0.2676572|        0.0483148|       -0.0314083|            0.1791486|           -0.0146299|            0.1166462|                        0.4134724|                           0.4134724|                            0.4506121|                0.2378212|                   -0.0438985|                0.6585065|                0.4279288|               -0.0783635|                    0.4768039|                    0.3497713|                   -0.0983930|        0.1966133|       -0.0284896|       -0.2158922|                        0.0828631|                                0.3163464|                    0.0320367|                       -0.1432545|
|         27| STANDING            |               0.2795669|              -0.0165932|              -0.1078358|                  0.9653515|                 -0.1885048|                 -0.0055742|                   0.0749700|                   0.0122433|                  -0.0013795|      -0.0267317|      -0.0675071|       0.0716841|          -0.0987605|          -0.0417472|          -0.0514039|                      -0.9727533|                         -0.9727533|                          -0.9853476|              -0.9687030|                  -0.9895321|              -0.9901218|              -0.9613561|              -0.9741462|                  -0.9877717|                  -0.9758687|                  -0.9851114|      -0.9701496|      -0.9837319|      -0.9808625|                      -0.9731862|                              -0.9841516|                  -0.9755256|                      -0.9894185|               -0.9919516|               -0.9551714|               -0.9624084|                  -0.9940122|                  -0.9796411|                  -0.9681700|                   -0.9876284|                   -0.9758297|                   -0.9873548|       -0.9699020|       -0.9824990|       -0.9812818|           -0.9826424|           -0.9907980|           -0.9889704|                       -0.9663601|                          -0.9663601|                           -0.9841591|               -0.9656933|                   -0.9888198|               -0.9928758|               -0.9543816|               -0.9589248|                   -0.9886068|                   -0.9776056|                   -0.9882083|       -0.9702218|       -0.9818578|       -0.9831050|                       -0.9675291|                               -0.9830223|                   -0.9654002|                       -0.9885791|
|          6| STANDING            |               0.2803462|              -0.0181236|              -0.1121728|                  0.9451390|                 -0.2302510|                  0.0139193|                   0.0730700|                   0.0087188|                  -0.0048171|      -0.0282519|      -0.0589824|       0.0767395|          -0.1032925|          -0.0428828|          -0.0506432|                      -0.9450229|                         -0.9450229|                          -0.9671024|              -0.9394047|                  -0.9634062|              -0.9771003|              -0.9303365|              -0.9428640|                  -0.9734805|                  -0.9514055|                  -0.9637435|      -0.9316124|      -0.9432731|      -0.9432396|                      -0.9459498|                              -0.9559140|                  -0.9266643|                      -0.9554251|               -0.9817582|               -0.9214932|               -0.9256924|                  -0.9855831|                  -0.9684491|                  -0.9427951|                   -0.9731326|                   -0.9493623|                   -0.9675472|       -0.9475613|       -0.9424866|       -0.9477822|           -0.9464236|           -0.9624222|           -0.9627582|                       -0.9393102|                          -0.9393102|                           -0.9560991|               -0.9158916|                   -0.9525362|               -0.9840674|               -0.9214491|               -0.9220672|                   -0.9752357|                   -0.9506815|                   -0.9698958|       -0.9528174|       -0.9425392|       -0.9544557|                       -0.9445641|                               -0.9553816|                   -0.9231088|                       -0.9520885|
|         13| SITTING             |               0.2743285|              -0.0058773|              -0.0972465|                  0.9255765|                  0.1017698|                  0.0757774|                   0.0752866|                  -0.0011234|                  -0.0232397|      -0.0355125|      -0.0902687|       0.0823432|          -0.0959198|          -0.0410367|          -0.0466122|                      -0.9576906|                         -0.9576906|                          -0.9894978|              -0.9511426|                  -0.9926043|              -0.9901355|              -0.9596739|              -0.9561831|                  -0.9926782|                  -0.9839141|                  -0.9852612|      -0.9832182|      -0.9824561|      -0.9683844|                      -0.9569016|                              -0.9883485|                  -0.9732583|                      -0.9917237|               -0.9895463|               -0.9389677|               -0.9386412|                  -0.9813791|                  -0.9513531|                  -0.9309796|                   -0.9928273|                   -0.9842676|                   -0.9876121|       -0.9858443|       -0.9796685|       -0.9668964|           -0.9913710|           -0.9917734|           -0.9898614|                       -0.9379357|                          -0.9379357|                           -0.9888131|               -0.9639406|                   -0.9914149|               -0.9894106|               -0.9336665|               -0.9341890|                   -0.9936822|                   -0.9859081|                   -0.9886121|       -0.9867147|       -0.9782707|       -0.9694518|                       -0.9385299|                               -0.9883323|                   -0.9642681|                       -0.9912194|

Saving the Resulting Data to Disk
---------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
