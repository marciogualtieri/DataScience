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

    ## [1] "tBodyGyroJerkMag-arCoeff()3"     "fBodyGyro-max()-Y"              
    ## [3] "tGravityAcc-sma()"               "tBodyAcc-energy()-Y"            
    ## [5] "fBodyAccJerk-bandsEnergy()-9,16" "tBodyGyroJerk-correlation()-X,Y"

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

    ## [1] "fBodyGyro-bandsEnergy()-9,16" "tBodyAcc-max()-X"            
    ## [3] "fBodyBodyGyroJerkMag-sma()"   "tBodyGyroJerk-energy()-Y"    
    ## [5] "tBodyAccJerk-arCoeff()-Y,1"   "fBodyAcc-meanFreq()-Y"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyAcc-mean()-Z"       "tGravityAcc-mean()-Y"   
    ## [3] "fBodyGyro-mean()-Y"      "tBodyAccJerk-mean()-Y"  
    ## [5] "fBodyBodyGyroMag-mean()" "tBodyAccMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccJerk-std()-X"       "fBodyGyro-std()-X"         
    ## [3] "tBodyAccJerk-std()-Y"       "tGravityAccMag-std()"      
    ## [5] "fBodyBodyGyroJerkMag-std()" "tBodyGyroJerk-std()-Z"

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

    ## [1] "tGravityAcc-arCoeff()-X,3" "fBodyAcc-maxInds-Y"       
    ## [3] "fBodyGyro-mean()-X"        "tGravityAccMag-sma()"     
    ## [5] "fBodyGyro-skewness()-Y"    "tBodyGyro-arCoeff()-Z,1"

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
| 2722 |               0.2522954|              -0.0245293|              -0.0707893|                  0.9544489|                 -0.0881960|                 -0.1668372|                   0.2340848|                   0.0324542|                   0.1752681|       0.1973871|      -0.1368778|      -0.0274359|           0.2308306|           0.0694405|          -0.0887241|                      -0.0337554|                         -0.0337554|                          -0.1922312|              -0.2148902|                  -0.4453540|              -0.2894532|              -0.1413658|              -0.0207244|                  -0.3604647|                  -0.2269789|                  -0.0305857|      -0.0649932|      -0.3635725|      -0.2756462|                      -0.0442945|                              -0.1023674|                  -0.2553720|                      -0.3579188|               -0.0569417|               -0.0778185|               -0.0854440|                  -0.9758445|                  -0.9439360|                  -0.9333494|                   -0.3000184|                   -0.0684177|                   -0.1067355|       -0.2861049|       -0.4618590|       -0.3453273|           -0.2413255|           -0.4548316|           -0.3430927|                        0.0246894|                           0.0246894|                            0.0559967|               -0.3188340|                   -0.3152689|                0.0203743|               -0.1032978|               -0.2028939|                   -0.2990124|                    0.0350741|                   -0.1797586|       -0.3564766|       -0.5367042|       -0.4296769|                       -0.0978960|                                0.2227976|                   -0.4941866|                       -0.3093296|           3|         24|
| 2849 |               0.2666045|              -0.0187564|              -0.1028272|                 -0.2713488|                  0.7449565|                  0.6672550|                   0.0712323|                   0.0314177|                  -0.0076770|      -0.0322553|      -0.0672367|       0.0836074|          -0.0918460|          -0.0513221|          -0.0529149|                      -0.9847803|                         -0.9847803|                          -0.9908759|              -0.9765382|                  -0.9871759|              -0.9870485|              -0.9832366|              -0.9876871|                  -0.9901636|                  -0.9858601|                  -0.9888125|      -0.9871418|      -0.9714897|      -0.9970066|                      -0.9890568|                              -0.9928022|                  -0.9790591|                      -0.9864318|               -0.9818059|               -0.9884166|               -0.9880208|                  -0.9837909|                  -0.9967050|                  -0.9909579|                   -0.9904912|                   -0.9866586|                   -0.9916700|       -0.9912982|       -0.9658233|       -0.9973539|           -0.9880615|           -0.9833530|           -0.9975519|                       -0.9899405|                          -0.9899405|                           -0.9926314|               -0.9768562|                   -0.9865874|               -0.9796864|               -0.9915478|               -0.9882997|                   -0.9917613|                   -0.9887475|                   -0.9934457|       -0.9926706|       -0.9628032|       -0.9976782|                       -0.9911686|                               -0.9908504|                   -0.9790290|                       -0.9873542|           6|         24|
| 1147 |               0.3265279|              -0.0083717|              -0.1105160|                  0.9601685|                  0.0546742|                  0.0772059|                  -0.0036822|                  -0.0770787|                   0.0672711|       0.2250969|       0.0861888|       0.1354662|          -0.3812978|          -0.2120783|          -0.0623831|                      -0.1000818|                         -0.1000818|                          -0.1228009|              -0.1568411|                  -0.4663566|              -0.0904068|              -0.0619788|              -0.3143874|                  -0.0940433|                  -0.1015801|                  -0.3335745|      -0.2296415|      -0.3554072|      -0.1792979|                      -0.0502001|                               0.0306326|                  -0.3678996|                      -0.5824640|               -0.1212274|               -0.0859440|               -0.3162786|                  -0.9811175|                  -0.9592622|                  -0.8394288|                   -0.0261258|                    0.0358552|                   -0.4055886|       -0.4664468|       -0.2159255|       -0.2102757|           -0.4015671|           -0.5510685|           -0.3469609|                       -0.1368024|                          -0.1368024|                            0.0750380|               -0.3357702|                   -0.5601399|               -0.1336330|               -0.1569110|               -0.3729214|                   -0.0409150|                    0.1145869|                   -0.4770310|       -0.5446289|       -0.1463875|       -0.2928373|                       -0.3232201|                                0.1224624|                   -0.4278643|                       -0.5624978|           1|         10|
| 740  |               0.2662233|              -0.0798182|              -0.2212113|                  0.9882547|                 -0.0882014|                 -0.1246396|                   0.1259529|                  -0.1068113|                  -0.1464336|      -0.6540073|       0.0629938|       0.2040605|           0.0785617|           0.0062929|           0.1925652|                      -0.2784090|                         -0.2784090|                          -0.4345362|              -0.0796494|                  -0.7068544|              -0.3353749|              -0.3702479|              -0.4374386|                  -0.3880713|                  -0.5756600|                  -0.5956056|      -0.4345386|      -0.6259717|      -0.2759598|                      -0.3676982|                              -0.4076515|                  -0.5645214|                      -0.7740660|               -0.3468230|               -0.2568634|               -0.4014359|                  -0.9467214|                  -0.8742688|                  -0.8315148|                   -0.3052993|                   -0.5520270|                   -0.6479805|       -0.4893512|       -0.5984079|       -0.1109842|           -0.6583992|           -0.7622638|           -0.6833800|                       -0.3698486|                          -0.3698486|                           -0.3797521|               -0.3950798|                   -0.7917864|               -0.3513153|               -0.2487035|               -0.4284144|                   -0.2825751|                   -0.5557812|                   -0.7011605|       -0.5090022|       -0.5850311|       -0.1444355|                       -0.4685527|                               -0.3494798|                   -0.3958866|                       -0.8315287|           2|          9|
| 2540 |               0.1591957|               0.0290138|              -0.1347118|                  0.9164924|                 -0.2887299|                  0.0694371|                  -0.0193438|                   0.3034608|                  -0.1775198|       0.2937879|      -0.4056118|       0.2200666|           0.0808233|           0.1832445|          -0.1978595|                       0.1622126|                          0.1622126|                          -0.0865185|               0.1384683|                  -0.2962580|               0.0021178|               0.5191753|              -0.2666878|                  -0.1946884|                   0.2506878|                  -0.3537745|       0.0217679|      -0.1098653|       0.3431162|                       0.1921577|                               0.0047577|                  -0.0328822|                      -0.2802622|                0.0456953|                0.5710402|               -0.2711206|                  -0.9352628|                  -0.9566047|                  -0.9836579|                   -0.1612486|                    0.3099335|                   -0.4009151|       -0.1615828|       -0.0971536|        0.2358324|           -0.1612632|           -0.3757397|            0.0541492|                        0.1693720|                           0.1693720|                            0.0595436|               -0.0022130|                   -0.2177486|                0.0623891|                0.4985775|               -0.3330970|                   -0.2004258|                    0.2873940|                   -0.4452992|       -0.2201689|       -0.0957532|        0.0855497|                       -0.0257245|                                0.1213510|                   -0.1537581|                       -0.1955439|           3|         20|
| 1572 |               0.2788094|              -0.0174453|              -0.1075952|                  0.9697525|                 -0.0830779|                 -0.1188330|                   0.0706842|                   0.0180789|                   0.0042697|      -0.0293769|      -0.0689623|       0.0803050|          -0.1091307|          -0.0439372|          -0.0775401|                      -0.9943464|                         -0.9943464|                          -0.9918347|              -0.9869676|                  -0.9939765|              -0.9957009|              -0.9850667|              -0.9901805|                  -0.9941100|                  -0.9894870|                  -0.9890789|      -0.9859389|      -0.9882746|      -0.9705036|                      -0.9928059|                              -0.9948602|                  -0.9797643|                      -0.9931786|               -0.9972642|               -0.9865238|               -0.9880896|                  -0.9973258|                  -0.9974642|                  -0.9913490|                   -0.9941031|                   -0.9894235|                   -0.9901714|       -0.9905424|       -0.9863091|       -0.9762782|           -0.9935864|           -0.9920249|           -0.9933961|                       -0.9929636|                          -0.9929636|                           -0.9948213|               -0.9786561|                   -0.9925300|               -0.9981782|               -0.9871072|               -0.9867679|                   -0.9946068|                   -0.9900851|                   -0.9896864|       -0.9920703|       -0.9851559|       -0.9806445|                       -0.9932283|                               -0.9932761|                   -0.9813454|                       -0.9917441|           4|         13|

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
| 2455 |               0.3017205|              -0.0298761|              -0.1065670|                 -0.5002777|                  0.6606272|                  0.7654996|                   0.1251765|                   0.0504950|                  -0.0697608|       0.1774180|      -0.2711626|       0.5247196|          -0.1683360|          -0.0327235|          -0.1039998|                      -0.8972613|                         -0.8972613|                          -0.9487054|              -0.6871510|                  -0.9378633|              -0.9059050|              -0.8787156|              -0.9065104|                  -0.9383443|                  -0.9355982|                  -0.9593100|      -0.8575189|      -0.9211867|      -0.8269395|                      -0.8555995|                              -0.9434817|                  -0.8303085|                      -0.9056230|               -0.9050675|               -0.8366048|               -0.8916237|                  -0.8621778|                  -0.8593435|                  -0.8605464|                   -0.9447923|                   -0.9373746|                   -0.9646046|       -0.9042467|       -0.9248528|       -0.8394915|           -0.8853194|           -0.9415172|           -0.8902675|                       -0.8433070|                          -0.8433070|                           -0.9462003|               -0.7850362|                   -0.8930616|               -0.9045468|               -0.8269402|               -0.8909612|                   -0.9587094|                   -0.9443203|                   -0.9685581|       -0.9199339|       -0.9276702|       -0.8583834|                       -0.8599096|                               -0.9487714|                   -0.7926148|                       -0.8849179|         12| LAYING            |
| 527  |               0.2699178|              -0.0025826|              -0.1035396|                  0.9604371|                 -0.1343352|                 -0.1249665|                  -0.1186709|                  -0.0355419|                  -0.2588731|      -0.4541855|      -0.0458539|       0.2449933|          -0.1222920|          -0.0839298|          -0.1731438|                      -0.3892937|                         -0.3892937|                          -0.5374111|              -0.2209006|                  -0.7595730|              -0.4024516|              -0.5115419|              -0.5108550|                  -0.4118014|                  -0.6503165|                  -0.6475039|      -0.6133476|      -0.7071846|      -0.4506689|                      -0.4854305|                              -0.4602908|                  -0.6631748|                      -0.8077354|               -0.4462080|               -0.3424346|               -0.4741947|                  -0.9862118|                  -0.9249116|                  -0.9415605|                   -0.4176366|                   -0.6617490|                   -0.6829110|       -0.5116830|       -0.6273362|       -0.1785429|           -0.7370805|           -0.8052172|           -0.6888370|                       -0.4657698|                          -0.4657698|                           -0.4586337|               -0.5935810|                   -0.8136902|               -0.4643141|               -0.3079323|               -0.4948681|                   -0.4779827|                   -0.7017923|                   -0.7169031|       -0.4968234|       -0.5880604|       -0.1823162|                       -0.5374398|                               -0.4561493|                   -0.6173189|                       -0.8347071|          9| WALKING\_UPSTAIRS |
| 1668 |               0.2767809|              -0.0168214|              -0.1102416|                  0.8573662|                  0.1768663|                  0.3549723|                   0.0737889|                   0.0077682|                  -0.0075083|      -0.0278484|      -0.0769962|       0.0848124|          -0.0983182|          -0.0398207|          -0.0536099|                      -0.9970126|                         -0.9970126|                          -0.9954875|              -0.9979430|                  -0.9996422|              -0.9977030|              -0.9934836|              -0.9922404|                  -0.9971050|                  -0.9946327|                  -0.9918301|      -0.9989506|      -0.9984155|      -0.9961466|                      -0.9971965|                              -0.9956514|                  -0.9990454|                      -1.0000000|               -0.9979911|               -0.9933248|               -0.9914458|                  -0.9992713|                  -0.9980371|                  -0.9950126|                   -0.9967286|                   -0.9956422|                   -0.9922739|       -0.9994201|       -0.9982075|       -0.9938371|           -0.9987951|           -0.9990446|           -0.9986307|                       -0.9969688|                          -0.9969688|                           -0.9966697|               -0.9984614|                   -0.9999486|               -0.9980847|               -0.9925339|               -0.9906740|                   -0.9965316|                   -0.9975189|                   -0.9910919|       -0.9996057|       -0.9979955|       -0.9934486|                       -0.9963901|                               -0.9971090|                   -0.9980826|                       -0.9994716|         20| SITTING           |
| 861  |               0.2543829|               0.0093509|              -0.1372200|                  0.8349228|                 -0.4899697|                  0.0369273|                  -0.0456441|                   0.3579859|                   0.1616903|       0.0990950|      -0.2020536|       0.0417315|           0.0079003|          -0.0059439|           0.0650506|                      -0.1193527|                         -0.1193527|                          -0.3176527|              -0.2683536|                  -0.6417704|              -0.2447529|               0.1769420|              -0.3741642|                  -0.2695099|                  -0.0321464|                  -0.5512225|      -0.2806204|      -0.5831385|      -0.3879137|                      -0.1060546|                              -0.2095948|                  -0.4469041|                      -0.6640032|               -0.2787064|                0.2008186|               -0.2671941|                  -0.9589947|                  -0.9521876|                  -0.9541248|                   -0.3200890|                   -0.0840635|                   -0.6269867|       -0.3525910|       -0.4698220|       -0.3004538|           -0.4957346|           -0.7433106|           -0.5033755|                       -0.1768773|                          -0.1768773|                           -0.2562106|               -0.3708043|                   -0.6584107|               -0.2924687|                0.1375113|               -0.2672048|                   -0.4483225|                   -0.2230749|                   -0.7095829|       -0.3782042|       -0.4141656|       -0.3379139|                       -0.3474226|                               -0.3254304|                   -0.4267871|                       -0.6742951|          2| WALKING\_UPSTAIRS |
| 1762 |               0.2622674|              -0.0042715|              -0.0841807|                  0.9006651|                  0.2449375|                  0.1651657|                   0.0771576|                   0.0096363|                  -0.0386546|      -0.0300918|      -0.0751292|       0.0724235|          -0.0978166|          -0.0424670|          -0.0445129|                      -0.9668581|                         -0.9668581|                          -0.9836253|              -0.9869447|                  -0.9921558|              -0.9927905|              -0.9709827|              -0.9578387|                  -0.9916242|                  -0.9759780|                  -0.9802233|      -0.9898582|      -0.9886577|      -0.9806977|                      -0.9690898|                              -0.9865718|                  -0.9904387|                      -0.9937211|               -0.9933010|               -0.9687333|               -0.9489732|                  -0.9821180|                  -0.9697047|                  -0.9281159|                   -0.9922660|                   -0.9760300|                   -0.9822671|       -0.9919592|       -0.9887061|       -0.9824235|           -0.9915404|           -0.9929877|           -0.9884049|                       -0.9591127|                          -0.9591127|                           -0.9878364|               -0.9883162|                   -0.9945149|               -0.9934219|               -0.9684264|               -0.9470189|                   -0.9938192|                   -0.9778178|                   -0.9827480|       -0.9925634|       -0.9887234|       -0.9845308|                       -0.9590347|                               -0.9884802|                   -0.9885942|                       -0.9959270|         24| SITTING           |
| 1505 |               0.2714811|              -0.0298682|              -0.1024048|                  0.9715215|                 -0.1503432|                  0.0649673|                   0.0839940|                   0.0045952|                  -0.0411845|      -0.0459635|      -0.0734530|       0.1066241|          -0.0755424|          -0.0665923|          -0.0615906|                      -0.9614567|                         -0.9614567|                          -0.9760332|              -0.9444827|                  -0.9842501|              -0.9850474|              -0.9605283|              -0.9477042|                  -0.9822835|                  -0.9751292|                  -0.9671717|      -0.9606303|      -0.9619922|      -0.9486222|                      -0.9628371|                              -0.9734753|                  -0.9586511|                      -0.9855528|               -0.9872166|               -0.9490798|               -0.9400756|                  -0.9949440|                  -0.9713688|                  -0.9881410|                   -0.9811666|                   -0.9746018|                   -0.9719413|       -0.9664510|       -0.9589909|       -0.9199215|           -0.9880903|           -0.9839431|           -0.9792523|                       -0.9627332|                          -0.9627332|                           -0.9760812|               -0.9496244|                   -0.9869053|               -0.9881224|               -0.9457950|               -0.9394880|                   -0.9815402|                   -0.9757264|                   -0.9754356|       -0.9682550|       -0.9573924|       -0.9193818|                       -0.9673030|                               -0.9788031|                   -0.9520005|                       -0.9894103|         10| SITTING           |

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
| 6360 |               0.2476659|              -0.0208559|              -0.0968133|                 -0.2283990|                  0.5489160|                  0.8342726|                   0.0581700|                   0.0439087|                  -0.0242813|      -0.0238139|      -0.0403778|       0.0879305|          -0.1000775|          -0.0256362|          -0.0532966|                      -0.9618964|                         -0.9618964|                          -0.9611137|              -0.9642347|                  -0.9703626|              -0.9618667|              -0.9477668|              -0.9584405|                  -0.9663551|                  -0.9638024|                  -0.9533721|      -0.9705180|      -0.9541595|      -0.9749584|                      -0.9603231|                              -0.9629521|                  -0.9610475|                      -0.9688716|               -0.9690489|               -0.9519704|               -0.9668174|                  -0.9795850|                  -0.9841694|                  -0.9798425|                   -0.9660741|                   -0.9648933|                   -0.9592847|       -0.9798701|       -0.9588154|       -0.9772673|           -0.9691080|           -0.9670254|           -0.9811974|                       -0.9651341|                          -0.9651341|                           -0.9659202|               -0.9653835|                   -0.9710776|               -0.9723493|               -0.9563600|               -0.9750439|                   -0.9688116|                   -0.9689188|                   -0.9638590|       -0.9829632|       -0.9622082|       -0.9800524|                       -0.9727526|                               -0.9690155|                   -0.9752947|                       -0.9760948|         28| LAYING       |
| 3408 |               0.2888940|              -0.0175303|              -0.1132295|                  0.9624611|                  0.0833804|                  0.0573365|                   0.0661321|                   0.0251051|                   0.0328883|      -0.1376803|       0.0483152|      -0.0854360|          -0.0539583|          -0.0668774|           0.0099488|                      -0.9804860|                         -0.9804860|                          -0.9900874|              -0.8507357|                  -0.9934044|              -0.9878976|              -0.9758094|              -0.9698497|                  -0.9951795|                  -0.9832021|                  -0.9863909|      -0.9301892|      -0.9659492|      -0.9072399|                      -0.9815142|                              -0.9898473|                  -0.8965971|                      -0.9941407|               -0.9866839|               -0.9783404|               -0.9666769|                  -0.9651247|                  -0.9768322|                  -0.9595002|                   -0.9947660|                   -0.9834715|                   -0.9884353|       -0.9374523|       -0.9617281|       -0.9076056|           -0.9942933|           -0.9927646|           -0.9930752|                       -0.9792702|                          -0.9792702|                           -0.9910148|               -0.8577002|                   -0.9943278|               -0.9860030|               -0.9800890|               -0.9664621|                   -0.9947036|                   -0.9850178|                   -0.9890373|       -0.9398929|       -0.9594487|       -0.9159834|                       -0.9799930|                               -0.9916087|                   -0.8579382|                       -0.9946176|         27| SITTING      |
| 241  |               0.2850814|               0.0028415|              -0.1359852|                  0.9482532|                 -0.2312507|                  0.0598391|                   0.2035628|                  -0.5733624|                   0.1380348|       0.0005464|      -0.1350233|       0.1166554|          -0.3098485|          -0.2807297|          -0.2450063|                      -0.1546169|                         -0.1546169|                          -0.2348386|              -0.1336929|                  -0.4837259|              -0.2694612|               0.3142108|              -0.6018125|                  -0.2725110|                   0.0786613|                  -0.6809516|      -0.1303402|      -0.4119467|      -0.5593128|                      -0.1497668|                              -0.1912401|                  -0.4190550|                      -0.6049939|               -0.2786979|                0.2850188|               -0.5862123|                  -0.9861860|                  -0.9826774|                  -0.9848551|                   -0.2554171|                    0.1250573|                   -0.7143473|       -0.2300987|       -0.2218579|       -0.6288913|           -0.1908750|           -0.6340785|           -0.6406108|                       -0.1577026|                          -0.1577026|                           -0.1665858|               -0.3248931|                   -0.5985356|               -0.2823083|                0.1873764|               -0.6098851|                   -0.3040888|                    0.1003849|                   -0.7465372|       -0.2643457|       -0.1301116|       -0.6886845|                       -0.2929284|                               -0.1417616|                   -0.3773884|                       -0.6182074|         15| WALKING      |
| 1009 |               0.3273166|              -0.0222558|              -0.1491439|                  0.9450276|                 -0.2514783|                 -0.0242460|                   0.3986239|                  -0.3450005|                  -0.1626956|      -0.0455324|      -0.1460064|       0.0068022|           0.0140010|           0.4039911|          -0.4730453|                      -0.0898404|                         -0.0898404|                          -0.1141347|              -0.1230442|                  -0.2497903|              -0.1459075|               0.1165576|              -0.2608198|                  -0.1654680|                  -0.1058541|                  -0.4522239|      -0.2647675|      -0.0068209|      -0.1707880|                      -0.1149254|                              -0.1173148|                  -0.0966429|                      -0.2337810|               -0.2486453|                0.1332291|               -0.1795470|                  -0.9732221|                  -0.9886693|                  -0.9739678|                   -0.0526662|                   -0.0115700|                   -0.4948847|       -0.4221665|       -0.0131677|       -0.2926046|           -0.1223961|           -0.2492311|           -0.3803075|                       -0.2080606|                          -0.2080606|                           -0.1051238|               -0.1249932|                   -0.2511326|               -0.2931295|                0.0704857|               -0.1994268|                   -0.0218322|                    0.0264399|                   -0.5351012|       -0.4721050|       -0.0240133|       -0.4020734|                       -0.3889561|                               -0.0960904|                   -0.3019735|                       -0.3288867|          1| WALKING      |
| 5756 |               0.2721459|              -0.0302937|              -0.0955848|                  0.9645766|                 -0.1406763|                  0.1123622|                   0.0703115|                   0.0141633|                   0.0637379|      -0.0043178|      -0.0374973|       0.1023020|          -0.0763403|          -0.0353817|          -0.0396627|                      -0.9530776|                         -0.9530776|                          -0.9740308|              -0.9429939|                  -0.9779321|              -0.9816391|              -0.9448505|              -0.9365130|                  -0.9775701|                  -0.9557271|                  -0.9808395|      -0.9390179|      -0.9687621|      -0.9555556|                      -0.9634377|                              -0.9717343|                  -0.9465348|                      -0.9848022|               -0.9849858|               -0.9411272|               -0.9229906|                  -0.9975960|                  -0.9695268|                  -0.9764949|                   -0.9768501|                   -0.9575311|                   -0.9839302|       -0.9397282|       -0.9624060|       -0.9557087|           -0.9718035|           -0.9821188|           -0.9770430|                       -0.9512289|                          -0.9512289|                           -0.9754304|               -0.9234900|                   -0.9854210|               -0.9864950|               -0.9418292|               -0.9206232|                   -0.9780759|                   -0.9630939|                   -0.9856956|       -0.9404736|       -0.9590432|       -0.9596309|                       -0.9513349|                               -0.9801102|                   -0.9223569|                       -0.9869782|         19| STANDING     |
| 6382 |               0.2715044|              -0.0188685|              -0.1040372|                 -0.1216074|                  0.6224170|                  0.7585747|                   0.0821187|                   0.0159532|                  -0.0195916|      -0.0251454|      -0.0872812|       0.0829837|          -0.0970642|          -0.0459309|          -0.0537284|                      -0.9602301|                         -0.9602301|                          -0.9953387|              -0.9770670|                  -0.9956268|              -0.9856982|              -0.9812026|              -0.9799476|                  -0.9958987|                  -0.9877361|                  -0.9954890|      -0.9917053|      -0.9859651|      -0.9952350|                      -0.9863436|                              -0.9963415|                  -0.9871535|                      -0.9961208|               -0.9659780|               -0.9700784|               -0.9474079|                  -0.9672914|                  -0.9846553|                  -0.9641733|                   -0.9955765|                   -0.9872916|                   -0.9972374|       -0.9898874|       -0.9675876|       -0.9936004|           -0.9948427|           -0.9948168|           -0.9955526|                       -0.9743501|                          -0.9743501|                           -0.9964929|               -0.9766963|                   -0.9965615|               -0.9600295|               -0.9659210|               -0.9361490|                   -0.9955516|                   -0.9876004|                   -0.9977862|       -0.9894284|       -0.9599875|       -0.9934509|                       -0.9712386|                               -0.9953493|                   -0.9744343|                       -0.9971938|         21| LAYING       |

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
|          3| LAYING              |               0.2755169|              -0.0189557|              -0.1013005|                 -0.2417585|                  0.8370321|                  0.4887032|                   0.0769811|                   0.0138041|                  -0.0043563|      -0.0208171|      -0.0718507|       0.1379996|          -0.1000445|          -0.0389772|          -0.0687339|                      -0.9727913|                         -0.9727913|                          -0.9794846|              -0.9515648|                  -0.9867136|              -0.9806656|              -0.9611700|              -0.9683321|                  -0.9805132|                  -0.9687521|                  -0.9791223|      -0.9701673|      -0.9780997|      -0.9623420|                      -0.9655243|                              -0.9759496|                  -0.9645867|                      -0.9842783|               -0.9827766|               -0.9620575|               -0.9636910|                  -0.9825122|                  -0.9812027|                  -0.9648075|                   -0.9808793|                   -0.9687107|                   -0.9820932|       -0.9745458|       -0.9772727|       -0.9635056|           -0.9803286|           -0.9867627|           -0.9833383|                       -0.9642182|                          -0.9642182|                           -0.9761213|               -0.9542751|                   -0.9831393|               -0.9836911|               -0.9640946|               -0.9632791|                   -0.9831226|                   -0.9710440|                   -0.9837119|       -0.9759864|       -0.9770325|       -0.9672569|                       -0.9683502|                               -0.9753054|                   -0.9554419|                       -0.9825682|
|          4| SITTING             |               0.2715383|              -0.0071631|              -0.1058746|                  0.8693030|                  0.2116225|                  0.1101205|                   0.0784500|                  -0.0108582|                  -0.0121500|      -0.0494435|      -0.0894301|       0.1011503|          -0.0969495|          -0.0418484|          -0.0489964|                      -0.9356948|                         -0.9356948|                          -0.9701323|              -0.9260633|                  -0.9804905|              -0.9774625|              -0.9057829|              -0.9517837|                  -0.9768457|                  -0.9442984|                  -0.9751549|      -0.9605896|      -0.9675836|      -0.9337769|                      -0.9290021|                              -0.9625007|                  -0.9487698|                      -0.9765478|               -0.9803099|               -0.8902240|               -0.9322030|                  -0.9814053|                  -0.9327271|                  -0.9509493|                   -0.9767422|                   -0.9445961|                   -0.9790388|       -0.9701318|       -0.9584681|       -0.9279722|           -0.9698997|           -0.9844414|           -0.9688048|                       -0.9144078|                          -0.9144078|                           -0.9625491|               -0.9288983|                   -0.9758067|               -0.9819082|               -0.8894673|               -0.9269993|                   -0.9787769|                   -0.9492932|                   -0.9816994|       -0.9733331|       -0.9541204|       -0.9328684|                       -0.9198157|                               -0.9615845|                   -0.9288506|                       -0.9762618|
|         10| WALKING             |               0.2785741|              -0.0170224|              -0.1090575|                  0.9630921|                 -0.0838277|                  0.0549276|                   0.0857944|                   0.0040825|                  -0.0162953|       0.0106895|      -0.0819541|       0.0986696|          -0.1227096|          -0.0519205|          -0.0611263|                      -0.1274009|                         -0.1274009|                          -0.1326250|              -0.1564587|                  -0.4403636|              -0.1141900|               0.0533912|              -0.4121827|                  -0.1079411|                   0.0309052|                  -0.4640205|      -0.2779138|      -0.3452090|      -0.1085300|                      -0.0930237|                               0.0205190|                  -0.4126169|                      -0.5150653|               -0.1787097|               -0.0227432|               -0.3956451|                  -0.9744352|                  -0.9711147|                  -0.9578627|                   -0.0521991|                    0.0750805|                   -0.5116629|       -0.4142055|       -0.2508533|       -0.1745249|           -0.3660637|           -0.5096833|           -0.3290795|                       -0.1856024|                          -0.1856024|                            0.0376083|               -0.4020251|                   -0.5010279|               -0.2063665|               -0.1297757|               -0.4353042|                   -0.0791518|                    0.0484868|                   -0.5585127|       -0.4582929|       -0.2043928|       -0.2732929|                       -0.3704719|                                0.0502088|                   -0.4997598|                       -0.5176758|
|         24| WALKING\_DOWNSTAIRS |               0.2886312|              -0.0145730|              -0.1048188|                  0.9508834|                 -0.1283267|                 -0.1401232|                   0.0802620|                  -0.0044732|                  -0.0084692|      -0.0867069|      -0.0542300|       0.1119737|          -0.0914145|          -0.0291766|          -0.0412055|                      -0.0737699|                         -0.0737699|                          -0.2631069|              -0.3049658|                  -0.4971522|              -0.2223243|              -0.0861830|              -0.1738251|                  -0.3761758|                  -0.2258244|                  -0.2500002|      -0.2724692|      -0.4334754|      -0.3962866|                      -0.0231702|                              -0.2008301|                  -0.3742987|                      -0.4744499|               -0.0827325|               -0.1026073|               -0.2055664|                  -0.9618453|                  -0.9414790|                  -0.9422077|                   -0.3372189|                   -0.1692919|                   -0.2902394|       -0.4319191|       -0.4846735|       -0.4910772|           -0.3584446|           -0.5193267|           -0.4786909|                       -0.0224839|                          -0.0224839|                           -0.1435020|               -0.3636949|                   -0.4591599|               -0.0349086|               -0.1691911|               -0.2915538|                   -0.3559306|                   -0.1636268|                   -0.3285700|       -0.4848947|       -0.5234127|       -0.5732819|                       -0.1752917|                               -0.0827555|                   -0.4701473|                       -0.4780305|
|         27| LAYING              |               0.2741025|              -0.0179868|              -0.1076997|                 -0.5304346|                  0.5678795|                  0.8453924|                   0.0766269|                   0.0126491|                  -0.0006855|      -0.0195427|      -0.0957840|       0.1187384|          -0.1011477|          -0.0362186|          -0.0642798|                      -0.9820917|                         -0.9820917|                          -0.9883728|              -0.9669176|                  -0.9943550|              -0.9806318|              -0.9829160|              -0.9873566|                  -0.9866796|                  -0.9852573|                  -0.9880331|      -0.9870285|      -0.9867958|      -0.9792020|                      -0.9813890|                              -0.9880989|                  -0.9798907|                      -0.9935638|               -0.9784552|               -0.9837360|               -0.9866370|                  -0.9711839|                  -0.9937017|                  -0.9890563|                   -0.9864719|                   -0.9851595|                   -0.9896851|       -0.9888372|       -0.9842875|       -0.9783750|           -0.9935037|           -0.9930259|           -0.9932967|                       -0.9789202|                          -0.9789202|                           -0.9885868|               -0.9719157|                   -0.9934843|               -0.9776157|               -0.9842691|               -0.9865824|                   -0.9874775|                   -0.9861160|                   -0.9899012|       -0.9893823|       -0.9830523|       -0.9800964|                       -0.9802963|                               -0.9881749|                   -0.9718062|                       -0.9935523|
|         25| WALKING             |               0.2789928|              -0.0186478|              -0.1087376|                  0.9374831|                 -0.1273159|                  0.1884163|                   0.0721721|                   0.0035112|                  -0.0033510|      -0.0156305|      -0.0820768|       0.0867869|          -0.1023773|          -0.0398987|          -0.0512696|                      -0.4052894|                         -0.4052894|                          -0.5382914|              -0.3943624|                  -0.6784661|              -0.6090389|              -0.2518803|              -0.5335632|                  -0.6255954|                  -0.4344552|                  -0.6592864|      -0.4119097|      -0.6787504|      -0.5613230|                      -0.5660600|                              -0.5645913|                  -0.5627333|                      -0.7703009|               -0.5960074|               -0.1618524|               -0.4371334|                  -0.9794993|                  -0.9650934|                  -0.9449957|                   -0.6076209|                   -0.3826197|                   -0.6756014|       -0.4011588|       -0.6040321|       -0.5627752|           -0.5079571|           -0.7996354|           -0.6595762|                       -0.5656015|                          -0.5656015|                           -0.5428701|               -0.4898094|                   -0.7570325|               -0.5914500|               -0.1703138|               -0.4306246|                   -0.6241457|                   -0.3677601|                   -0.6904134|       -0.4066781|       -0.5672013|       -0.6035442|                       -0.6329275|                               -0.5190042|                   -0.5292622|                       -0.7573858|

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
