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
-   [Saving the Output Data to Disk](#saving-the-output-data-to-disk)

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

    ## [1] "fBodyAccMag-skewness()"     "tBodyAccJerk-arCoeff()-Z,1"
    ## [3] "tBodyAccJerkMag-iqr()"      "fBodyGyro-skewness()-X"    
    ## [5] "tBodyAcc-correlation()-X,Y" "tGravityAcc-arCoeff()-Y,1"

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

Let's create a list of all variables, which include the features names, subject and activity:

``` r
variables <- c(feature_names, "ActivityID", "SubjectID")
```

The variable names for subject and activity are my own choice. I believe they are descriptive enough.

Let's also create a list of the variables we are interested in exploring (means and standard deviations at the moment):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "tGravityAcc-mad()-Z"              "tBodyGyroJerkMag-arCoeff()3"     
    ## [3] "tBodyAccJerk-arCoeff()-Z,3"       "fBodyAccJerk-bandsEnergy()-57,64"
    ## [5] "fBodyAccJerk-bandsEnergy()-17,32" "tBodyAcc-entropy()-Z"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAccJerk-mean()-X"   "fBodyAccJerk-mean()-X"  
    ## [3] "fBodyAccJerk-mean()-Y"   "fBodyAcc-mean()-Z"      
    ## [5] "tBodyGyro-mean()-Y"      "fBodyBodyGyroMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyBodyGyroJerkMag-std()" "fBodyGyro-std()-Y"         
    ## [3] "tBodyGyroJerk-std()-X"      "tBodyAcc-std()-X"          
    ## [5] "tBodyGyro-std()-Y"          "fBodyBodyGyroMag-std()"

### Binding Feature, Label and Subject Data Together

``` r
test_data <- cbind(test_data, test_labels)
test_data <- cbind(test_data, test_subjects)
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

    ## [1] "fBodyAcc-bandsEnergy()-33,40"     "tBodyGyroJerk-mean()-Z"          
    ## [3] "tBodyGyro-mad()-X"                "fBodyAccJerk-bandsEnergy()-49,56"
    ## [5] "tBodyAcc-std()-Z"                 "tBodyAccJerk-arCoeff()-Z,2"

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
| 71   |               0.2673108|              -0.0177393|              -0.1041849|                 -0.5599759|                  0.7705947|                  0.6344530|                   0.0777690|                   0.0049525|                   0.0037925|      -0.0416867|      -0.0738331|       0.0480349|          -0.0959586|          -0.0409038|          -0.0433973|                      -0.9824368|                         -0.9824368|                          -0.9898351|              -0.9773069|                  -0.9944413|              -0.9846067|              -0.9861222|              -0.9919317|                  -0.9898179|                  -0.9864968|                  -0.9890906|      -0.9951084|      -0.9915502|      -0.9786010|                      -0.9881418|                              -0.9923969|                  -0.9891850|                      -0.9941208|               -0.9761868|               -0.9880198|               -0.9932741|                  -0.9781088|                  -0.9968478|                  -0.9946530|                   -0.9903162|                   -0.9869808|                   -0.9900439|       -0.9962796|       -0.9918910|       -0.9759062|           -0.9965640|           -0.9926713|           -0.9921081|                       -0.9877413|                          -0.9877413|                           -0.9930840|               -0.9847773|                   -0.9938850|               -0.9730806|               -0.9887876|               -0.9939036|                   -0.9918332|                   -0.9885850|                   -0.9894012|       -0.9966104|       -0.9920879|       -0.9770334|                       -0.9883146|                               -0.9928140|                   -0.9842546|                       -0.9935661|           6|          2|
| 2785 |               0.2672502|              -0.0273439|              -0.1400839|                  0.9580721|                 -0.1721154|                 -0.1204528|                   0.0744332|                   0.0291145|                   0.0043438|      -0.0415682|      -0.0862508|       0.0884737|          -0.0948294|          -0.0408306|          -0.0622467|                      -0.9676814|                         -0.9676814|                          -0.9882811|              -0.9780415|                  -0.9932433|              -0.9917367|              -0.9656589|              -0.9879668|                  -0.9908132|                  -0.9790913|                  -0.9909998|      -0.9832861|      -0.9906215|      -0.9834535|                      -0.9847556|                              -0.9925386|                  -0.9862606|                      -0.9942943|               -0.9933982|               -0.9610705|               -0.9796571|                  -0.9899977|                  -0.9658172|                  -0.9486328|                   -0.9907790|                   -0.9792228|                   -0.9922354|       -0.9818191|       -0.9869518|       -0.9840383|           -0.9908378|           -0.9939709|           -0.9904897|                       -0.9768928|                          -0.9768928|                           -0.9935196|               -0.9813979|                   -0.9943587|               -0.9941624|               -0.9600979|               -0.9756939|                   -0.9915522|                   -0.9808877|                   -0.9919534|       -0.9815375|       -0.9849698|       -0.9855561|                       -0.9751021|                               -0.9938729|                   -0.9811500|                       -0.9944568|           5|         24|
| 1335 |               0.1988641|              -0.0108165|              -0.1006081|                  0.9541752|                 -0.1666865|                 -0.0686199|                   0.7276402|                  -0.2706055|                  -0.2683184|       0.3656742|      -0.2872918|       0.0381962|          -0.0655918|           0.1457814|           0.0637598|                      -0.1160121|                         -0.1160121|                          -0.1921783|              -0.3214534|                  -0.4974685|               0.0410682|              -0.2194374|              -0.3634646|                  -0.0179286|                  -0.3175486|                  -0.3850941|      -0.4505137|      -0.4325909|      -0.3636639|                       0.0973552|                               0.0685945|                  -0.4716922|                      -0.4880418|               -0.0160611|               -0.3002762|               -0.4217282|                  -0.9796414|                  -0.9519742|                  -0.9853286|                   -0.0267117|                   -0.2582585|                   -0.4268148|       -0.5857123|       -0.5155919|       -0.4237286|           -0.5023806|           -0.5006635|           -0.4930440|                        0.0135782|                           0.0135782|                           -0.0167424|               -0.4518576|                   -0.5340381|               -0.0394133|               -0.3923332|               -0.5081518|                   -0.1267567|                   -0.2419876|                   -0.4656941|       -0.6288411|       -0.5783845|       -0.4974815|                       -0.1944051|                               -0.1417879|                   -0.5327231|                       -0.6376086|           3|         12|
| 2824 |               0.2792704|              -0.0216369|              -0.1240420|                 -0.2995291|                  0.6945170|                  0.7352655|                   0.1692386|                   0.0179053|                  -0.0553714|       0.1439290|      -0.2341469|       0.5740013|          -0.1317543|           0.0289293|          -0.1609189|                      -0.9144578|                         -0.9144578|                          -0.9641976|              -0.7012108|                  -0.9646913|              -0.8920403|              -0.9508765|              -0.9126800|                  -0.9488533|                  -0.9481287|                  -0.9442498|      -0.9376755|      -0.9254698|      -0.8388059|                      -0.8541970|                              -0.9272368|                  -0.8646532|                      -0.9211119|               -0.8896978|               -0.9584349|               -0.8948981|                  -0.7521933|                  -0.9787005|                  -0.8472576|                   -0.9569995|                   -0.9499187|                   -0.9562586|       -0.9562530|       -0.9474702|       -0.8333654|           -0.9618389|           -0.9416170|           -0.9761622|                       -0.8513001|                          -0.8513001|                           -0.9320509|               -0.8397709|                   -0.9291796|               -0.8885615|               -0.9646462|               -0.8925005|                   -0.9732029|                   -0.9559741|                   -0.9688492|       -0.9623124|       -0.9679656|       -0.8466465|                       -0.8716140|                               -0.9377500|                   -0.8503606|                       -0.9464758|           6|         24|
| 1543 |               0.2772855|              -0.0157214|              -0.1103110|                  0.9151302|                 -0.2421078|                 -0.2525474|                   0.0721608|                  -0.0091913|                  -0.0137317|      -0.0322201|      -0.0777268|       0.0929588|          -0.1051173|          -0.0420702|          -0.0457336|                      -0.9866038|                         -0.9866038|                          -0.9890377|              -0.9811781|                  -0.9901466|              -0.9930670|              -0.9704347|              -0.9845033|                  -0.9900550|                  -0.9862736|                  -0.9867470|      -0.9815639|      -0.9850154|      -0.9887660|                      -0.9905890|                              -0.9941158|                  -0.9828665|                      -0.9915079|               -0.9954092|               -0.9698654|               -0.9843171|                  -0.9985050|                  -0.9820249|                  -0.9885074|                   -0.9902604|                   -0.9862626|                   -0.9902660|       -0.9781074|       -0.9857526|       -0.9892362|           -0.9914113|           -0.9878654|           -0.9950546|                       -0.9907610|                          -0.9907610|                           -0.9954439|               -0.9781000|                   -0.9916809|               -0.9967428|               -0.9703567|               -0.9845306|                   -0.9913895|                   -0.9872241|                   -0.9928818|       -0.9774372|       -0.9862514|       -0.9902551|                       -0.9913205|                               -0.9959703|                   -0.9784152|                       -0.9920834|           5|         13|
| 2227 |               0.2745697|              -0.0195642|              -0.0959868|                  0.9468522|                 -0.1989311|                  0.1523723|                   0.0766700|                   0.0116128|                  -0.0097958|      -0.0291547|      -0.0735711|       0.0827124|          -0.1035771|          -0.0443358|          -0.0657582|                      -0.9878805|                         -0.9878805|                          -0.9894334|              -0.9876246|                  -0.9932248|              -0.9968598|              -0.9715083|              -0.9863130|                  -0.9970580|                  -0.9752666|                  -0.9882996|      -0.9815269|      -0.9891666|      -0.9825994|                      -0.9842999|                              -0.9890650|                  -0.9844487|                      -0.9899147|               -0.9969025|               -0.9717007|               -0.9856154|                  -0.9937438|                  -0.9896222|                  -0.9732701|                   -0.9967916|                   -0.9766316|                   -0.9899963|       -0.9857217|       -0.9871835|       -0.9862002|           -0.9838248|           -0.9946364|           -0.9890528|                       -0.9812010|                          -0.9812010|                           -0.9894006|               -0.9796473|                   -0.9883464|               -0.9968294|               -0.9724947|               -0.9853850|                   -0.9967245|                   -0.9802401|                   -0.9902159|       -0.9869954|       -0.9860182|       -0.9888465|                       -0.9811164|                               -0.9881197|                   -0.9797072|                       -0.9867364|           5|         20|

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
| 1338 |               0.2615664|              -0.0207922|              -0.1415333|                  0.8687554|                 -0.3323419|                  0.1103914|                  -0.4432164|                   0.5941498|                   0.1482923|      -0.1242166|      -0.0153869|       0.0869573|          -0.0320139|          -0.0335662|          -0.0041872|                       0.1863239|                          0.1863239|                           0.1427660|              -0.0992586|                  -0.3056226|               0.4174933|               0.4323328|              -0.0373365|                   0.2856798|                   0.1497209|                  -0.0688702|      -0.0839236|      -0.1412555|      -0.0710222|                       0.4493536|                               0.4033678|                  -0.1020636|                      -0.0947856|                0.1782549|                0.3144007|               -0.1439202|                  -0.8628074|                  -0.9756377|                  -0.9363380|                    0.3370292|                    0.1488227|                   -0.1596898|       -0.1799363|       -0.2377514|       -0.2880778|           -0.1772672|           -0.2216066|           -0.1486590|                        0.2691322|                           0.2691322|                            0.4177836|               -0.1325610|                   -0.0568609|                0.0694839|                0.1621852|               -0.2876608|                    0.2723664|                    0.0638679|                   -0.2490798|       -0.2137061|       -0.3095261|       -0.4410588|                       -0.0419327|                                0.4283939|                   -0.3095390|                       -0.0742335|          2| WALKING\_DOWNSTAIRS |
| 1088 |               0.3759045|              -0.0215657|              -0.1192733|                  0.9385181|                 -0.1683850|                 -0.0557877|                   0.5985411|                  -0.2264916|                  -0.0439711|      -0.1726829|       0.0110968|       0.1084752|           0.1059991|          -0.0817519|          -0.2478684|                      -0.0462640|                         -0.0462640|                          -0.2269750|              -0.4485674|                  -0.5451245|               0.0310874|              -0.1093416|              -0.3989056|                  -0.0939149|                  -0.2614954|                  -0.4556538|      -0.4335258|      -0.5737736|      -0.3277320|                       0.1035957|                              -0.0836596|                  -0.5566244|                      -0.6217138|                0.0425814|               -0.1821033|               -0.3868216|                  -0.9488253|                  -0.9408284|                  -0.8821647|                   -0.0758809|                   -0.2835778|                   -0.5008705|       -0.5843270|       -0.6096620|       -0.3471136|           -0.4600914|           -0.6369931|           -0.4688206|                        0.0728814|                           0.0728814|                           -0.1105331|               -0.5529528|                   -0.6542495|                0.0471460|               -0.2759750|               -0.4290386|                   -0.1399640|                   -0.3654275|                   -0.5438325|       -0.6328143|       -0.6363493|       -0.4131722|                       -0.1115995|                               -0.1504613|                   -0.6281620|                       -0.7241896|         12| WALKING\_DOWNSTAIRS |
| 1229 |               0.2257180|              -0.0394528|              -0.1440404|                  0.9345655|                 -0.0021943|                  0.1397194|                   0.1501628|                  -0.2068384|                   0.0129146|      -0.0549692|      -0.1122046|       0.0943879|          -0.0510820|           0.0523131|           0.0060575|                      -0.0419984|                         -0.0419984|                          -0.2722512|              -0.2966056|                  -0.6013320|              -0.1994367|              -0.0904646|              -0.4486089|                  -0.2971013|                  -0.1636730|                  -0.5662309|      -0.0925615|      -0.7358195|      -0.4006285|                      -0.0625312|                              -0.2437961|                  -0.4466245|                      -0.6995204|               -0.0074156|               -0.1689828|               -0.4167245|                  -0.9728191|                  -0.9369138|                  -0.9809800|                   -0.2413681|                   -0.0832392|                   -0.6337613|       -0.2042893|       -0.7266189|       -0.5685101|           -0.3673903|           -0.8436478|           -0.4496019|                       -0.1108861|                          -0.1108861|                           -0.2362972|               -0.4054629|                   -0.7104307|                0.0588161|               -0.2673067|               -0.4448224|                   -0.2500679|                   -0.0555545|                   -0.7055991|       -0.2420653|       -0.7229267|       -0.6803068|                       -0.2774073|                               -0.2313684|                   -0.4790520|                       -0.7464658|          4| WALKING\_DOWNSTAIRS |
| 2926 |               0.2636603|              -0.0144895|              -0.1098653|                 -0.3103446|                  0.6933125|                  0.7270369|                   0.0651823|                  -0.0002214|                   0.0209183|      -0.0374301|      -0.0529517|       0.0740160|          -0.0940832|          -0.0526888|          -0.0480884|                      -0.9678291|                         -0.9678291|                          -0.9912029|              -0.9716479|                  -0.9868730|              -0.9793312|              -0.9899225|              -0.9753485|                  -0.9895744|                  -0.9935990|                  -0.9868648|      -0.9829262|      -0.9714318|      -0.9927267|                      -0.9769518|                              -0.9906165|                  -0.9772380|                      -0.9891102|               -0.9642138|               -0.9910561|               -0.9630000|                  -0.9640388|                  -0.9885312|                  -0.9702282|                   -0.9894744|                   -0.9937272|                   -0.9893488|       -0.9890257|       -0.9633392|       -0.9936121|           -0.9826600|           -0.9863765|           -0.9946471|                       -0.9710429|                          -0.9710429|                           -0.9919686|               -0.9719566|                   -0.9893608|               -0.9591719|               -0.9911602|               -0.9583224|                   -0.9902837|                   -0.9943482|                   -0.9905235|       -0.9911335|       -0.9591654|       -0.9944524|                       -0.9710706|                               -0.9928247|                   -0.9729661|                       -0.9900809|         24| LAYING              |
| 205  |               0.2803088|              -0.0597791|              -0.1027185|                  0.9625214|                 -0.0996803|                 -0.1423695|                  -0.2861152|                   0.5469983|                   0.3417760|      -0.0226793|      -0.0439804|       0.0528999|          -0.1783533|          -0.3449405|          -0.2873780|                      -0.2144184|                         -0.2144184|                          -0.3721084|              -0.4290712|                  -0.5465525|              -0.3671016|              -0.0175805|              -0.3134391|                  -0.4708956|                  -0.3123385|                  -0.5308692|      -0.4583692|      -0.5118215|      -0.3306880|                      -0.4412120|                              -0.4185531|                  -0.5948511|                      -0.6256584|               -0.3974317|               -0.0400408|               -0.2866643|                  -0.9882428|                  -0.9614547|                  -0.9738372|                   -0.4070384|                   -0.2997822|                   -0.5627104|       -0.5645919|       -0.5335583|       -0.4144598|           -0.5091418|           -0.5758766|           -0.6064409|                       -0.4785544|                          -0.4785544|                           -0.4360320|               -0.6063180|                   -0.6337424|               -0.4096809|               -0.1130183|               -0.3283254|                   -0.3939446|                   -0.3348830|                   -0.5919980|       -0.5983254|       -0.5507523|       -0.4981653|                       -0.5813537|                               -0.4618612|                   -0.6847915|                       -0.6707816|         24| WALKING             |
| 536  |               0.2811443|              -0.0126048|              -0.0786130|                  0.8222042|                  0.0913168|                 -0.4199640|                  -0.1934268|                   0.0493222|                   0.4589081|      -0.4986505|      -0.1695059|       0.4580065|          -0.0059845|          -0.0101049|          -0.2342238|                      -0.2092223|                         -0.2092223|                          -0.3847280|              -0.0039456|                  -0.6202616|              -0.2510932|              -0.5406830|              -0.2454108|                  -0.3516271|                  -0.6929422|                  -0.5817353|      -0.4888031|      -0.3442165|      -0.4085000|                      -0.2891511|                              -0.4413763|                  -0.5521799|                      -0.6771778|               -0.2731511|               -0.4714138|               -0.0696077|                  -0.9753292|                  -0.9514194|                  -0.8755944|                   -0.2656357|                   -0.6664545|                   -0.6258919|       -0.3470263|       -0.1931185|       -0.4304899|           -0.6685284|           -0.6218204|           -0.6526969|                       -0.2705949|                          -0.2705949|                           -0.4692087|               -0.3749882|                   -0.6922122|               -0.2819409|               -0.4702170|               -0.0509177|                   -0.2430162|                   -0.6592286|                   -0.6690038|       -0.3262171|       -0.1180931|       -0.4898332|                       -0.3734404|                               -0.5095463|                   -0.3748280|                       -0.7357877|          9| WALKING\_UPSTAIRS   |

We also remove "ActivityID", given that "ActivityName" is better suited for data exploration (more readable).

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels, subjects) {
  data <- cbind(data, labels)
  data <- cbind(data, subjects)
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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName      |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:------------------|
| 827  |               0.2909910|              -0.0668439|              -0.1187924|                  0.8841031|                 -0.1570658|                 -0.3449634|                   0.0195844|                   0.6673368|                  -0.2041132|       0.1410390|      -0.1406305|      -0.1730319|           0.0566782|          -0.1372777|          -0.0680867|                       0.1698995|                          0.1698995|                           0.0269614|              -0.0103716|                  -0.3166721|              -0.3301260|               0.4425370|              -0.1607271|                  -0.3528139|                   0.1381261|                  -0.2848297|      -0.2540344|      -0.2005922|       0.1237108|                      -0.0872705|                              -0.1101887|                  -0.3273003|                      -0.4759167|               -0.1161935|                0.5029022|                0.0673787|                  -0.9836881|                  -0.9729911|                  -0.9594988|                   -0.2506109|                    0.3373729|                   -0.2496030|       -0.3581901|       -0.1798061|        0.2044477|           -0.3841240|           -0.3794096|           -0.2440586|                       -0.1474780|                          -0.1474780|                           -0.1781758|               -0.2321490|                   -0.5052504|               -0.0448107|                0.4391877|                0.1003815|                   -0.2144223|                    0.4596288|                   -0.2181929|       -0.3925120|       -0.1730035|        0.1196493|                       -0.3158043|                               -0.2797879|                   -0.2992008|                       -0.5674927|          8| WALKING           |
| 4929 |               0.2773184|              -0.0168131|              -0.1087897|                  0.9634392|                 -0.2015838|                 -0.0185690|                   0.0719152|                   0.0134831|                   0.0049146|      -0.0276069|      -0.0701646|       0.0842534|          -0.0963464|          -0.0399323|          -0.0545074|                      -0.9904224|                         -0.9904224|                          -0.9916168|              -0.9910394|                  -0.9962287|              -0.9954059|              -0.9887511|              -0.9834016|                  -0.9954049|                  -0.9893905|                  -0.9863534|      -0.9883478|      -0.9937467|      -0.9945033|                      -0.9916558|                              -0.9931849|                  -0.9928172|                      -0.9965819|               -0.9964570|               -0.9904554|               -0.9776080|                  -0.9981411|                  -0.9951904|                  -0.9884261|                   -0.9956877|                   -0.9884977|                   -0.9881640|       -0.9888627|       -0.9929485|       -0.9949358|           -0.9935988|           -0.9960318|           -0.9964604|                       -0.9922591|                          -0.9922591|                           -0.9922799|               -0.9908190|                   -0.9968906|               -0.9969624|               -0.9909562|               -0.9750440|                   -0.9964466|                   -0.9881482|                   -0.9884800|       -0.9889914|       -0.9924087|       -0.9954720|                       -0.9929417|                               -0.9893730|                   -0.9907606|                       -0.9972533|         27| STANDING          |
| 7229 |               0.2991591|              -0.0180658|              -0.1100171|                 -0.4188472|                  0.4463522|                  0.9171927|                   0.0585262|                   0.0041185|                   0.0029107|      -0.0326357|      -0.0504454|       0.0727162|          -0.0993909|          -0.0382646|          -0.0518605|                      -0.9809722|                         -0.9809722|                          -0.9901701|              -0.9730813|                  -0.9853481|              -0.9757527|              -0.9888379|              -0.9920449|                  -0.9887364|                  -0.9905895|                  -0.9894857|      -0.9893067|      -0.9718457|      -0.9941256|                      -0.9782808|                              -0.9929302|                  -0.9731840|                      -0.9846347|               -0.9724458|               -0.9903281|               -0.9915621|                  -0.9715224|                  -0.9966541|                  -0.9974795|                   -0.9892705|                   -0.9908931|                   -0.9892629|       -0.9915968|       -0.9623513|       -0.9951176|           -0.9892973|           -0.9804463|           -0.9948262|                       -0.9741264|                          -0.9741264|                           -0.9924424|               -0.9701290|                   -0.9840035|               -0.9709626|               -0.9906989|               -0.9909911|                   -0.9909262|                   -0.9919631|                   -0.9873605|       -0.9922633|       -0.9575513|       -0.9959040|                       -0.9745811|                               -0.9901589|                   -0.9728831|                       -0.9838504|         23| LAYING            |
| 1711 |               0.2916054|              -0.0230002|              -0.0993674|                  0.9392166|                 -0.2210465|                 -0.1456572|                   0.1964226|                   0.0560044|                  -0.0434449|       0.1944787|      -0.1045281|      -0.0981160|           0.1086219|          -0.1292809|          -0.1116398|                      -0.1627581|                         -0.1627581|                          -0.5264038|              -0.2314401|                  -0.7345762|              -0.4284745|              -0.2771350|              -0.4797772|                  -0.5480037|                  -0.5096003|                  -0.6673997|      -0.2927593|      -0.5984642|      -0.4474606|                      -0.4725444|                              -0.5563415|                  -0.4836021|                      -0.7647894|               -0.2741972|               -0.1098109|               -0.3114936|                  -0.9716775|                  -0.9446867|                  -0.9677820|                   -0.5154282|                   -0.5175642|                   -0.6749061|       -0.2720679|       -0.5559765|       -0.1341490|           -0.6946624|           -0.7670758|           -0.7153964|                       -0.4258961|                          -0.4258961|                           -0.5602299|               -0.1726608|                   -0.7788235|               -0.2215672|               -0.0871798|               -0.2805266|                   -0.5240012|                   -0.5632940|                   -0.6803172|       -0.2761093|       -0.5346749|       -0.1329686|                       -0.4899538|                               -0.5670627|                   -0.1395183|                       -0.8131184|         27| WALKING\_UPSTAIRS |
| 1331 |               0.3680172|              -0.0213092|              -0.1318112|                  0.8426030|                 -0.4085649|                 -0.1998507|                   0.1626846|                  -0.3011988|                  -0.3221416|       0.1082179|      -0.2239668|      -0.0816265|          -0.1056258|           0.0828216|           0.0734901|                       0.0162816|                          0.0162816|                          -0.3284917|              -0.2373749|                  -0.5933315|              -0.1396438|              -0.0509315|              -0.3920478|                  -0.3018129|                  -0.3861086|                  -0.5831373|      -0.2855772|      -0.5439549|      -0.2293968|                      -0.1606835|                              -0.4160851|                  -0.4269636|                      -0.6386032|               -0.0505915|                0.1237303|               -0.3004132|                  -0.9824325|                  -0.9538508|                  -0.9722254|                   -0.2929468|                   -0.3508352|                   -0.6278539|       -0.3103955|       -0.5550178|       -0.0891301|           -0.4474303|           -0.6769738|           -0.5815487|                       -0.1221008|                          -0.1221008|                           -0.4566463|               -0.2695899|                   -0.6574762|               -0.0176591|                0.1368150|               -0.3055693|                   -0.3475461|                   -0.3551606|                   -0.6716629|       -0.3245681|       -0.5651022|       -0.1308687|                       -0.2374952|                               -0.5164375|                   -0.2945427|                       -0.7092371|         17| WALKING\_UPSTAIRS |
| 503  |               0.2070012|              -0.0409626|              -0.1841452|                  0.9073970|                 -0.2185375|                 -0.2665390|                  -0.1395536|                   0.2814901|                  -0.0399267|       0.0098674|      -0.1302955|       0.0805605|          -0.0890442|          -0.0038849|          -0.2270187|                      -0.2424721|                         -0.2424721|                          -0.2918256|              -0.5123604|                  -0.6607152|              -0.3666590|              -0.2470661|              -0.2358798|                  -0.4053019|                  -0.3566154|                  -0.2993128|      -0.6238572|      -0.6579370|      -0.4168620|                      -0.3456116|                              -0.2926668|                  -0.6344010|                      -0.6780266|               -0.3895533|               -0.2196114|               -0.1828764|                  -0.9630573|                  -0.9871096|                  -0.9455593|                   -0.3289472|                   -0.3220993|                   -0.3552500|       -0.6687643|       -0.6574288|       -0.3321209|           -0.6285206|           -0.7012864|           -0.5308268|                       -0.4086951|                          -0.4086951|                           -0.2799283|               -0.6548276|                   -0.6718758|               -0.3987274|               -0.2541684|               -0.2179482|                   -0.3103300|                   -0.3292227|                   -0.4085047|       -0.6839829|       -0.6594790|       -0.3675287|                       -0.5391090|                               -0.2686411|                   -0.7326844|                       -0.6865975|         16| WALKING           |

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

|  SubjectID| ActivityName |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|----------:|:-------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
|         13| SITTING      |               0.2743285|              -0.0058773|              -0.0972465|                  0.9255765|                  0.1017698|                  0.0757774|                   0.0752866|                  -0.0011234|                  -0.0232397|      -0.0355125|      -0.0902687|       0.0823432|          -0.0959198|          -0.0410367|          -0.0466122|                      -0.9576906|                         -0.9576906|                          -0.9894978|              -0.9511426|                  -0.9926043|              -0.9901355|              -0.9596739|              -0.9561831|                  -0.9926782|                  -0.9839141|                  -0.9852612|      -0.9832182|      -0.9824561|      -0.9683844|                      -0.9569016|                              -0.9883485|                  -0.9732583|                      -0.9917237|               -0.9895463|               -0.9389677|               -0.9386412|                  -0.9813791|                  -0.9513531|                  -0.9309796|                   -0.9928273|                   -0.9842676|                   -0.9876121|       -0.9858443|       -0.9796685|       -0.9668964|           -0.9913710|           -0.9917734|           -0.9898614|                       -0.9379357|                          -0.9379357|                           -0.9888131|               -0.9639406|                   -0.9914149|               -0.9894106|               -0.9336665|               -0.9341890|                   -0.9936822|                   -0.9859081|                   -0.9886121|       -0.9867147|       -0.9782707|       -0.9694518|                       -0.9385299|                               -0.9883323|                   -0.9642681|                       -0.9912194|
|         15| LAYING       |               0.2894757|              -0.0166297|              -0.1185302|                 -0.1719931|                  0.8992426|                 -0.0369193|                   0.0767515|                   0.0123984|                  -0.0044393|      -0.0168301|      -0.0619701|       0.1134519|          -0.1022667|          -0.0415879|          -0.0624335|                      -0.9553407|                         -0.9553407|                          -0.9798902|              -0.9446051|                  -0.9832350|              -0.9740162|              -0.9624611|              -0.9515659|                  -0.9813300|                  -0.9708332|                  -0.9747757|      -0.9554136|      -0.9643109|      -0.9581901|                      -0.9560010|                              -0.9736812|                  -0.9468126|                      -0.9757279|               -0.9722556|               -0.9627594|               -0.9295868|                  -0.9615097|                  -0.9860362|                  -0.9507104|                   -0.9817394|                   -0.9709216|                   -0.9784030|       -0.9571677|       -0.9611429|       -0.9565371|           -0.9739240|           -0.9804828|           -0.9801127|                       -0.9433141|                          -0.9433141|                           -0.9736445|               -0.9240430|                   -0.9736500|               -0.9717188|               -0.9645904|               -0.9239240|                   -0.9839493|                   -0.9732153|                   -0.9807451|       -0.9582245|       -0.9599919|       -0.9600158|                       -0.9455086|                               -0.9725301|                   -0.9236822|                       -0.9726457|
|         21| STANDING     |               0.2769522|              -0.0167085|              -0.1104179|                  0.8812133|                 -0.3461556|                 -0.2076857|                   0.0754544|                   0.0100621|                  -0.0033209|      -0.0191732|      -0.0738116|       0.0864863|          -0.1031998|          -0.0404301|          -0.0538212|                      -0.9587743|                         -0.9587743|                          -0.9747652|              -0.9498372|                  -0.9768571|              -0.9783277|              -0.9496949|              -0.9602741|                  -0.9768030|                  -0.9645030|                  -0.9747806|      -0.9569900|      -0.9600826|      -0.9594326|                      -0.9622913|                              -0.9706343|                  -0.9567230|                      -0.9761268|               -0.9814200|               -0.9436016|               -0.9461234|                  -0.9829067|                  -0.9776814|                  -0.9585900|                   -0.9770634|                   -0.9639215|                   -0.9779157|       -0.9625145|       -0.9559792|       -0.9593270|           -0.9718665|           -0.9768159|           -0.9754273|                       -0.9569199|                          -0.9569199|                           -0.9716065|               -0.9456144|                   -0.9761537|               -0.9828928|               -0.9435452|               -0.9424589|                   -0.9795305|                   -0.9660241|                   -0.9797233|       -0.9645303|       -0.9540809|       -0.9631246|                       -0.9600418|                               -0.9719261|                   -0.9477632|                       -0.9777066|
|         22| STANDING     |               0.2790539|              -0.0158563|              -0.1049674|                  0.9540643|                 -0.2264188|                  0.0323825|                   0.0752323|                   0.0107287|                  -0.0062629|      -0.0275202|      -0.0690068|       0.0733467|          -0.0975013|          -0.0420999|          -0.0513179|                      -0.9548077|                         -0.9548077|                          -0.9758760|              -0.9316243|                  -0.9786035|              -0.9803739|              -0.9291614|              -0.9571018|                  -0.9749692|                  -0.9521415|                  -0.9775674|      -0.9170181|      -0.9706824|      -0.9623278|                      -0.9490445|                              -0.9597439|                  -0.9320653|                      -0.9683778|               -0.9850005|               -0.9226933|               -0.9422017|                  -0.9928273|                  -0.9710807|                  -0.9588902|                   -0.9756391|                   -0.9523035|                   -0.9814781|       -0.9178370|       -0.9647147|       -0.9605825|           -0.9497160|           -0.9849001|           -0.9797536|                       -0.9398663|                          -0.9398663|                           -0.9588251|               -0.9007766|                   -0.9660861|               -0.9874003|               -0.9236576|               -0.9384099|                   -0.9787730|                   -0.9561700|                   -0.9843052|       -0.9198518|       -0.9621727|       -0.9636528|                       -0.9437391|                               -0.9566540|                   -0.9002224|                       -0.9653447|
|         25| STANDING     |               0.2780137|              -0.0163570|              -0.1073530|                  0.9297947|                 -0.1593168|                  0.2011821|                   0.0752337|                   0.0066321|                  -0.0062281|      -0.0247947|      -0.0698877|       0.0852685|          -0.1004737|          -0.0418295|          -0.0556979|                      -0.9726636|                         -0.9726636|                          -0.9846471|              -0.9670774|                  -0.9850920|              -0.9900932|              -0.9598462|              -0.9740512|                  -0.9884047|                  -0.9725545|                  -0.9848323|      -0.9680785|      -0.9783999|      -0.9704569|                      -0.9723554|                              -0.9822942|                  -0.9689725|                      -0.9840178|               -0.9919701|               -0.9545692|               -0.9646427|                  -0.9931483|                  -0.9806430|                  -0.9677926|                   -0.9883127|                   -0.9722724|                   -0.9870627|       -0.9713574|       -0.9767576|       -0.9718141|           -0.9779097|           -0.9872421|           -0.9807223|                       -0.9680756|                          -0.9680756|                           -0.9826371|               -0.9598843|                   -0.9832308|               -0.9928517|               -0.9541793|               -0.9621237|                   -0.9893399|                   -0.9740295|                   -0.9878980|       -0.9726642|       -0.9759607|       -0.9749821|                       -0.9702037|                               -0.9820833|                   -0.9610904|                       -0.9830989|
|         13| STANDING     |               0.2777584|              -0.0167892|              -0.1121241|                  0.9426953|                 -0.2399431|                 -0.0524857|                   0.0758631|                   0.0076204|                  -0.0007050|      -0.0295492|      -0.0753205|       0.0854712|          -0.0981200|          -0.0412873|          -0.0539261|                      -0.9715642|                         -0.9715642|                          -0.9868000|              -0.9578254|                  -0.9836376|              -0.9894260|              -0.9594276|              -0.9775673|                  -0.9881983|                  -0.9777528|                  -0.9846086|      -0.9571541|      -0.9729131|      -0.9743944|                      -0.9723936|                              -0.9819775|                  -0.9574888|                      -0.9771974|               -0.9910208|               -0.9494224|               -0.9675380|                  -0.9922324|                  -0.9746812|                  -0.9768272|                   -0.9876361|                   -0.9777042|                   -0.9869262|       -0.9555774|       -0.9717218|       -0.9734366|           -0.9784651|           -0.9809827|           -0.9851770|                       -0.9685197|                          -0.9685197|                           -0.9818656|               -0.9449802|                   -0.9761977|               -0.9918177|               -0.9471798|               -0.9640481|                   -0.9881851|                   -0.9794123|                   -0.9878715|       -0.9558184|       -0.9714252|       -0.9755333|                       -0.9704454|                               -0.9806213|                   -0.9468575|                       -0.9764673|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
