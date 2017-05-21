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
    -   [Pertinent Variables (Mean, Standard Deviation & Activity)](#pertinent-variables-mean-standard-deviation-activity)
    -   [Binding Feature, Label and Subject Data Together](#binding-feature-label-and-subject-data-together)
    -   [Re-Naming the Data-set Variables](#re-naming-the-data-set-variables)
    -   [Filtering Out Non-Pertinent Variables](#filtering-out-non-pertinent-variables)
    -   [Normalizing Variable Names](#normalizing-variable-names)
    -   [Joining with Activity Names Data](#joining-with-activity-names-data)
    -   [Putting All Transformations Together](#putting-all-transformations-together)
    -   [Resulting Clean Data-set](#resulting-clean-data-set)
-   [Computing Averages per Activity and Subject](#computing-averages-per-activity-and-subject)
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

For the purpose of this data exploration, we are not interested in the pre-processed data, thus, we're going to work with the following files:

<table>
<colgroup>
<col width="28%" />
<col width="71%" />
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

    ## [1] "fBodyAcc-iqr()-Z"                 "tBodyGyroJerk-arCoeff()-Y,4"     
    ## [3] "tGravityAcc-mean()-Z"             "fBodyAccJerk-bandsEnergy()-49,56"
    ## [5] "fBodyAccJerk-maxInds-Y"           "fBodyAcc-maxInds-Z"

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

### Pertinent Variables (Mean, Standard Deviation & Activity)

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

    ## [1] "fBodyAccMag-sma()"            "fBodyAcc-bandsEnergy()-33,40"
    ## [3] "fBodyAcc-bandsEnergy()-41,48" "fBodyAccJerk-max()-Z"        
    ## [5] "tBodyGyroJerk-iqr()-Z"        "tBodyAccJerk-min()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "tGravityAcc-mean()-Y"  "fBodyAcc-mean()-X"     "tGravityAccMag-mean()"
    ## [4] "tBodyGyro-mean()-Z"    "tBodyAccMag-mean()"    "fBodyAccMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccJerk-std()-X" "tBodyGyro-std()-X"    "tBodyGyroMag-std()"  
    ## [4] "fBodyAccMag-std()"    "tBodyAcc-std()-X"     "fBodyGyro-std()-Y"

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

    ## [1] "fBodyAccMag-min()"            "tBodyAccJerk-arCoeff()-Y,4"  
    ## [3] "fBodyGyro-max()-X"            "fBodyAcc-bandsEnergy()-25,48"
    ## [5] "fBodyAcc-max()-Z"             "fBodyAcc-bandsEnergy()-49,64"

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
| 1042 |               0.2708122|              -0.0357390|              -0.0770988|                  0.9399274|                 -0.2691961|                  0.0139472|                  -0.1513061|                   0.0071824|                  -0.1344923|       0.2673928|      -0.2949259|       0.1435523|          -0.1858254|          -0.0208436|          -0.3783820|                      -0.0597472|                         -0.0597472|                          -0.3210986|               0.1230732|                  -0.5036327|              -0.1793944|              -0.0429947|              -0.4130055|                  -0.2566368|                  -0.2643506|                  -0.6224381|      -0.1295500|      -0.3048524|      -0.1132805|                      -0.1470443|                              -0.1385232|                  -0.1654658|                      -0.6187392|               -0.1981690|                0.0731391|               -0.1526957|                  -0.9652525|                  -0.9534068|                  -0.9094823|                   -0.2259274|                   -0.1893630|                   -0.6655988|       -0.1323277|        0.0269617|       -0.0968411|           -0.3353035|           -0.6364037|           -0.4616761|                       -0.2229149|                          -0.2229149|                           -0.2198685|                0.0170958|                   -0.6344017|               -0.2056384|                0.0632633|               -0.0938484|                   -0.2622040|                   -0.1606757|                   -0.7082289|       -0.1434542|        0.1794162|       -0.1739866|                       -0.3899168|                               -0.3423641|                   -0.0380522|                       -0.6828683|           2|         10|
| 1116 |               0.3803700|              -0.0148636|              -0.1041095|                 -0.4068853|                 -0.9988143|                  0.2958065|                  -0.0418437|                  -0.1151947|                   0.0117169|       0.1235236|      -0.5003398|       0.0663839|          -0.1237803|           0.0361155|          -0.0490679|                      -0.8770649|                         -0.8770649|                          -0.9400432|              -0.7356130|                  -0.9182568|              -0.8368241|              -0.8551118|              -0.9478448|                  -0.9274367|                  -0.8998274|                  -0.9473278|      -0.9210079|      -0.8203230|      -0.9541410|                      -0.7809159|                              -0.8962234|                  -0.7935864|                      -0.8735373|               -0.8395259|               -0.8775350|               -0.9552674|                  -0.7691887|                  -0.9103007|                  -0.9670222|                   -0.9210404|                   -0.9011734|                   -0.9536119|       -0.9289679|       -0.8276278|       -0.9585217|           -0.9492240|           -0.8758961|           -0.9651752|                       -0.7788152|                          -0.7788152|                           -0.8886181|               -0.7630024|                   -0.8672558|               -0.8404266|               -0.8982611|               -0.9633896|                   -0.9211731|                   -0.9101229|                   -0.9585100|       -0.9316836|       -0.8334278|       -0.9637493|                       -0.8109668|                               -0.8783715|                   -0.7826846|                       -0.8679396|           6|         10|
| 2197 |               0.2106503|              -0.0582948|              -0.1232959|                  0.8548767|                 -0.3115059|                 -0.2837684|                  -0.1937850|                   0.1911455|                   0.4113019|       0.4185234|      -0.3784696|      -0.2756024|           0.0552226|           0.0434666|          -0.2830447|                      -0.3108979|                         -0.3108979|                          -0.6089676|              -0.2994778|                  -0.7893282|              -0.4362945|              -0.3731616|              -0.4138211|                  -0.6134609|                  -0.6010993|                  -0.7377783|      -0.6058551|      -0.6883791|      -0.3770699|                      -0.4098183|                              -0.6115085|                  -0.6032695|                      -0.8293549|               -0.4278553|               -0.2125829|               -0.3117375|                  -0.9785711|                  -0.9636384|                  -0.9561039|                   -0.5926328|                   -0.5886571|                   -0.7558343|       -0.6503627|       -0.6407008|       -0.2719582|           -0.7833835|           -0.8229618|           -0.7364541|                       -0.3951032|                          -0.3951032|                           -0.6355639|               -0.4492141|                   -0.8406776|               -0.4244220|               -0.1873817|               -0.3108008|                   -0.6066488|                   -0.6029994|                   -0.7717577|       -0.6656343|       -0.6165754|       -0.3071055|                       -0.4804848|                               -0.6679161|                   -0.4500097|                       -0.8687093|           2|         18|
| 2889 |               0.2870441|              -0.0564525|              -0.1394243|                  0.9580218|                 -0.1345199|                 -0.1502484|                   0.0029528|                  -0.3972098|                  -0.2416348|       0.1120363|      -0.1093713|       0.0617405|           0.3938531|          -0.1383862|          -0.3305646|                      -0.4106978|                         -0.4106978|                          -0.5024012|              -0.3475764|                  -0.5595920|              -0.6080125|              -0.1232117|              -0.3837156|                  -0.6083374|                  -0.4985307|                  -0.5574213|      -0.1416512|      -0.5279249|      -0.3644321|                      -0.4287188|                              -0.5513042|                  -0.2095767|                      -0.6315372|               -0.6097713|               -0.1605180|               -0.3552744|                  -0.9814733|                  -0.9327752|                  -0.9636232|                   -0.5794736|                   -0.4662078|                   -0.5466399|       -0.3337016|       -0.5159635|       -0.4289109|           -0.5186358|           -0.5748078|           -0.5880945|                       -0.4717804|                          -0.4717804|                           -0.5258380|               -0.2290599|                   -0.5981056|               -0.6103389|               -0.2343088|               -0.3903514|                   -0.5862647|                   -0.4659449|                   -0.5357553|       -0.3946024|       -0.5120813|       -0.5038488|                       -0.5793614|                               -0.4961560|                   -0.3801175|                       -0.5847424|           1|         24|
| 1614 |               0.3358224|              -0.0095293|              -0.0530749|                  0.8854534|                 -0.2624440|                 -0.2877670|                  -0.0381250|                   0.1599384|                  -0.1788761|      -0.0416741|      -0.0001706|       0.2031266|          -0.0893715|           0.4390519|           0.1605642|                      -0.0800887|                         -0.0800887|                          -0.1446492|              -0.2534205|                  -0.2348415|              -0.4240452|              -0.0409881|              -0.0723921|                  -0.3944984|                  -0.1907488|                  -0.1796814|      -0.3372586|      -0.0125314|      -0.1611512|                      -0.2127208|                              -0.1871745|                  -0.2267258|                      -0.1407197|               -0.3280245|                0.0522374|                0.0404487|                  -0.9690425|                  -0.9690265|                  -0.9187311|                   -0.3350701|                   -0.0029232|                   -0.1934503|       -0.5315098|       -0.1797946|       -0.2801640|           -0.2968753|           -0.0994541|           -0.4030987|                       -0.3197830|                          -0.3197830|                           -0.1494884|               -0.2506034|                   -0.0965765|               -0.2936115|                0.0329553|                0.0200770|                   -0.3320481|                    0.1238661|                   -0.2047579|       -0.5949903|       -0.3087653|       -0.3895791|                       -0.4943425|                               -0.1090402|                   -0.4013128|                       -0.1032185|           1|         13|
| 1066 |               0.2539407|               0.0181663|              -0.1148345|                  0.9385774|                  0.1810919|                  0.0261873|                   0.0425930|                   0.1241246|                  -0.0611981|      -0.0005567|      -0.0250053|       0.1937348|          -0.1156836|          -0.0394606|          -0.0542285|                      -0.9226332|                         -0.9226332|                          -0.9506259|              -0.8518537|                  -0.9496923|              -0.9576405|              -0.8259306|              -0.9363888|                  -0.9500785|                  -0.8729173|                  -0.9560491|      -0.8530338|      -0.9261857|      -0.9401885|                      -0.8718113|                              -0.8973228|                  -0.8966876|                      -0.9312228|               -0.9694886|               -0.8444061|               -0.9436532|                  -0.9720901|                  -0.9122899|                  -0.9693749|                   -0.9540709|                   -0.8757528|                   -0.9622324|       -0.8487812|       -0.9219146|       -0.9213150|           -0.9037879|           -0.9516291|           -0.9698493|                       -0.8847814|                          -0.8847814|                           -0.8913214|               -0.8716950|                   -0.9288672|               -0.9756744|               -0.8642568|               -0.9524559|                   -0.9635640|                   -0.8885777|                   -0.9672037|       -0.8494966|       -0.9198205|       -0.9228690|                       -0.9097979|                               -0.8829859|                   -0.8771790|                       -0.9303929|           5|         10|

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
| 2162 |               0.2814800|              -0.0095492|              -0.1034947|                  0.9597042|                 -0.2298545|                  0.0061656|                   0.0838427|                   0.0128521|                  -0.0015566|      -0.0195305|      -0.0735232|       0.0732473|          -0.0877845|          -0.0315174|          -0.0716249|                      -0.9892263|                         -0.9892263|                          -0.9893926|              -0.9827457|                  -0.9926001|              -0.9919526|              -0.9804642|              -0.9883771|                  -0.9899642|                  -0.9834717|                  -0.9876520|      -0.9817718|      -0.9899230|      -0.9641164|                      -0.9887100|                              -0.9922175|                  -0.9773357|                      -0.9914861|               -0.9943894|               -0.9795412|               -0.9898512|                  -0.9973355|                  -0.9854842|                  -0.9903088|                   -0.9901685|                   -0.9848284|                   -0.9905801|       -0.9854799|       -0.9900389|       -0.9649359|           -0.9892143|           -0.9958549|           -0.9812328|                       -0.9875579|                          -0.9875579|                           -0.9929542|               -0.9692331|                   -0.9901324|               -0.9957084|               -0.9792263|               -0.9908309|                   -0.9913020|                   -0.9878757|                   -0.9923949|       -0.9865873|       -0.9900887|       -0.9682533|                       -0.9876706|                               -0.9926149|                   -0.9690684|                       -0.9886340|         12| STANDING            |
| 2792 |               0.2623825|              -0.0200216|              -0.0996749|                 -0.5601666|                  0.7717474|                  0.6309613|                   0.0891273|                   0.0048566|                   0.0027824|      -0.0043025|      -0.1828209|       0.1665794|          -0.1187739|          -0.0215582|          -0.0969870|                      -0.9679812|                         -0.9679812|                          -0.9898154|              -0.9313668|                  -0.9935838|              -0.9791186|              -0.9885196|              -0.9864018|                  -0.9899158|                  -0.9890838|                  -0.9892029|      -0.9691936|      -0.9757002|      -0.9390069|                      -0.9850396|                              -0.9926674|                  -0.9567960|                      -0.9940806|               -0.9609721|               -0.9909080|               -0.9837781|                  -0.9585844|                  -0.9925661|                  -0.9785875|                   -0.9890824|                   -0.9888323|                   -0.9904805|       -0.9729806|       -0.9716112|       -0.9442086|           -0.9969503|           -0.9934416|           -0.9883782|                       -0.9785932|                          -0.9785932|                           -0.9938245|               -0.9352192|                   -0.9946471|               -0.9551500|               -0.9918351|               -0.9824898|                   -0.9890538|                   -0.9892823|                   -0.9902156|       -0.9741533|       -0.9693798|       -0.9510010|                       -0.9771875|                               -0.9945576|                   -0.9332187|                       -0.9955472|          2| LAYING              |
| 346  |               0.2842027|               0.0137047|              -0.1139541|                  0.9194876|                 -0.3511610|                  0.0275232|                   0.3131968|                  -0.1509392|                  -0.0594674|       0.0019450|      -0.1502453|       0.1035824|          -0.2841116|           0.0111180|          -0.2058480|                      -0.3287157|                         -0.3287157|                          -0.3226121|              -0.4985824|                  -0.6385988|              -0.3046733|              -0.1379046|              -0.5127235|                  -0.2673309|                  -0.2043270|                  -0.5822072|      -0.5443002|      -0.6092089|      -0.4281312|                      -0.4094633|                              -0.2497595|                  -0.6298628|                      -0.7061118|               -0.4186222|               -0.2075538|               -0.4810806|                  -0.9425038|                  -0.9793771|                  -0.9896800|                   -0.2532555|                   -0.2045232|                   -0.6191702|       -0.6404017|       -0.5698987|       -0.4718244|           -0.5735395|           -0.7327394|           -0.5145373|                       -0.4706778|                          -0.4706778|                           -0.2457053|               -0.6426028|                   -0.7277950|               -0.4701347|               -0.2980070|               -0.5040860|                   -0.3055849|                   -0.2627647|                   -0.6541855|       -0.6708483|       -0.5502479|       -0.5351736|                       -0.5905196|                               -0.2448999|                   -0.7157194|                       -0.7787890|          2| WALKING             |
| 1253 |               0.2713862|              -0.0424834|              -0.1282111|                  0.8912034|                 -0.3399125|                 -0.0016321|                   0.6534859|                  -0.3064075|                  -0.3449920|       0.3158320|      -0.4221215|       0.1124908|           0.2386662|           0.1274488|          -0.0645575|                       0.0447245|                          0.0447245|                          -0.0769059|              -0.2147976|                  -0.5607011|               0.1104779|               0.2813491|              -0.0789174|                   0.0385146|                   0.0137561|                  -0.2754534|      -0.2837196|      -0.5030550|      -0.1642170|                       0.2574294|                               0.0413030|                  -0.6219753|                      -0.6005482|               -0.0171770|                0.2648551|               -0.0884593|                  -0.9474277|                  -0.9887115|                  -0.9460871|                    0.0084348|                    0.0243397|                   -0.3547117|       -0.4977105|       -0.4739480|       -0.2967010|           -0.4249091|           -0.6804241|           -0.3404458|                        0.1754520|                           0.1754520|                            0.0691503|               -0.6312406|                   -0.5796220|               -0.0721865|                0.1755690|               -0.1687289|                   -0.1213342|                   -0.0368492|                   -0.4337978|       -0.5678967|       -0.4603860|       -0.4103751|                       -0.0562994|                                0.0964326|                   -0.7035037|                       -0.5809934|          2| WALKING\_DOWNSTAIRS |
| 1419 |               0.2754065|              -0.0194270|              -0.1036544|                  0.9289752|                 -0.1304995|                  0.2629604|                   0.0711637|                  -0.0077640|                  -0.0032495|      -0.0270104|      -0.0719741|       0.0937202|          -0.0934865|          -0.0485188|          -0.0699466|                      -0.9842610|                         -0.9842610|                          -0.9884868|              -0.9843081|                  -0.9914873|              -0.9917900|              -0.9725312|              -0.9834825|                  -0.9896243|                  -0.9769808|                  -0.9908842|      -0.9905742|      -0.9819955|      -0.9730851|                      -0.9837896|                              -0.9870741|                  -0.9814232|                      -0.9893588|               -0.9938404|               -0.9761185|               -0.9722273|                  -0.9965261|                  -0.9954519|                  -0.9794296|                   -0.9902220|                   -0.9773950|                   -0.9916386|       -0.9935737|       -0.9796988|       -0.9782661|           -0.9928027|           -0.9900330|           -0.9853427|                       -0.9854173|                          -0.9854173|                           -0.9886354|               -0.9798025|                   -0.9891530|               -0.9948646|               -0.9786705|               -0.9674325|                   -0.9918843|                   -0.9795792|                   -0.9907935|       -0.9945543|       -0.9783924|       -0.9822149|                       -0.9878278|                               -0.9898656|                   -0.9818994|                       -0.9891120|          2| SITTING             |
| 1956 |               0.2853021|              -0.0039769|              -0.1059023|                  0.9465117|                 -0.2277300|                 -0.1506301|                   0.0835118|                  -0.0034044|                   0.0038606|      -0.0363610|      -0.0596847|       0.0848970|          -0.0992561|          -0.0209276|          -0.0557711|                      -0.9610146|                         -0.9610146|                          -0.9569378|              -0.9358873|                  -0.9407491|              -0.9544209|              -0.9490611|              -0.9459415|                  -0.9403744|                  -0.9512591|                  -0.9509544|      -0.9196168|      -0.8788908|      -0.9414488|                      -0.9346186|                              -0.9217050|                  -0.8520146|                      -0.8949997|               -0.9631533|               -0.9541441|               -0.9461089|                  -0.9963012|                  -0.9753481|                  -0.9889603|                   -0.9300953|                   -0.9529524|                   -0.9570252|       -0.9380636|       -0.8923122|       -0.9545654|           -0.9322387|           -0.9023658|           -0.9532673|                       -0.9385558|                          -0.9385558|                           -0.9123068|               -0.8520377|                   -0.8788296|               -0.9671911|               -0.9589569|               -0.9496894|                   -0.9257600|                   -0.9586760|                   -0.9617399|       -0.9438690|       -0.9022343|       -0.9639496|                       -0.9494214|                               -0.8998511|                   -0.8778463|                       -0.8678593|         13| STANDING            |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:--------------------|
| 419  |               0.1821615|              -0.1027737|              -0.0519005|                  0.8402650|                 -0.2243128|                 -0.3942488|                   0.3488974|                   0.3978839|                  -0.1194883|       0.2261438|      -0.2557033|      -0.2214066|          -0.0602480|          -0.3461214|          -0.1402345|                      -0.2918523|                         -0.2918523|                          -0.5590672|              -0.1961476|                  -0.6660411|              -0.5278345|              -0.2395008|              -0.3587528|                  -0.6692842|                  -0.4880988|                  -0.6046359|      -0.5500355|      -0.3220585|      -0.4294294|                      -0.4802898|                              -0.6209564|                  -0.4882165|                      -0.7338262|               -0.5594893|               -0.1470328|               -0.1219070|                  -0.9328483|                  -0.8319333|                  -0.9393998|                   -0.6615609|                   -0.4898819|                   -0.6158002|       -0.5969827|       -0.1710740|       -0.3107840|           -0.6861999|           -0.6822330|           -0.6879648|                       -0.4523533|                          -0.4523533|                           -0.6191765|               -0.3468528|                   -0.7455952|               -0.5724887|               -0.1545218|               -0.0737874|                   -0.6836913|                   -0.5293090|                   -0.6246616|       -0.6134513|       -0.0959203|       -0.3390131|                       -0.5217138|                               -0.6162339|                   -0.3687750|                       -0.7795800|         14| WALKING             |
| 3154 |               0.2168011|              -0.0583305|              -0.1259245|                  0.9787386|                 -0.0048802|                 -0.0048311|                   0.0118651|                  -0.2200863|                   0.0271899|       0.1171409|      -0.1043693|       0.0671709|           0.1693344|           0.1215637|          -0.1955742|                       0.0918992|                          0.0918992|                          -0.0937460|              -0.1398634|                  -0.3392401|              -0.0278603|               0.1485875|              -0.3554104|                  -0.1255327|                   0.0651272|                  -0.4257901|      -0.2554110|      -0.2891643|       0.0543169|                       0.0893414|                               0.0460052|                  -0.3358146|                      -0.3653779|                0.1568628|                0.0658556|               -0.3412405|                  -0.9569214|                  -0.9076710|                  -0.9445637|                   -0.0572044|                    0.1197770|                   -0.4578200|       -0.3136148|       -0.3471639|       -0.1640625|           -0.4837426|           -0.4002212|            0.1031508|                        0.1904422|                           0.1904422|                           -0.0060011|               -0.4205813|                   -0.3300082|                0.2220276|               -0.0493903|               -0.3859530|                   -0.0690038|                    0.1050749|                   -0.4868898|       -0.3360498|       -0.3903685|       -0.3261732|                        0.0581719|                               -0.0738356|                   -0.6010476|                       -0.3322266|          5| WALKING\_DOWNSTAIRS |
| 5723 |               0.2782997|              -0.0191280|              -0.1139158|                  0.9729768|                 -0.0868217|                  0.0760918|                   0.0744189|                   0.0187390|                   0.0042181|      -0.0278991|      -0.0732784|       0.0877534|          -0.0976784|          -0.0395972|          -0.0558716|                      -0.9917078|                         -0.9917078|                          -0.9917346|              -0.9918932|                  -0.9961467|              -0.9977779|              -0.9838974|              -0.9854762|                  -0.9964734|                  -0.9898004|                  -0.9844203|      -0.9883148|      -0.9945841|      -0.9949134|                      -0.9924679|                              -0.9877018|                  -0.9935905|                      -0.9974614|               -0.9983791|               -0.9828285|               -0.9858631|                  -0.9986346|                  -0.9893757|                  -0.9904957|                   -0.9965876|                   -0.9892760|                   -0.9861205|       -0.9899857|       -0.9932708|       -0.9949106|           -0.9917192|           -0.9973503|           -0.9967616|                       -0.9923766|                          -0.9923766|                           -0.9894642|               -0.9919759|                   -0.9976307|               -0.9986898|               -0.9822256|               -0.9863522|                   -0.9970367|                   -0.9893359|                   -0.9862695|       -0.9904444|       -0.9924415|       -0.9952588|                       -0.9925259|                               -0.9910934|                   -0.9919760|                       -0.9977007|          8| STANDING            |
| 6491 |               0.5168399|               0.0034079|              -0.1126922|                 -0.8350382|                  0.6928042|                  0.7152430|                   0.1446705|                   0.0288808|                  -0.0050618|      -0.0127105|      -0.2275853|       0.1236530|          -0.0964219|          -0.0444209|          -0.0540412|                      -0.8454176|                         -0.8454176|                          -0.9797063|              -0.9196210|                  -0.9770974|              -0.9002366|              -0.9577864|              -0.9794250|                  -0.9829693|                  -0.9737270|                  -0.9783439|      -0.9648323|      -0.9587590|      -0.9726441|                      -0.8853429|                              -0.9764651|                  -0.9562365|                      -0.9738490|               -0.8631751|               -0.9444558|               -0.9783195|                  -0.8831547|                  -0.9801497|                  -0.9963038|                   -0.9838790|                   -0.9728944|                   -0.9790268|       -0.9753524|       -0.9467480|       -0.9756298|           -0.9627084|           -0.9790070|           -0.9793046|                       -0.7940969|                          -0.7940969|                           -0.9792400|               -0.9396278|                   -0.9740545|               -0.8506394|               -0.9406528|               -0.9784239|                   -0.9865141|                   -0.9737547|                   -0.9780114|       -0.9787770|       -0.9406739|       -0.9788287|                       -0.7875432|                               -0.9823464|                   -0.9393970|                       -0.9757656|         19| LAYING              |
| 4209 |               0.2754861|              -0.0124997|              -0.1094528|                  0.9606350|                  0.0692799|                  0.1016212|                   0.0774028|                   0.0103318|                  -0.0021920|      -0.0253821|      -0.0644232|       0.0863462|          -0.0981222|          -0.0372354|          -0.0536532|                      -0.9916981|                         -0.9916981|                          -0.9890798|              -0.9885215|                  -0.9955708|              -0.9945754|              -0.9845708|              -0.9848502|                  -0.9921414|                  -0.9897916|                  -0.9833603|      -0.9931691|      -0.9913344|      -0.9832269|                      -0.9875243|                              -0.9893853|                  -0.9921319|                      -0.9958990|               -0.9958870|               -0.9825930|               -0.9851384|                  -0.9990091|                  -0.9912996|                  -0.9953460|                   -0.9922502|                   -0.9899858|                   -0.9845778|       -0.9941001|       -0.9905728|       -0.9808592|           -0.9955052|           -0.9953434|           -0.9917378|                       -0.9871209|                          -0.9871209|                           -0.9899372|               -0.9895530|                   -0.9956529|               -0.9965332|               -0.9815452|               -0.9856164|                   -0.9930704|                   -0.9909623|                   -0.9841659|       -0.9943232|       -0.9900697|       -0.9816382|                       -0.9877994|                               -0.9892895|                   -0.9893384|                       -0.9951877|         14| SITTING             |
| 4709 |               0.2743950|              -0.0067474|              -0.0893787|                  0.9697408|                 -0.0200946|                  0.1007945|                   0.0706989|                  -0.0134217|                   0.0113861|      -0.0256151|      -0.0677038|       0.1088119|          -0.0977334|          -0.0582897|          -0.0707443|                      -0.9575091|                         -0.9575091|                          -0.9562968|              -0.9452184|                  -0.9530578|              -0.9729224|              -0.9218537|              -0.9554241|                  -0.9603540|                  -0.9398230|                  -0.9605433|      -0.9524877|      -0.9482798|      -0.8842887|                      -0.9426119|                              -0.9485865|                  -0.9335916|                      -0.9503534|               -0.9803811|               -0.9229899|               -0.9536871|                  -0.9963239|                  -0.9732473|                  -0.9874756|                   -0.9581138|                   -0.9392698|                   -0.9620054|       -0.9629019|       -0.9495581|       -0.9106054|           -0.9497364|           -0.9616155|           -0.9097669|                       -0.9488077|                          -0.9488077|                           -0.9473167|               -0.9260941|                   -0.9457903|               -0.9842588|               -0.9274360|               -0.9554266|                   -0.9593416|                   -0.9429442|                   -0.9617216|       -0.9661441|       -0.9506364|       -0.9293374|                       -0.9597612|                               -0.9443258|                   -0.9333737|                       -0.9434571|          5| STANDING            |

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
|         19| LAYING              |               0.2726537|              -0.0171427|              -0.1089815|                 -0.6800432|                  0.7256466|                  0.6876239|                   0.0772318|                   0.0111496|                  -0.0009887|      -0.0312073|      -0.0952628|       0.1086051|          -0.0956018|          -0.0371477|          -0.0599161|                      -0.9662608|                         -0.9662608|                          -0.9847843|              -0.9532634|                  -0.9853425|              -0.9745337|              -0.9727988|              -0.9853404|                  -0.9834786|                  -0.9748783|                  -0.9865065|      -0.9741962|      -0.9720610|      -0.9739323|                      -0.9719574|                              -0.9806216|                  -0.9656247|                      -0.9818905|               -0.9650196|               -0.9734500|               -0.9846728|                  -0.9589596|                  -0.9869931|                  -0.9888190|                   -0.9836052|                   -0.9745245|                   -0.9882602|       -0.9813576|       -0.9636177|       -0.9731975|           -0.9761057|           -0.9846077|           -0.9869584|                       -0.9631935|                          -0.9631935|                           -0.9806683|               -0.9559066|                   -0.9802455|               -0.9620850|               -0.9748321|               -0.9847410|                   -0.9852780|                   -0.9759641|                   -0.9885587|       -0.9839448|       -0.9598314|       -0.9754175|                       -0.9640568|                               -0.9794522|                   -0.9574960|                       -0.9793278|
|         17| WALKING\_DOWNSTAIRS |               0.2939183|              -0.0167359|              -0.0892433|                  0.9288176|                 -0.1510771|                 -0.1609630|                   0.1182509|                  -0.0113826|                  -0.0093984|       0.0677728|      -0.1235172|       0.0162879|          -0.1077700|          -0.0381702|          -0.0582519|                       0.1489511|                          0.1489511|                          -0.2216317|              -0.2326418|                  -0.5403258|              -0.0226239|              -0.1302725|              -0.3180819|                  -0.2150920|                  -0.3512684|                  -0.4986685|      -0.3164130|      -0.4511269|      -0.4033804|                       0.0580681|                              -0.1886804|                  -0.4094388|                      -0.5773489|                0.1877198|               -0.0607892|               -0.2310642|                  -0.9500262|                  -0.9465767|                  -0.9010978|                   -0.1034365|                   -0.3040635|                   -0.5363316|       -0.3704369|       -0.4592820|       -0.4684630|           -0.5268018|           -0.5721447|           -0.5427706|                        0.0914077|                           0.0914077|                           -0.2065767|               -0.3526873|                   -0.5923195|                0.2589417|               -0.0860527|               -0.2454135|                   -0.0718767|                   -0.2989311|                   -0.5730437|       -0.3931947|       -0.4693904|       -0.5409495|                       -0.0618877|                               -0.2365385|                   -0.4288687|                       -0.6433992|
|         27| WALKING\_DOWNSTAIRS |               0.2975442|              -0.0135564|              -0.1128377|                  0.9313802|                 -0.1669388|                 -0.1400476|                   0.0936273|                   0.0159869|                  -0.0098503|      -0.1598266|      -0.0163132|       0.1526950|          -0.0515815|          -0.0642024|          -0.0621044|                       0.1080714|                          0.1080714|                          -0.1154212|              -0.1647832|                  -0.4405466|               0.0829832|              -0.0626730|              -0.2416004|                  -0.0437826|                  -0.1709753|                  -0.3436264|      -0.2966286|      -0.4021328|      -0.1449049|                       0.1498165|                               0.0108576|                  -0.3591137|                      -0.4677778|                0.1674075|               -0.0979710|               -0.2400408|                  -0.9469752|                  -0.9349640|                  -0.9209215|                   -0.0035834|                   -0.1385281|                   -0.4093109|       -0.3637229|       -0.4818134|       -0.2578462|           -0.4938376|           -0.4594593|           -0.3072683|                        0.1211763|                           0.1211763|                           -0.0386367|               -0.3079521|                   -0.4658075|                0.1949127|               -0.1756471|               -0.3030907|                   -0.0522811|                   -0.1632440|                   -0.4747555|       -0.3909684|       -0.5430332|       -0.3678160|                       -0.0712120|                               -0.1136259|                   -0.3979842|                       -0.5028314|
|          5| LAYING              |               0.2783343|              -0.0183042|              -0.1079376|                 -0.4834706|                  0.9548903|                  0.2636447|                   0.0848165|                   0.0074746|                  -0.0030407|      -0.0218935|      -0.0798710|       0.1598944|          -0.1021141|          -0.0404447|          -0.0708310|                      -0.9667779|                         -0.9667779|                          -0.9801413|              -0.9469383|                  -0.9864194|              -0.9687417|              -0.9654195|              -0.9770077|                  -0.9826897|                  -0.9653286|                  -0.9832503|      -0.9757975|      -0.9782496|      -0.9632029|                      -0.9622350|                              -0.9773564|                  -0.9682571|                      -0.9846180|               -0.9659345|               -0.9692956|               -0.9685625|                  -0.9456953|                  -0.9859641|                  -0.9770766|                   -0.9833079|                   -0.9645604|                   -0.9854194|       -0.9794987|       -0.9774274|       -0.9605838|           -0.9834223|           -0.9837595|           -0.9896796|                       -0.9586128|                          -0.9586128|                           -0.9774771|               -0.9582879|                   -0.9837714|               -0.9649539|               -0.9729092|               -0.9658822|                   -0.9856253|                   -0.9662426|                   -0.9861356|       -0.9807058|       -0.9772578|       -0.9633057|                       -0.9625254|                               -0.9763819|                   -0.9592631|                       -0.9834345|
|          5| WALKING             |               0.2778423|              -0.0172850|              -0.1077418|                  0.9726250|                 -0.1004403|                  0.0024762|                   0.0845889|                  -0.0163194|                   0.0000832|      -0.0488920|      -0.0690135|       0.0815435|          -0.0888408|          -0.0449560|          -0.0482680|                      -0.1583387|                         -0.1583387|                          -0.2883330|              -0.3559331|                  -0.4445325|              -0.2877826|               0.0094604|              -0.4902511|                  -0.3449548|                  -0.1810556|                  -0.5904966|      -0.3726687|      -0.5139517|      -0.2131270|                      -0.3049925|                              -0.2694817|                  -0.4842628|                      -0.5480536|               -0.2940985|                0.0767484|               -0.4570214|                  -0.9793484|                  -0.9615855|                  -0.9645808|                   -0.3028910|                   -0.0910397|                   -0.6128953|       -0.4908775|       -0.5046220|       -0.3187006|           -0.3576814|           -0.5714381|           -0.1576825|                       -0.3771787|                          -0.3771787|                           -0.2822423|               -0.4921768|                   -0.4891997|               -0.2975174|                0.0426027|               -0.4830600|                   -0.3213903|                   -0.0545214|                   -0.6334300|       -0.5293928|       -0.5026834|       -0.4203671|                       -0.5196369|                               -0.3056854|                   -0.5897415|                       -0.4556653|
|          2| LAYING              |               0.2813734|              -0.0181587|              -0.1072456|                 -0.5097542|                  0.7525366|                  0.6468349|                   0.0825973|                   0.0122548|                  -0.0018026|      -0.0184766|      -0.1118008|       0.1448828|          -0.1019741|          -0.0358590|          -0.0701783|                      -0.9774355|                         -0.9774355|                          -0.9877417|              -0.9500116|                  -0.9917671|              -0.9767251|              -0.9798009|              -0.9843810|                  -0.9858136|                  -0.9827683|                  -0.9861971|      -0.9864311|      -0.9833216|      -0.9626719|                      -0.9751102|                              -0.9853741|                  -0.9721130|                      -0.9902487|               -0.9740595|               -0.9802774|               -0.9842333|                  -0.9590144|                  -0.9882119|                  -0.9842304|                   -0.9858722|                   -0.9831725|                   -0.9884420|       -0.9882752|       -0.9822916|       -0.9603066|           -0.9932358|           -0.9895675|           -0.9880358|                       -0.9728739|                          -0.9728739|                           -0.9855181|               -0.9611641|                   -0.9897181|               -0.9732465|               -0.9810251|               -0.9847922|                   -0.9872503|                   -0.9849874|                   -0.9893454|       -0.9888607|       -0.9819106|       -0.9631742|                       -0.9751214|                               -0.9845685|                   -0.9610984|                       -0.9894927|

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
