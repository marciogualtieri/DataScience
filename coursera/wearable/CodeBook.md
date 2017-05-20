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

    ## [1] "tBodyGyroMag-max()"           "fBodyAcc-kurtosis()-X"       
    ## [3] "fBodyBodyGyroJerkMag-std()"   "fBodyGyro-max()-X"           
    ## [5] "tBodyGyro-entropy()-X"        "fBodyAcc-bandsEnergy()-49,56"

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

    ## [1] "fBodyAcc-maxInds-Z"        "fBodyAccJerk-skewness()-Y"
    ## [3] "fBodyGyro-max()-X"         "fBodyAccJerk-meanFreq()-X"
    ## [5] "tGravityAcc-arCoeff()-Z,4" "tBodyAccMag-sma()"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-Z"       "tBodyAccJerk-mean()-Z"  
    ## [3] "tBodyGyroJerk-mean()-Z"  "tGravityAcc-mean()-Z"   
    ## [5] "fBodyBodyGyroMag-mean()" "fBodyGyro-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccJerk-std()-X"   "tBodyGyroMag-std()"    
    ## [3] "tBodyAcc-std()-Y"       "tBodyAccJerk-std()-Y"  
    ## [5] "tBodyGyroJerkMag-std()" "tGravityAcc-std()-X"

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

    ## [1] "tBodyGyroJerk-energy()-X"      "fBodyBodyGyroJerkMag-maxInds" 
    ## [3] "tBodyGyro-min()-Y"             "fBodyBodyGyroMag-std()"       
    ## [5] "fBodyGyro-bandsEnergy()-17,32" "fBodyGyro-maxInds-X"

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
| 894  |               0.1894812|              -0.0094321|              -0.0625153|                  0.8411651|                  0.0999949|                 -0.4042844|                   0.0801443|                   0.1405594|                  -0.1308986|      -0.4108816|       0.0822990|       0.3457325|           0.4558121|          -0.4868289|          -0.1906172|                      -0.1662949|                         -0.1662949|                          -0.3900421|               0.0065420|                  -0.5910325|              -0.2728351|              -0.5084310|              -0.3573133|                  -0.3612950|                  -0.6514718|                  -0.6340092|      -0.0624269|      -0.2843420|      -0.3777422|                      -0.3206164|                              -0.3861884|                  -0.4287682|                      -0.6451218|               -0.2436409|               -0.5123555|               -0.0837980|                  -0.9187203|                  -0.8715052|                  -0.8390449|                   -0.2559276|                   -0.6362808|                   -0.6438631|       -0.2610607|       -0.1697629|       -0.3509977|           -0.5986091|           -0.6097451|           -0.6258140|                       -0.3843442|                          -0.3843442|                           -0.4334767|               -0.3078429|                   -0.6721110|               -0.2323676|               -0.5447333|               -0.0233485|                   -0.2165193|                   -0.6439617|                   -0.6514828|       -0.3239955|       -0.1119653|       -0.4016786|                       -0.5188599|                               -0.5039697|                   -0.3471486|                       -0.7351089|           2|
| 536  |               0.2753702|              -0.0170708|              -0.1096177|                 -0.4311370|                  0.9612038|                  0.2189692|                   0.0783528|                   0.0073824|                   0.0068540|      -0.0339180|      -0.0944317|       0.1336362|          -0.1035505|          -0.0399246|          -0.0875535|                      -0.9926354|                         -0.9926354|                          -0.9956231|              -0.9648451|                  -0.9959484|              -0.9932598|              -0.9903485|              -0.9928598|                  -0.9944341|                  -0.9913283|                  -0.9962964|      -0.9898787|      -0.9867488|      -0.9554320|                      -0.9954239|                              -0.9965636|                  -0.9785175|                      -0.9972929|               -0.9912782|               -0.9914048|               -0.9883056|                  -0.9856561|                  -0.9930283|                  -0.9947336|                   -0.9942149|                   -0.9911289|                   -0.9961741|       -0.9894112|       -0.9751844|       -0.9505839|           -0.9944296|           -0.9956999|           -0.9963612|                       -0.9938457|                          -0.9938457|                           -0.9963972|               -0.9686169|                   -0.9975654|               -0.9902943|               -0.9914426|               -0.9855605|                   -0.9944422|                   -0.9914815|                   -0.9944126|       -0.9892757|       -0.9699627|       -0.9533519|                       -0.9927196|                               -0.9947110|                   -0.9676248|                       -0.9978097|           6|
| 1582 |               0.2718642|              -0.0197095|              -0.1089592|                 -0.1281085|                  0.3818476|                  0.9022997|                   0.0696208|                   0.0075410|                   0.0067263|      -0.0313633|      -0.0625122|       0.0902412|          -0.1028178|          -0.0356243|          -0.0516849|                      -0.9651605|                         -0.9651605|                          -0.9917047|              -0.9753771|                  -0.9896986|              -0.9843868|              -0.9795890|              -0.9787060|                  -0.9889369|                  -0.9921876|                  -0.9886060|      -0.9852911|      -0.9770310|      -0.9921133|                      -0.9788103|                              -0.9874851|                  -0.9793231|                      -0.9873959|               -0.9752692|               -0.9487245|               -0.9589053|                  -0.9847011|                  -0.9867464|                  -0.9792257|                   -0.9889611|                   -0.9923537|                   -0.9899287|       -0.9799736|       -0.9720157|       -0.9895795|           -0.9940053|           -0.9846602|           -0.9950919|                       -0.9719814|                          -0.9719814|                           -0.9899215|               -0.9751926|                   -0.9866606|               -0.9719591|               -0.9393694|               -0.9514265|                   -0.9899736|                   -0.9931256|                   -0.9897046|       -0.9789234|       -0.9693266|       -0.9895100|                       -0.9714142|                               -0.9927853|                   -0.9763808|                       -0.9861075|           6|
| 1171 |               0.3504418|              -0.0204009|              -0.1856847|                  0.9290029|                  0.0503235|                  0.0784797|                   0.0402682|                   0.2021961|                  -0.2386981|      -0.4944877|      -0.3758445|      -0.0065449|          -0.0734561|           0.2601438|          -0.1504266|                       0.2108778|                          0.2108778|                           0.0310872|              -0.1130758|                  -0.4654915|               0.2073738|              -0.0680793|              -0.1969524|                   0.2400978|                  -0.1486006|                  -0.3202794|      -0.3728872|      -0.3052125|      -0.1278556|                       0.3048240|                               0.1815111|                  -0.4249209|                      -0.5210284|                0.2942905|               -0.1608430|               -0.2400258|                  -0.9610066|                  -0.8175486|                  -0.8598129|                    0.2738344|                   -0.1465936|                   -0.3703810|       -0.5441078|       -0.3110185|       -0.2006080|           -0.4449925|           -0.5375166|           -0.3065202|                        0.1340753|                           0.1340753|                            0.1677517|               -0.4171438|                   -0.5453319|                0.3269328|               -0.2687509|               -0.3299919|                    0.1954742|                   -0.2062357|                   -0.4176901|       -0.5993845|       -0.3194476|       -0.2990112|                       -0.1518492|                                0.1410916|                   -0.5132873|                       -0.6106611|           3|
| 1393 |               0.2780260|              -0.0148393|              -0.1180617|                  0.9325233|                 -0.3147645|                 -0.0107221|                   0.0831335|                   0.0924055|                   0.0581564|       0.2261312|      -0.2060889|       0.0195257|           0.0443042|          -0.0757674|          -0.0778382|                      -0.8154823|                         -0.8154823|                          -0.9330891|              -0.4213074|                  -0.9392947|              -0.9391910|              -0.7836257|              -0.8995534|                  -0.9406680|                  -0.8923096|                  -0.9616621|      -0.5844269|      -0.8889427|      -0.8734484|                      -0.8788854|                              -0.9289870|                  -0.7137432|                      -0.9438570|               -0.9399465|               -0.6366430|               -0.8447005|                  -0.9608642|                  -0.8784140|                  -0.8733399|                   -0.9443236|                   -0.8883150|                   -0.9680455|       -0.3624565|       -0.8025112|       -0.8403809|           -0.8948490|           -0.9613156|           -0.9389708|                       -0.8437080|                          -0.8437080|                           -0.9319286|               -0.4296197|                   -0.9419185|               -0.9400718|               -0.5996875|               -0.8295740|                   -0.9541412|                   -0.8913963|                   -0.9734567|       -0.3289431|       -0.7654608|       -0.8452171|                       -0.8497878|                               -0.9347914|                   -0.3820414|                       -0.9430601|           5|
| 2375 |               0.1515778|              -0.0939952|              -0.2757788|                  0.8492457|                 -0.4165521|                 -0.2104263|                  -0.0448887|                  -0.1280944|                  -0.2833159|       0.2938577|      -0.5839559|       0.0209807|          -0.2397942|          -0.0178898|          -0.2771112|                      -0.1434353|                         -0.1434353|                          -0.4437557|              -0.1900300|                  -0.5333246|              -0.2578841|              -0.2654154|              -0.2377333|                  -0.3559620|                  -0.5446068|                  -0.4539492|      -0.6047982|      -0.3504427|      -0.1098316|                      -0.3020686|                              -0.2261201|                  -0.4738698|                      -0.5374460|               -0.2866609|               -0.1015503|               -0.2421512|                  -0.8475558|                  -0.8598679|                  -0.7567797|                   -0.3399709|                   -0.5275003|                   -0.4995351|       -0.7203662|       -0.3337070|        0.0057844|           -0.6322897|           -0.4963119|           -0.4899046|                       -0.3469016|                          -0.3469016|                           -0.2684665|               -0.4014640|                   -0.5204824|               -0.2982636|               -0.0807464|               -0.3064989|                   -0.3821959|                   -0.5406377|                   -0.5429254|       -0.7580972|       -0.3282508|       -0.0510238|                       -0.4748190|                               -0.3314629|                   -0.4548961|                       -0.5320302|           2|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 1278 |               0.1495707|              -0.0051894|              -0.0403712|                  0.9596386|                 -0.0920827|                  0.1419835|                   0.1227611|                  -0.0897229|                  -0.1382700|      -0.0555169|       0.0428832|       0.0822089|          -0.1068974|          -0.1220420|          -0.0161638|                      -0.2761778|                         -0.2761778|                          -0.3571175|              -0.3738529|                  -0.6372710|              -0.2518529|              -0.3607338|              -0.5204599|                  -0.2078199|                  -0.4223381|                  -0.5602135|      -0.2473274|      -0.7079006|      -0.3914026|                      -0.1739107|                              -0.3473660|                  -0.4911670|                      -0.6794428|               -0.2643140|               -0.3622618|               -0.4682873|                  -0.9648070|                  -0.9562132|                  -0.9396246|                   -0.2414185|                   -0.4527786|                   -0.6049448|       -0.3116378|       -0.7071097|       -0.5297967|           -0.4677074|           -0.7867681|           -0.4995791|                       -0.2893196|                          -0.2893196|                           -0.3343211|               -0.4250994|                   -0.7013077|               -0.2692237|               -0.4030029|               -0.4810136|                   -0.3531019|                   -0.5350044|                   -0.6483249|       -0.3356837|       -0.7086261|       -0.6283971|                       -0.4742800|                               -0.3221798|                   -0.4786243|                       -0.7553010| WALKING\_DOWNSTAIRS |
| 1050 |               0.2200931|              -0.0191442|              -0.0908758|                  0.9420515|                 -0.1844214|                 -0.1812601|                   0.3564400|                  -0.0619960|                  -0.5977284|      -0.0776262|      -0.1175864|       0.0398604|          -0.1398179|           0.4309031|           0.0137824|                      -0.0965011|                         -0.0965011|                          -0.2103729|              -0.0962852|                  -0.2909781|              -0.1853003|               0.0298539|              -0.0377093|                  -0.2609727|                  -0.2230108|                  -0.2304639|      -0.3940772|       0.0989683|      -0.3302515|                      -0.0117214|                              -0.1259656|                  -0.1663879|                      -0.1157202|               -0.2433669|                0.0854622|               -0.0540707|                  -0.9762836|                  -0.9256274|                  -0.9504326|                   -0.2385333|                   -0.1778212|                   -0.2735104|       -0.3557990|       -0.0443644|       -0.3960902|           -0.6009178|           -0.0848861|           -0.4485782|                       -0.0988415|                          -0.0988415|                           -0.1115077|               -0.2315819|                   -0.0989014|               -0.2674428|                0.0457703|               -0.1414046|                   -0.2828026|                   -0.1826599|                   -0.3131601|       -0.3549934|       -0.1517444|       -0.4744826|                       -0.2920498|                               -0.0996076|                   -0.4232602|                       -0.1400672| WALKING\_DOWNSTAIRS |
| 77   |               0.2576862|               0.0026939|              -0.0912672|                  0.9025197|                 -0.3210624|                 -0.0911886|                  -0.2528117|                   0.3792269|                   0.3636029|      -0.1333838|       0.0146444|       0.1502384|          -0.3140563|          -0.2676662|           0.1247996|                      -0.0503426|                         -0.0503426|                          -0.1049088|              -0.0433047|                  -0.2844733|              -0.1563416|               0.2641386|              -0.1699335|                  -0.1605610|                   0.0075406|                  -0.3308687|      -0.1547378|      -0.0232749|      -0.1276668|                      -0.0074776|                              -0.0077854|                  -0.1251035|                      -0.1487109|               -0.2729787|                0.3077789|               -0.1431978|                  -0.9754073|                  -0.9852741|                  -0.9722395|                   -0.0995847|                    0.1173108|                   -0.3776198|       -0.2416647|       -0.0848576|       -0.1528104|           -0.2760567|           -0.1512453|           -0.3786329|                       -0.1742025|                          -0.1742025|                            0.0177538|               -0.0703851|                   -0.0937461|               -0.3243635|                0.2479012|               -0.1966303|                   -0.1152063|                    0.1633945|                   -0.4214593|       -0.2723772|       -0.1315999|       -0.2385915|                       -0.4145647|                                0.0421220|                   -0.1923883|                       -0.0882967| WALKING             |
| 1419 |               0.2754065|              -0.0194270|              -0.1036544|                  0.9289752|                 -0.1304995|                  0.2629604|                   0.0711637|                  -0.0077640|                  -0.0032495|      -0.0270104|      -0.0719741|       0.0937202|          -0.0934865|          -0.0485188|          -0.0699466|                      -0.9842610|                         -0.9842610|                          -0.9884868|              -0.9843081|                  -0.9914873|              -0.9917900|              -0.9725312|              -0.9834825|                  -0.9896243|                  -0.9769808|                  -0.9908842|      -0.9905742|      -0.9819955|      -0.9730851|                      -0.9837896|                              -0.9870741|                  -0.9814232|                      -0.9893588|               -0.9938404|               -0.9761185|               -0.9722273|                  -0.9965261|                  -0.9954519|                  -0.9794296|                   -0.9902220|                   -0.9773950|                   -0.9916386|       -0.9935737|       -0.9796988|       -0.9782661|           -0.9928027|           -0.9900330|           -0.9853427|                       -0.9854173|                          -0.9854173|                           -0.9886354|               -0.9798025|                   -0.9891530|               -0.9948646|               -0.9786705|               -0.9674325|                   -0.9918843|                   -0.9795792|                   -0.9907935|       -0.9945543|       -0.9783924|       -0.9822149|                       -0.9878278|                               -0.9898656|                   -0.9818994|                       -0.9891120| SITTING             |
| 668  |               0.2809633|              -0.0247158|              -0.1534380|                  0.9341123|                 -0.2552535|                  0.0919843|                   0.2089222|                  -0.0305784|                   0.0750715|      -0.2344594|      -0.0013859|       0.0698946|          -0.3174749|           0.0164636|          -0.0921759|                      -0.1375766|                         -0.1375766|                          -0.3871408|              -0.2201292|                  -0.6484598|              -0.3108908|              -0.1483014|              -0.4722353|                  -0.3722929|                  -0.2925462|                  -0.6368229|      -0.1766288|      -0.6342644|      -0.3552407|                      -0.2642683|                              -0.3758464|                  -0.4815477|                      -0.7098424|               -0.1959453|               -0.0802870|               -0.2975636|                  -0.9741528|                  -0.9662085|                  -0.9202296|                   -0.3503071|                   -0.2851076|                   -0.6855766|       -0.2609488|       -0.5728237|       -0.3287640|           -0.4549132|           -0.7965720|           -0.5481139|                       -0.2112577|                          -0.2112577|                           -0.3935890|               -0.4095837|                   -0.7034275|               -0.1548122|               -0.1034413|               -0.2647534|                   -0.3849107|                   -0.3277235|                   -0.7353054|       -0.2907592|       -0.5418116|       -0.3815639|                       -0.3053603|                               -0.4190554|                   -0.4619356|                       -0.7155062| WALKING\_UPSTAIRS   |
| 981  |               0.1419732|              -0.0009492|              -0.0742675|                  0.9716341|                 -0.0610045|                  0.0323833|                  -0.1286413|                   0.0720698|                   0.0640408|       0.1768630|      -0.0641573|       0.1071855|           0.2619354|          -0.0592581|           0.1791175|                      -0.0831132|                         -0.0831132|                          -0.4435098|              -0.2407658|                  -0.6714794|              -0.1657647|              -0.4086824|              -0.3948669|                  -0.3429766|                  -0.5044823|                  -0.5464553|      -0.2233888|      -0.5708665|      -0.3281468|                      -0.1910986|                              -0.3527625|                  -0.5144235|                      -0.7035986|               -0.0381935|               -0.4251043|               -0.3033036|                  -0.9451711|                  -0.9764500|                  -0.7944781|                   -0.3324995|                   -0.5475940|                   -0.6105098|       -0.3112777|       -0.5657988|       -0.3151361|           -0.6369111|           -0.7046199|           -0.5934871|                       -0.1526450|                          -0.1526450|                           -0.3753915|               -0.4677058|                   -0.6938207|                0.0077322|               -0.4700913|               -0.3083128|                   -0.3816164|                   -0.6438349|                   -0.6770351|       -0.3415176|       -0.5657133|       -0.3734042|                       -0.2633584|                               -0.4066848|                   -0.5266874|                       -0.7024461| WALKING\_DOWNSTAIRS |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName        |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 1337 |               0.3038769|              -0.0297596|              -0.0753515|                  0.8449354|                 -0.3893910|                 -0.2071572|                  -0.2685337|                   0.3327021|                   0.2178007|       0.1087292|      -0.1065925|       0.0494481|           0.0455339|          -0.2948722|           0.0642999|                      -0.0106500|                         -0.0106500|                          -0.3401819|              -0.3461039|                  -0.6301594|              -0.0740220|              -0.0591214|              -0.5234625|                  -0.2628204|                  -0.3652606|                  -0.6765862|      -0.2206311|      -0.5883140|      -0.3446749|                      -0.1373746|                              -0.2681100|                  -0.4800209|                      -0.6730164|               -0.0341473|                0.1378475|               -0.4102310|                  -0.9509292|                  -0.9573652|                  -0.9049068|                   -0.2116311|                   -0.3187461|                   -0.7236302|       -0.4181966|       -0.5859340|       -0.2852028|           -0.4291769|           -0.7475674|           -0.5997636|                       -0.0310926|                          -0.0310926|                           -0.2969854|               -0.4273878|                   -0.6769753|               -0.0188245|                0.1595279|               -0.3970312|                   -0.2275497|                   -0.3125630|                   -0.7723816|       -0.4813998|       -0.5872921|       -0.3319951|                       -0.1269334|                               -0.3404212|                   -0.4892253|                       -0.7036984| WALKING\_UPSTAIRS   |
| 6651 |               0.2790184|              -0.0170884|              -0.1059239|                 -0.4754922|                  0.9787541|                  0.1392600|                   0.0787095|                   0.0062394|                   0.0109232|      -0.0330905|      -0.0730431|       0.0975154|          -0.1054951|          -0.0542881|          -0.0562444|                      -0.9852536|                         -0.9852536|                          -0.9768684|              -0.9802206|                  -0.9802410|              -0.9882997|              -0.9686054|              -0.9762085|                  -0.9825771|                  -0.9701214|                  -0.9759558|      -0.9737391|      -0.9730322|      -0.9906391|                      -0.9818480|                              -0.9798646|                  -0.9748264|                      -0.9783312|               -0.9911313|               -0.9721630|               -0.9797226|                  -0.9974476|                  -0.9956202|                  -0.9857277|                   -0.9816823|                   -0.9679287|                   -0.9808847|       -0.9828301|       -0.9774710|       -0.9919040|           -0.9749052|           -0.9778597|           -0.9911737|                       -0.9863781|                          -0.9863781|                           -0.9831076|               -0.9771847|                   -0.9793015|               -0.9925307|               -0.9749325|               -0.9830248|                   -0.9822614|                   -0.9674832|                   -0.9849348|       -0.9859327|       -0.9808189|       -0.9930462|                       -0.9913331|                               -0.9866344|                   -0.9831654|                       -0.9818126| LAYING              |
| 5828 |               0.2792350|              -0.0157571|              -0.1051317|                  0.9753811|                 -0.1190931|                  0.0154596|                   0.0762711|                  -0.0014582|                  -0.0004186|      -0.0300642|      -0.0725691|       0.0882154|          -0.1067291|          -0.0401667|          -0.0496038|                      -0.9929455|                         -0.9929455|                          -0.9924668|              -0.9936380|                  -0.9946291|              -0.9961638|              -0.9789282|              -0.9929401|                  -0.9951750|                  -0.9839242|                  -0.9925187|      -0.9872947|      -0.9967012|      -0.9905863|                      -0.9920064|                              -0.9940622|                  -0.9930303|                      -0.9959188|               -0.9969507|               -0.9788657|               -0.9928693|                  -0.9987454|                  -0.9905698|                  -0.9937938|                   -0.9947341|                   -0.9847367|                   -0.9935133|       -0.9917432|       -0.9973601|       -0.9926434|           -0.9898731|           -0.9964212|           -0.9940529|                       -0.9929161|                          -0.9929161|                           -0.9947330|               -0.9933684|                   -0.9963485|               -0.9973116|               -0.9790573|               -0.9924786|                   -0.9946428|                   -0.9869677|                   -0.9929738|       -0.9932620|       -0.9978208|       -0.9941158|                       -0.9938077|                               -0.9943901|                   -0.9946970|                       -0.9968630| STANDING            |
| 3155 |               0.2132728|               0.0252634|              -0.1340817|                  0.9555309|                 -0.1644082|                 -0.0009173|                  -0.0754534|                   0.1992057|                  -0.2613993|       0.2168787|      -0.2850274|       0.1017342|          -0.1227948|           0.1306336|          -0.2267556|                      -0.1593341|                         -0.1593341|                          -0.4111267|              -0.1751395|                  -0.6173790|              -0.1877750|              -0.1245803|              -0.2495077|                  -0.2952824|                  -0.3714845|                  -0.4509581|      -0.3189095|      -0.4270169|      -0.3386932|                      -0.0603857|                              -0.1916117|                  -0.4508522|                      -0.6656757|               -0.2136032|               -0.1107599|               -0.1828523|                  -0.9578494|                  -0.9205844|                  -0.9128112|                   -0.3224042|                   -0.3705455|                   -0.5196373|       -0.3268036|       -0.3158072|       -0.3982931|           -0.5872004|           -0.6670811|           -0.5541128|                       -0.1061924|                          -0.1061924|                           -0.2236443|               -0.3148719|                   -0.6896644|               -0.2239634|               -0.1594146|               -0.2103486|                   -0.4184989|                   -0.4152321|                   -0.5894335|       -0.3367412|       -0.2600519|       -0.4741277|                       -0.2719615|                               -0.2689554|                   -0.3445382|                       -0.7441556| WALKING\_DOWNSTAIRS |
| 4390 |               0.2779840|              -0.0178670|              -0.1069486|                  0.7858502|                  0.3120493|                  0.3455607|                   0.0776286|                   0.0099012|                   0.0061507|      -0.0280857|      -0.0737493|       0.0864133|          -0.0985938|          -0.0425147|          -0.0547922|                      -0.9977939|                         -0.9977939|                          -0.9944262|              -0.9983859|                  -0.9977872|              -0.9958270|              -0.9913809|              -0.9959607|                  -0.9946002|                  -0.9917270|                  -0.9919750|      -0.9991411|      -0.9967626|      -0.9949490|                      -0.9975424|                              -0.9942223|                  -0.9978229|                      -0.9978692|               -0.9962901|               -0.9931134|               -0.9957503|                  -0.9993426|                  -0.9973548|                  -0.9995038|                   -0.9946837|                   -0.9913705|                   -0.9933879|       -0.9993901|       -0.9973537|       -0.9955021|           -0.9982594|           -0.9967029|           -0.9954238|                       -0.9981549|                          -0.9981549|                           -0.9957971|               -0.9982339|                   -0.9973293|               -0.9964371|               -0.9934780|               -0.9950322|                   -0.9952581|                   -0.9914969|                   -0.9933401|       -0.9994614|       -0.9977542|       -0.9960517|                       -0.9982489|                               -0.9976163|                   -0.9988894|                       -0.9963460| SITTING             |
| 3394 |               0.2754100|              -0.0076772|              -0.0841159|                  0.9144690|                  0.1910507|                  0.1620839|                   0.0869651|                  -0.0501863|                  -0.0372415|      -0.0086257|      -0.0976406|       0.2579976|          -0.0877608|          -0.0392262|          -0.0802691|                      -0.9442916|                         -0.9442916|                          -0.9736112|              -0.9111051|                  -0.9741910|              -0.9821846|              -0.8940582|              -0.9513395|                  -0.9854915|                  -0.9547011|                  -0.9734225|      -0.9527070|      -0.9650918|      -0.9490440|                      -0.9301792|                              -0.9658989|                  -0.9579398|                      -0.9739888|               -0.9854662|               -0.8777823|               -0.9390375|                  -0.9812683|                  -0.9059226|                  -0.9269093|                   -0.9850586|                   -0.9504160|                   -0.9769378|       -0.9648403|       -0.9607159|       -0.9528765|           -0.9613580|           -0.9774441|           -0.9725252|                       -0.9176650|                          -0.9176650|                           -0.9683820|               -0.9487393|                   -0.9734710|               -0.9869485|               -0.8764355|               -0.9360860|                   -0.9858674|                   -0.9487868|                   -0.9790405|       -0.9686790|       -0.9583645|       -0.9583845|                       -0.9226832|                               -0.9707336|                   -0.9511543|                       -0.9742238| SITTING             |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

The following tables describe all the variables in the clean data-set:

<br/>

> **Notes: **
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
