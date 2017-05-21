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

    ## [1] "tBodyAccJerk-arCoeff()-Z,3"    "fBodyGyro-bandsEnergy()-17,24"
    ## [3] "fBodyGyro-mad()-Z"             "tBodyGyroMag-energy()"        
    ## [5] "tBodyGyro-arCoeff()-Z,1"       "fBodyAcc-bandsEnergy()-9,16"

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

    ## [1] "tBodyAcc-arCoeff()-X,4"       "fBodyBodyGyroJerkMag-mean()" 
    ## [3] "fBodyGyro-min()-X"            "fBodyAcc-bandsEnergy()-33,40"
    ## [5] "tBodyAcc-arCoeff()-Y,2"       "tBodyAcc-correlation()-X,Z"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyAccJerk-mean()-Z"      "fBodyGyro-mean()-Z"        
    ## [3] "fBodyBodyAccJerkMag-mean()" "tBodyAccJerkMag-mean()"    
    ## [5] "tBodyGyroJerk-mean()-Z"     "fBodyAcc-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyGyro-std()-Y"     "fBodyAcc-std()-Y"      "tBodyGyroJerk-std()-Y"
    ## [4] "tGravityAccMag-std()"  "fBodyAcc-std()-Z"      "tGravityAcc-std()-Z"

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

    ## [1] "fBodyAcc-bandsEnergy()-9,16"      "tGravityAccMag-std()"            
    ## [3] "fBodyBodyGyroJerkMag-iqr()"       "fBodyAcc-mean()-Z"               
    ## [5] "fBodyAccJerk-bandsEnergy()-33,40" "fBodyGyro-bandsEnergy()-41,48"

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
| 1800 |               0.2790426|              -0.0223463|              -0.0801960|                  0.9308765|                 -0.3040459|                  0.0386596|                   0.1845306|                  -0.1846893|                  -0.0896313|      -0.0824411|      -0.0002027|       0.1207866|           0.0035072|          -0.0547013|          -0.3296653|                      -0.1811684|                         -0.1811684|                          -0.1544094|              -0.2616986|                  -0.3824563|              -0.3606133|               0.1514448|              -0.3810151|                  -0.3022007|                   0.0643014|                  -0.4238562|      -0.1533415|      -0.4505685|      -0.1941172|                      -0.2768418|                              -0.1640774|                  -0.4011435|                      -0.5112759|               -0.3767756|                0.2500440|               -0.4178860|                  -0.9932808|                  -0.9815960|                  -0.9760492|                   -0.2353135|                    0.2049635|                   -0.4907575|       -0.3142817|       -0.4649870|       -0.3673589|           -0.1753145|           -0.5975798|           -0.1684021|                       -0.2661948|                          -0.2661948|                           -0.0827290|               -0.3842882|                   -0.5315993|               -0.3831816|                0.2211415|               -0.4892791|                   -0.2334021|                    0.2774315|                   -0.5578532|       -0.3655037|       -0.4778585|       -0.4937663|                       -0.3739987|                                0.0056772|                   -0.4792788|                       -0.5929327|           1|         13|
| 2729 |               0.3412230|              -0.0379408|              -0.1010512|                  0.9011974|                 -0.2369581|                 -0.2354703|                  -0.3679330|                   0.1206822|                   0.0944008|       0.1221011|      -0.1121452|      -0.0248391|          -0.2576044|           0.0258400|          -0.0882601|                      -0.2495434|                         -0.2495434|                          -0.5150678|              -0.3980148|                  -0.6649554|              -0.3128862|              -0.2294574|              -0.3506014|                  -0.5328113|                  -0.5295740|                  -0.4766599|      -0.5001541|      -0.5931212|      -0.2874928|                      -0.3149924|                              -0.3996781|                  -0.5995134|                      -0.6588708|               -0.3628063|               -0.1024323|               -0.2983985|                  -0.9642893|                  -0.9452964|                  -0.9632560|                   -0.5580152|                   -0.4983761|                   -0.5211507|       -0.5607978|       -0.6216818|       -0.2156398|           -0.6419061|           -0.6789338|           -0.5723126|                       -0.3149480|                          -0.3149480|                           -0.4556215|               -0.5457533|                   -0.6538970|               -0.3834690|               -0.0971276|               -0.3246242|                   -0.6306822|                   -0.4971868|                   -0.5635364|       -0.5813036|       -0.6431262|       -0.2650957|                       -0.4210586|                               -0.5372421|                   -0.5869792|                       -0.6711016|           2|         24|
| 846  |               0.2693514|              -0.0242542|              -0.1073132|                  0.9291785|                  0.0273128|                 -0.2425354|                   0.3047075|                   0.1585179|                   0.3435465|       0.0730921|       0.0225546|       0.0601797|           0.0193085|          -0.0279181|          -0.3476971|                      -0.0131450|                         -0.0131450|                          -0.0646429|              -0.2491474|                  -0.3479747|              -0.2935625|              -0.2399761|              -0.1250338|                  -0.2743613|                  -0.2471657|                  -0.3065781|      -0.3152675|      -0.2438457|      -0.1275712|                      -0.1598287|                              -0.2316786|                  -0.4007610|                      -0.4855529|               -0.1908847|               -0.1098470|                0.1160483|                  -0.9806938|                  -0.9817378|                  -0.9799866|                   -0.0777268|                   -0.1119761|                   -0.3319050|       -0.5266641|       -0.2788956|       -0.2124086|           -0.3297742|           -0.3811488|           -0.4092469|                       -0.2777305|                          -0.2777305|                           -0.2217519|               -0.4048087|                   -0.4701575|               -0.1537281|               -0.1027747|                0.1516209|                    0.0252756|                   -0.0278935|                   -0.3542661|       -0.5965715|       -0.3065579|       -0.3142589|                       -0.4660305|                               -0.2128221|                   -0.5123711|                       -0.4873757|           1|          9|
| 2616 |               0.2785586|              -0.0157694|              -0.1082855|                  0.8834584|                  0.2684290|                  0.1937889|                   0.0770079|                   0.0123375|                  -0.0047985|      -0.0290221|      -0.0762091|       0.0797432|          -0.0986494|          -0.0373511|          -0.0483317|                      -0.9885048|                         -0.9885048|                          -0.9851443|              -0.9909930|                  -0.9922250|              -0.9890282|              -0.9818504|              -0.9798703|                  -0.9837689|                  -0.9852513|                  -0.9803874|      -0.9951118|      -0.9864326|      -0.9867444|                      -0.9859173|                              -0.9808075|                  -0.9896962|                      -0.9904332|               -0.9918227|               -0.9818615|               -0.9809239|                  -0.9996979|                  -0.9986912|                  -0.9989261|                   -0.9826103|                   -0.9851615|                   -0.9839886|       -0.9957433|       -0.9882072|       -0.9888699|           -0.9959136|           -0.9892568|           -0.9894497|                       -0.9891161|                          -0.9891161|                           -0.9827018|               -0.9897813|                   -0.9899230|               -0.9932309|               -0.9819018|               -0.9822761|                   -0.9828078|                   -0.9860958|                   -0.9864022|       -0.9958732|       -0.9894776|       -0.9906307|                       -0.9925036|                               -0.9843345|                   -0.9914882|                       -0.9894594|           4|         24|
| 223  |               0.2732604|              -0.0164961|              -0.1146947|                 -0.3258388|                  0.7859078|                  0.5948957|                   0.0769178|                   0.0069207|                   0.0057588|      -0.0270870|      -0.0797247|       0.0786857|          -0.0962745|          -0.0433368|          -0.0566219|                      -0.9933976|                         -0.9933976|                          -0.9920717|              -0.9918946|                  -0.9955601|              -0.9943440|              -0.9884026|              -0.9884738|                  -0.9942566|                  -0.9883570|                  -0.9868434|      -0.9941385|      -0.9921911|      -0.9919337|                      -0.9923981|                              -0.9909448|                  -0.9938210|                      -0.9961249|               -0.9953399|               -0.9867930|               -0.9907730|                  -0.9945633|                  -0.9948486|                  -0.9916168|                   -0.9945521|                   -0.9883370|                   -0.9889613|       -0.9951488|       -0.9904977|       -0.9930853|           -0.9958937|           -0.9949737|           -0.9935655|                       -0.9935858|                          -0.9935858|                           -0.9911720|               -0.9940290|                   -0.9965987|               -0.9957699|               -0.9856630|               -0.9923434|                   -0.9954261|                   -0.9891363|                   -0.9896669|       -0.9954034|       -0.9894752|       -0.9940883|                       -0.9946250|                               -0.9899038|                   -0.9951234|                       -0.9973030|           6|          2|
| 1992 |               0.2228723|              -0.0053261|              -0.0722156|                  0.9129746|                 -0.3215332|                  0.0658260|                   0.3839854|                  -0.1065779|                  -0.0915663|       0.1688983|      -0.2189712|       0.0954531|          -0.0521197|          -0.2931772|           0.0501274|                      -0.2874659|                         -0.2874659|                          -0.6089879|              -0.4563934|                  -0.7884994|              -0.4414964|              -0.3811452|              -0.6727382|                  -0.6004187|                  -0.5375235|                  -0.8423898|      -0.6463908|      -0.6376371|      -0.5940187|                      -0.4195141|                              -0.5915414|                  -0.6654832|                      -0.8444126|               -0.3537235|               -0.2503653|               -0.3653671|                  -0.9753036|                  -0.9537652|                  -0.9112435|                   -0.5650558|                   -0.5321825|                   -0.8439302|       -0.7019884|       -0.4362338|       -0.5936486|           -0.7221066|           -0.8681193|           -0.7105309|                       -0.3659147|                          -0.3659147|                           -0.5968675|               -0.5473398|                   -0.8519761|               -0.3220617|               -0.2352448|               -0.2844696|                   -0.5665373|                   -0.5593851|                   -0.8436957|       -0.7199388|       -0.3455614|       -0.6305332|                       -0.4357852|                               -0.6056183|                   -0.5519946|                       -0.8732646|           2|         18|

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
| 2273 |               0.3046379|              -0.0133764|               0.0250007|                  0.9518661|                 -0.2269822|                 -0.0187961|                   0.0625491|                   0.0301262|                  -0.0325106|      -0.0788503|      -0.0074339|       0.0309315|          -0.0763575|          -0.0333500|          -0.0523908|                      -0.8529565|                         -0.8529565|                          -0.9379855|              -0.8679096|                  -0.9252224|              -0.9512908|              -0.8853719|              -0.9169666|                  -0.9315033|                  -0.9169311|                  -0.9600222|      -0.8727768|      -0.9060834|      -0.9179338|                      -0.9033486|                              -0.9225312|                  -0.8915897|                      -0.9147794|               -0.9656995|               -0.8714512|               -0.8341251|                  -0.9726336|                  -0.9652582|                  -0.7490491|                   -0.9305325|                   -0.9121464|                   -0.9663929|       -0.8813550|       -0.9197843|       -0.9183824|           -0.9145149|           -0.9201518|           -0.9463173|                       -0.8554442|                          -0.8554442|                           -0.9258374|               -0.8905355|                   -0.9221560|               -0.9734300|               -0.8715718|               -0.8102001|                   -0.9357272|                   -0.9125894|                   -0.9717271|       -0.8847443|       -0.9301000|       -0.9258156|                       -0.8551312|                               -0.9293314|                   -0.9087241|                       -0.9382879|         12| STANDING          |
| 2323 |               0.2774377|              -0.0188126|              -0.1156528|                  0.9493416|                 -0.1968013|                  0.1484009|                   0.0732640|                   0.0273151|                   0.0209506|      -0.0231647|      -0.0796841|       0.0713333|          -0.1034357|          -0.0416805|          -0.0523308|                      -0.9910859|                         -0.9910859|                          -0.9932905|              -0.9877613|                  -0.9969652|              -0.9977196|              -0.9845937|              -0.9812645|                  -0.9970731|                  -0.9891364|                  -0.9887581|      -0.9890316|      -0.9922752|      -0.9962867|                      -0.9891745|                              -0.9930425|                  -0.9934742|                      -0.9982933|               -0.9981620|               -0.9854474|               -0.9819132|                  -0.9973128|                  -0.9934373|                  -0.9760894|                   -0.9968216|                   -0.9899626|                   -0.9899086|       -0.9905429|       -0.9891312|       -0.9959108|           -0.9946253|           -0.9967250|           -0.9980111|                       -0.9894897|                          -0.9894897|                           -0.9933192|               -0.9919094|                   -0.9982712|               -0.9983575|               -0.9857316|               -0.9828959|                   -0.9967703|                   -0.9918742|                   -0.9894876|       -0.9909505|       -0.9874038|       -0.9960202|                       -0.9903089|                               -0.9920878|                   -0.9919540|                       -0.9979826|         20| STANDING          |
| 442  |               0.3444790|              -0.0283079|              -0.1009581|                  0.9643557|                 -0.1978858|                  0.0420714|                  -0.1455693|                  -0.2632373|                  -0.1415703|      -0.0056037|      -0.0924668|       0.1267844|           0.0328612|          -0.0460629|           0.0135620|                      -0.0954764|                         -0.0954764|                          -0.0040449|              -0.1473750|                  -0.4352671|              -0.0849069|               0.3443337|              -0.4122949|                   0.0012076|                   0.3367146|                  -0.4347356|      -0.2920495|      -0.3877464|      -0.1170136|                      -0.0844362|                               0.0769828|                  -0.4379654|                      -0.5476456|               -0.2232959|                0.2450004|               -0.4065773|                  -0.9858953|                  -0.9742872|                  -0.9741617|                   -0.0096531|                    0.4274891|                   -0.4927660|       -0.3767948|       -0.2539580|       -0.1510471|           -0.3724872|           -0.5277009|           -0.2967102|                       -0.1640805|                          -0.1640805|                            0.1582534|               -0.3933317|                   -0.5380838|               -0.2850964|                0.1085324|               -0.4510303|                   -0.1138301|                    0.4327725|                   -0.5497228|       -0.4055993|       -0.1873032|       -0.2400656|                       -0.3424443|                                0.2460644|                   -0.4666070|                       -0.5540869|         10| WALKING           |
| 1396 |               0.2761973|               0.0054113|              -0.1072516|                  0.9769048|                 -0.0328580|                  0.0370905|                   0.0837291|                   0.0347208|                   0.0053195|      -0.0125691|      -0.0653445|       0.0908418|          -0.1240478|          -0.0112129|          -0.0262582|                      -0.9647164|                         -0.9647164|                          -0.9872451|              -0.9678234|                  -0.9889850|              -0.9915329|              -0.9526319|              -0.9823454|                  -0.9880432|                  -0.9708874|                  -0.9900744|      -0.9733212|      -0.9762199|      -0.9533171|                      -0.9666626|                              -0.9885534|                  -0.9712201|                      -0.9844238|               -0.9943264|               -0.9355200|               -0.9699050|                  -0.9983105|                  -0.9431815|                  -0.9818734|                   -0.9886453|                   -0.9730604|                   -0.9934428|       -0.9839613|       -0.9740338|       -0.9512843|           -0.9809847|           -0.9899904|           -0.9838408|                       -0.9510052|                          -0.9510052|                           -0.9870249|               -0.9658329|                   -0.9848415|               -0.9958999|               -0.9306859|               -0.9647444|                   -0.9904486|                   -0.9781364|                   -0.9960954|       -0.9878550|       -0.9728095|       -0.9548738|                       -0.9497103|                               -0.9833402|                   -0.9677752|                       -0.9861275|          4| SITTING           |
| 701  |               0.1580156|              -0.0297853|              -0.1330249|                  0.7749753|                 -0.5290170|                  0.0490200|                  -0.0075750|                   0.5507358|                  -0.0305528|       0.3754555|      -0.6528052|      -0.0993800|          -0.2746664|          -0.0733347|           0.2304170|                       0.0289706|                          0.0289706|                          -0.1505788|               0.2185806|                  -0.2526844|              -0.1241925|               0.1789461|              -0.4519436|                  -0.2541058|                  -0.1149857|                  -0.5522966|      -0.3205087|      -0.0831615|       0.2988073|                      -0.1970385|                              -0.2556440|                  -0.2331135|                      -0.3467970|               -0.1100891|                0.2541184|               -0.3089984|                  -0.8937951|                  -0.9160562|                  -0.9460163|                   -0.1499329|                   -0.0798795|                   -0.5358647|       -0.4622748|        0.1005209|        0.2992655|           -0.4266241|           -0.3195920|           -0.0338889|                       -0.2214259|                          -0.2214259|                           -0.3060172|               -0.2170510|                   -0.4329820|               -0.1045505|                0.2136716|               -0.2891684|                   -0.1195232|                   -0.1033222|                   -0.5201469|       -0.5072436|        0.1923485|        0.1806400|                       -0.3562681|                               -0.3808076|                   -0.3419146|                       -0.6204092|         20| WALKING\_UPSTAIRS |
| 663  |               0.3486324|              -0.0414763|              -0.0550061|                  0.9552572|                 -0.2462591|                  0.0396240|                  -0.3226654|                  -0.0612575|                   0.2510285|       0.1585758|      -0.0128727|       0.0809048|          -0.0132185|          -0.0359723|          -0.2000077|                      -0.1302570|                         -0.1302570|                          -0.3238158|              -0.3432560|                  -0.6618998|              -0.1187648|              -0.1887566|              -0.5070440|                  -0.3307728|                  -0.3402652|                  -0.6211836|      -0.3851593|      -0.6898347|      -0.3435299|                      -0.0929222|                              -0.3595498|                  -0.6470104|                      -0.7182942|               -0.1149600|               -0.1114595|               -0.4242770|                  -0.9604791|                  -0.9103447|                  -0.8713324|                   -0.2729469|                   -0.3054624|                   -0.6891072|       -0.4817392|       -0.5859813|       -0.3500114|           -0.4986449|           -0.8214919|           -0.5224382|                       -0.1003286|                          -0.1003286|                           -0.4331616|               -0.6555841|                   -0.7356195|               -0.1133905|               -0.1282326|               -0.4246125|                   -0.2768369|                   -0.3134869|                   -0.7643038|       -0.5129990|       -0.5359321|       -0.4114645|                       -0.2440195|                               -0.5471407|                   -0.7229988|                       -0.7790616|          4| WALKING\_UPSTAIRS |

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
| 7124 |               0.2778587|              -0.0171721|              -0.1064711|                 -0.5193934|                  0.6839664|                  0.7562426|                   0.0801132|                   0.0093571|                  -0.0014827|      -0.0260739|      -0.0808293|       0.0861627|          -0.0960872|          -0.0382251|          -0.0566223|                      -0.9968460|                         -0.9968460|                          -0.9945166|              -0.9936959|                  -0.9930314|              -0.9914811|              -0.9946477|              -0.9965715|                  -0.9909448|                  -0.9927360|                  -0.9957180|      -0.9936823|      -0.9876815|      -0.9947159|                      -0.9988829|                              -0.9965999|                  -0.9865951|                      -0.9922070|               -0.9933007|               -0.9965293|               -0.9959349|                  -0.9956309|                  -0.9985716|                  -0.9950233|                   -0.9909853|                   -0.9922786|                   -0.9968580|       -0.9957428|       -0.9886532|       -0.9953182|           -0.9931456|           -0.9903594|           -0.9957024|                       -0.9989078|                          -0.9989078|                           -0.9969453|               -0.9878960|                   -0.9919360|               -0.9941571|               -0.9968105|               -0.9949050|                   -0.9918353|                   -0.9922057|                   -0.9965817|       -0.9964195|       -0.9893106|       -0.9959039|                       -0.9983379|                               -0.9959053|                   -0.9910683|                       -0.9917016|         19| LAYING              |
| 4632 |               0.2881726|              -0.0086842|              -0.0900963|                  0.8812778|                 -0.2183583|                 -0.3428134|                   0.0733775|                   0.0025536|                   0.0004656|      -0.0235680|      -0.0730301|       0.0964257|          -0.1034120|          -0.0449369|          -0.0372450|                      -0.9664969|                         -0.9664969|                          -0.9913668|              -0.9756338|                  -0.9947711|              -0.9916999|              -0.9712287|              -0.9794119|                  -0.9950037|                  -0.9874440|                  -0.9856098|      -0.9846763|      -0.9858134|      -0.9690810|                      -0.9763198|                              -0.9906551|                  -0.9853064|                      -0.9959915|               -0.9890286|               -0.9388724|               -0.9630029|                  -0.9833062|                  -0.9643857|                  -0.9573460|                   -0.9952138|                   -0.9881714|                   -0.9881684|       -0.9806640|       -0.9807811|       -0.9636336|           -0.9953484|           -0.9944095|           -0.9920601|                       -0.9614209|                          -0.9614209|                           -0.9922176|               -0.9720446|                   -0.9959610|               -0.9877898|               -0.9291497|               -0.9566134|                   -0.9959129|                   -0.9900522|                   -0.9893995|       -0.9798546|       -0.9781343|       -0.9650460|                       -0.9589734|                               -0.9936204|                   -0.9691913|                       -0.9958051|         14| STANDING            |
| 6918 |               0.3408878|              -0.0092364|              -0.1276114|                 -0.1739744|                  0.7862820|                  0.5860832|                  -0.0295833|                  -0.0458370|                   0.1184715|       0.0793016|      -0.1516627|       0.2216093|          -0.1466831|          -0.0280922|          -0.0735714|                      -0.8458756|                         -0.8458756|                          -0.9501966|              -0.8529510|                  -0.9624562|              -0.8585177|              -0.9192826|              -0.8912880|                  -0.9523187|                  -0.9487457|                  -0.9557028|      -0.8985384|      -0.9467415|      -0.9423525|                      -0.8781543|                              -0.9552350|                  -0.9089525|                      -0.9691912|               -0.8359708|               -0.9259617|               -0.8497161|                  -0.7601688|                  -0.9708451|                  -0.8649502|                   -0.9508754|                   -0.9488872|                   -0.9624501|       -0.8982622|       -0.9442278|       -0.9302809|           -0.9571353|           -0.9635856|           -0.9750512|                       -0.8311797|                          -0.8311797|                           -0.9603511|               -0.8465456|                   -0.9710308|               -0.8275902|               -0.9334677|               -0.8395350|                   -0.9536542|                   -0.9527679|                   -0.9681290|       -0.8992766|       -0.9430053|       -0.9328122|                       -0.8343911|                               -0.9670195|                   -0.8379969|                       -0.9754795|         17| LAYING              |
| 2974 |               0.3293993|              -0.0212339|              -0.0914434|                  0.9259302|                 -0.1088784|                 -0.2804560|                   0.4403446|                  -0.0239660|                  -0.1822936|      -0.1530869|      -0.0585580|       0.0939024|           0.1042956|           0.0381198|          -0.0647718|                      -0.1069879|                         -0.1069879|                          -0.3076341|              -0.1909304|                  -0.4619238|              -0.0442728|              -0.1992409|               0.0245007|                  -0.2196145|                  -0.3053768|                  -0.2391647|      -0.3063346|      -0.2025518|      -0.3509784|                       0.1775070|                              -0.0023345|                  -0.1363810|                      -0.2553000|               -0.1185628|               -0.2503096|                0.1989694|                  -0.9410161|                  -0.9582921|                  -0.9649384|                   -0.1847848|                   -0.3338283|                   -0.2903434|       -0.2681064|       -0.2961712|       -0.3766862|           -0.5810154|           -0.2777209|           -0.5624629|                        0.2250049|                           0.2250049|                            0.0341670|               -0.1909023|                   -0.2243881|               -0.1495388|               -0.3267104|                0.1977912|                   -0.2203014|                   -0.4212960|                   -0.3383886|       -0.2683387|       -0.3659037|       -0.4422507|                        0.0600893|                                0.0733902|                   -0.3794645|                       -0.2386347|          7| WALKING\_DOWNSTAIRS |
| 3781 |               0.2793033|              -0.0205214|              -0.1132364|                  0.8732420|                  0.1475858|                  0.3223358|                   0.0736478|                   0.0083842|                  -0.0050818|      -0.0280061|      -0.0763063|       0.0924671|          -0.0973735|          -0.0372310|          -0.0563447|                      -0.9920514|                         -0.9920514|                          -0.9959885|              -0.9944106|                  -0.9970612|              -0.9952783|              -0.9886292|              -0.9950961|                  -0.9941016|                  -0.9923079|                  -0.9945010|      -0.9974877|      -0.9948662|      -0.9901195|                      -0.9963488|                              -0.9960259|                  -0.9957281|                      -0.9976529|               -0.9958485|               -0.9807008|               -0.9934038|                  -0.9969555|                  -0.9915077|                  -0.9945718|                   -0.9939669|                   -0.9919646|                   -0.9959254|       -0.9982711|       -0.9950509|       -0.9888931|           -0.9982045|           -0.9962354|           -0.9947180|                       -0.9948680|                          -0.9948680|                           -0.9953607|               -0.9955746|                   -0.9976958|               -0.9960453|               -0.9772430|               -0.9918900|                   -0.9943227|                   -0.9920646|                   -0.9959696|       -0.9985169|       -0.9951250|       -0.9893127|                       -0.9936562|                               -0.9928462|                   -0.9960570|                       -0.9975475|          1| SITTING             |
| 1924 |               0.3614311|              -0.0766007|              -0.0827651|                  0.8405609|                 -0.3230955|                 -0.2977066|                  -0.0901258|                  -0.2675204|                  -0.1393096|       0.0316999|      -0.1501100|      -0.0185126|          -0.0607526|          -0.1610675|          -0.4018187|                      -0.0969638|                         -0.0969638|                          -0.2501817|              -0.2154857|                  -0.5801089|              -0.0831082|              -0.1374236|              -0.4347767|                  -0.1291610|                  -0.2713944|                  -0.5894376|      -0.3135152|      -0.5110575|      -0.2794932|                       0.0117929|                              -0.1582236|                  -0.4918416|                      -0.6445538|               -0.1153614|               -0.0646271|               -0.3113074|                  -0.9674476|                  -0.9450250|                  -0.9787205|                   -0.1308456|                   -0.1848901|                   -0.6311152|       -0.2966480|       -0.5264441|       -0.1586281|           -0.4261806|           -0.6730802|           -0.6062116|                       -0.0867324|                          -0.0867324|                           -0.1823607|               -0.4112370|                   -0.6737924|               -0.1283461|               -0.0863866|               -0.3002185|                   -0.2126662|                   -0.1444978|                   -0.6715320|       -0.3012657|       -0.5395283|       -0.1994558|                       -0.2893244|                               -0.2186058|                   -0.4579073|                       -0.7408837|         28| WALKING\_UPSTAIRS   |

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
|         27| SITTING      |               0.2739413|              -0.0155270|              -0.1055219|                  0.8394647|                  0.2129470|                  0.2764174|                   0.0779039|                   0.0046707|                  -0.0061129|      -0.0371831|      -0.0797346|       0.0833753|          -0.0951636|          -0.0396411|          -0.0503884|                      -0.9794817|                         -0.9794817|                          -0.9894672|              -0.9635655|                  -0.9940347|              -0.9886821|              -0.9740579|              -0.9746658|                  -0.9908396|                  -0.9852386|                  -0.9870877|      -0.9872079|      -0.9841411|      -0.9768481|                      -0.9747665|                              -0.9887733|                  -0.9794828|                      -0.9923903|               -0.9885801|               -0.9715791|               -0.9658587|                  -0.9824457|                  -0.9825533|                  -0.9672681|                   -0.9906581|                   -0.9850975|                   -0.9889040|       -0.9884924|       -0.9820675|       -0.9757133|           -0.9936403|           -0.9922264|           -0.9917668|                       -0.9695267|                          -0.9695267|                           -0.9892005|               -0.9707821|                   -0.9921128|               -0.9886592|               -0.9712661|               -0.9632207|                   -0.9912923|                   -0.9860831|                   -0.9892825|       -0.9889846|       -0.9810377|       -0.9775955|                       -0.9708853|                               -0.9885317|                   -0.9705283|                       -0.9919678|
|         28| LAYING       |               0.2759135|              -0.0167538|              -0.1083449|                 -0.4903345|                  0.1440733|                  0.0157570|                   0.0780771|                   0.0059399|                   0.0060097|      -0.0173677|      -0.0974487|       0.0935791|          -0.1045116|          -0.0356010|          -0.0534502|                      -0.9581122|                         -0.9581122|                          -0.9784553|              -0.9371069|                  -0.9782203|              -0.9739309|              -0.9584364|              -0.9611157|                  -0.9800134|                  -0.9780948|                  -0.9702516|      -0.9468042|      -0.9658245|      -0.9611648|                      -0.9610356|                              -0.9734362|                  -0.9442184|                      -0.9718306|               -0.9688883|               -0.9453868|               -0.9564503|                  -0.9705991|                  -0.9697590|                  -0.9791247|                   -0.9801647|                   -0.9786795|                   -0.9730717|       -0.9551623|       -0.9600575|       -0.9623749|           -0.9608029|           -0.9803998|           -0.9814189|                       -0.9545740|                          -0.9545740|                           -0.9733126|               -0.9289409|                   -0.9697733|               -0.9673249|               -0.9420040|               -0.9567709|                   -0.9822059|                   -0.9811175|                   -0.9745308|       -0.9580921|       -0.9575530|       -0.9663120|                       -0.9575640|                               -0.9723361|                   -0.9316750|                       -0.9693198|
|         29| SITTING      |               0.2771800|              -0.0166307|              -0.1104118|                  0.8915638|                  0.1556595|                  0.2862561|                   0.0745438|                   0.0059853|                   0.0031677|      -0.0379271|      -0.0755798|       0.0580496|          -0.0953637|          -0.0400018|          -0.0470009|                      -0.9780170|                         -0.9780170|                          -0.9907198|              -0.9623773|                  -0.9953923|              -0.9910940|              -0.9696095|              -0.9756230|                  -0.9934458|                  -0.9838832|                  -0.9884702|      -0.9883936|      -0.9903292|      -0.9739336|                      -0.9733465|                              -0.9900937|                  -0.9802694|                      -0.9950630|               -0.9907450|               -0.9632225|               -0.9680639|                  -0.9846792|                  -0.9736043|                  -0.9660320|                   -0.9935256|                   -0.9840551|                   -0.9901687|       -0.9901787|       -0.9883340|       -0.9712280|           -0.9933220|           -0.9953192|           -0.9928338|                       -0.9692903|                          -0.9692903|                           -0.9905317|               -0.9715780|                   -0.9949053|               -0.9906175|               -0.9616939|               -0.9658010|                   -0.9942202|                   -0.9854933|                   -0.9904459|       -0.9907278|       -0.9872598|       -0.9729125|                       -0.9712180|                               -0.9898229|                   -0.9710114|                       -0.9947420|
|         15| SITTING      |               0.2729034|              -0.0117188|              -0.1136613|                  0.8903643|                  0.2108493|                  0.0028157|                   0.0784793|                  -0.0089844|                  -0.0023721|      -0.0377111|      -0.0803429|       0.0951978|          -0.0953649|          -0.0396069|          -0.0524148|                      -0.9586698|                         -0.9586698|                          -0.9861078|              -0.9573316|                  -0.9921889|              -0.9866196|              -0.9389264|              -0.9632270|                  -0.9881061|                  -0.9781590|                  -0.9849084|      -0.9861526|      -0.9792017|      -0.9667315|                      -0.9497520|                              -0.9846894|                  -0.9737622|                      -0.9901810|               -0.9870844|               -0.9224072|               -0.9493380|                  -0.9826209|                  -0.9435614|                  -0.9529737|                   -0.9881623|                   -0.9781270|                   -0.9870110|       -0.9882041|       -0.9753215|       -0.9637658|           -0.9928890|           -0.9903133|           -0.9879372|                       -0.9379779|                          -0.9379779|                           -0.9846390|               -0.9634751|                   -0.9897200|               -0.9873848|               -0.9191627|               -0.9457047|                   -0.9893144|                   -0.9797130|                   -0.9876941|       -0.9888819|       -0.9734561|       -0.9662286|                       -0.9411959|                               -0.9832763|                   -0.9633782|                       -0.9895039|
|         14| LAYING       |               0.2332754|              -0.0113425|              -0.0868333|                 -0.1454836|                  0.4853969|                  0.8365629|                   0.0981404|                  -0.0083151|                  -0.0323602|       0.0050522|      -0.1534238|       0.1491241|          -0.1054466|          -0.0372677|          -0.0566172|                      -0.9059783|                         -0.9059783|                          -0.9725764|              -0.9046654|                  -0.9756212|              -0.9339362|              -0.9303669|              -0.9278823|                  -0.9720107|                  -0.9693421|                  -0.9685932|      -0.9499590|      -0.9380879|      -0.9491072|                      -0.8994637|                              -0.9679886|                  -0.9301517|                      -0.9664553|               -0.9175019|               -0.9096970|               -0.9003319|                  -0.8621369|                  -0.9487749|                  -0.9013039|                   -0.9714736|                   -0.9681276|                   -0.9724319|       -0.9572210|       -0.9324998|       -0.9522970|           -0.9702750|           -0.9680429|           -0.9797114|                       -0.8565931|                          -0.8565931|                           -0.9664509|               -0.9134332|                   -0.9640099|               -0.9119727|               -0.9052210|               -0.8940557|                   -0.9734914|                   -0.9691133|                   -0.9749144|       -0.9597405|       -0.9299554|       -0.9577905|                       -0.8596060|                               -0.9636074|                   -0.9177601|                       -0.9636660|
|          7| SITTING      |               0.2846746|              -0.0146110|              -0.1224646|                  0.9691478|                  0.0060885|                  0.0649636|                   0.0668520|                   0.0116863|                   0.0162004|      -0.0496380|      -0.0336120|       0.0259477|          -0.0938156|          -0.0396445|          -0.0454566|                      -0.9184321|                         -0.9184321|                          -0.9765597|              -0.8978705|                  -0.9816651|              -0.9726971|              -0.9314906|              -0.9046753|                  -0.9820372|                  -0.9694236|                  -0.9685035|      -0.9436318|      -0.9566781|      -0.9474199|                      -0.9089568|                              -0.9709542|                  -0.9330820|                      -0.9786350|               -0.9726684|               -0.9094547|               -0.8565329|                  -0.9570824|                  -0.9454363|                  -0.8686025|                   -0.9821581|                   -0.9694587|                   -0.9722565|       -0.9418710|       -0.9441243|       -0.9370212|           -0.9743690|           -0.9810247|           -0.9809547|                       -0.8819576|                          -0.8819576|                           -0.9702433|               -0.8980633|                   -0.9762144|               -0.9728800|               -0.9046292|               -0.8440831|                   -0.9840263|                   -0.9718150|                   -0.9746992|       -0.9427264|       -0.9382447|       -0.9398260|                       -0.8869156|                               -0.9684949|                   -0.8958050|                       -0.9749659|

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
