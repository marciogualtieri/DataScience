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

    ## [1] "fBodyAccJerk-bandsEnergy()-25,32" "tBodyGyro-arCoeff()-Z,4"         
    ## [3] "fBodyAcc-bandsEnergy()-1,16"      "tGravityAcc-arCoeff()-Z,2"       
    ## [5] "fBodyAcc-bandsEnergy()-1,24"      "fBodyAccJerk-bandsEnergy()-49,56"

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

    ## [1] "tBodyGyro-arCoeff()-Z,1"     "tBodyGyroMag-entropy()"     
    ## [3] "fBodyAcc-bandsEnergy()-1,16" "tBodyGyro-arCoeff()-X,1"    
    ## [5] "tGravityAcc-arCoeff()-X,2"   "tBodyAccJerk-arCoeff()-Y,4"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyAccJerk-mean()-X"  "fBodyAccJerk-mean()-Y" 
    ## [3] "tBodyGyroJerk-mean()-Y" "fBodyAcc-mean()-Z"     
    ## [5] "tBodyAccJerk-mean()-Y"  "fBodyAccMag-mean()"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccMag-std()"     "tBodyGyroJerk-std()-X" "tBodyGyroJerk-std()-Z"
    ## [4] "fBodyGyro-std()-Y"     "tBodyGyro-std()-X"     "tGravityAcc-std()-X"

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

    ## [1] "tBodyGyroJerk-correlation()-X,Z"     
    ## [2] "fBodyGyro-bandsEnergy()-9,16"        
    ## [3] "angle(tBodyAccJerkMean),gravityMean)"
    ## [4] "fBodyAcc-bandsEnergy()-1,8"          
    ## [5] "tGravityAcc-mean()-Z"                
    ## [6] "fBodyAcc-skewness()-X"

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
| 2269 |               0.2767809|              -0.0168214|              -0.1102416|                  0.8573662|                  0.1768663|                  0.3549723|                   0.0737889|                   0.0077682|                  -0.0075083|      -0.0278484|      -0.0769962|       0.0848124|          -0.0983182|          -0.0398207|          -0.0536099|                      -0.9970126|                         -0.9970126|                          -0.9954875|              -0.9979430|                  -0.9996422|              -0.9977030|              -0.9934836|              -0.9922404|                  -0.9971050|                  -0.9946327|                  -0.9918301|      -0.9989506|      -0.9984155|      -0.9961466|                      -0.9971965|                              -0.9956514|                  -0.9990454|                      -1.0000000|               -0.9979911|               -0.9933248|               -0.9914458|                  -0.9992713|                  -0.9980371|                  -0.9950126|                   -0.9967286|                   -0.9956422|                   -0.9922739|       -0.9994201|       -0.9982075|       -0.9938371|           -0.9987951|           -0.9990446|           -0.9986307|                       -0.9969688|                          -0.9969688|                           -0.9966697|               -0.9984614|                   -0.9999486|               -0.9980847|               -0.9925339|               -0.9906740|                   -0.9965316|                   -0.9975189|                   -0.9910919|       -0.9996057|       -0.9979955|       -0.9934486|                       -0.9963901|                               -0.9971090|                   -0.9980826|                       -0.9994716|           4|         20|
| 470  |               0.2974901|              -0.0040575|              -0.1608707|                  0.9536768|                 -0.0731890|                  0.1855834|                   0.0816781|                   0.0121727|                   0.0663481|      -0.0823398|      -0.0819251|       0.0870556|          -0.0737848|          -0.0338452|          -0.0007445|                      -0.8842389|                         -0.8842389|                          -0.9289607|              -0.8847718|                  -0.9501346|              -0.9722031|              -0.8361192|              -0.9056330|                  -0.9733004|                  -0.8574481|                  -0.9625169|      -0.9136352|      -0.9498758|      -0.8284062|                      -0.8669324|                              -0.8987102|                  -0.9040893|                      -0.9516433|               -0.9738002|               -0.8193629|               -0.8314905|                  -0.9592019|                  -0.9650935|                  -0.8333687|                   -0.9754000|                   -0.8456234|                   -0.9675574|       -0.9127685|       -0.9413502|       -0.8342791|           -0.9416230|           -0.9752086|           -0.8918091|                       -0.8648276|                          -0.8648276|                           -0.9113642|               -0.8735483|                   -0.9489009|               -0.9743233|               -0.8213333|               -0.8102413|                   -0.9804208|                   -0.8426423|                   -0.9712682|       -0.9134716|       -0.9368931|       -0.8512484|                       -0.8835589|                               -0.9299746|                   -0.8757529|                       -0.9485133|           5|          4|
| 1660 |               0.2346085|              -0.0138197|              -0.0933541|                  0.9375380|                 -0.2086116|                 -0.1824554|                   0.0815764|                   0.2395415|                   0.0671468|       0.3007891|      -0.3113462|      -0.1562510|           0.2123926|          -0.2409910|          -0.2296462|                      -0.1190435|                         -0.1190435|                          -0.2081369|               0.0585908|                  -0.2778087|              -0.1208369|              -0.0260617|              -0.1895419|                  -0.1906981|                  -0.0664666|                  -0.3417181|      -0.1582818|      -0.0061721|      -0.2682694|                       0.0579684|                               0.0398328|                  -0.1434252|                      -0.0772174|               -0.1424076|               -0.0973123|               -0.1879859|                  -0.9805990|                  -0.9271851|                  -0.9282132|                   -0.1421635|                   -0.0290636|                   -0.3847574|       -0.1798051|       -0.0793909|       -0.3323952|           -0.5995818|           -0.0624858|           -0.4548643|                       -0.0434036|                          -0.0434036|                            0.0330696|               -0.1771599|                   -0.0773395|               -0.1510246|               -0.1954799|               -0.2530913|                   -0.1669271|                   -0.0535129|                   -0.4248149|       -0.1947372|       -0.1342641|       -0.4158000|                       -0.2543860|                                0.0174713|                   -0.3492027|                       -0.1428866|           3|         13|
| 1841 |               0.2631829|              -0.0770394|              -0.2216574|                  0.9225924|                 -0.3442173|                  0.0502282|                   0.1643452|                  -0.3376748|                  -0.1070094|      -0.7806334|       0.4214378|       0.0344485|           0.0149362|          -0.1498184|           0.0939779|                       0.0497578|                          0.0497578|                          -0.3159306|               0.0613687|                  -0.6105790|              -0.1876909|               0.1602974|              -0.4304143|                  -0.2939920|                  -0.1424466|                  -0.6504531|      -0.4902666|      -0.5485294|      -0.0632493|                      -0.2522974|                              -0.1890281|                  -0.4523805|                      -0.6650728|               -0.1303300|                0.2366558|               -0.1574712|                  -0.9138768|                  -0.8507354|                  -0.7393029|                   -0.3300885|                   -0.0380974|                   -0.6913108|       -0.5946642|       -0.3597783|       -0.1345676|           -0.5230868|           -0.7666304|           -0.3419382|                       -0.2365625|                          -0.2365625|                           -0.2702635|               -0.3115105|                   -0.6768758|               -0.1086567|                0.1977565|               -0.0937202|                   -0.4369155|                    0.0118817|                   -0.7317216|       -0.6277746|       -0.2713557|       -0.2383548|                       -0.3462299|                               -0.3886099|                   -0.3390475|                       -0.7159176|           2|         13|
| 1306 |               0.1927008|              -0.0228530|              -0.1076756|                  0.9612429|                 -0.1500316|                 -0.0436236|                  -0.1297051|                  -0.0155429|                   0.4046426|      -0.0331078|      -0.0485484|       0.1593051|          -0.0172680|          -0.2520566|          -0.1826299|                      -0.0947457|                         -0.0947457|                          -0.1633133|              -0.3577983|                  -0.5620504|              -0.0872230|              -0.2163170|              -0.1473783|                  -0.1454698|                  -0.3042941|                  -0.2412863|      -0.4348501|      -0.4821553|      -0.1296794|                      -0.2708307|                              -0.1159936|                  -0.5018066|                      -0.5733843|               -0.1448497|               -0.2416807|               -0.2428343|                  -0.9786463|                  -0.9519045|                  -0.8915501|                   -0.0876306|                   -0.2145226|                   -0.3426125|       -0.5653523|       -0.4997466|       -0.1148561|           -0.4855569|           -0.6342866|           -0.3845863|                       -0.3153093|                          -0.3153093|                           -0.0788633|               -0.4523544|                   -0.5790387|               -0.1686015|               -0.3035035|               -0.3707193|                   -0.1074732|                   -0.1691117|                   -0.4475817|       -0.6068173|       -0.5144196|       -0.1909038|                       -0.4478552|                               -0.0398103|                   -0.5121972|                       -0.6165343|           1|         12|
| 2583 |               0.2807633|              -0.0126268|              -0.1083049|                  0.9751897|                 -0.1032623|                  0.0072260|                   0.0792111|                  -0.0074408|                  -0.0235489|      -0.0240572|      -0.0742168|       0.0913616|          -0.1010659|          -0.0376771|          -0.0545722|                      -0.9911801|                         -0.9911801|                          -0.9894556|              -0.9887118|                  -0.9936137|              -0.9952758|              -0.9812867|              -0.9845520|                  -0.9928744|                  -0.9839314|                  -0.9868079|      -0.9885880|      -0.9906204|      -0.9890188|                      -0.9897926|                              -0.9889622|                  -0.9915550|                      -0.9955125|               -0.9963395|               -0.9822261|               -0.9868728|                  -0.9972568|                  -0.9852742|                  -0.9908306|                   -0.9924700|                   -0.9836389|                   -0.9883552|       -0.9899806|       -0.9908459|       -0.9871650|           -0.9922118|           -0.9935137|           -0.9935416|                       -0.9916459|                          -0.9916459|                           -0.9903954|               -0.9900335|                   -0.9957534|               -0.9968486|               -0.9827675|               -0.9887232|                   -0.9926271|                   -0.9844088|                   -0.9883648|       -0.9903539|       -0.9909682|       -0.9875322|                       -0.9935200|                               -0.9914688|                   -0.9904242|                       -0.9960427|           5|         24|

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
| 1693 |               0.2782802|              -0.0171869|              -0.1085847|                  0.6816395|                 -0.5707760|                  0.3260452|                   0.0744996|                   0.0063600|                  -0.0041122|      -0.0268173|      -0.0656124|       0.1082936|          -0.0996534|          -0.0417527|          -0.0570905|                      -0.9981436|                         -0.9981436|                          -0.9923339|              -0.9922859|                  -0.9987490|              -0.9969553|              -0.9940776|              -0.9895087|                  -0.9966062|                  -0.9924706|                  -0.9854048|      -0.9992117|      -0.9982144|      -0.9948669|                      -0.9955847|                              -0.9928818|                  -0.9974143|                      -0.9994876|               -0.9971341|               -0.9953700|               -0.9932105|                  -0.9970446|                  -0.9981107|                  -0.9961951|                   -0.9962541|                   -0.9921939|                   -0.9875484|       -0.9996669|       -0.9981005|       -0.9940571|           -0.9986470|           -0.9983426|           -0.9970142|                       -0.9969201|                          -0.9969201|                           -0.9927412|               -0.9955508|                   -0.9996793|               -0.9971404|               -0.9953164|               -0.9958875|                   -0.9961304|                   -0.9923654|                   -0.9882486|       -0.9998768|       -0.9979538|       -0.9941579|                       -0.9978556|                               -0.9910579|                   -0.9947916|                       -0.9994913|         10| SITTING           |
| 1675 |               0.2730456|              -0.0097502|              -0.0977059|                  0.9414584|                 -0.0303771|                  0.2376682|                   0.0754876|                   0.0166209|                   0.0044103|      -0.0199848|      -0.0884630|       0.1299630|          -0.0992214|          -0.0432113|          -0.0542554|                      -0.9903616|                         -0.9903616|                          -0.9920696|              -0.9791601|                  -0.9974720|              -0.9973686|              -0.9849698|              -0.9879688|                  -0.9969407|                  -0.9886966|                  -0.9865770|      -0.9951499|      -0.9953565|      -0.9896300|                      -0.9857720|                              -0.9918568|                  -0.9954024|                      -0.9983957|               -0.9978402|               -0.9834431|               -0.9899508|                  -0.9962581|                  -0.9918178|                  -0.9847817|                   -0.9972511|                   -0.9888487|                   -0.9879980|       -0.9951723|       -0.9947752|       -0.9865110|           -0.9971786|           -0.9973352|           -0.9950509|                       -0.9859843|                          -0.9859843|                           -0.9924502|               -0.9925779|                   -0.9983868|               -0.9980408|               -0.9825670|               -0.9913206|                   -0.9979207|                   -0.9898486|                   -0.9878571|       -0.9951123|       -0.9943513|       -0.9865436|                       -0.9872615|                               -0.9919611|                   -0.9917391|                       -0.9980502|         20| SITTING           |
| 482  |               0.2997286|              -0.0384550|              -0.1218652|                  0.8987204|                 -0.3589181|                  0.0480458|                  -0.2331636|                  -0.0590952|                  -0.0916693|      -0.0358079|      -0.1231688|       0.0132481|          -0.3697452|           0.3323601|          -0.0521223|                       0.0753425|                          0.0753425|                          -0.0055426|               0.0677729|                  -0.1318278|              -0.1200260|               0.4817691|              -0.4073617|                  -0.1639465|                   0.2650639|                  -0.4291573|      -0.0653239|       0.1253800|      -0.0996351|                      -0.0099263|                              -0.0541253|                   0.0067815|                      -0.2362666|               -0.1455192|                0.5469439|               -0.3420588|                  -0.9835017|                  -0.9687162|                  -0.9504158|                   -0.0775164|                    0.3307394|                   -0.4602566|       -0.3361936|        0.2326010|       -0.2258974|           -0.2153057|           -0.1201961|           -0.1308409|                       -0.1504446|                          -0.1504446|                           -0.0310156|                0.0111371|                   -0.2062863|               -0.1557185|                0.4827775|               -0.3576771|                   -0.0696478|                    0.3140650|                   -0.4883431|       -0.4245033|        0.2857709|       -0.3429047|                       -0.3737373|                               -0.0081885|                   -0.1628900|                       -0.2228456|         20| WALKING           |
| 686  |               0.3083323|              -0.0312303|              -0.0237725|                  0.9459217|                 -0.2524448|                  0.0866207|                  -0.0912389|                  -0.3549363|                   0.3728187|       0.3617531|      -0.1400070|       0.2670109|          -0.0570527|          -0.0884815|          -0.2533838|                      -0.2245069|                         -0.2245069|                          -0.5247710|              -0.3511595|                  -0.7471021|              -0.3442625|              -0.2272854|              -0.4526093|                  -0.4922495|                  -0.3631801|                  -0.7401580|      -0.5193023|      -0.7212559|      -0.4222547|                      -0.2994938|                              -0.4705593|                  -0.6470798|                      -0.8040565|               -0.2707670|               -0.1706243|               -0.3577369|                  -0.9674678|                  -0.9704224|                  -0.9393934|                   -0.5032834|                   -0.3848217|                   -0.7727117|       -0.5682284|       -0.6308483|       -0.4311050|           -0.6338418|           -0.8510618|           -0.6633268|                       -0.2485248|                          -0.2485248|                           -0.4931176|               -0.5094201|                   -0.8059558|               -0.2436517|               -0.1936202|               -0.3569646|                   -0.5623518|                   -0.4589448|                   -0.8049622|       -0.5855181|       -0.5871034|       -0.4859208|                       -0.3378626|                               -0.5263895|                   -0.5098616|                       -0.8220874|          4| WALKING\_UPSTAIRS |
| 2216 |               0.2747697|              -0.0258125|              -0.1187935|                  0.9709690|                 -0.1477236|                 -0.0252346|                   0.0726509|                   0.0246651|                  -0.0221513|      -0.0367553|      -0.0878524|       0.0988040|          -0.1255669|          -0.0387990|          -0.0546718|                      -0.9690161|                         -0.9690161|                          -0.9807336|              -0.9318492|                  -0.9874687|              -0.9891782|              -0.9512230|              -0.9670525|                  -0.9856381|                  -0.9684915|                  -0.9795896|      -0.9289978|      -0.9764728|      -0.9697404|                      -0.9656037|                              -0.9775535|                  -0.9562732|                      -0.9878890|               -0.9926987|               -0.9423652|               -0.9558901|                  -0.9974309|                  -0.9768190|                  -0.9852616|                   -0.9861632|                   -0.9689788|                   -0.9817313|       -0.9191755|       -0.9585433|       -0.9629727|           -0.9781309|           -0.9892722|           -0.9854058|                       -0.9613316|                          -0.9613316|                           -0.9802186|               -0.9205161|                   -0.9852473|               -0.9946722|               -0.9405586|               -0.9522614|                   -0.9880794|                   -0.9718701|                   -0.9823176|       -0.9178514|       -0.9505159|       -0.9640722|                       -0.9637192|                               -0.9831708|                   -0.9144691|                       -0.9826245|         24| STANDING          |
| 213  |               0.2447147|              -0.0121917|              -0.0508673|                  0.9030106|                 -0.2645499|                 -0.2304575|                   0.1357769|                  -0.1021262|                   0.2989444|      -0.0415611|      -0.0190752|       0.1504023|          -0.0997120|          -0.1228637|          -0.1547369|                      -0.2752235|                         -0.2752235|                          -0.3710640|              -0.5208334|                  -0.6411358|              -0.3962668|              -0.3292946|              -0.3658326|                  -0.4388137|                  -0.4411364|                  -0.5032535|      -0.6812484|      -0.5165971|      -0.5181581|                      -0.4413606|                              -0.4310892|                  -0.5650676|                      -0.6766507|               -0.3780528|               -0.2916952|               -0.3136065|                  -0.9782783|                  -0.9868840|                  -0.9500383|                   -0.3772668|                   -0.3803702|                   -0.5601886|       -0.7440536|       -0.4901046|       -0.4611645|           -0.6979540|           -0.6476521|           -0.6273731|                       -0.4868149|                          -0.4868149|                           -0.4644981|               -0.5622825|                   -0.7070993|               -0.3709219|               -0.3165350|               -0.3385733|                   -0.3687218|                   -0.3547407|                   -0.6169436|       -0.7639643|       -0.4779300|       -0.4928599|                       -0.5936758|                               -0.5101418|                   -0.6365827|                       -0.7756339|         18| WALKING           |

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
| 2494 |               0.3974328|              -0.0218095|              -0.1291103|                  0.9064472|                 -0.1924287|                 -0.2504736|                  -0.1548960|                   0.0839226|                   0.1332631|      -0.0495962|      -0.0729197|       0.0507850|           0.0555144|          -0.0451140|          -0.1436155|                       0.1655728|                          0.1655728|                          -0.0897665|              -0.1857172|                  -0.4960628|               0.0600838|               0.0274141|              -0.0414868|                  -0.1385703|                  -0.1161310|                  -0.1677050|      -0.2665267|      -0.3508215|      -0.2050105|                       0.1170407|                               0.0228903|                  -0.4379894|                      -0.4740649|                0.1288286|                0.0553640|                0.0233725|                  -0.9760597|                  -0.9612820|                  -0.9635468|                   -0.0972479|                   -0.0835725|                   -0.2236542|       -0.2426299|       -0.4416527|       -0.2881795|           -0.5410782|           -0.4819495|           -0.3932197|                        0.1026227|                           0.1026227|                           -0.0341321|               -0.3746661|                   -0.4771537|                0.1547945|                0.0034507|               -0.0217169|                   -0.1336568|                   -0.1099185|                   -0.2762516|       -0.2463278|       -0.5100833|       -0.3827279|                       -0.0771884|                               -0.1172616|                   -0.4381678|                       -0.5184665|         16| WALKING\_DOWNSTAIRS |
| 2439 |               0.3567819|               0.0087010|              -0.1004551|                  0.9574982|                 -0.1587415|                 -0.0371165|                   0.2627197|                  -0.1177612|                   0.0778047|      -0.1388924|      -0.1097680|       0.0171194|          -0.1097460|           0.0264910|           0.0037061|                       0.2097464|                          0.2097464|                          -0.0007688|              -0.1136894|                  -0.2538648|               0.1869105|               0.1877633|              -0.0664486|                   0.0715583|                  -0.0535637|                  -0.1420935|      -0.2277325|      -0.0305453|      -0.1080074|                       0.2208994|                               0.1736960|                  -0.1600827|                      -0.2094189|                0.1932390|                0.1997394|               -0.0909173|                  -0.9484532|                  -0.9015626|                  -0.9709902|                    0.1423436|                   -0.0165101|                   -0.2493713|       -0.3027901|       -0.1579998|       -0.2989512|           -0.3664291|           -0.2107135|           -0.1371116|                        0.1739657|                           0.1739657|                            0.1914260|               -0.2217400|                   -0.2213880|                0.1957060|                0.1301236|               -0.1806366|                    0.1157096|                   -0.0422578|                   -0.3592530|       -0.3297418|       -0.2535539|       -0.4385791|                       -0.0361127|                                0.2071231|                   -0.4116046|                       -0.2927475|          7| WALKING\_DOWNSTAIRS |
| 3700 |               0.2502641|               0.0269359|              -0.2433694|                  0.9661537|                  0.0272528|                 -0.0867656|                   0.0757710|                   0.0055439|                   0.0972583|      -0.0305910|      -0.0802410|       0.0638595|          -0.0979584|          -0.0045694|          -0.0372948|                      -0.8290246|                         -0.8290246|                          -0.9560233|              -0.8714482|                  -0.9549155|              -0.9746128|              -0.8995549|              -0.8555223|                  -0.9741454|                  -0.9343355|                  -0.9554479|      -0.9304740|      -0.8832998|      -0.9114106|                      -0.8843125|                              -0.9538044|                  -0.8954404|                      -0.9638807|               -0.9767378|               -0.8905490|               -0.7505563|                  -0.9708058|                  -0.9094708|                  -0.7507887|                   -0.9731952|                   -0.9351680|                   -0.9599824|       -0.9293397|       -0.8333674|       -0.8929357|           -0.9542081|           -0.9561130|           -0.9560976|                       -0.8047478|                          -0.8047478|                           -0.9595418|               -0.8442078|                   -0.9628739|               -0.9775203|               -0.8918272|               -0.7218119|                   -0.9744909|                   -0.9409747|                   -0.9629713|       -0.9297791|       -0.8098252|       -0.8970178|                       -0.8004031|                               -0.9674383|                   -0.8405202|                       -0.9637325|          3| SITTING             |
| 6253 |               0.2740036|              -0.0172009|              -0.1051602|                 -0.1337423|                  0.9335122|                  0.1888041|                   0.0832420|                   0.0073940|                   0.0048256|      -0.0277222|      -0.0859108|       0.0663475|          -0.0956224|          -0.0404804|          -0.0583423|                      -0.9918572|                         -0.9918572|                          -0.9878498|              -0.9877816|                  -0.9936154|              -0.9876700|              -0.9862906|              -0.9871577|                  -0.9900069|                  -0.9827601|                  -0.9844116|      -0.9917794|      -0.9941590|      -0.9733866|                      -0.9895384|                              -0.9890315|                  -0.9867591|                      -0.9917364|               -0.9885685|               -0.9902067|               -0.9894202|                  -0.9890512|                  -0.9983116|                  -0.9911310|                   -0.9903238|                   -0.9833762|                   -0.9865150|       -0.9941885|       -0.9946524|       -0.9755814|           -0.9936773|           -0.9950205|           -0.9819549|                       -0.9897324|                          -0.9897324|                           -0.9888838|               -0.9821788|                   -0.9906757|               -0.9888362|               -0.9922773|               -0.9910506|                   -0.9915943|                   -0.9854163|                   -0.9871412|       -0.9949480|       -0.9949538|       -0.9784664|                       -0.9904050|                               -0.9871669|                   -0.9819678|                       -0.9894862|         11| LAYING              |
| 2072 |               0.3625961|              -0.0360614|              -0.2302628|                  0.9222972|                 -0.2466858|                 -0.0517972|                  -0.0737305|                   0.0656208|                  -0.5457050|       0.1661812|      -0.5174049|      -0.0140797|          -0.0647138|           0.2425327|          -0.0586104|                      -0.1957539|                         -0.1957539|                          -0.6901744|              -0.2048260|                  -0.7711158|              -0.5877214|              -0.4186143|              -0.2794712|                  -0.7197316|                  -0.7064094|                  -0.8152847|      -0.6367583|      -0.4747768|      -0.3386724|                      -0.5434995|                              -0.7395930|                  -0.6291750|                      -0.8347008|               -0.4214674|               -0.1033920|               -0.0778509|                  -0.9588397|                  -0.9189422|                  -0.9088763|                   -0.6808530|                   -0.6925982|                   -0.8213759|       -0.5995863|       -0.2263274|       -0.0930170|           -0.7850850|           -0.8107507|           -0.6924987|                       -0.4059796|                          -0.4059796|                           -0.7552339|               -0.2722352|                   -0.8347816|               -0.3675458|               -0.0286093|               -0.0470441|                   -0.6694554|                   -0.6979298|                   -0.8254532|       -0.5961922|       -0.1119257|       -0.1088290|                       -0.4330999|                               -0.7773926|                   -0.2135093|                       -0.8462834|         30| WALKING\_UPSTAIRS   |
| 1356 |               0.2336308|              -0.0193296|              -0.0944974|                  0.8886936|                 -0.3730491|                 -0.1828076|                   0.2601328|                   0.1141294|                  -0.0152495|       0.0723992|      -0.1086142|      -0.0729170|          -0.0827544|          -0.1039641|          -0.0103521|                      -0.2375916|                         -0.2375916|                          -0.4933817|              -0.5805476|                  -0.6971153|              -0.4684272|              -0.2511178|              -0.5630050|                  -0.5126796|                  -0.4008752|                  -0.7026873|      -0.6306743|      -0.6932915|      -0.5094229|                      -0.3748985|                              -0.4770318|                  -0.7314974|                      -0.8058333|               -0.3191885|               -0.1522420|               -0.3695235|                  -0.8906681|                  -0.8790812|                  -0.9446101|                   -0.4650364|                   -0.4032643|                   -0.7319266|       -0.7390221|       -0.6404469|       -0.5427612|           -0.6007682|           -0.8113290|           -0.5919763|                       -0.3575131|                          -0.3575131|                           -0.4924114|               -0.6988733|                   -0.7927452|               -0.2684806|               -0.1565328|               -0.3253036|                   -0.4628007|                   -0.4499030|                   -0.7596884|       -0.7744305|       -0.6137613|       -0.5959537|                       -0.4473310|                               -0.5156233|                   -0.7280431|                       -0.7904915|          3| WALKING\_UPSTAIRS   |

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
|         24| WALKING\_UPSTAIRS   |               0.2698811|              -0.0251979|              -0.1142486|                  0.9063695|                 -0.2374984|                 -0.2271349|                   0.0862310|                  -0.0150816|                  -0.0132354|       0.0883164|      -0.1059329|       0.0248291|          -0.1468008|          -0.0317351|          -0.0498427|                      -0.2264028|                         -0.2264028|                          -0.4884876|              -0.3344358|                  -0.6587516|              -0.3957906|              -0.2524125|              -0.3127922|                  -0.5156446|                  -0.5276042|                  -0.4833910|      -0.5031887|      -0.5466210|      -0.3721829|                      -0.3223010|                              -0.4298008|                  -0.5646650|                      -0.6461147|               -0.3443994|               -0.1168045|               -0.2556010|                  -0.9621906|                  -0.9166908|                  -0.9349529|                   -0.4987647|                   -0.5152208|                   -0.5238073|       -0.5774264|       -0.5685341|       -0.2745963|           -0.6404895|           -0.6466444|           -0.6489753|                       -0.3068545|                          -0.3068545|                           -0.4410687|               -0.5039291|                   -0.6381804|               -0.3261656|               -0.1077877|               -0.2831434|                   -0.5271047|                   -0.5358433|                   -0.5627271|       -0.6029455|       -0.5861778|       -0.3119964|                       -0.4062834|                               -0.4596478|                   -0.5490710|                       -0.6538770|
|         11| WALKING\_DOWNSTAIRS |               0.2916056|              -0.0178098|              -0.1110701|                  0.9417464|                 -0.2003219|                  0.1323717|                   0.0897169|                   0.0252274|                  -0.0225209|      -0.1250687|      -0.0262775|       0.0575245|          -0.0220916|          -0.0520273|          -0.0373048|                       0.1262277|                          0.1262277|                          -0.1982061|              -0.1978834|                  -0.5992948|               0.0351937|               0.0247508|              -0.3776248|                  -0.1204630|                  -0.1774792|                  -0.5302255|      -0.3187770|      -0.5282545|      -0.2734591|                       0.0902808|                              -0.0974550|                  -0.4561701|                      -0.6683405|                0.1424566|                0.0708123|               -0.3240269|                  -0.9544975|                  -0.9263105|                  -0.9258149|                   -0.0834213|                   -0.1268167|                   -0.5797105|       -0.3740690|       -0.4959117|       -0.3189596|           -0.5343749|           -0.6845933|           -0.4805592|                        0.0507744|                           0.0507744|                           -0.1270172|               -0.3393498|                   -0.6777506|                0.1799068|                0.0262777|               -0.3486266|                   -0.1283416|                   -0.1304438|                   -0.6289027|       -0.3977228|       -0.4811275|       -0.3972205|                       -0.1371231|                               -0.1736618|                   -0.3805594|                       -0.7142297|
|         19| STANDING            |               0.2781723|              -0.0154244|              -0.1090419|                  0.9440458|                 -0.2238978|                  0.1306437|                   0.0754120|                   0.0099134|                   0.0012922|      -0.0250906|      -0.0631430|       0.0710520|          -0.0990468|          -0.0422919|          -0.0523770|                      -0.9605057|                         -0.9605057|                          -0.9830689|              -0.9417450|                  -0.9858016|              -0.9873520|              -0.9528729|              -0.9685434|                  -0.9850396|                  -0.9700113|                  -0.9834633|      -0.9478656|      -0.9750617|      -0.9651006|                      -0.9689108|                              -0.9791354|                  -0.9585781|                      -0.9845366|               -0.9899110|               -0.9444303|               -0.9525997|                  -0.9924115|                  -0.9714266|                  -0.9588620|                   -0.9847920|                   -0.9705433|                   -0.9861425|       -0.9461097|       -0.9695763|       -0.9607343|           -0.9751267|           -0.9880967|           -0.9834539|                       -0.9625493|                          -0.9625493|                           -0.9796408|               -0.9379510|                   -0.9830694|               -0.9911617|               -0.9431938|               -0.9477540|                   -0.9859137|                   -0.9735885|                   -0.9875246|       -0.9466070|       -0.9669672|       -0.9632128|                       -0.9642591|                               -0.9791791|                   -0.9367235|                       -0.9822286|
|          2| SITTING             |               0.2770874|              -0.0156880|              -0.1092183|                  0.9404773|                 -0.1056300|                  0.1987268|                   0.0722564|                   0.0116955|                   0.0076055|      -0.0454707|      -0.0599287|       0.0412277|          -0.0936328|          -0.0415602|          -0.0435851|                      -0.9678936|                         -0.9678936|                          -0.9867747|              -0.9460351|                  -0.9910815|              -0.9858038|              -0.9573435|              -0.9701622|                  -0.9878488|                  -0.9771397|                  -0.9851291|      -0.9826214|      -0.9821009|      -0.9598148|                      -0.9612737|                              -0.9838747|                  -0.9718406|                      -0.9898620|               -0.9868223|               -0.9507045|               -0.9598282|                  -0.9799888|                  -0.9567503|                  -0.9544159|                   -0.9880559|                   -0.9779840|                   -0.9875182|       -0.9857420|       -0.9789195|       -0.9598037|           -0.9897090|           -0.9908896|           -0.9855423|                       -0.9530814|                          -0.9530814|                           -0.9844759|               -0.9613136|                   -0.9895949|               -0.9873621|               -0.9500738|               -0.9568629|                   -0.9894591|                   -0.9808042|                   -0.9885708|       -0.9868085|       -0.9773562|       -0.9635227|                       -0.9555756|                               -0.9841242|                   -0.9613857|                       -0.9896329|
|         19| WALKING             |               0.2739312|              -0.0191774|              -0.1227367|                  0.9352226|                 -0.2233381|                 -0.0898429|                   0.0822246|                   0.0144113|                  -0.0327529|      -0.0274971|      -0.0751569|       0.0798107|          -0.0832353|          -0.0307128|          -0.0603092|                       0.0648173|                          0.0648173|                           0.1094510|               0.1000451|                  -0.1647000|              -0.0299816|               0.1692586|              -0.1044234|                   0.0336381|                   0.0107319|                  -0.1293679|       0.2281424|      -0.0973550|      -0.0105047|                       0.0322272|                               0.0730180|                  -0.0952460|                      -0.2624428|               -0.0489049|                0.1818016|               -0.1394779|                  -0.9698615|                  -0.9586512|                  -0.9291879|                    0.1103067|                    0.0809271|                   -0.1793905|       -0.0264358|       -0.1144061|       -0.1042030|            0.0801187|           -0.2915948|           -0.2134941|                       -0.0993927|                          -0.0993927|                            0.0356559|               -0.0218463|                   -0.2714875|               -0.0578821|                0.1126151|               -0.2338723|                    0.0908366|                    0.0854011|                   -0.2278298|       -0.1083888|       -0.1330103|       -0.2202712|                       -0.3247934|                               -0.0222870|                   -0.1415984|                       -0.3361487|
|         21| STANDING            |               0.2769522|              -0.0167085|              -0.1104179|                  0.8812133|                 -0.3461556|                 -0.2076857|                   0.0754544|                   0.0100621|                  -0.0033209|      -0.0191732|      -0.0738116|       0.0864863|          -0.1031998|          -0.0404301|          -0.0538212|                      -0.9587743|                         -0.9587743|                          -0.9747652|              -0.9498372|                  -0.9768571|              -0.9783277|              -0.9496949|              -0.9602741|                  -0.9768030|                  -0.9645030|                  -0.9747806|      -0.9569900|      -0.9600826|      -0.9594326|                      -0.9622913|                              -0.9706343|                  -0.9567230|                      -0.9761268|               -0.9814200|               -0.9436016|               -0.9461234|                  -0.9829067|                  -0.9776814|                  -0.9585900|                   -0.9770634|                   -0.9639215|                   -0.9779157|       -0.9625145|       -0.9559792|       -0.9593270|           -0.9718665|           -0.9768159|           -0.9754273|                       -0.9569199|                          -0.9569199|                           -0.9716065|               -0.9456144|                   -0.9761537|               -0.9828928|               -0.9435452|               -0.9424589|                   -0.9795305|                   -0.9660241|                   -0.9797233|       -0.9645303|       -0.9540809|       -0.9631246|                       -0.9600418|                               -0.9719261|                   -0.9477632|                       -0.9777066|

Saving the Output Data to Disk
------------------------------

Let's finally save our clean data-sets to `*.txt` files:

``` r
suppressWarnings(dir.create("./tidy_data"))
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
