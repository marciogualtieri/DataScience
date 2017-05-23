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
Data Cleaning: Wearable Computing, Human Activity Recognition Using Smartphones
</h1>
<br/>

<h3>
by Marcio Gualtieri
</h3>
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

This file has been downloaded from [UCI's Machine Learning Repository](http://archive.ics.uci.edu/ml/). You will find the original data [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

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

    ## [1] "tBodyAccMag-entropy()"       "tGravityAcc-arCoeff()-Z,4"  
    ## [3] "tBodyGyroJerkMag-arCoeff()2" "tGravityAcc-mad()-Z"        
    ## [5] "tBodyGyro-correlation()-X,Y" "fBodyGyro-skewness()-Y"

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

    ## [1] "fBodyAcc-energy()-Z"           "tBodyGyroJerk-arCoeff()-Y,2"  
    ## [3] "fBodyGyro-maxInds-Z"           "fBodyAcc-bandsEnergy()-49,64" 
    ## [5] "fBodyBodyGyroMag-max()"        "fBodyGyro-bandsEnergy()-25,48"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyAccJerk-mean()-X"  "tBodyAccJerk-mean()-X" 
    ## [3] "fBodyGyro-mean()-X"     "tGravityAcc-mean()-Z"  
    ## [5] "tBodyGyroJerk-mean()-Y" "tGravityAcc-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyAccMag-std()"         "tBodyAcc-std()-Z"         
    ## [3] "fBodyBodyGyroMag-std()"    "tBodyAcc-std()-X"         
    ## [5] "fBodyBodyAccJerkMag-std()" "fBodyAcc-std()-Y"

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

    ## [1] "fBodyAccJerk-bandsEnergy()-33,48" "angle(X,gravityMean)"            
    ## [3] "tGravityAcc-arCoeff()-Z,4"        "tBodyAccJerk-mean()-X"           
    ## [5] "fBodyAccJerk-bandsEnergy()-49,64" "fBodyBodyGyroMag-maxInds"

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
| 726  |               0.3381516|              -0.0218159|              -0.2367780|                  0.9527248|                 -0.1434361|                 -0.1168755|                   0.0292584|                   0.0837251|                  -0.2918493|      -0.1991314|      -0.1645384|      -0.0587556|           0.0919054|           0.0843185|           0.0959533|                      -0.3893443|                         -0.3893443|                          -0.5889111|              -0.4145510|                  -0.7836240|              -0.4234484|              -0.5024097|              -0.5265558|                  -0.4699599|                  -0.7010241|                  -0.7022787|      -0.5522981|      -0.6711379|      -0.4868166|                      -0.4198198|                              -0.4490332|                  -0.7157208|                      -0.8214690|               -0.4804165|               -0.2878384|               -0.4312269|                  -0.9715455|                  -0.8501678|                  -0.8797144|                   -0.4498059|                   -0.6887505|                   -0.7346994|       -0.6356336|       -0.6312161|       -0.2444231|           -0.7454273|           -0.8143685|           -0.7794088|                       -0.4190712|                          -0.4190712|                           -0.4674201|               -0.6878967|                   -0.8296454|               -0.5045993|               -0.2396233|               -0.4249084|                   -0.4774128|                   -0.6961517|                   -0.7660922|       -0.6621282|       -0.6110488|       -0.2494528|                       -0.5084195|                               -0.4941479|                   -0.7220939|                       -0.8533732|           2|          9|
| 1180 |               0.2631599|              -0.0314167|              -0.1684404|                  0.9275224|                  0.1467661|                  0.0137414|                   0.3667678|                  -0.0882904|                  -0.0864460|       0.4451506|       0.0785492|       0.1737006|          -0.1132904|           0.0530677|          -0.1466073|                      -0.0225313|                         -0.0225313|                          -0.2409023|               0.1170553|                  -0.5576648|              -0.0808435|              -0.0647573|              -0.2317783|                  -0.1549582|                  -0.2019824|                  -0.4791628|      -0.2524936|      -0.1880983|      -0.4047983|                      -0.1789380|                              -0.1071130|                  -0.1914213|                      -0.5410434|               -0.1509730|               -0.0935421|                0.0027685|                  -0.9692314|                  -0.9179502|                  -0.9303363|                   -0.1523914|                   -0.2195925|                   -0.5301587|       -0.2342523|        0.1610018|       -0.4482710|           -0.4582460|           -0.5863108|           -0.5186614|                       -0.2264894|                          -0.2264894|                           -0.1967502|                0.1462007|                   -0.5523195|               -0.1802099|               -0.1667736|                0.0426204|                   -0.2273141|                   -0.2999777|                   -0.5797416|       -0.2393212|        0.3236904|       -0.5136655|                       -0.3746479|                               -0.3298613|                    0.1519600|                       -0.5995384|           2|         10|
| 1544 |               0.2745917|              -0.0206755|              -0.1130161|                  0.9146617|                 -0.2417214|                 -0.2541196|                   0.0744017|                   0.0246110|                   0.0050796|      -0.0332823|      -0.0684307|       0.0871771|          -0.1065279|          -0.0392182|          -0.0518322|                      -0.9866004|                         -0.9866004|                          -0.9924801|              -0.9804440|                  -0.9922827|              -0.9938952|              -0.9789296|              -0.9879043|                  -0.9919383|                  -0.9886190|                  -0.9904500|      -0.9790760|      -0.9874173|      -0.9911695|                      -0.9914358|                              -0.9942864|                  -0.9846621|                      -0.9929510|               -0.9945947|               -0.9731706|               -0.9843193|                  -0.9955080|                  -0.9853409|                  -0.9948169|                   -0.9918020|                   -0.9893009|                   -0.9932781|       -0.9779362|       -0.9865004|       -0.9854706|           -0.9908475|           -0.9907685|           -0.9959747|                       -0.9912037|                          -0.9912037|                           -0.9953983|               -0.9782708|                   -0.9930677|               -0.9948366|               -0.9709492|               -0.9824264|                   -0.9923532|                   -0.9910379|                   -0.9951063|       -0.9777773|       -0.9859340|       -0.9848971|                       -0.9913927|                               -0.9957798|                   -0.9776712|                       -0.9933054|           5|         13|
| 715  |               0.2338728|              -0.0201124|              -0.1387575|                  0.9773541|                 -0.0882318|                  0.0203642|                   0.0739634|                   0.3087121|                   0.3695288|      -0.0084235|      -0.0375498|       0.0279761|          -0.0195794|          -0.1624983|          -0.3372692|                      -0.1422298|                         -0.1422298|                          -0.2474546|              -0.3523943|                  -0.5863624|              -0.3874365|              -0.1367934|              -0.2608451|                  -0.4127471|                  -0.2845532|                  -0.4222421|      -0.4402851|      -0.5663313|      -0.2955155|                      -0.4249369|                              -0.4049524|                  -0.5857151|                      -0.7620025|               -0.3277420|               -0.1143074|               -0.1304754|                  -0.9893874|                  -0.9636982|                  -0.9708220|                   -0.3349988|                   -0.1954775|                   -0.4491228|       -0.4590236|       -0.5762544|       -0.2748657|           -0.5963380|           -0.6671522|           -0.4901367|                       -0.5026880|                          -0.5026880|                           -0.4184852|               -0.5576039|                   -0.7449250|               -0.3055071|               -0.1581719|               -0.1290320|                   -0.3145711|                   -0.1518574|                   -0.4731076|       -0.4699304|       -0.5854606|       -0.3343896|                       -0.6296879|                               -0.4388093|                   -0.6140596|                       -0.7411290|           1|          9|
| 1860 |               0.2746671|              -0.0186658|              -0.0999990|                  0.9643874|                 -0.1729952|                  0.0843219|                   0.0763424|                   0.0321793|                  -0.0008169|      -0.0377020|      -0.0557143|       0.0760689|          -0.1195976|          -0.0285421|          -0.0794642|                      -0.9568957|                         -0.9568957|                          -0.9875217|              -0.9473395|                  -0.9915968|              -0.9943432|              -0.9584621|              -0.9717060|                  -0.9935682|                  -0.9758426|                  -0.9855348|      -0.9540851|      -0.9814193|      -0.9545023|                      -0.9714425|                              -0.9861615|                  -0.9762543|                      -0.9926576|               -0.9954007|               -0.9346335|               -0.9290418|                  -0.9997270|                  -0.9740902|                  -0.9740723|                   -0.9936165|                   -0.9759588|                   -0.9881048|       -0.9446944|       -0.9792765|       -0.9466331|           -0.9857783|           -0.9943882|           -0.9883491|                       -0.9642684|                          -0.9642684|                           -0.9879523|               -0.9524670|                   -0.9925517|               -0.9958695|               -0.9274649|               -0.9151798|                   -0.9942399|                   -0.9778392|                   -0.9893476|       -0.9431924|       -0.9780532|       -0.9488745|                       -0.9647166|                               -0.9895943|                   -0.9477050|                       -0.9924993|           5|         18|
| 92   |               0.3496910|              -0.0304961|              -0.1082978|                  0.9122910|                 -0.3441265|                  0.0285201|                   0.0788672|                  -0.2626615|                  -0.2224463|      -0.0556819|      -0.0108983|       0.0431303|           0.0116539|          -0.0742944|          -0.1995988|                      -0.2891818|                         -0.2891818|                          -0.2352392|              -0.4498079|                  -0.5482020|              -0.3734495|               0.0119160|              -0.3823143|                  -0.3369022|                   0.0204668|                  -0.5016669|      -0.4230711|      -0.5458151|      -0.3865869|                      -0.2451245|                              -0.1440135|                  -0.4543239|                      -0.6258788|               -0.4325196|               -0.1064564|               -0.3372380|                  -0.9606839|                  -0.9793801|                  -0.9799904|                   -0.3166973|                    0.0699533|                   -0.5322890|       -0.5446472|       -0.5279543|       -0.4584251|           -0.3738719|           -0.6493132|           -0.4395801|                       -0.4065608|                          -0.4065608|                           -0.2004008|               -0.4956290|                   -0.5728016|               -0.4574996|               -0.2343284|               -0.3642847|                   -0.3562823|                    0.0527570|                   -0.5602155|       -0.5832024|       -0.5205215|       -0.5336376|                       -0.6142460|                               -0.2833267|                   -0.6200095|                       -0.5398504|           1|          2|

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
| 2280 |               0.2746613|              -0.0212350|              -0.1146452|                  0.9633290|                 -0.1682036|                  0.0991094|                   0.0449694|                   0.0039002|                  -0.0428950|      -0.0801208|      -0.0615975|       0.0647177|          -0.1078521|          -0.0596643|          -0.0283570|                      -0.9257774|                         -0.9257774|                          -0.9528927|              -0.9174839|                  -0.9696403|              -0.9564250|              -0.8803401|              -0.9330780|                  -0.9572109|                  -0.9083243|                  -0.9724511|      -0.9177394|      -0.9633326|      -0.9326008|                      -0.9185157|                              -0.9342669|                  -0.9324220|                      -0.9663055|               -0.9675791|               -0.8743142|               -0.8844907|                  -0.9919488|                  -0.9755982|                  -0.9447365|                   -0.9614238|                   -0.9083540|                   -0.9756704|       -0.9196866|       -0.9617706|       -0.9357709|           -0.9404428|           -0.9812122|           -0.9643567|                       -0.9046190|                          -0.9046190|                           -0.9384369|               -0.8973969|                   -0.9639270|               -0.9732075|               -0.8780962|               -0.8699159|                   -0.9706951|                   -0.9150446|                   -0.9773977|       -0.9209749|       -0.9609902|       -0.9425688|                       -0.9109761|                               -0.9431752|                   -0.8942009|                       -0.9628870|         18| STANDING            |
| 2662 |               0.2750230|              -0.0163484|              -0.1116796|                 -0.2814256|                  0.9068612|                  0.3663756|                   0.0747087|                   0.0076242|                  -0.0118233|      -0.0264534|      -0.0723360|       0.0881986|          -0.0970079|          -0.0381814|          -0.0564189|                      -0.9962200|                         -0.9962200|                          -0.9929680|              -0.9928549|                  -0.9949606|              -0.9972060|              -0.9915532|              -0.9880950|                  -0.9971881|                  -0.9897349|                  -0.9868816|      -0.9962470|      -0.9908815|      -0.9962691|                      -0.9942947|                              -0.9925546|                  -0.9932396|                      -0.9951177|               -0.9971178|               -0.9936038|               -0.9900558|                  -0.9984372|                  -0.9984926|                  -0.9985522|                   -0.9972396|                   -0.9895801|                   -0.9889130|       -0.9963135|       -0.9885732|       -0.9975306|           -0.9968767|           -0.9923164|           -0.9933385|                       -0.9952722|                          -0.9952722|                           -0.9923754|               -0.9929714|                   -0.9928966|               -0.9969781|               -0.9941549|               -0.9914000|                   -0.9975465|                   -0.9901062|                   -0.9895113|       -0.9962620|       -0.9872390|       -0.9983465|                       -0.9959205|                               -0.9906242|                   -0.9937770|                       -0.9903360|         13| LAYING              |
| 2547 |               0.2496410|              -0.0209676|              -0.1007060|                 -0.4734262|                  0.6547001|                  0.7647677|                   0.1028422|                   0.0154593|                  -0.0158284|      -0.0280061|      -0.0960429|       0.0896340|          -0.0959786|          -0.0445506|          -0.0531619|                      -0.9557172|                         -0.9557172|                          -0.9754627|              -0.9661791|                  -0.9740749|              -0.9578464|              -0.9607905|              -0.9740931|                  -0.9755793|                  -0.9680695|                  -0.9794537|      -0.9761226|      -0.9629676|      -0.9687329|                      -0.9677383|                              -0.9728755|                  -0.9656968|                      -0.9737160|               -0.9550607|               -0.9570037|               -0.9758333|                  -0.9332530|                  -0.9907902|                  -0.9812384|                   -0.9743666|                   -0.9666659|                   -0.9812474|       -0.9789782|       -0.9610945|       -0.9697765|           -0.9799706|           -0.9695080|           -0.9795225|                       -0.9679368|                          -0.9679368|                           -0.9747399|               -0.9647521|                   -0.9742815|               -0.9537692|               -0.9566722|               -0.9780762|                   -0.9752560|                   -0.9672636|                   -0.9814345|       -0.9798446|       -0.9601370|       -0.9727391|                       -0.9719259|                               -0.9761183|                   -0.9700127|                       -0.9765017|         12| LAYING              |
| 338  |               0.2057271|              -0.0698761|              -0.1174008|                  0.8955315|                 -0.3568274|                  0.0280056|                   0.0327480|                  -0.0082745|                   0.1125460|      -0.1473113|       0.0223545|       0.0542584|          -0.2778310|          -0.1977890|          -0.1687345|                       0.1257620|                          0.1257620|                           0.0424465|               0.1539250|                  -0.0872579|              -0.0824854|               0.6360739|              -0.4109658|                  -0.0334804|                   0.4245298|                  -0.4787010|      -0.0155048|       0.1265912|      -0.0128323|                       0.1216769|                               0.2548892|                   0.1191945|                      -0.1570969|               -0.1410124|                0.7349081|               -0.3438454|                  -0.9468132|                  -0.9170129|                  -0.9846510|                    0.0115832|                    0.5035454|                   -0.5111341|       -0.1867627|        0.2607886|       -0.1686211|           -0.1821530|           -0.0857477|            0.0184906|                       -0.0444584|                          -0.0444584|                            0.1578021|                0.1194250|                   -0.1448758|               -0.1651716|                0.6757486|               -0.3583682|                   -0.0305658|                    0.4903308|                   -0.5408035|       -0.2416241|        0.3281131|       -0.3026632|                       -0.3018038|                                0.0116542|                   -0.0770715|                       -0.1890057|         20| WALKING             |
| 1275 |               0.3172505|              -0.0481120|              -0.1240573|                  0.9373395|                 -0.2762723|                 -0.1175993|                  -0.2986203|                   0.1283550|                   0.3123057|      -0.1312011|       0.0278879|       0.1002456|          -0.0432545|          -0.6661154|           0.1029955|                       0.1353370|                          0.1353370|                          -0.1724980|              -0.0252518|                  -0.3305671|              -0.0733360|               0.3951217|              -0.1330199|                  -0.3102728|                   0.0026243|                  -0.3579707|      -0.1745918|      -0.0831421|       0.0948957|                       0.1510559|                              -0.0870854|                  -0.2197677|                      -0.3689327|               -0.0138654|                0.5118708|               -0.1375633|                  -0.9672280|                  -0.9227470|                  -0.9331358|                   -0.2794043|                    0.1751024|                   -0.3780916|       -0.2190066|       -0.2253566|        0.0464285|           -0.3466009|           -0.3425832|           -0.2277274|                        0.1080821|                           0.1080821|                           -0.0355540|               -0.1863619|                   -0.3538573|                0.0086765|                0.4754431|               -0.2105920|                   -0.3107206|                    0.2801255|                   -0.3954023|       -0.2390723|       -0.3335234|       -0.0655962|                       -0.0893066|                                0.0197145|                   -0.3035934|                       -0.3795832|         20| WALKING\_DOWNSTAIRS |
| 461  |               0.2970299|              -0.0151667|              -0.0788453|                  0.8883733|                 -0.3720858|                  0.0431857|                   0.4376075|                  -0.1281596|                  -0.0097687|       0.0491992|      -0.0235679|       0.1013582|           0.0310389|          -0.6339217|           0.0365266|                       0.1227158|                          0.1227158|                           0.0391931|               0.0572244|                  -0.0997062|              -0.0339809|               0.4584135|              -0.3812321|                  -0.0779892|                   0.2553380|                  -0.3588761|      -0.1683409|       0.2070454|      -0.1502800|                       0.1313767|                               0.1368067|                  -0.0154241|                      -0.1871930|               -0.0989450|                0.6100457|               -0.3386771|                  -0.9792554|                  -0.9856574|                  -0.9770259|                   -0.0272998|                    0.3859937|                   -0.3644961|       -0.3811376|        0.2242898|       -0.2710259|           -0.2611342|           -0.0862973|           -0.0280523|                       -0.1119095|                          -0.1119095|                            0.0824178|               -0.0706489|                   -0.1844268|               -0.1258150|                0.5841453|               -0.3670441|                   -0.0599931|                    0.4372998|                   -0.3683003|       -0.4492738|        0.2262886|       -0.3819605|                       -0.4256921|                                0.0008403|                   -0.2806972|                       -0.2363495|         20| WALKING             |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|  SubjectID| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|----------:|:--------------------|
| 2944 |               0.1180560|               0.0198119|              -0.1041776|                  0.9260053|                 -0.2339331|                 -0.1149729|                   0.4378060|                  -0.3923794|                  -0.0237313|       0.3151350|      -0.3490840|      -0.0049139|          -0.3276054|          -0.0945726|           0.0178609|                       0.1982884|                          0.1982884|                           0.0346668|              -0.0549991|                  -0.2264658|               0.1797430|               0.2926214|              -0.2445082|                  -0.0042756|                   0.1562738|                  -0.2663105|      -0.0188630|      -0.1125788|      -0.1325428|                       0.2448912|                               0.1617018|                  -0.1547418|                      -0.2884468|                0.2327599|                0.1898815|               -0.3041022|                  -0.9595952|                  -0.9507345|                  -0.9386146|                    0.0915763|                    0.2635589|                   -0.3314063|       -0.3500939|       -0.1313804|       -0.2664688|           -0.0678010|           -0.3091344|           -0.1856453|                        0.2039629|                           0.2039629|                            0.1885613|               -0.1856714|                   -0.2999455|                0.2530234|                0.0546787|               -0.4006261|                    0.0945848|                    0.2978084|                   -0.3944309|       -0.4625302|       -0.1493730|       -0.3832444|                       -0.0072124|                                0.2141358|                   -0.3543345|                       -0.3626294|         28| WALKING\_DOWNSTAIRS |
| 2673 |               0.0888572|              -0.0329676|              -0.1326659|                  0.9572638|                 -0.0702716|                  0.1340462|                  -0.0271894|                  -0.0737978|                  -0.0084847|      -0.3586687|      -0.1342632|      -0.0309749|          -0.0502084|          -0.1129482|          -0.1283151|                       0.0850856|                          0.0850856|                          -0.1740669|               0.0958329|                  -0.5520190|               0.0585150|              -0.1498097|              -0.2183502|                  -0.0633239|                  -0.2067776|                  -0.3671681|      -0.0067808|      -0.4522968|      -0.1728503|                       0.0820921|                               0.0169204|                  -0.2252642|                      -0.5541287|                0.1314991|               -0.2200030|               -0.1392386|                  -0.9613066|                  -0.8879368|                  -0.8661454|                   -0.0396451|                   -0.2197448|                   -0.4378146|        0.1500800|       -0.3488709|       -0.2502167|           -0.2926029|           -0.7156057|           -0.4039166|                        0.0766541|                           0.0766541|                           -0.0649438|                0.1409564|                   -0.5637767|                0.1589976|               -0.3100446|               -0.1634615|                   -0.1006297|                   -0.2938174|                   -0.5082869|        0.1694639|       -0.2969544|       -0.3459190|                       -0.0939448|                               -0.1871823|                    0.1602685|                       -0.6080473|         29| WALKING\_DOWNSTAIRS |
| 2901 |               0.3746830|               0.0047331|              -0.1076479|                  0.9638846|                 -0.1435959|                 -0.0132427|                  -0.1419577|                  -0.0577227|                   0.3940142|      -0.2279451|       0.0864440|       0.0314419|          -0.2012046|          -0.1974722|           0.1696555|                      -0.1066292|                         -0.1066292|                          -0.4346056|              -0.0163185|                  -0.6507161|              -0.3329219|              -0.0637586|              -0.3139303|                  -0.4983501|                  -0.3332138|                  -0.5034533|      -0.2530551|      -0.3610491|      -0.2829264|                      -0.2479859|                              -0.3662975|                  -0.3323742|                      -0.6711948|               -0.2011046|                0.0693982|               -0.2871900|                  -0.9643347|                  -0.9064893|                  -0.8980908|                   -0.4478708|                   -0.2812574|                   -0.5733094|       -0.0617986|       -0.2283892|       -0.3427246|           -0.6239060|           -0.6919541|           -0.5528169|                       -0.1710220|                          -0.1710220|                           -0.3422725|               -0.0568315|                   -0.6858879|               -0.1546475|                0.0674549|               -0.3287454|                   -0.4442901|                   -0.2713254|                   -0.6458186|       -0.0341911|       -0.1621061|       -0.4235932|                       -0.2594381|                               -0.3107807|                   -0.0530515|                       -0.7285851|         30| WALKING\_DOWNSTAIRS |
| 5957 |               0.2840991|              -0.0132083|              -0.1120401|                 -0.2329742|                  0.5179750|                  0.8406986|                   0.0761322|                   0.0052940|                  -0.0075627|      -0.0231286|      -0.0805423|       0.0841581|          -0.0952523|          -0.0416051|          -0.0490631|                      -0.9882219|                         -0.9882219|                          -0.9925243|              -0.9868913|                  -0.9947423|              -0.9914511|              -0.9844227|              -0.9915682|                  -0.9918649|                  -0.9907732|                  -0.9895501|      -0.9874054|      -0.9911009|      -0.9953795|                      -0.9936223|                              -0.9936447|                  -0.9923871|                      -0.9966154|               -0.9922419|               -0.9753634|               -0.9912572|                  -0.9912385|                  -0.9855686|                  -0.9900658|                   -0.9920632|                   -0.9909592|                   -0.9920981|       -0.9859898|       -0.9903314|       -0.9964161|           -0.9927660|           -0.9945124|           -0.9963034|                       -0.9922708|                          -0.9922708|                           -0.9950904|               -0.9911004|                   -0.9969682|               -0.9924945|               -0.9717236|               -0.9908284|                   -0.9930226|                   -0.9918557|                   -0.9934630|       -0.9856689|       -0.9898260|       -0.9971478|                       -0.9915373|                               -0.9965655|                   -0.9914808|                       -0.9972266|         14| LAYING              |
| 1092 |               0.2865631|              -0.0077090|              -0.1029869|                  0.9422140|                 -0.2533699|                 -0.1015218|                   0.0234180|                   0.2248175|                   0.0199928|      -0.6597634|       0.3954792|       0.2933216|          -0.2232466|          -0.1147694|           0.1522926|                      -0.3258787|                         -0.3258787|                          -0.4459141|              -0.1440482|                  -0.6692876|              -0.4891064|              -0.2856386|              -0.4052163|                  -0.5169104|                  -0.4757904|                  -0.5921960|      -0.4758752|      -0.6391872|      -0.4261121|                      -0.4995576|                              -0.4729474|                  -0.5077183|                      -0.7321048|               -0.4878605|               -0.2636337|               -0.2583038|                  -0.9498800|                  -0.9679425|                  -0.8219391|                   -0.4431349|                   -0.3765121|                   -0.6286883|       -0.6003073|       -0.5801980|       -0.4208003|           -0.5077628|           -0.7674589|           -0.6332541|                       -0.5272250|                          -0.5272250|                           -0.4545948|               -0.4318513|                   -0.7161827|               -0.4872609|               -0.2981907|               -0.2400679|                   -0.4181049|                   -0.3133093|                   -0.6633399|       -0.6398932|       -0.5504074|       -0.4718934|                       -0.6165204|                               -0.4349598|                   -0.4780644|                       -0.7156058|         28| WALKING             |
| 442  |               0.2552582|              -0.0515331|              -0.0837676|                  0.9570326|                 -0.2643339|                  0.0000946|                   0.2972851|                   0.2856594|                  -0.2958690|       0.0164762|      -0.0982462|       0.0849864|           0.1550548|          -0.2043838|          -0.2776056|                      -0.0044287|                         -0.0044287|                          -0.1241283|              -0.0680890|                  -0.3402780|              -0.2898824|               0.3630981|              -0.4286106|                  -0.3875013|                   0.1265411|                  -0.5456769|       0.0155267|      -0.3691533|      -0.3767743|                      -0.1885061|                              -0.1865865|                  -0.2742305|                      -0.5341483|               -0.1999017|                0.3947401|               -0.3748841|                  -0.9743470|                  -0.9874776|                  -0.9823669|                   -0.3279290|                    0.3097163|                   -0.5750286|       -0.1102345|       -0.2820661|       -0.3707957|           -0.0771868|           -0.5174510|           -0.4924564|                       -0.2275498|                          -0.2275498|                           -0.2346031|               -0.2098132|                   -0.5791875|               -0.1669998|                0.3230241|               -0.3941458|                   -0.3254497|                    0.4181118|                   -0.6017580|       -0.1526847|       -0.2381419|       -0.4262366|                       -0.3703004|                               -0.3060200|                   -0.3010084|                       -0.6803240|          8| WALKING             |

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
|          4| WALKING\_DOWNSTAIRS |               0.2799653|              -0.0098020|              -0.1067775|                  0.9477319|                 -0.0620853|                  0.1487148|                   0.0971863|                   0.0056378|                  -0.0072914|      -0.1028388|      -0.0704026|       0.0592639|          -0.0921283|          -0.0348435|          -0.0492836|                      -0.0491617|                         -0.0491617|                          -0.2288514|              -0.3466063|                  -0.5928430|              -0.0722392|              -0.1296066|              -0.4946835|                  -0.1616329|                  -0.1729416|                  -0.5839174|      -0.2402989|      -0.7175458|      -0.3183065|                      -0.0190743|                              -0.1752953|                  -0.4292134|                      -0.6217525|                0.0111935|               -0.2185983|               -0.4791860|                  -0.9552589|                  -0.9320660|                  -0.9377538|                   -0.1457597|                   -0.1462423|                   -0.6266470|       -0.3702447|       -0.6994535|       -0.4984808|           -0.3959955|           -0.8168582|           -0.3257801|                       -0.0819559|                          -0.0819559|                           -0.2168589|               -0.3805726|                   -0.6370795|                0.0390098|               -0.3225313|               -0.5126943|                   -0.2082501|                   -0.1772021|                   -0.6688673|       -0.4149190|       -0.6915184|       -0.6216585|                       -0.2636440|                               -0.2804268|                   -0.4576741|                       -0.6854709|
|          1| SITTING             |               0.2612376|              -0.0013083|              -0.1045442|                  0.8315099|                  0.2044116|                  0.3320437|                   0.0774825|                  -0.0006191|                  -0.0033678|      -0.0453501|      -0.0919242|       0.0629314|          -0.0936794|          -0.0402118|          -0.0467026|                      -0.9485368|                         -0.9485368|                          -0.9873642|              -0.9308925|                  -0.9919763|              -0.9796412|              -0.9440846|              -0.9591849|                  -0.9865970|                  -0.9815795|                  -0.9860531|      -0.9761615|      -0.9758386|      -0.9513155|                      -0.9477829|                              -0.9852621|                  -0.9584356|                      -0.9897975|               -0.9772290|               -0.9226186|               -0.9395863|                  -0.9684571|                  -0.9355171|                  -0.9490409|                   -0.9864307|                   -0.9813720|                   -0.9879108|       -0.9772113|       -0.9664739|       -0.9414259|           -0.9917316|           -0.9895181|           -0.9879358|                       -0.9270784|                          -0.9270784|                           -0.9841200|               -0.9345318|                   -0.9883087|               -0.9764123|               -0.9172750|               -0.9344696|                   -0.9874930|                   -0.9825139|                   -0.9883392|       -0.9779042|       -0.9623450|       -0.9439178|                       -0.9284448|                               -0.9816062|                   -0.9321984|                       -0.9870496|
|         21| STANDING            |               0.2769522|              -0.0167085|              -0.1104179|                  0.8812133|                 -0.3461556|                 -0.2076857|                   0.0754544|                   0.0100621|                  -0.0033209|      -0.0191732|      -0.0738116|       0.0864863|          -0.1031998|          -0.0404301|          -0.0538212|                      -0.9587743|                         -0.9587743|                          -0.9747652|              -0.9498372|                  -0.9768571|              -0.9783277|              -0.9496949|              -0.9602741|                  -0.9768030|                  -0.9645030|                  -0.9747806|      -0.9569900|      -0.9600826|      -0.9594326|                      -0.9622913|                              -0.9706343|                  -0.9567230|                      -0.9761268|               -0.9814200|               -0.9436016|               -0.9461234|                  -0.9829067|                  -0.9776814|                  -0.9585900|                   -0.9770634|                   -0.9639215|                   -0.9779157|       -0.9625145|       -0.9559792|       -0.9593270|           -0.9718665|           -0.9768159|           -0.9754273|                       -0.9569199|                          -0.9569199|                           -0.9716065|               -0.9456144|                   -0.9761537|               -0.9828928|               -0.9435452|               -0.9424589|                   -0.9795305|                   -0.9660241|                   -0.9797233|       -0.9645303|       -0.9540809|       -0.9631246|                       -0.9600418|                               -0.9719261|                   -0.9477632|                       -0.9777066|
|          8| SITTING             |               0.2674915|              -0.0067255|              -0.1044610|                  0.8324539|                  0.2400951|                  0.2638952|                   0.0786714|                  -0.0065752|                  -0.0106809|      -0.0547397|      -0.0955089|       0.0716049|          -0.0923150|          -0.0402674|          -0.0445732|                      -0.9521397|                         -0.9521397|                          -0.9860615|              -0.9326822|                  -0.9918074|              -0.9811429|              -0.9442197|              -0.9594363|                  -0.9849773|                  -0.9802211|                  -0.9829953|      -0.9822003|      -0.9765899|      -0.9617987|                      -0.9479818|                              -0.9809323|                  -0.9658068|                      -0.9877306|               -0.9790262|               -0.9273320|               -0.9395530|                  -0.9667580|                  -0.9374623|                  -0.9354753|                   -0.9851888|                   -0.9807846|                   -0.9852858|       -0.9845241|       -0.9715007|       -0.9596235|           -0.9932646|           -0.9888763|           -0.9852414|                       -0.9299436|                          -0.9299436|                           -0.9806674|               -0.9530016|                   -0.9867567|               -0.9782567|               -0.9238300|               -0.9338898|                   -0.9869136|                   -0.9830388|                   -0.9861853|       -0.9853393|       -0.9689244|       -0.9626323|                       -0.9317212|                               -0.9793202|                   -0.9532512|                       -0.9861473|
|         29| LAYING              |               0.2872952|              -0.0171965|              -0.1094621|                 -0.3467898|                  0.8075354|                  0.5904522|                   0.0718861|                   0.0116912|                   0.0024154|      -0.0258281|      -0.0761814|       0.1274120|          -0.0995340|          -0.0386768|          -0.0674470|                      -0.9864932|                         -0.9864932|                          -0.9927254|              -0.9719236|                  -0.9973225|              -0.9866270|              -0.9890343|              -0.9894739|                  -0.9921540|                  -0.9893988|                  -0.9920184|      -0.9931226|      -0.9936963|      -0.9761843|                      -0.9868006|                              -0.9939983|                  -0.9840013|                      -0.9976174|               -0.9842196|               -0.9902409|               -0.9872551|                  -0.9729399|                  -0.9942476|                  -0.9857782|                   -0.9920060|                   -0.9895136|                   -0.9932883|       -0.9942766|       -0.9927510|       -0.9749946|           -0.9965425|           -0.9970816|           -0.9953808|                       -0.9815721|                          -0.9815721|                           -0.9946469|               -0.9770401|                   -0.9976661|               -0.9834323|               -0.9906804|               -0.9863788|                   -0.9925435|                   -0.9904681|                   -0.9931078|       -0.9946522|       -0.9922408|       -0.9768590|                       -0.9815998|                               -0.9943667|                   -0.9766790|                       -0.9975852|
|          3| WALKING\_DOWNSTAIRS |               0.2924235|              -0.0193554|              -0.1161398|                  0.9390578|                 -0.2288292|                 -0.1023528|                   0.0725689|                   0.0109708|                  -0.0020273|      -0.1315733|      -0.0139358|       0.1238267|          -0.0778702|          -0.0391568|          -0.0416193|                      -0.0628126|                         -0.0628126|                          -0.2052392|              -0.2152945|                  -0.5085676|              -0.0421707|              -0.0077005|              -0.4044524|                  -0.0906707|                  -0.1359385|                  -0.5290595|      -0.1290666|      -0.5426942|      -0.3028665|                       0.0289413|                              -0.0494780|                  -0.3323766|                      -0.5762772|               -0.0574100|               -0.0331504|               -0.3622402|                  -0.9500611|                  -0.9460946|                  -0.8999439|                   -0.0858010|                   -0.1114392|                   -0.5717352|       -0.2616534|       -0.5467404|       -0.4423078|           -0.2856832|           -0.6809473|           -0.3746054|                       -0.0411340|                          -0.0411340|                           -0.0926324|               -0.2457947|                   -0.5839192|               -0.0654417|               -0.1097224|               -0.3897230|                   -0.1654429|                   -0.1477282|                   -0.6135251|       -0.3086303|       -0.5530945|       -0.5481643|                       -0.2338494|                               -0.1591023|                   -0.3224408|                       -0.6249108|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE)
```
