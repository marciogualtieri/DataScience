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

    ## [1] "fBodyAccJerk-bandsEnergy()-17,24" "tBodyGyroJerk-mad()-X"           
    ## [3] "fBodyGyro-bandsEnergy()-25,32"    "fBodyAcc-iqr()-X"                
    ## [5] "tBodyGyroMag-max()"               "tBodyAccJerkMag-std()"

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

The variable names for subject and activity are my own choice. I believe they are descriptive enough.

Let's also create a list of the variables we are interested in exploring (means and standard deviations at the moment):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "tBodyAcc-entropy()-X"          "fBodyGyro-std()-X"            
    ## [3] "fBodyBodyGyroMag-mad()"        "tBodyGyroJerkMag-min()"       
    ## [5] "fBodyAccJerk-max()-X"          "fBodyGyro-bandsEnergy()-25,32"

``` r
sample(mean_variables, 6)
```

    ## [1] "tGravityAcc-mean()-X"        "tBodyGyro-mean()-X"         
    ## [3] "fBodyBodyGyroJerkMag-mean()" "fBodyAcc-mean()-Z"          
    ## [5] "fBodyAccJerk-mean()-Y"       "tBodyAcc-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyGyro-std()-Y"      "fBodyAcc-std()-X"      
    ## [3] "tBodyGyroJerk-std()-Z"  "tBodyGyroJerkMag-std()"
    ## [5] "tBodyGyro-std()-Z"      "fBodyAccJerk-std()-Y"

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

    ## [1] "fBodyAccJerk-bandsEnergy()-41,48" "tBodyGyroMag-mean()"             
    ## [3] "fBodyGyro-mad()-Y"                "tBodyGyroJerk-iqr()-Y"           
    ## [5] "fBodyAccMag-iqr()"                "fBodyAccMag-maxInds"

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
| 703  |               0.2724912|              -0.0151488|              -0.1194508|                  0.9764096|                 -0.0924010|                  0.0149138|                  -0.1591331|                  -0.1724563|                  -0.0583300|      -0.0346950|      -0.0693941|       0.0626467|          -0.2190097|           0.0646644|          -0.0852857|                      -0.2122995|                         -0.2122995|                          -0.3486530|              -0.4290785|                  -0.6471308|              -0.4098663|              -0.3317983|              -0.2111765|                  -0.4919803|                  -0.4885971|                  -0.3747168|      -0.5117850|      -0.5649891|      -0.4485673|                      -0.5116789|                              -0.4292222|                  -0.6022462|                      -0.6847689|               -0.4021980|               -0.2719532|               -0.0986260|                  -0.9873166|                  -0.9873463|                  -0.9623097|                   -0.4507129|                   -0.3919691|                   -0.3777449|       -0.5376502|       -0.5987139|       -0.3624370|           -0.6598357|           -0.6769309|           -0.5270193|                       -0.5707502|                          -0.5707502|                           -0.4225583|               -0.6069525|                   -0.6752051|               -0.3990930|               -0.2871270|               -0.1085021|                   -0.4560162|                   -0.3305075|                   -0.3792354|       -0.5493584|       -0.6238798|       -0.3947946|                       -0.6743817|                               -0.4174734|                   -0.6796998|                       -0.6850222|           1|          9|
| 546  |               0.2851204|               0.0067621|              -0.0873241|                  0.9676685|                 -0.0619993|                  0.1112627|                   0.0670211|                  -0.1466306|                   0.2556352|      -0.0906196|      -0.0025485|       0.1243427|          -0.2080650|          -0.0494192|          -0.0084501|                      -0.3097822|                         -0.3097822|                          -0.3541505|              -0.5294543|                  -0.7206566|              -0.4241934|              -0.2312520|              -0.6399220|                  -0.3408990|                  -0.3718431|                  -0.8083850|      -0.4060308|      -0.7124207|      -0.6714107|                      -0.4986675|                              -0.3759557|                  -0.6514747|                      -0.7610483|               -0.4176121|               -0.0934101|               -0.6549481|                  -0.9856772|                  -0.9381674|                  -0.9467643|                   -0.2450586|                   -0.2598661|                   -0.8282645|       -0.5171070|       -0.6825991|       -0.7227520|           -0.5648468|           -0.8274487|           -0.6840486|                       -0.5385859|                          -0.5385859|                           -0.3297029|               -0.5825694|                   -0.7728780|               -0.4149381|               -0.0839428|               -0.6921568|                   -0.2149394|                   -0.1903727|                   -0.8467645|       -0.5524580|       -0.6676252|       -0.7671459|                       -0.6339182|                               -0.2756553|                   -0.6083965|                       -0.8060292|           1|          4|
| 996  |               0.2200613|              -0.0159048|              -0.1267308|                  0.9601541|                 -0.2205001|                  0.0402975|                   0.0227888|                   0.6856354|                   0.0876034|       0.0219066|      -0.1399521|       0.1454781|          -0.2915354|          -0.2498399|           0.2405056|                      -0.1680765|                         -0.1680765|                          -0.1377864|              -0.1603192|                  -0.4667696|              -0.1009084|               0.2508284|              -0.4494201|                  -0.1310355|                   0.2629270|                  -0.5030741|      -0.2659877|      -0.3393299|      -0.0391085|                      -0.0265501|                              -0.0146252|                  -0.3847786|                      -0.4842531|               -0.1982768|               -0.0320912|               -0.4461722|                  -0.9923594|                  -0.9778718|                  -0.9707892|                   -0.1039136|                    0.1845178|                   -0.5767394|       -0.3579951|       -0.3124106|       -0.1251122|           -0.4488943|           -0.4827508|           -0.3387534|                       -0.1722864|                          -0.1722864|                           -0.0018624|               -0.3837991|                   -0.4574895|               -0.2400257|               -0.2900154|               -0.4888691|                   -0.1551830|                   -0.0121599|                   -0.6541512|       -0.3889521|       -0.3010758|       -0.2351823|                       -0.3955798|                                0.0069626|                   -0.4911224|                       -0.4579796|           1|         10|
| 2332 |               0.2128832|              -0.0400771|              -0.1607659|                  0.9245768|                 -0.2946501|                 -0.0721155|                   0.2146116|                  -0.3641876|                  -0.1702778|       0.1361229|      -0.1267984|       0.0558489|          -0.4894627|          -0.2839410|          -0.2689776|                      -0.1199720|                         -0.1199720|                          -0.1933195|              -0.0501472|                  -0.3440711|              -0.3051338|               0.2475676|              -0.2136258|                  -0.3005625|                   0.0012315|                  -0.3462258|      -0.1170475|      -0.0815875|      -0.2109598|                      -0.0498583|                              -0.0849525|                  -0.1871015|                      -0.1876198|               -0.3371850|                0.2401264|               -0.1686845|                  -0.9336097|                  -0.8964490|                  -0.8661758|                   -0.2860470|                    0.0558976|                   -0.3946265|       -0.2712719|       -0.1034381|       -0.1672393|           -0.3543755|           -0.2043882|           -0.4382767|                       -0.1810818|                          -0.1810818|                           -0.1402968|               -0.1317371|                   -0.1475855|               -0.3501808|                0.1574264|               -0.2094898|                   -0.3348753|                    0.0456500|                   -0.4402899|       -0.3206177|       -0.1235746|       -0.2294487|                       -0.3928233|                               -0.2220564|                   -0.2426726|                       -0.1556775|           1|         20|
| 1921 |               0.2786506|              -0.0173908|              -0.1073858|                 -0.2600998|                  0.9193107|                  0.3725880|                   0.0765637|                   0.0055981|                  -0.0103546|      -0.0231217|      -0.0613685|       0.0557149|          -0.0998771|          -0.0444774|          -0.0640716|                      -0.9961199|                         -0.9961199|                          -0.9912438|              -0.9852479|                  -0.9940491|              -0.9915401|              -0.9911709|              -0.9922487|                  -0.9890532|                  -0.9910705|                  -0.9907706|      -0.9960044|      -0.9913353|      -0.9872660|                      -0.9943095|                              -0.9939262|                  -0.9931578|                      -0.9960987|               -0.9929300|               -0.9933181|               -0.9948181|                  -0.9960025|                  -0.9983108|                  -0.9962833|                   -0.9883291|                   -0.9907198|                   -0.9931093|       -0.9970849|       -0.9920211|       -0.9903602|           -0.9957341|           -0.9932438|           -0.9918343|                       -0.9961802|                          -0.9961802|                           -0.9945239|               -0.9928716|                   -0.9955022|               -0.9935216|               -0.9939508|               -0.9963699|                   -0.9884950|                   -0.9909008|                   -0.9942399|       -0.9974040|       -0.9924647|       -0.9924989|                       -0.9977122|                               -0.9941748|                   -0.9937115|                       -0.9945720|           6|         18|
| 2413 |               0.3814722|               0.0504946|               0.0691034|                  0.7981748|                 -0.5212272|                 -0.1272481|                   0.0688581|                  -0.0826967|                  -0.0376687|      -0.0004655|       0.0347645|      -0.2417382|          -0.0145913|          -0.0645687|           0.0275603|                      -0.6713013|                         -0.6713013|                          -0.8401220|              -0.6193345|                  -0.7799747|              -0.8322393|              -0.7008879|              -0.7684635|                  -0.8328866|                  -0.8208714|                  -0.8225155|      -0.7221392|      -0.5949181|      -0.5857296|                      -0.7399053|                              -0.7809325|                  -0.5392530|                      -0.6556090|               -0.8364893|               -0.5842588|               -0.7489350|                  -0.7883067|                  -0.7302642|                  -0.7839131|                   -0.8293424|                   -0.8282306|                   -0.8386073|       -0.7754758|       -0.5968379|       -0.5727402|           -0.8101808|           -0.7029310|           -0.7601757|                       -0.7575821|                          -0.7575821|                           -0.7814793|               -0.5286302|                   -0.6590563|               -0.8380423|               -0.5584477|               -0.7570993|                   -0.8408549|                   -0.8507813|                   -0.8530213|       -0.7923831|       -0.6008280|       -0.6074760|                       -0.8050511|                               -0.7819749|                   -0.6030376|                       -0.6864146|           5|         20|

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
| 2237 |               0.2788511|              -0.0137607|              -0.0979128|                  0.9704243|                 -0.1502800|                 -0.0544104|                   0.0770433|                   0.0035725|                  -0.0273909|      -0.0217885|      -0.0722025|       0.0852269|          -0.0992043|          -0.0382277|          -0.0545673|                      -0.9852035|                         -0.9852035|                          -0.9874199|              -0.9849128|                  -0.9879773|              -0.9925725|              -0.9800958|              -0.9764016|                  -0.9883892|                  -0.9818955|                  -0.9863140|      -0.9813776|      -0.9853375|      -0.9854468|                      -0.9841768|                              -0.9864439|                  -0.9821380|                      -0.9874681|               -0.9943051|               -0.9823397|               -0.9742107|                  -0.9984098|                  -0.9868892|                  -0.9667205|                   -0.9871892|                   -0.9818120|                   -0.9875763|       -0.9867584|       -0.9844165|       -0.9875402|           -0.9810185|           -0.9893812|           -0.9888541|                       -0.9857997|                          -0.9857997|                           -0.9860910|               -0.9827736|                   -0.9887852|               -0.9951483|               -0.9836680|               -0.9739693|                   -0.9869246|                   -0.9829950|                   -0.9872491|       -0.9884800|       -0.9838620|       -0.9893879|                       -0.9881612|                               -0.9840534|                   -0.9861897|                       -0.9913255|         12| STANDING            |
| 99   |               0.3090925|              -0.0218608|              -0.1026760|                  0.9667230|                 -0.1714689|                 -0.0341002|                  -0.4416504|                  -0.0392667|                   0.0115558|       0.0025301|      -0.0723206|      -0.0005243|          -0.0893870|           0.0675115|           0.0446346|                      -0.0054589|                         -0.0054589|                          -0.0354024|              -0.3405465|                  -0.4035136|               0.1341740|               0.0642726|              -0.5757310|                   0.0538561|                  -0.0654957|                  -0.6289031|      -0.3319859|      -0.3202298|      -0.4400624|                      -0.0038705|                               0.0361778|                  -0.2820168|                      -0.4026450|               -0.0118039|                0.0548985|               -0.5147740|                  -0.9798993|                  -0.9700321|                  -0.9551594|                    0.1760280|                   -0.0125444|                   -0.5800079|       -0.4883318|       -0.2915196|       -0.5327457|           -0.1944605|           -0.4219421|           -0.5423439|                       -0.1234250|                          -0.1234250|                            0.0818915|               -0.3106140|                   -0.3710990|               -0.0755315|               -0.0169747|               -0.5192935|                    0.1975086|                   -0.0198658|                   -0.5388452|       -0.5380558|       -0.2793113|       -0.6102126|                       -0.3351234|                                0.1315570|                   -0.4545673|                       -0.3735932|         12| WALKING             |
| 2923 |               0.2524584|              -0.0167830|              -0.1043116|                 -0.3127408|                  0.6899233|                  0.7334394|                   0.0711156|                   0.0171685|                   0.0115383|      -0.0172641|      -0.0882514|       0.0677054|          -0.1151281|          -0.0377205|          -0.0691200|                      -0.9631652|                         -0.9631652|                          -0.9811970|              -0.9619122|                  -0.9810714|              -0.9772905|              -0.9765978|              -0.9695730|                  -0.9866182|                  -0.9790089|                  -0.9747737|      -0.9711808|      -0.9599235|      -0.9826597|                      -0.9730254|                              -0.9813506|                  -0.9580951|                      -0.9776279|               -0.9620260|               -0.9785606|               -0.9640414|                  -0.9858585|                  -0.9935536|                  -0.9883000|                   -0.9870692|                   -0.9796458|                   -0.9768972|       -0.9753512|       -0.9495606|       -0.9841732|           -0.9845176|           -0.9750605|           -0.9932767|                       -0.9706664|                          -0.9706664|                           -0.9826380|               -0.9498595|                   -0.9781099|               -0.9568972|               -0.9799454|               -0.9626933|                   -0.9888064|                   -0.9819841|                   -0.9774014|       -0.9766206|       -0.9442510|       -0.9860446|                       -0.9726669|                               -0.9831173|                   -0.9526764|                       -0.9798653|         24| LAYING              |
| 1635 |               0.2771034|              -0.0183343|              -0.1281671|                  0.9712404|                  0.0457690|                 -0.0091203|                   0.0704038|                   0.0571974|                  -0.0017014|      -0.0192386|      -0.0840633|       0.0647510|          -0.1095257|          -0.0193610|          -0.0654025|                      -0.9499125|                         -0.9499125|                          -0.9806168|              -0.9648589|                  -0.9845869|              -0.9876335|              -0.9307033|              -0.9585851|                  -0.9868124|                  -0.9778625|                  -0.9734213|      -0.9768836|      -0.9629294|      -0.9655081|                      -0.9619222|                              -0.9806858|                  -0.9689070|                      -0.9814803|               -0.9899015|               -0.9073442|               -0.9404718|                  -0.9959842|                  -0.9634890|                  -0.9492870|                   -0.9870331|                   -0.9778974|                   -0.9769951|       -0.9825438|       -0.9630330|       -0.9625508|           -0.9828979|           -0.9826064|           -0.9834447|                       -0.9545154|                          -0.9545154|                           -0.9826620|               -0.9687770|                   -0.9825295|               -0.9909180|               -0.9014544|               -0.9347135|                   -0.9884717|                   -0.9795213|                   -0.9791689|       -0.9842966|       -0.9632590|       -0.9648164|                       -0.9563393|                               -0.9844348|                   -0.9739726|                       -0.9848946|          9| SITTING             |
| 1217 |               0.3955821|              -0.0121936|              -0.1480187|                  0.8650910|                 -0.3116162|                 -0.2491606|                   0.0366765|                   0.3400411|                   0.2957647|      -0.4921276|       0.3959397|       0.3435522|          -0.4854703|          -0.1644921|          -0.1895070|                       0.1289366|                          0.1289366|                           0.0795702|              -0.0890726|                  -0.4727873|               0.1015901|               0.3518381|               0.1442068|                   0.1329507|                   0.1446474|                  -0.0816391|      -0.1639036|      -0.3801548|      -0.1186514|                       0.3002644|                               0.3687529|                  -0.3265025|                      -0.5247486|                0.0107129|                0.2139545|                0.1778479|                  -0.9641390|                  -0.9432906|                  -0.9330270|                    0.1752088|                    0.1984165|                   -0.1522085|       -0.2856069|       -0.3938444|       -0.3140965|           -0.4777451|           -0.5279286|           -0.2364233|                        0.1674046|                           0.1674046|                            0.3280903|               -0.1243064|                   -0.4898306|               -0.0274188|                0.0549577|                0.1020710|                    0.1153055|                    0.1772213|                   -0.2197566|       -0.3254159|       -0.4067368|       -0.4548146|                       -0.0966905|                                0.2643823|                   -0.1470287|                       -0.4810533|          2| WALKING\_DOWNSTAIRS |
| 2650 |               0.4788031|              -0.0226503|              -0.0828336|                 -0.3289430|                  0.9099939|                  0.3522223|                  -0.0564006|                   0.0372393|                   0.0127645|       0.0360572|       0.0384846|       0.4538622|          -0.1349124|          -0.0314292|          -0.2258250|                      -0.8228357|                         -0.8228357|                          -0.9593639|              -0.8093676|                  -0.9774885|              -0.8121048|              -0.9161379|              -0.9114789|                  -0.9474414|                  -0.9134352|                  -0.9574620|      -0.9422510|      -0.9543915|      -0.7539484|                      -0.7541432|                              -0.9235176|                  -0.8351109|                      -0.9543591|               -0.7766489|               -0.9218078|               -0.8753222|                  -0.5603087|                  -0.9838461|                  -0.8959596|                   -0.9526951|                   -0.9023941|                   -0.9654034|       -0.9640010|       -0.9539286|       -0.7779491|           -0.9573416|           -0.9745995|           -0.9334178|                       -0.6685993|                          -0.6685993|                           -0.9048058|               -0.7946204|                   -0.9436866|               -0.7638247|               -0.9289630|               -0.8658968|                   -0.9642044|                   -0.8965973|                   -0.9727704|       -0.9717180|       -0.9538710|       -0.8065762|                       -0.6794272|                               -0.8831473|                   -0.8033415|                       -0.9351168|         13| LAYING              |

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
| 3276 |               0.4675788|              -0.0587085|              -0.1872356|                  0.9075563|                 -0.1896031|                 -0.2346846|                   0.0337377|                  -0.0802131|                   0.1016164|      -0.2115226|      -0.0275317|       0.1963156|          -0.0390767|          -0.2858862|           0.0681058|                       0.0605949|                          0.0605949|                          -0.2664885|              -0.5043547|                  -0.6583528|              -0.0650301|              -0.1484341|              -0.1775772|                  -0.3035852|                  -0.3367829|                  -0.2752268|      -0.6428512|      -0.5805464|      -0.4094186|                      -0.0741564|                              -0.1327727|                  -0.6909768|                      -0.6911969|                0.0790620|               -0.1197016|               -0.1390889|                  -0.9567776|                  -0.9563315|                  -0.9094174|                   -0.2409807|                   -0.2708667|                   -0.3369564|       -0.6768945|       -0.6312998|       -0.4713166|           -0.6833044|           -0.6919581|           -0.4998279|                        0.0754866|                           0.0754866|                           -0.1372537|               -0.6701849|                   -0.6765362|                0.1308405|               -0.1599989|               -0.1860271|                   -0.2428244|                   -0.2467288|                   -0.3963957|       -0.6891204|       -0.6690430|       -0.5415537|                       -0.0165397|                               -0.1490837|                   -0.7122966|                       -0.6796713|         16| WALKING\_DOWNSTAIRS |
| 5149 |               0.2768234|              -0.0210377|              -0.1251704|                  0.9700019|                 -0.1275122|                  0.0781637|                   0.0799954|                  -0.0170318|                  -0.0303658|      -0.0270242|      -0.0758640|       0.0956764|          -0.1210066|          -0.0379743|          -0.0597992|                      -0.9757946|                         -0.9757946|                          -0.9915793|              -0.9676485|                  -0.9902519|              -0.9966385|              -0.9633519|              -0.9769562|                  -0.9951638|                  -0.9812227|                  -0.9916548|      -0.9492831|      -0.9892297|      -0.9847675|                      -0.9780532|                              -0.9919245|                  -0.9609696|                      -0.9889136|               -0.9977641|               -0.9541119|               -0.9704706|                  -0.9991873|                  -0.9905320|                  -0.9790913|                   -0.9956221|                   -0.9813822|                   -0.9928888|       -0.9511728|       -0.9872994|       -0.9848048|           -0.9790061|           -0.9942244|           -0.9914412|                       -0.9741974|                          -0.9741974|                           -0.9928826|               -0.9460727|                   -0.9897123|               -0.9983991|               -0.9514669|               -0.9680926|                   -0.9966352|                   -0.9829290|                   -0.9926199|       -0.9520700|       -0.9861615|       -0.9860482|                       -0.9748017|                               -0.9930717|                   -0.9457737|                       -0.9913158|         26| STANDING            |
| 5909 |               0.2776814|              -0.0187771|              -0.1110455|                  0.9638270|                 -0.1495369|                  0.1006760|                   0.0747294|                   0.0046888|                  -0.0056261|      -0.0246726|      -0.0906673|       0.0932061|          -0.1082324|          -0.0395454|          -0.0496084|                      -0.9613277|                         -0.9613277|                          -0.9832513|              -0.9495324|                  -0.9848377|              -0.9902147|              -0.9241180|              -0.9728087|                  -0.9886514|                  -0.9659864|                  -0.9836726|      -0.9322074|      -0.9734595|      -0.9657294|                      -0.9500439|                              -0.9777472|                  -0.9373655|                      -0.9792258|               -0.9921637|               -0.8930917|               -0.9623415|                  -0.9990619|                  -0.9769073|                  -0.9855348|                   -0.9880184|                   -0.9643898|                   -0.9863466|       -0.9222057|       -0.9679317|       -0.9542419|           -0.9655218|           -0.9871532|           -0.9863555|                       -0.9320364|                          -0.9320364|                           -0.9770680|               -0.8946770|                   -0.9763377|               -0.9930594|               -0.8850229|               -0.9585839|                   -0.9883184|                   -0.9649178|                   -0.9876650|       -0.9208146|       -0.9649846|       -0.9548582|                       -0.9324905|                               -0.9745663|                   -0.8886469|                       -0.9739924|         25| STANDING            |
| 4567 |               0.2827730|              -0.0146648|              -0.0834082|                  0.9660039|                  0.0506238|                 -0.0904628|                   0.0763038|                   0.0084129|                  -0.0289793|      -0.0278575|      -0.0872034|       0.0896185|          -0.0993316|          -0.0472367|          -0.0526724|                      -0.9558826|                         -0.9558826|                          -0.9874105|              -0.9802819|                  -0.9884184|              -0.9952128|              -0.9857508|              -0.9520620|                  -0.9947199|                  -0.9883052|                  -0.9783161|      -0.9926152|      -0.9758712|      -0.9924134|                      -0.9590741|                              -0.9862959|                  -0.9800420|                      -0.9854829|               -0.9955097|               -0.9844573|               -0.9024471|                  -0.9930185|                  -0.9871430|                  -0.9108154|                   -0.9942084|                   -0.9888490|                   -0.9802948|       -0.9947441|       -0.9710406|       -0.9938185|           -0.9934316|           -0.9827938|           -0.9926732|                       -0.9443280|                          -0.9443280|                           -0.9870414|               -0.9809136|                   -0.9842508|               -0.9955497|               -0.9836353|               -0.8870089|                   -0.9940813|                   -0.9904109|                   -0.9806768|       -0.9954089|       -0.9684402|       -0.9948921|                       -0.9443599|                               -0.9867586|                   -0.9848462|                       -0.9833134|         23| SITTING             |
| 2955 |               0.0487613|               0.0031228|              -0.1126936|                  0.9067060|                 -0.2396504|                 -0.0501063|                  -0.1027639|                  -0.0241374|                   0.1782700|      -0.0980250|      -0.0433614|       0.0733937|          -0.4145432|          -0.0615149|          -0.2769731|                       0.6350466|                          0.6350466|                           0.2943503|               0.1899025|                  -0.1664601|               0.5574125|               0.4188237|              -0.2748343|                   0.4234359|                   0.1958010|                  -0.3452253|       0.4386956|      -0.2090417|       0.2554270|                       0.5185486|                               0.4579406|                  -0.1210067|                      -0.3302875|                0.6671758|                0.4476157|               -0.3056502|                  -0.9459342|                  -0.9236729|                  -0.8782600|                    0.5389023|                    0.2399539|                   -0.3645336|        0.1779299|       -0.2678367|        0.0332089|            0.0184095|           -0.3827607|            0.0706379|                        0.2988464|                           0.2988464|                            0.3558073|                0.0038873|                   -0.3677308|                0.7083592|                0.3709798|               -0.3819796|                    0.5235047|                    0.2044391|                   -0.3811391|        0.0946396|       -0.3118862|       -0.1456480|                       -0.0466231|                                0.2030498|                   -0.0837245|                       -0.4676213|         19| WALKING\_DOWNSTAIRS |
| 3446 |               0.2755275|              -0.0141041|              -0.1114299|                  0.8329465|                  0.2901220|                  0.2727698|                   0.0813256|                   0.0118510|                  -0.0084142|      -0.0224071|      -0.0843556|       0.0876415|          -0.1012101|          -0.0543139|          -0.0554666|                      -0.9784758|                         -0.9784758|                          -0.9685939|              -0.9721642|                  -0.9752926|              -0.9783960|              -0.9647172|              -0.9754739|                  -0.9726195|                  -0.9638302|                  -0.9745660|      -0.9742686|      -0.9701780|      -0.9672814|                      -0.9812366|                              -0.9756106|                  -0.9774098|                      -0.9812772|               -0.9826456|               -0.9688135|               -0.9770147|                  -0.9981101|                  -0.9966062|                  -0.9958006|                   -0.9691680|                   -0.9635271|                   -0.9787774|       -0.9820179|       -0.9718363|       -0.9729305|           -0.9739047|           -0.9775141|           -0.9735273|                       -0.9861302|                          -0.9861302|                           -0.9796254|               -0.9789572|                   -0.9826617|               -0.9846112|               -0.9721276|               -0.9790242|                   -0.9681487|                   -0.9657525|                   -0.9817836|       -0.9845369|       -0.9730351|       -0.9774922|                       -0.9914871|                               -0.9852920|                   -0.9838717|                       -0.9856413|          3| SITTING             |

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
|          5| WALKING\_UPSTAIRS   |               0.2684595|              -0.0325270|              -0.1074715|                  0.9368218|                 -0.2659426|                 -0.0232035|                   0.0795443|                   0.0140130|                  -0.0255910|       0.0395191|      -0.1171956|       0.0424443|          -0.1430297|          -0.0559896|          -0.0534895|                       0.0435562|                          0.0435562|                          -0.2474035|              -0.2355169|                  -0.4734882|              -0.1614853|               0.0728903|              -0.4574707|                  -0.2897255|                  -0.1968179|                  -0.6067175|      -0.2636151|      -0.5166090|      -0.1398014|                      -0.1692615|                              -0.2646749|                  -0.3925645|                      -0.5713441|               -0.0457238|                0.1850225|               -0.3089390|                  -0.9535800|                  -0.9005117|                  -0.9214196|                   -0.2238966|                   -0.1250266|                   -0.6383690|       -0.4433423|       -0.4403458|       -0.2654513|           -0.3052452|           -0.6318220|           -0.2821544|                       -0.1367364|                          -0.1367364|                           -0.3101865|               -0.3546879|                   -0.5579881|               -0.0047382|                0.1650376|               -0.2892567|                   -0.2253278|                   -0.1053112|                   -0.6688257|       -0.5016856|       -0.4034864|       -0.3803780|                       -0.2540919|                               -0.3786167|                   -0.4404451|                       -0.5724850|
|         28| STANDING            |               0.2777951|              -0.0172635|              -0.1065794|                  0.9485148|                 -0.2476562|                 -0.0385831|                   0.0753132|                   0.0090736|                  -0.0026781|      -0.0253282|      -0.0739002|       0.0865173|          -0.1022484|          -0.0431365|          -0.0525896|                      -0.9254717|                         -0.9254717|                          -0.9595520|              -0.8942425|                  -0.9596810|              -0.9725198|              -0.8934304|              -0.9345030|                  -0.9685137|                  -0.9351690|                  -0.9647512|      -0.8804261|      -0.9481608|      -0.9266552|                      -0.9291465|                              -0.9527278|                  -0.9096524|                      -0.9587586|               -0.9777486|               -0.8756892|               -0.9051238|                  -0.9900594|                  -0.9628014|                  -0.9517822|                   -0.9686046|                   -0.9337682|                   -0.9697654|       -0.8840322|       -0.9400063|       -0.9254914|           -0.9283434|           -0.9729770|           -0.9564972|                       -0.9176583|                          -0.9176583|                           -0.9540684|               -0.8769175|                   -0.9562665|               -0.9802675|               -0.8744693|               -0.8976008|                   -0.9716728|                   -0.9369913|                   -0.9735721|       -0.8867068|       -0.9361016|       -0.9320391|                       -0.9238572|                               -0.9549632|                   -0.8784597|                       -0.9559834|
|          4| WALKING\_DOWNSTAIRS |               0.2799653|              -0.0098020|              -0.1067775|                  0.9477319|                 -0.0620853|                  0.1487148|                   0.0971863|                   0.0056378|                  -0.0072914|      -0.1028388|      -0.0704026|       0.0592639|          -0.0921283|          -0.0348435|          -0.0492836|                      -0.0491617|                         -0.0491617|                          -0.2288514|              -0.3466063|                  -0.5928430|              -0.0722392|              -0.1296066|              -0.4946835|                  -0.1616329|                  -0.1729416|                  -0.5839174|      -0.2402989|      -0.7175458|      -0.3183065|                      -0.0190743|                              -0.1752953|                  -0.4292134|                      -0.6217525|                0.0111935|               -0.2185983|               -0.4791860|                  -0.9552589|                  -0.9320660|                  -0.9377538|                   -0.1457597|                   -0.1462423|                   -0.6266470|       -0.3702447|       -0.6994535|       -0.4984808|           -0.3959955|           -0.8168582|           -0.3257801|                       -0.0819559|                          -0.0819559|                           -0.2168589|               -0.3805726|                   -0.6370795|                0.0390098|               -0.3225313|               -0.5126943|                   -0.2082501|                   -0.1772021|                   -0.6688673|       -0.4149190|       -0.6915184|       -0.6216585|                       -0.2636440|                               -0.2804268|                   -0.4576741|                       -0.6854709|
|         20| STANDING            |               0.2780769|              -0.0180695|              -0.1004028|                  0.9112318|                 -0.3059387|                  0.0708655|                   0.0763556|                   0.0116930|                  -0.0061368|      -0.0241335|      -0.0698309|       0.0773671|          -0.1020491|          -0.0432152|          -0.0518152|                      -0.9224069|                         -0.9224069|                          -0.9566249|              -0.8836750|                  -0.9479365|              -0.9619327|              -0.8981942|              -0.9299858|                  -0.9597105|                  -0.9357176|                  -0.9527411|      -0.8810194|      -0.9106491|      -0.9114099|                      -0.9212256|                              -0.9400079|                  -0.8794377|                      -0.9296000|               -0.9672100|               -0.8754104|               -0.9131425|                  -0.9819169|                  -0.9574627|                  -0.9424373|                   -0.9595283|                   -0.9356057|                   -0.9589363|       -0.8867492|       -0.9039139|       -0.9073433|           -0.9216442|           -0.9476331|           -0.9486699|                       -0.9106721|                          -0.9106721|                           -0.9384544|               -0.8436834|                   -0.9263288|               -0.9698062|               -0.8725254|               -0.9109959|                   -0.9630989|                   -0.9404742|                   -0.9639731|       -0.8905257|       -0.9012375|       -0.9148720|                       -0.9186519|                               -0.9360250|                   -0.8491273|                       -0.9272257|
|          1| LAYING              |               0.2215982|              -0.0405140|              -0.1132036|                 -0.2488818|                  0.7055498|                  0.4458177|                   0.0810865|                   0.0038382|                   0.0108342|      -0.0165531|      -0.0644861|       0.1486894|          -0.1072709|          -0.0415173|          -0.0740501|                      -0.8419292|                         -0.8419292|                          -0.9543963|              -0.8747595|                  -0.9634610|              -0.9390991|              -0.8670652|              -0.8826669|                  -0.9570739|                  -0.9224626|                  -0.9480609|      -0.8502492|      -0.9521915|      -0.9093027|                      -0.8617676|                              -0.9333004|                  -0.8621902|                      -0.9423669|               -0.9280565|               -0.8368274|               -0.8260614|                  -0.8968300|                  -0.9077200|                  -0.8523663|                   -0.9584821|                   -0.9241493|                   -0.9548551|       -0.8735439|       -0.9510904|       -0.9082847|           -0.9186085|           -0.9679072|           -0.9577902|                       -0.7951449|                          -0.7951449|                           -0.9282456|               -0.8190102|                   -0.9358410|               -0.9244374|               -0.8336256|               -0.8128916|                   -0.9641607|                   -0.9322179|                   -0.9605870|       -0.8822965|       -0.9512320|       -0.9165825|                       -0.7983009|                               -0.9218040|                   -0.8243194|                       -0.9326607|
|         15| STANDING            |               0.2789158|              -0.0183516|              -0.1059108|                  0.9655289|                 -0.1647132|                  0.0645976|                   0.0752281|                   0.0061726|                  -0.0065874|      -0.0262434|      -0.0659638|       0.0761947|          -0.1013588|          -0.0438507|          -0.0522784|                      -0.9612076|                         -0.9612076|                          -0.9814951|              -0.9469614|                  -0.9844071|              -0.9867250|              -0.9433488|              -0.9654735|                  -0.9853535|                  -0.9678847|                  -0.9826323|      -0.9503803|      -0.9751339|      -0.9682649|                      -0.9603373|                              -0.9790788|                  -0.9567339|                      -0.9831881|               -0.9889492|               -0.9319001|               -0.9516703|                  -0.9884321|                  -0.9656880|                  -0.9588102|                   -0.9854591|                   -0.9677204|                   -0.9853019|       -0.9477908|       -0.9713326|       -0.9681670|           -0.9715143|           -0.9881074|           -0.9812931|                       -0.9486004|                          -0.9486004|                           -0.9799948|               -0.9312868|                   -0.9814328|               -0.9900610|               -0.9302864|               -0.9479059|                   -0.9869341|                   -0.9699341|                   -0.9866545|       -0.9482752|       -0.9694429|       -0.9712822|                       -0.9502040|                               -0.9801841|                   -0.9288383|                       -0.9803297|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
