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

    ## [1] "fBodyAccMag-std()"                   
    ## [2] "fBodyAcc-bandsEnergy()-33,40"        
    ## [3] "fBodyGyro-bandsEnergy()-49,56"       
    ## [4] "tBodyGyro-iqr()-X"                   
    ## [5] "fBodyGyro-bandsEnergy()-49,56"       
    ## [6] "angle(tBodyAccJerkMean),gravityMean)"

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

    ## [1] "tBodyAcc-arCoeff()-Z,2"          "fBodyAcc-bandsEnergy()-33,48"   
    ## [3] "fBodyBodyGyroJerkMag-kurtosis()" "fBodyGyro-bandsEnergy()-33,48"  
    ## [5] "fBodyAcc-meanFreq()-Y"           "tBodyGyro-min()-Y"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAccJerkMag-mean()"      "tBodyAcc-mean()-Z"          
    ## [3] "tGravityAcc-mean()-X"        "fBodyBodyGyroJerkMag-mean()"
    ## [5] "fBodyBodyGyroMag-mean()"     "tBodyGyroJerk-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyAcc-std()-Z"       "tBodyGyroJerk-std()-Y" 
    ## [3] "tBodyAcc-std()-X"       "fBodyAccMag-std()"     
    ## [5] "tBodyGyro-std()-Y"      "fBodyBodyGyroMag-std()"

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

    ## [1] "tBodyAcc-correlation()-X,Y"   "fBodyAcc-bandsEnergy()-17,24"
    ## [3] "tBodyGyroJerk-max()-Z"        "tBodyAccJerk-max()-Z"        
    ## [5] "fBodyAccJerk-max()-Z"         "tBodyGyroMag-entropy()"

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
| 676  |               0.2835183|              -0.0211301|              -0.1076440|                 -0.7245087|                  0.1809032|                  0.9839674|                   0.0810776|                   0.0051132|                  -0.0086122|      -0.0280990|      -0.0745920|       0.0884707|          -0.0881304|          -0.0398078|          -0.0482682|                      -0.9870619|                         -0.9870619|                          -0.9903864|              -0.9871584|                  -0.9939558|              -0.9884764|              -0.9748454|              -0.9957529|                  -0.9891694|                  -0.9840448|                  -0.9946876|      -0.9836444|      -0.9903544|      -0.9920774|                      -0.9880381|                              -0.9919480|                  -0.9900605|                      -0.9943178|               -0.9871652|               -0.9692889|               -0.9961386|                  -0.9929144|                  -0.9899445|                  -0.9972256|                   -0.9881532|                   -0.9843478|                   -0.9949313|       -0.9877981|       -0.9865405|       -0.9942698|           -0.9907120|           -0.9940408|           -0.9935991|                       -0.9834399|                          -0.9834399|                           -0.9932374|               -0.9897904|                   -0.9944520|               -0.9864449|               -0.9673800|               -0.9958226|                   -0.9880019|                   -0.9858750|                   -0.9935563|       -0.9890789|       -0.9844907|       -0.9957306|                       -0.9822015|                               -0.9941586|                   -0.9911910|                       -0.9945972|           6|          9|
| 1663 |               0.1831296|              -0.1008959|              -0.2203356|                  0.8959637|                 -0.2786997|                 -0.2804386|                  -0.0906078|                   0.0482934|                  -0.0010886|      -0.7612908|       0.3407504|       0.5921680|          -0.0759427|           0.0174063|          -0.3525326|                      -0.1920860|                         -0.1920860|                          -0.5358922|               0.0017555|                  -0.6814349|              -0.4307384|              -0.2653555|              -0.2719259|                  -0.5665426|                  -0.5190051|                  -0.5821002|      -0.5947710|      -0.5010328|      -0.3219479|                      -0.3379293|                              -0.5032848|                  -0.5555370|                      -0.6913388|               -0.4155876|               -0.1400274|               -0.0051547|                  -0.9192355|                  -0.9142783|                  -0.8257948|                   -0.5481234|                   -0.4852218|                   -0.6216942|       -0.6676767|       -0.4724274|       -0.3384028|           -0.6494430|           -0.6921136|           -0.7032785|                       -0.3072304|                          -0.3072304|                           -0.5045269|               -0.5269043|                   -0.7094526|               -0.4096088|               -0.1333218|                0.0484854|                   -0.5687432|                   -0.4820280|                   -0.6596856|       -0.6909203|       -0.4591629|       -0.4042376|                       -0.3978766|                               -0.5087864|                   -0.5883161|                       -0.7566512|           2|         13|
| 1756 |               0.2720878|              -0.0166441|              -0.1097305|                 -0.2794540|                  0.9061715|                  0.3660650|                   0.0774570|                   0.0119164|                   0.0005235|      -0.0267923|      -0.0705781|       0.0895963|          -0.0989370|          -0.0435229|          -0.0532083|                      -0.9952426|                         -0.9952426|                          -0.9881134|              -0.9941414|                  -0.9922850|              -0.9934434|              -0.9887786|              -0.9887926|                  -0.9896908|                  -0.9826263|                  -0.9899020|      -0.9958647|      -0.9903612|      -0.9919997|                      -0.9925896|                              -0.9934858|                  -0.9925561|                      -0.9930385|               -0.9950702|               -0.9933835|               -0.9899823|                  -0.9952267|                  -0.9988469|                  -0.9963088|                   -0.9884931|                   -0.9830874|                   -0.9910023|       -0.9968135|       -0.9913175|       -0.9939915|           -0.9965272|           -0.9880305|           -0.9913490|                       -0.9952973|                          -0.9952973|                           -0.9933051|               -0.9932276|                   -0.9884819|               -0.9958811|               -0.9959496|               -0.9907356|                   -0.9881135|                   -0.9849320|                   -0.9905413|       -0.9970718|       -0.9919637|       -0.9953574|                       -0.9978422|                               -0.9914598|                   -0.9949143|                       -0.9841012|           6|         13|
| 1264 |               0.2431372|              -0.0226621|              -0.0963129|                 -0.3378396|                  0.5408772|                  0.8383687|                   0.0746601|                   0.0139505|                  -0.0379069|      -0.0291337|      -0.0651710|       0.0530756|          -0.0845654|          -0.0634630|          -0.0500639|                      -0.9444906|                         -0.9444906|                          -0.9498568|              -0.9534048|                  -0.9561954|              -0.9552335|              -0.9457289|              -0.9228974|                  -0.9536690|                  -0.9551866|                  -0.9158075|      -0.9518321|      -0.9214720|      -0.9510847|                      -0.9343376|                              -0.9035796|                  -0.9187079|                      -0.9171862|               -0.9590940|               -0.9382344|               -0.9302150|                  -0.9471900|                  -0.9737045|                  -0.9710617|                   -0.9529094|                   -0.9514412|                   -0.9186561|       -0.9690423|       -0.9341375|       -0.9587356|           -0.9531684|           -0.9300896|           -0.9640681|                       -0.9449363|                          -0.9449363|                           -0.9061488|               -0.9226018|                   -0.9153807|               -0.9606061|               -0.9372948|               -0.9400713|                   -0.9562899|                   -0.9503500|                   -0.9196635|       -0.9750041|       -0.9437760|       -0.9652918|                       -0.9598103|                               -0.9086716|                   -0.9392544|                       -0.9183355|           6|         12|
| 1056 |               0.2968412|              -0.0140008|              -0.1308980|                  0.9518329|                  0.0893364|                  0.0800155|                   0.0628014|                  -0.0146888|                   0.0825678|       0.0109735|      -0.2643587|       0.2626260|          -0.0983113|           0.0377037|          -0.0460508|                      -0.9399111|                         -0.9399111|                          -0.9595454|              -0.8413868|                  -0.9487039|              -0.9522432|              -0.9344565|              -0.8774657|                  -0.9336910|                  -0.9604491|                  -0.9333928|      -0.8799075|      -0.8495312|      -0.9459544|                      -0.8854662|                              -0.9274441|                  -0.8529870|                      -0.8644456|               -0.9679692|               -0.9240327|               -0.8518798|                  -0.9726847|                  -0.9546076|                  -0.9012751|                   -0.9384542|                   -0.9634136|                   -0.9457402|       -0.9015936|       -0.8770984|       -0.9402244|           -0.8983624|           -0.9023513|           -0.9661751|                       -0.8670291|                          -0.8670291|                           -0.9135167|               -0.8354658|                   -0.8593012|               -0.9768999|               -0.9226008|               -0.8488107|                   -0.9503312|                   -0.9703323|                   -0.9581223|       -0.9084424|       -0.8985991|       -0.9436697|                       -0.8769736|                               -0.8965171|                   -0.8514638|                       -0.8621875|           5|         10|
| 195  |               0.2843121|              -0.0155943|              -0.0859769|                  0.9341656|                 -0.1555848|                  0.2284247|                   0.0689217|                   0.0278945|                   0.0067182|      -0.1008783|       0.0636533|      -0.2575010|          -0.0727588|          -0.0642440|           0.0418128|                      -0.9756505|                         -0.9756505|                          -0.9847938|              -0.8156089|                  -0.9909613|              -0.9883470|              -0.9753610|              -0.9772256|                  -0.9879213|                  -0.9759749|                  -0.9836119|      -0.9566328|      -0.9702118|      -0.8533468|                      -0.9821476|                              -0.9843264|                  -0.8864309|                      -0.9911224|               -0.9884618|               -0.9807833|               -0.9685127|                  -0.9858694|                  -0.9952632|                  -0.9642791|                   -0.9883827|                   -0.9767252|                   -0.9853329|       -0.9592037|       -0.9679235|       -0.8386752|           -0.9926280|           -0.9906080|           -0.9884007|                       -0.9823422|                          -0.9823422|                           -0.9861043|               -0.8352547|                   -0.9919640|               -0.9883574|               -0.9843764|               -0.9651567|                   -0.9900166|                   -0.9794311|                   -0.9854932|       -0.9601811|       -0.9666783|       -0.8486442|                       -0.9841462|                               -0.9874422|                   -0.8327154|                       -0.9934468|           4|          2|

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
| 569  |               0.2308838|              -0.0251046|              -0.0704130|                  0.9446091|                 -0.2232169|                  0.0889634|                   0.1732879|                   0.4262263|                  -0.1025660|      -0.0173713|      -0.1152326|       0.0794485|           0.0033357|          -0.0825893|          -0.0253899|                      -0.1250508|                         -0.1250508|                          -0.3683802|              -0.3545280|                  -0.6681069|              -0.3914687|               0.0423489|              -0.5526042|                  -0.4354462|                  -0.1240284|                  -0.6843372|      -0.4011019|      -0.6780585|      -0.3649352|                      -0.2509411|                              -0.4171927|                  -0.6204632|                      -0.7165380|               -0.2200752|                0.0165904|               -0.3038586|                  -0.9519635|                  -0.9699222|                  -0.9375745|                   -0.4051825|                   -0.1517080|                   -0.7176334|       -0.4950071|       -0.4773491|       -0.4176922|           -0.4953931|           -0.8515146|           -0.4820395|                       -0.2370042|                          -0.2370042|                           -0.4166795|               -0.6250499|                   -0.7217595|               -0.1619382|               -0.0618841|               -0.2425573|                   -0.4257393|                   -0.2509321|                   -0.7497515|       -0.5254004|       -0.3886421|       -0.4892503|                       -0.3475976|                               -0.4193530|                   -0.6945194|                       -0.7485571|          4| WALKING\_UPSTAIRS |
| 857  |               0.2420004|              -0.0516860|              -0.1161494|                  0.8455690|                 -0.4709459|                  0.0505642|                   0.2512560|                  -0.0998717|                   0.0750639|      -0.1302828|       0.0109074|       0.0061328|          -0.1630474|          -0.1469644|          -0.3248939|                      -0.0617590|                         -0.0617590|                          -0.1769863|              -0.4246624|                  -0.5693916|              -0.0896380|               0.2959684|              -0.3838916|                  -0.1167995|                   0.1925348|                  -0.5689273|      -0.4242715|      -0.5603072|      -0.1865262|                       0.0460840|                               0.0592336|                  -0.4695799|                      -0.6359405|               -0.1611857|                0.2245024|               -0.2349829|                  -0.9165841|                  -0.9204971|                  -0.7762193|                   -0.1402938|                    0.1863075|                   -0.6160971|       -0.5332701|       -0.5566607|       -0.3630968|           -0.4620384|           -0.7016228|           -0.3458217|                       -0.0094479|                          -0.0094479|                            0.0030654|               -0.4811784|                   -0.6286112|               -0.1910624|                0.1061688|               -0.2174102|                   -0.2480928|                    0.0916228|                   -0.6625105|       -0.5679469|       -0.5574999|       -0.4913242|                       -0.1958730|                               -0.0809809|                   -0.5817017|                       -0.6450384|          2| WALKING\_UPSTAIRS |
| 478  |               0.2895594|              -0.0157084|              -0.1326931|                  0.9509734|                 -0.2216738|                  0.0494763|                   0.1667297|                  -0.2370770|                  -0.1354198|      -0.0196990|      -0.1737323|       0.1393721|          -0.3619575|           0.0476513|          -0.4273851|                      -0.1800965|                         -0.1800965|                          -0.1400829|              -0.1928618|                  -0.4178633|              -0.1991660|               0.1646806|              -0.4378767|                  -0.1371152|                   0.1702209|                  -0.4764254|      -0.1329061|      -0.4322663|      -0.0849851|                      -0.0881538|                              -0.0476850|                  -0.4317078|                      -0.5412856|               -0.2675741|                0.0814425|               -0.4190677|                  -0.9696256|                  -0.9938962|                  -0.9442090|                   -0.0835889|                    0.1392331|                   -0.5564582|       -0.3841978|       -0.3355501|       -0.1643727|           -0.2612769|           -0.5283355|           -0.3692701|                       -0.1928587|                          -0.1928587|                            0.0022196|               -0.4134089|                   -0.5248178|               -0.2963132|               -0.0351020|               -0.4545740|                   -0.1083024|                    0.0146486|                   -0.6414809|       -0.4661163|       -0.2868574|       -0.2684414|                       -0.3840114|                                0.0617456|                   -0.5021494|                       -0.5352885|         10| WALKING           |
| 1821 |               0.2772912|              -0.0138104|              -0.1079484|                  0.9626359|                  0.1013486|                 -0.0268257|                   0.0742421|                   0.0080519|                  -0.0161006|      -0.0189293|      -0.0778119|       0.1158218|          -0.0937665|          -0.0409526|          -0.0447069|                      -0.9744957|                         -0.9744957|                          -0.9885108|              -0.9665243|                  -0.9919943|              -0.9922454|              -0.9695373|              -0.9729438|                  -0.9903236|                  -0.9855636|                  -0.9853695|      -0.9897043|      -0.9791137|      -0.9693308|                      -0.9813642|                              -0.9905846|                  -0.9828638|                      -0.9936893|               -0.9942144|               -0.9516921|               -0.9621952|                  -0.9983022|                  -0.9853353|                  -0.9850462|                   -0.9899790|                   -0.9859242|                   -0.9879184|       -0.9907541|       -0.9674473|       -0.9569761|           -0.9936490|           -0.9913715|           -0.9897260|                       -0.9751798|                          -0.9751798|                           -0.9916236|               -0.9729467|                   -0.9939832|               -0.9952048|               -0.9459234|               -0.9583136|                   -0.9904398|                   -0.9874266|                   -0.9891249|       -0.9910209|       -0.9618893|       -0.9571529|                       -0.9744320|                               -0.9918088|                   -0.9713712|                       -0.9944775|         24| SITTING           |
| 223  |               0.2852635|              -0.0155948|              -0.1502642|                  0.9332457|                 -0.3116623|                  0.0226050|                   0.0135992|                   0.1042240|                   0.2457517|      -0.0501873|      -0.0282207|       0.0462445|          -0.4654554|           0.1984048|          -0.0872498|                      -0.0090483|                         -0.0090483|                          -0.0153911|              -0.1570292|                  -0.3145903|              -0.2633525|               0.2880884|              -0.3748264|                  -0.2240835|                   0.1278706|                  -0.4061249|       0.1017787|      -0.3802368|      -0.2315047|                      -0.1023737|                              -0.0591952|                  -0.3236201|                      -0.5677882|               -0.2369355|                0.5238304|               -0.3787497|                  -0.9762320|                  -0.9832691|                  -0.9861967|                   -0.0266320|                    0.2783625|                   -0.4528983|       -0.1717187|       -0.3938970|       -0.3730360|            0.0658488|           -0.5993152|           -0.2323900|                       -0.1276794|                          -0.1276794|                            0.0255329|               -0.2549312|                   -0.4778761|               -0.2267037|                0.5406163|               -0.4315290|                    0.0742435|                    0.3564757|                   -0.4971648|       -0.2590303|       -0.4066986|       -0.4845082|                       -0.2775531|                                0.1172723|                   -0.3355222|                       -0.4128736|         13| WALKING           |
| 2467 |               0.2724897|              -0.0180074|              -0.1063990|                 -0.4312918|                  0.9618238|                  0.2132356|                   0.0762851|                   0.0155261|                  -0.0026870|      -0.0274320|      -0.0726719|       0.0879921|          -0.0960919|          -0.0521624|          -0.0529185|                      -0.9960276|                         -0.9960276|                          -0.9933474|              -0.9828300|                  -0.9971022|              -0.9953109|              -0.9896896|              -0.9936547|                  -0.9954911|                  -0.9887638|                  -0.9919491|      -0.9951118|      -0.9830167|      -0.9959224|                      -0.9961047|                              -0.9939732|                  -0.9883868|                      -0.9963562|               -0.9952474|               -0.9922954|               -0.9932534|                  -0.9957112|                  -0.9970527|                  -0.9973117|                   -0.9942797|                   -0.9871998|                   -0.9929688|       -0.9957173|       -0.9719105|       -0.9961303|           -0.9970646|           -0.9952555|           -0.9977494|                       -0.9966945|                          -0.9966945|                           -0.9933870|               -0.9792791|                   -0.9965546|               -0.9950975|               -0.9933013|               -0.9926015|                   -0.9933681|                   -0.9861375|                   -0.9924479|       -0.9958382|       -0.9666987|       -0.9964743|                       -0.9968921|                               -0.9909925|                   -0.9772748|                       -0.9967455|          4| LAYING            |

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
| 257  |               0.2789302|              -0.0020861|              -0.0758552|                  0.9635336|                 -0.1378169|                  0.0821962|                   0.3198793|                  -0.2096986|                   0.1566502|       0.2259355|      -0.1791981|       0.1597623|          -0.3277383|           0.1763129|          -0.0290447|                      -0.4336980|                         -0.4336980|                          -0.5839746|              -0.4132708|                  -0.6973585|              -0.5983107|              -0.2308772|              -0.5544223|                  -0.6539868|                  -0.4584752|                  -0.6690210|      -0.3335998|      -0.6586488|      -0.5998086|                      -0.5147996|                              -0.5782308|                  -0.5102129|                      -0.7710115|               -0.6241622|               -0.1581763|               -0.4514942|                  -0.9856210|                  -0.9438437|                  -0.9189904|                   -0.6758200|                   -0.3982124|                   -0.6936111|       -0.4731960|       -0.6231021|       -0.5906378|           -0.5042165|           -0.8302464|           -0.6948488|                       -0.5316030|                          -0.5316030|                           -0.5633218|               -0.4722304|                   -0.7678317|               -0.6346869|               -0.1742390|               -0.4402220|                   -0.7336214|                   -0.3720801|                   -0.7159487|       -0.5174530|       -0.6052225|       -0.6249509|                       -0.6135696|                               -0.5466553|                   -0.5365065|                       -0.7794069|         25| WALKING             |
| 2326 |               0.3357857|              -0.0542982|              -0.1189268|                  0.9264516|                 -0.1094479|                 -0.1881873|                   0.5277071|                   0.3940574|                   0.8203675|       0.0074658|      -0.0839397|       0.0027909|           0.3256257|           0.4382381|          -0.1467332|                       0.2549472|                          0.2549472|                           0.2253952|               0.0489913|                   0.0024981|               0.4615960|               0.2936106|               0.2706143|                   0.4709538|                   0.1341240|                   0.1765037|      -0.1607274|       0.5043538|      -0.0781654|                       0.5735309|                               0.5369477|                   0.3167743|                       0.2841502|                0.2143981|                0.2901671|                0.1958900|                  -0.9561818|                  -0.9581670|                  -0.9502554|                    0.4266123|                    0.0230926|                   -0.0024560|       -0.3927021|        0.3084154|       -0.1800405|           -0.3189646|            0.2766864|           -0.3348861|                        0.3884615|                           0.3884615|                            0.4614321|                0.1926921|                    0.2500638|                0.1020093|                0.2063890|                0.0490646|                    0.2410341|                   -0.2167029|                   -0.1943980|       -0.4677058|        0.1616704|       -0.2913017|                        0.0558444|                                0.3499631|                   -0.1267850|                        0.1125284|         23| WALKING\_DOWNSTAIRS |
| 1279 |               0.2101162|              -0.0736089|              -0.2365494|                  0.8842729|                 -0.1385064|                 -0.3760978|                   0.2149361|                  -0.5861066|                  -0.3773131|      -0.6950591|       0.0904038|       0.6818313|          -0.0928695|           0.0949122|           0.0034623|                       0.0939355|                          0.0939355|                          -0.2755530|               0.0018296|                  -0.5798746|              -0.0749192|               0.0178546|              -0.1977050|                  -0.2859343|                  -0.3691395|                  -0.5558356|      -0.5308383|      -0.3375932|      -0.3272477|                      -0.1061200|                              -0.2830520|                  -0.4474679|                      -0.4979292|                0.0134985|               -0.0100806|               -0.0040186|                  -0.9053409|                  -0.9042387|                  -0.8459686|                   -0.2134676|                   -0.3160916|                   -0.5706428|       -0.5785388|       -0.3460190|       -0.2840702|           -0.6453833|           -0.5253677|           -0.5548205|                       -0.0478918|                          -0.0478918|                           -0.3476029|               -0.3777508|                   -0.5211548|                0.0463226|               -0.0880283|                0.0183534|                   -0.2079146|                   -0.3028848|                   -0.5829645|       -0.5953973|       -0.3558941|       -0.3358144|                       -0.1647192|                               -0.4450072|                   -0.4368684|                       -0.5871295|         17| WALKING\_UPSTAIRS   |
| 5162 |               0.2661630|              -0.0218193|              -0.1181808|                  0.8273239|                 -0.2231318|                 -0.4305466|                   0.0847775|                   0.0241833|                   0.0377981|      -0.0244516|      -0.0699724|       0.0790195|          -0.0740791|          -0.0661761|          -0.0424639|                      -0.9643526|                         -0.9643526|                          -0.9805523|              -0.9599192|                  -0.9835675|              -0.9794334|              -0.9418805|              -0.9646244|                  -0.9819068|                  -0.9647681|                  -0.9813313|      -0.9488614|      -0.9661431|      -0.9643020|                      -0.9628366|                              -0.9790264|                  -0.9553109|                      -0.9826369|               -0.9787801|               -0.9292062|               -0.9577201|                  -0.9846776|                  -0.9849689|                  -0.9681175|                   -0.9829115|                   -0.9640504|                   -0.9858540|       -0.9559406|       -0.9661719|       -0.9663460|           -0.9766520|           -0.9826220|           -0.9798329|                       -0.9495276|                          -0.9495276|                           -0.9767435|               -0.9472859|                   -0.9786801|               -0.9783301|               -0.9264904|               -0.9561174|                   -0.9857473|                   -0.9656921|                   -0.9896306|       -0.9581776|       -0.9663271|       -0.9699860|                       -0.9494107|                               -0.9721837|                   -0.9506520|                       -0.9750902|         14| STANDING            |
| 4289 |               0.2697761|              -0.0140465|              -0.1134388|                  0.1760677|                  0.6001030|                  0.6686399|                   0.0693017|                   0.0058647|                   0.0080751|      -0.0270942|      -0.0500494|       0.0673566|          -0.0962861|          -0.0466305|          -0.0531680|                      -0.9798205|                         -0.9798205|                          -0.9828662|              -0.9648113|                  -0.9825970|              -0.9729993|              -0.9726770|              -0.9854783|                  -0.9774271|                  -0.9786320|                  -0.9859857|      -0.9843255|      -0.9551945|      -0.9722859|                      -0.9727057|                              -0.9784199|                  -0.9513833|                      -0.9779660|               -0.9740376|               -0.9677832|               -0.9856132|                  -0.9949008|                  -0.9948031|                  -0.9886518|                   -0.9767814|                   -0.9764204|                   -0.9883977|       -0.9865172|       -0.9390905|       -0.9747335|           -0.9858077|           -0.9756856|           -0.9807204|                       -0.9666120|                          -0.9666120|                           -0.9780948|               -0.9313996|                   -0.9737748|               -0.9743106|               -0.9662632|               -0.9859460|                   -0.9781008|                   -0.9753606|                   -0.9894515|       -0.9871456|       -0.9311657|       -0.9777921|                       -0.9672336|                               -0.9761319|                   -0.9306585|                       -0.9700349|         19| SITTING             |
| 4025 |               0.2522469|              -0.0043403|              -0.0983133|                  0.8866726|                  0.2206443|                  0.2351125|                   0.0859081|                   0.0047887|                   0.0324168|      -0.0024288|      -0.1576198|       0.3052855|          -0.1076209|          -0.0356350|          -0.0818911|                      -0.9670556|                         -0.9670556|                          -0.9923850|              -0.8927175|                  -0.9923028|              -0.9897423|              -0.9891019|              -0.9622315|                  -0.9954636|                  -0.9893942|                  -0.9873619|      -0.9837543|      -0.9865076|      -0.9585309|                      -0.9711989|                              -0.9917931|                  -0.9669510|                      -0.9946359|               -0.9882259|               -0.9915329|               -0.9420088|                  -0.9651574|                  -0.9832781|                  -0.9154463|                   -0.9951936|                   -0.9888448|                   -0.9896659|       -0.9874344|       -0.9835099|       -0.9464875|           -0.9900603|           -0.9923126|           -0.9942852|                       -0.9676777|                          -0.9676777|                           -0.9926536|               -0.9432675|                   -0.9950228|               -0.9874223|               -0.9924549|               -0.9352564|                   -0.9952683|                   -0.9889036|                   -0.9906242|       -0.9885433|       -0.9818294|       -0.9476191|                       -0.9694880|                               -0.9927320|                   -0.9394298|                       -0.9955641|          6| SITTING             |

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
|         15| WALKING\_UPSTAIRS   |               0.2701876|              -0.0287524|              -0.1169525|                  0.9185448|                 -0.3149610|                  0.0811803|                   0.0729724|                  -0.0041736|                  -0.0052588|       0.0903340|      -0.1547213|       0.0911681|          -0.1444860|          -0.0365419|          -0.0767242|                      -0.0009714|                         -0.0009714|                          -0.3160504|              -0.2012173|                  -0.6636371|              -0.0746328|              -0.1019354|              -0.5395911|                  -0.2370531|                  -0.3381022|                  -0.7145542|      -0.3610969|      -0.5170252|      -0.4857017|                      -0.1652421|                              -0.2619567|                  -0.4536936|                      -0.7314224|               -0.0260972|               -0.0040654|               -0.3797175|                  -0.9525624|                  -0.9276488|                  -0.9216185|                   -0.1869447|                   -0.3118614|                   -0.7488095|       -0.4152513|       -0.3302332|       -0.4773659|           -0.5255339|           -0.7630535|           -0.6579076|                       -0.1365522|                          -0.1365522|                           -0.3133636|               -0.2884290|                   -0.7489548|               -0.0083824|               -0.0191328|               -0.3496004|                   -0.2072316|                   -0.3303914|                   -0.7830045|       -0.4372253|       -0.2436123|       -0.5237443|                       -0.2556593|                               -0.3913134|                   -0.3085859|                       -0.7931045|
|         26| WALKING\_DOWNSTAIRS |               0.2792846|              -0.0126258|              -0.1064396|                  0.9467973|                 -0.0799004|                  0.1539063|                   0.1114708|                  -0.0071316|                  -0.0118911|      -0.0107522|      -0.1003822|       0.0822214|          -0.0992465|          -0.0372681|          -0.0510587|                       0.1143794|                          0.1143794|                          -0.1488563|              -0.2353146|                  -0.4187798|               0.0228001|              -0.0062370|              -0.2796401|                  -0.2013681|                  -0.1655524|                  -0.3601146|      -0.1259182|      -0.4431262|      -0.2213888|                       0.0751017|                              -0.1531720|                  -0.3345099|                      -0.4722008|                0.1739538|               -0.0116299|               -0.2848077|                  -0.9627220|                  -0.9354259|                  -0.9330818|                   -0.1281116|                   -0.0864049|                   -0.3793360|       -0.3313129|       -0.4734081|       -0.3320502|           -0.1708427|           -0.5471984|           -0.3589516|                        0.1470017|                           0.1470017|                           -0.1113040|               -0.2961583|                   -0.4631408|                0.2267838|               -0.0782838|               -0.3466485|                   -0.1308259|                   -0.0615371|                   -0.3967017|       -0.3981999|       -0.4975063|       -0.4344822|                        0.0057494|                               -0.0679411|                   -0.3929907|                       -0.4894974|
|         20| WALKING\_DOWNSTAIRS |               0.2961444|              -0.0096412|              -0.1046029|                  0.9197266|                 -0.2774197|                 -0.0282592|                   0.0695031|                   0.0043645|                  -0.0025348|      -0.1113677|       0.0139023|       0.1039005|          -0.0452503|          -0.0577372|          -0.0615313|                       0.2218516|                          0.2218516|                          -0.0612700|               0.0938419|                  -0.2681834|              -0.0343310|               0.5241877|              -0.1880988|                  -0.1993604|                   0.2058290|                  -0.3562202|      -0.0629573|      -0.1380979|       0.2570378|                       0.1518877|                               0.0137917|                  -0.1005661|                      -0.3116685|                0.0745099|                0.6169370|               -0.1609385|                  -0.9404581|                  -0.9085772|                  -0.9196935|                   -0.1356996|                    0.2896710|                   -0.3815034|       -0.2049396|       -0.1467942|        0.1597235|           -0.2492351|           -0.3345688|            0.0030785|                        0.1726364|                           0.1726364|                            0.0467186|               -0.0305762|                   -0.2755919|                0.1130334|                0.5601913|               -0.2139168|                   -0.1472786|                    0.2931195|                   -0.4052949|       -0.2533656|       -0.1599614|        0.0183051|                        0.0002422|                                0.0790380|                   -0.1516820|                       -0.2816573|
|         24| WALKING\_DOWNSTAIRS |               0.2886312|              -0.0145730|              -0.1048188|                  0.9508834|                 -0.1283267|                 -0.1401232|                   0.0802620|                  -0.0044732|                  -0.0084692|      -0.0867069|      -0.0542300|       0.1119737|          -0.0914145|          -0.0291766|          -0.0412055|                      -0.0737699|                         -0.0737699|                          -0.2631069|              -0.3049658|                  -0.4971522|              -0.2223243|              -0.0861830|              -0.1738251|                  -0.3761758|                  -0.2258244|                  -0.2500002|      -0.2724692|      -0.4334754|      -0.3962866|                      -0.0231702|                              -0.2008301|                  -0.3742987|                      -0.4744499|               -0.0827325|               -0.1026073|               -0.2055664|                  -0.9618453|                  -0.9414790|                  -0.9422077|                   -0.3372189|                   -0.1692919|                   -0.2902394|       -0.4319191|       -0.4846735|       -0.4910772|           -0.3584446|           -0.5193267|           -0.4786909|                       -0.0224839|                          -0.0224839|                           -0.1435020|               -0.3636949|                   -0.4591599|               -0.0349086|               -0.1691911|               -0.2915538|                   -0.3559306|                   -0.1636268|                   -0.3285700|       -0.4848947|       -0.5234127|       -0.5732819|                       -0.1752917|                               -0.0827555|                   -0.4701473|                       -0.4780305|
|         18| WALKING\_DOWNSTAIRS |               0.2884395|              -0.0168667|              -0.1033908|                  0.9322775|                 -0.2258091|                 -0.0493637|                   0.0809044|                  -0.0007571|                  -0.0141770|      -0.0576549|      -0.0636214|       0.0987472|          -0.0836567|          -0.0509120|          -0.0570592|                      -0.2935320|                         -0.2935320|                          -0.4665160|              -0.3810228|                  -0.7016631|              -0.3500868|              -0.3090496|              -0.5058244|                  -0.4127283|                  -0.4659827|                  -0.6221359|      -0.4892323|      -0.6415276|      -0.4470307|                      -0.2419735|                              -0.3833987|                  -0.6047354|                      -0.7442360|               -0.3026346|               -0.2542140|               -0.4186101|                  -0.9604049|                  -0.9329622|                  -0.9216617|                   -0.3872239|                   -0.4470339|                   -0.6512467|       -0.5024730|       -0.6172308|       -0.4836583|           -0.6767162|           -0.7526086|           -0.6056554|                       -0.2299342|                          -0.2299342|                           -0.3825173|               -0.5079955|                   -0.7441595|               -0.2855359|               -0.2737982|               -0.4182586|                   -0.4160505|                   -0.4645461|                   -0.6787511|       -0.5139471|       -0.6077580|       -0.5439961|                       -0.3442994|                               -0.3865651|                   -0.5338449|                       -0.7634308|
|          3| SITTING             |               0.2571976|              -0.0035030|              -0.0983579|                  0.9010990|                  0.1273034|                  0.1390206|                   0.0726098|                   0.0027253|                  -0.0042335|      -0.0385365|      -0.0752410|       0.0940114|          -0.1036059|          -0.0360910|          -0.0590080|                      -0.8953834|                         -0.8953834|                          -0.9690808|              -0.9193544|                  -0.9779981|              -0.9701544|              -0.8919078|              -0.9179879|                  -0.9749504|                  -0.9541702|                  -0.9708457|      -0.9575506|      -0.9561736|      -0.9349680|                      -0.9041857|                              -0.9658889|                  -0.9466649|                      -0.9778981|               -0.9710101|               -0.8566178|               -0.8751102|                  -0.9573245|                  -0.9039230|                  -0.8977363|                   -0.9744674|                   -0.9536314|                   -0.9746616|       -0.9654348|       -0.9448546|       -0.9264137|           -0.9725469|           -0.9786359|           -0.9737517|                       -0.8703017|                          -0.8703017|                           -0.9665501|               -0.9255181|                   -0.9767727|               -0.9716059|               -0.8496557|               -0.8643225|                   -0.9762835|                   -0.9564618|                   -0.9771596|       -0.9680131|       -0.9396100|       -0.9306332|                       -0.8746266|                               -0.9665689|                   -0.9254496|                       -0.9766898|

Saving the Resulting Data to Disk
---------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
dir.create("./tidy_data")
```

    ## Warning in dir.create("./tidy_data"): './tidy_data' already exists

``` r
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
