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

    ## [1] "fBodyAccJerk-bandsEnergy()-1,8"   "tGravityAcc-min()-X"             
    ## [3] "fBodyAcc-max()-Z"                 "fBodyAccJerk-energy()-X"         
    ## [5] "tBodyAcc-mean()-Z"                "fBodyAccJerk-bandsEnergy()-49,64"

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

    ## [1] "fBodyAcc-bandsEnergy()-49,64"   "tBodyAccJerk-energy()-Z"       
    ## [3] "fBodyAccJerk-maxInds-X"         "fBodyAccJerk-bandsEnergy()-1,8"
    ## [5] "fBodyAccMag-maxInds"            "fBodyAcc-bandsEnergy()-17,24"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-X"     "tBodyAcc-mean()-Z"     "fBodyAccMag-mean()"   
    ## [4] "tGravityAcc-mean()-Y"  "tBodyAccJerk-mean()-Z" "fBodyGyro-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyGyro-std()-X"          "fBodyBodyGyroJerkMag-std()"
    ## [3] "tBodyAccJerk-std()-Z"       "tBodyAccMag-std()"         
    ## [5] "tGravityAcc-std()-Y"        "tBodyAccJerk-std()-X"

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

    ## [1] "fBodyBodyGyroJerkMag-entropy()"      
    ## [2] "tGravityAcc-entropy()-Z"             
    ## [3] "angle(tBodyAccJerkMean),gravityMean)"
    ## [4] "fBodyAcc-maxInds-Y"                  
    ## [5] "tBodyGyro-energy()-Z"                
    ## [6] "fBodyAccJerk-skewness()-Z"

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
| 1007 |               0.2070958|              -0.0104847|              -0.0742258|                  0.9501629|                 -0.2087806|                  0.0427665|                   0.3472455|                  -0.2234376|                  -0.0516747|      -0.1034640|      -0.0484038|       0.1039250|          -0.1493291|          -0.1041182|          -0.0592141|                      -0.1721857|                         -0.1721857|                          -0.1838239|              -0.1489239|                  -0.4288200|              -0.2251184|               0.1276633|              -0.4941462|                  -0.2558836|                   0.0615178|                  -0.5492137|      -0.2479562|      -0.3942756|      -0.0338206|                      -0.1705064|                              -0.1201134|                  -0.4450098|                      -0.4564604|               -0.2722709|                0.0563529|               -0.4672556|                  -0.9873267|                  -0.9538283|                  -0.9678537|                   -0.2027374|                    0.0872773|                   -0.5838143|       -0.3572374|       -0.2876164|       -0.1416386|           -0.3350149|           -0.4828669|           -0.2686166|                       -0.2962455|                          -0.2962455|                           -0.1656951|               -0.3884999|                   -0.4248566|               -0.2916536|               -0.0513707|               -0.4941044|                   -0.2173770|                    0.0404646|                   -0.6161092|       -0.3930225|       -0.2339756|       -0.2585657|                       -0.4881345|                               -0.2319182|                   -0.4544911|                       -0.4251779|           1|
| 102  |               0.2911281|               0.0155673|              -0.1042922|                  0.9205330|                 -0.3491428|                  0.0229325|                   0.3215386|                  -0.1156797|                  -0.0478461|       0.0012047|      -0.1213497|       0.0950149|          -0.3083297|           0.0565115|          -0.1590161|                      -0.2943328|                         -0.2943328|                          -0.2988577|              -0.4772534|                  -0.6247288|              -0.3095951|              -0.1216153|              -0.4925398|                  -0.2761810|                  -0.1697061|                  -0.5792845|      -0.4736618|      -0.5836374|      -0.4444932|                      -0.3188519|                              -0.1513534|                  -0.5852280|                      -0.6741478|               -0.4045258|               -0.1399257|               -0.4314133|                  -0.9861710|                  -0.9808862|                  -0.9831076|                   -0.2271638|                   -0.1040797|                   -0.6090950|       -0.5993474|       -0.5428384|       -0.5051162|           -0.5159373|           -0.6990013|           -0.5568316|                       -0.4371629|                          -0.4371629|                           -0.1549506|               -0.6040387|                   -0.6732642|               -0.4463027|               -0.2042646|               -0.4422792|                   -0.2439526|                   -0.0910060|                   -0.6364933|       -0.6393349|       -0.5224845|       -0.5718881|                       -0.6045655|                               -0.1654695|                   -0.6892458|                       -0.6950410|           1|
| 1514 |               0.2940403|              -0.0637552|              -0.0801772|                  0.9487119|                 -0.2920473|                 -0.0095087|                   0.0041290|                  -0.1754715|                   0.0020179|      -0.3717158|       0.1348272|       0.0699222|           0.1068416|           0.1325301|          -0.3051715|                      -0.2430005|                         -0.2430005|                          -0.4269548|              -0.2799722|                  -0.6483097|              -0.3170010|               0.0182761|              -0.7040636|                  -0.4379441|                  -0.1440920|                  -0.8252579|      -0.3560769|      -0.6012754|      -0.4029984|                      -0.3433166|                              -0.3515955|                  -0.5540323|                      -0.6877654|               -0.3225879|               -0.0500363|               -0.5019881|                  -0.8968369|                  -0.9547773|                  -0.8773285|                   -0.4271516|                   -0.1130754|                   -0.8487886|       -0.5239175|       -0.4339231|       -0.5274900|           -0.3967155|           -0.8095817|           -0.6147924|                       -0.3238592|                          -0.3238592|                           -0.3326657|               -0.5491836|                   -0.6895162|               -0.3247277|               -0.1493121|               -0.4494592|                   -0.4672750|                   -0.1391286|                   -0.8719793|       -0.5777471|       -0.3555190|       -0.6195505|                       -0.4178234|                               -0.3133591|                   -0.6243238|                       -0.7137542|           2|
| 1271 |               0.3017205|              -0.0298761|              -0.1065670|                 -0.5002777|                  0.6606272|                  0.7654996|                   0.1251765|                   0.0504950|                  -0.0697608|       0.1774180|      -0.2711626|       0.5247196|          -0.1683360|          -0.0327235|          -0.1039998|                      -0.8972613|                         -0.8972613|                          -0.9487054|              -0.6871510|                  -0.9378633|              -0.9059050|              -0.8787156|              -0.9065104|                  -0.9383443|                  -0.9355982|                  -0.9593100|      -0.8575189|      -0.9211867|      -0.8269395|                      -0.8555995|                              -0.9434817|                  -0.8303085|                      -0.9056230|               -0.9050675|               -0.8366048|               -0.8916237|                  -0.8621778|                  -0.8593435|                  -0.8605464|                   -0.9447923|                   -0.9373746|                   -0.9646046|       -0.9042467|       -0.9248528|       -0.8394915|           -0.8853194|           -0.9415172|           -0.8902675|                       -0.8433070|                          -0.8433070|                           -0.9462003|               -0.7850362|                   -0.8930616|               -0.9045468|               -0.8269402|               -0.8909612|                   -0.9587094|                   -0.9443203|                   -0.9685581|       -0.9199339|       -0.9276702|       -0.8583834|                       -0.8599096|                               -0.9487714|                   -0.7926148|                       -0.8849179|           6|
| 2619 |               0.2786212|               0.0130429|              -0.1399545|                  0.9654535|                  0.0707036|                 -0.0225454|                   0.0714896|                   0.0233727|                   0.1227594|      -0.2024134|      -0.0043078|      -0.3321643|          -0.0556675|          -0.0310057|           0.0296526|                      -0.9049284|                         -0.9049284|                          -0.9810092|              -0.7333295|                  -0.9862401|              -0.9900073|              -0.9588512|              -0.8626011|                  -0.9857778|                  -0.9740806|                  -0.9799403|      -0.9249780|      -0.9758489|      -0.8668015|                      -0.8802722|                              -0.9828355|                  -0.8851826|                      -0.9888893|               -0.9921543|               -0.9285185|               -0.7972754|                  -0.9857501|                  -0.9321045|                  -0.7785340|                   -0.9852357|                   -0.9738543|                   -0.9831805|       -0.9207432|       -0.9699397|       -0.8424183|           -0.9839957|           -0.9867984|           -0.9895206|                       -0.8586202|                          -0.8586202|                           -0.9851612|               -0.8063401|                   -0.9901769|               -0.9931690|               -0.9194975|               -0.7805012|                   -0.9858914|                   -0.9754282|                   -0.9851047|       -0.9205810|       -0.9668136|       -0.8493220|                       -0.8683385|                               -0.9876883|                   -0.7956922|                       -0.9926375|           4|
| 1662 |               0.2684908|              -0.0557563|              -0.0872004|                  0.9443458|                 -0.1897040|                 -0.1837865|                   0.1369820|                  -0.3861322|                  -0.1522422|       0.2523609|      -0.3294592|       0.0815255|           0.1371816|          -0.3546515|          -0.0971735|                      -0.0118367|                         -0.0118367|                          -0.0725564|              -0.1762892|                  -0.1973505|              -0.0623319|              -0.0629887|               0.0029341|                  -0.0690278|                  -0.2077348|                  -0.1719519|      -0.6058238|       0.1363501|      -0.3295403|                       0.1431217|                               0.1010003|                  -0.0150600|                      -0.1479481|               -0.0611935|               -0.1062974|                0.0631925|                  -0.9880616|                  -0.9671370|                  -0.8995775|                   -0.0506872|                   -0.1639236|                   -0.1439215|       -0.7435003|        0.0533843|       -0.4476582|           -0.6894703|           -0.0257765|           -0.4916188|                        0.0595582|                           0.0595582|                            0.0357411|               -0.1056837|                   -0.1764598|               -0.0607223|               -0.1870746|                0.0122794|                   -0.1167120|                   -0.1713830|                   -0.1185097|       -0.7907767|       -0.0088670|       -0.5429630|                       -0.1554168|                               -0.0616864|                   -0.3429162|                       -0.2750434|           3|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName      |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 768  |               0.3016693|               0.0093982|              -0.1639903|                  0.9036710|                 -0.2329207|                 -0.2345174|                  -0.1787444|                   0.2272330|                  -0.0328227|       0.2023066|      -0.1710594|      -0.2008702|          -0.0987434|          -0.0108960|           0.0851837|                      -0.2006398|                         -0.2006398|                          -0.4870248|              -0.2045951|                  -0.6030436|              -0.4551642|              -0.1854838|              -0.1814546|                  -0.5694164|                  -0.4335651|                  -0.3904187|      -0.3904842|      -0.4966139|      -0.3391509|                      -0.3475873|                              -0.3669254|                  -0.4457712|                      -0.5695753|               -0.4059478|               -0.0347915|               -0.1377086|                  -0.9421144|                  -0.9067471|                  -0.9221560|                   -0.5883346|                   -0.4516857|                   -0.4308732|       -0.3232188|       -0.5073720|       -0.2234101|           -0.5657088|           -0.5757781|           -0.6884977|                       -0.3673736|                          -0.3673736|                           -0.4012688|               -0.3829552|                   -0.5782604|               -0.3874559|               -0.0231100|               -0.1817246|                   -0.6497688|                   -0.5160468|                   -0.4684435|       -0.3167126|       -0.5175871|       -0.2599660|                       -0.4766871|                               -0.4520678|                   -0.4456962|                       -0.6175204| WALKING\_UPSTAIRS |
| 1664 |               0.2800452|              -0.0171391|              -0.1104983|                  0.8016256|                  0.3758121|                  0.2540908|                   0.0777494|                   0.0053690|                   0.0091436|      -0.0276771|      -0.0710876|       0.0890913|          -0.0990357|          -0.0392046|          -0.0567575|                      -0.9948878|                         -0.9948878|                          -0.9901359|              -0.9947020|                  -0.9958302|              -0.9945329|              -0.9866183|              -0.9885819|                  -0.9920870|                  -0.9881434|                  -0.9880354|      -0.9974482|      -0.9938318|      -0.9920107|                      -0.9927316|                              -0.9932928|                  -0.9969366|                      -0.9968177|               -0.9959966|               -0.9888877|               -0.9898357|                  -0.9970030|                  -0.9962620|                  -0.9940929|                   -0.9915583|                   -0.9879615|                   -0.9893853|       -0.9985106|       -0.9930965|       -0.9927792|           -0.9959790|           -0.9951694|           -0.9945670|                       -0.9940840|                          -0.9940840|                           -0.9937148|               -0.9970266|                   -0.9970864|               -0.9967490|               -0.9898467|               -0.9906461|                   -0.9916549|                   -0.9885687|                   -0.9891833|       -0.9989114|       -0.9925926|       -0.9936318|                       -0.9952087|                               -0.9929280|                   -0.9975079|                       -0.9973617| SITTING           |
| 1505 |               0.2714811|              -0.0298682|              -0.1024048|                  0.9715215|                 -0.1503432|                  0.0649673|                   0.0839940|                   0.0045952|                  -0.0411845|      -0.0459635|      -0.0734530|       0.1066241|          -0.0755424|          -0.0665923|          -0.0615906|                      -0.9614567|                         -0.9614567|                          -0.9760332|              -0.9444827|                  -0.9842501|              -0.9850474|              -0.9605283|              -0.9477042|                  -0.9822835|                  -0.9751292|                  -0.9671717|      -0.9606303|      -0.9619922|      -0.9486222|                      -0.9628371|                              -0.9734753|                  -0.9586511|                      -0.9855528|               -0.9872166|               -0.9490798|               -0.9400756|                  -0.9949440|                  -0.9713688|                  -0.9881410|                   -0.9811666|                   -0.9746018|                   -0.9719413|       -0.9664510|       -0.9589909|       -0.9199215|           -0.9880903|           -0.9839431|           -0.9792523|                       -0.9627332|                          -0.9627332|                           -0.9760812|               -0.9496244|                   -0.9869053|               -0.9881224|               -0.9457950|               -0.9394880|                   -0.9815402|                   -0.9757264|                   -0.9754356|       -0.9682550|       -0.9573924|       -0.9193818|                       -0.9673030|                               -0.9788031|                   -0.9520005|                       -0.9894103| SITTING           |
| 943  |               0.2308523|              -0.0422856|              -0.0899204|                  0.8911273|                 -0.2784662|                 -0.2207862|                  -0.3042368|                   0.3129585|                   0.0864778|       0.1287200|      -0.1483702|      -0.0059513|          -0.2786850|          -0.0040840|           0.0241806|                      -0.1906097|                         -0.1906097|                          -0.4164558|              -0.2810365|                  -0.5635251|              -0.2902006|              -0.1925576|              -0.2232987|                  -0.4318719|                  -0.4918730|                  -0.3951722|      -0.3876613|      -0.3971552|      -0.3361263|                      -0.1822282|                              -0.2991060|                  -0.4514572|                      -0.5040135|               -0.3093472|               -0.0791262|               -0.1517267|                  -0.9786992|                  -0.9586799|                  -0.9454819|                   -0.4194367|                   -0.4722285|                   -0.4146212|       -0.4294672|       -0.4355078|       -0.2568029|           -0.6145717|           -0.4942424|           -0.5679675|                       -0.2088020|                          -0.2088020|                           -0.3170825|               -0.3956858|                   -0.4810767|               -0.3169241|               -0.0811491|               -0.1790399|                   -0.4584111|                   -0.4862822|                   -0.4313697|       -0.4464218|       -0.4645766|       -0.3004279|                       -0.3469121|                               -0.3447924|                   -0.4606719|                       -0.4880775| WALKING\_UPSTAIRS |
| 1394 |               0.2739077|              -0.0138500|              -0.1015642|                  0.4957604|                 -0.4220265|                  0.6607712|                   0.0713820|                   0.0214576|                   0.0205234|      -0.0250814|      -0.1112992|       0.0420835|          -0.1077555|          -0.0527236|          -0.0133274|                      -0.9363076|                         -0.9363076|                          -0.9325753|              -0.9179626|                  -0.9372313|              -0.9288090|              -0.9207070|              -0.8975848|                  -0.9127756|                  -0.9369702|                  -0.9116889|      -0.9352029|      -0.8920678|      -0.8846281|                      -0.8930109|                              -0.8880512|                  -0.8953133|                      -0.9066702|               -0.9447015|               -0.9185052|               -0.8975755|                  -0.9948288|                  -0.9893619|                  -0.9952976|                   -0.9115725|                   -0.9372636|                   -0.9183099|       -0.9509460|       -0.9045126|       -0.9102334|           -0.9363868|           -0.9158789|           -0.9198362|                       -0.9001301|                          -0.9001301|                           -0.8797284|               -0.8948126|                   -0.8979464|               -0.9523788|               -0.9214358|               -0.9050385|                   -0.9182382|                   -0.9421935|                   -0.9231744|       -0.9559118|       -0.9137229|       -0.9286388|                       -0.9189586|                               -0.8687657|                   -0.9127286|                       -0.8939048| SITTING           |
| 2055 |               0.2729576|              -0.0225008|              -0.1103746|                  0.8763968|                 -0.4010463|                  0.1644211|                   0.0742498|                   0.0028183|                  -0.0045186|      -0.0318744|      -0.0673036|       0.0927601|          -0.0988606|          -0.0445387|          -0.0500067|                      -0.9904702|                         -0.9904702|                          -0.9873373|              -0.9839761|                  -0.9913449|              -0.9930423|              -0.9816710|              -0.9854357|                  -0.9895859|                  -0.9849130|                  -0.9823068|      -0.9840463|      -0.9812690|      -0.9883963|                      -0.9877722|                              -0.9857482|                  -0.9796902|                      -0.9898983|               -0.9951193|               -0.9817039|               -0.9873556|                  -0.9975862|                  -0.9928964|                  -0.9967006|                   -0.9893735|                   -0.9857308|                   -0.9842311|       -0.9852348|       -0.9794923|       -0.9892785|           -0.9896338|           -0.9893600|           -0.9932762|                       -0.9902398|                          -0.9902398|                           -0.9871543|               -0.9751350|                   -0.9902931|               -0.9962365|               -0.9817662|               -0.9888615|                   -0.9900502|                   -0.9879053|                   -0.9846073|       -0.9855815|       -0.9784746|       -0.9904629|                       -0.9928155|                               -0.9880302|                   -0.9760706|                       -0.9911835| STANDING          |

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
| 6131 |               0.2782054|              -0.0175990|              -0.1075561|                 -0.4242959|                  0.7632909|                  0.6591533|                   0.0745675|                   0.0184103|                  -0.0037452|      -0.0272436|      -0.0783298|       0.0854882|          -0.0983882|          -0.0417520|          -0.0569291|                      -0.9959851|                         -0.9959851|                          -0.9926696|              -0.9978206|                  -0.9971292|              -0.9925335|              -0.9898338|              -0.9946455|                  -0.9923322|                  -0.9905634|                  -0.9919892|      -0.9974424|      -0.9966782|      -0.9946484|                      -0.9954879|                              -0.9934692|                  -0.9971249|                      -0.9981698|               -0.9927286|               -0.9915973|               -0.9962676|                  -0.9991936|                  -0.9970392|                  -0.9970738|                   -0.9918795|                   -0.9890309|                   -0.9930288|       -0.9983519|       -0.9969204|       -0.9958793|           -0.9968126|           -0.9974239|           -0.9940157|                       -0.9964627|                          -0.9964627|                           -0.9941634|               -0.9973564|                   -0.9983454|               -0.9926852|               -0.9920682|               -0.9969217|                   -0.9920362|                   -0.9878774|                   -0.9925332|       -0.9986620|       -0.9970352|       -0.9967419|                       -0.9970477|                               -0.9939818|                   -0.9979324|                       -0.9984170| LAYING              |
| 1772 |               0.2511831|              -0.1287578|              -0.1710170|                  0.9338866|                 -0.2898132|                  0.1384707|                  -0.1232171|                  -0.0440394|                  -0.1843664|      -0.5999366|       0.1775440|      -0.0220522|           0.1760178|           0.1053891|          -0.0060691|                      -0.1003152|                         -0.1003152|                          -0.5471174|              -0.1659330|                  -0.7808527|              -0.4220115|              -0.2759102|              -0.5524924|                  -0.5449807|                  -0.4691108|                  -0.7945869|      -0.5549140|      -0.6289748|      -0.6416356|                      -0.3908120|                              -0.5029861|                  -0.6757128|                      -0.8171332|               -0.2451442|               -0.0775727|               -0.1459323|                  -0.9152995|                  -0.7318772|                  -0.7941363|                   -0.4966313|                   -0.4443991|                   -0.8059211|       -0.6922354|       -0.3629359|       -0.6372760|           -0.6905351|           -0.8278489|           -0.7982178|                       -0.2953064|                          -0.2953064|                           -0.5109326|               -0.5856780|                   -0.8180921|               -0.1857324|               -0.0442894|               -0.0399813|                   -0.4910835|                   -0.4544290|                   -0.8151515|       -0.7375692|       -0.2481527|       -0.6688645|                       -0.3561678|                               -0.5238076|                   -0.5992289|                       -0.8320343| WALKING\_UPSTAIRS   |
| 6444 |               0.2800788|              -0.0167846|              -0.1067776|                 -0.2984225|                  0.7990332|                  0.5962702|                   0.0729195|                   0.0120247|                  -0.0159085|      -0.0281075|      -0.0747182|       0.0866883|          -0.0971419|          -0.0388349|          -0.0550109|                      -0.9965554|                         -0.9965554|                          -0.9938802|              -0.9985302|                  -0.9981704|              -0.9913744|              -0.9942594|              -0.9948286|                  -0.9889710|                  -0.9924818|                  -0.9962356|      -0.9970068|      -0.9972849|      -0.9973904|                      -0.9961202|                              -0.9946643|                  -0.9991002|                      -0.9987918|               -0.9928668|               -0.9967477|               -0.9945221|                  -0.9985692|                  -0.9981801|                  -0.9963478|                   -0.9894672|                   -0.9928861|                   -0.9963938|       -0.9982521|       -0.9976982|       -0.9974569|           -0.9970405|           -0.9976816|           -0.9976089|                       -0.9966132|                          -0.9966132|                           -0.9958600|               -0.9991199|                   -0.9990115|               -0.9935146|               -0.9974666|               -0.9938307|                   -0.9910509|                   -0.9939664|                   -0.9949416|       -0.9987216|       -0.9979536|       -0.9976386|                       -0.9967278|                               -0.9968856|                   -0.9991953|                       -0.9991594| LAYING              |
| 2756 |               0.2077579|              -0.0083759|              -0.0983270|                  0.9462867|                 -0.2305354|                 -0.0692752|                  -0.3430520|                   0.1137843|                   0.1040574|       0.0886841|      -0.1708923|       0.0754432|           0.0440543|          -0.0731414|           0.0409137|                       0.0583703|                          0.0583703|                          -0.3638405|              -0.1078496|                  -0.6233163|              -0.0535680|              -0.1709842|              -0.4571601|                  -0.2933292|                  -0.4452391|                  -0.5888715|      -0.2662089|      -0.5009853|      -0.3263205|                      -0.0473842|                              -0.3070439|                  -0.4485446|                      -0.6452637|                0.0724841|               -0.0010964|               -0.4391792|                  -0.9557709|                  -0.9278544|                  -0.9594695|                   -0.2400389|                   -0.4290218|                   -0.6499456|       -0.0995882|       -0.4519690|       -0.4186546|           -0.6068037|           -0.6727916|           -0.4839508|                       -0.0854231|                          -0.0854231|                           -0.3336153|               -0.3114088|                   -0.6598532|                0.1183220|                0.0168082|               -0.4735286|                   -0.2513348|                   -0.4502821|                   -0.7139780|       -0.0761251|       -0.4275468|       -0.5054878|                       -0.2497039|                               -0.3735670|                   -0.3409406|                       -0.7048244| WALKING\_DOWNSTAIRS |
| 2128 |               0.2812869|              -0.0348025|              -0.0893525|                  0.9260084|                 -0.3179825|                 -0.0317022|                   0.3334876|                   0.3817781|                   0.1073207|       0.0792290|      -0.2103897|       0.1164076|          -0.2204516|           0.0003050|          -0.0956605|                       0.0710822|                          0.0710822|                          -0.2278794|              -0.3126075|                  -0.5303493|              -0.1870997|               0.2491020|              -0.3939014|                  -0.3446293|                  -0.1337613|                  -0.5674388|      -0.2849891|      -0.5614776|      -0.1465783|                      -0.1482930|                              -0.2840714|                  -0.4431510|                      -0.6258772|               -0.0645753|                0.3140119|               -0.2809089|                  -0.9453586|                  -0.8787997|                  -0.9449524|                   -0.2734273|                   -0.0592317|                   -0.5994956|       -0.4174185|       -0.5304848|       -0.2453224|           -0.3862188|           -0.7031803|           -0.3184590|                       -0.1570834|                          -0.1570834|                           -0.3606232|               -0.4375748|                   -0.6377697|               -0.0204089|                0.2645617|               -0.2769741|                   -0.2641604|                   -0.0394459|                   -0.6292020|       -0.4596184|       -0.5155517|       -0.3496623|                       -0.2929622|                               -0.4786562|                   -0.5317526|                       -0.6796936| WALKING\_UPSTAIRS   |
| 6085 |               0.2783098|              -0.0163853|              -0.1112288|                 -0.4838919|                  0.9836050|                  0.0896439|                   0.0772577|                   0.0168319|                   0.0314731|      -0.0324051|      -0.0608830|       0.0802238|          -0.0956514|          -0.0447245|          -0.0456165|                      -0.9695044|                         -0.9695044|                          -0.9708284|              -0.9671994|                  -0.9673686|              -0.9822882|              -0.9714517|              -0.9511940|                  -0.9783965|                  -0.9694578|                  -0.9639426|      -0.9580507|      -0.9594954|      -0.9774325|                      -0.9721672|                              -0.9678149|                  -0.9596581|                      -0.9660608|               -0.9854065|               -0.9754059|               -0.9424771|                  -0.9910219|                  -0.9993014|                  -0.9556151|                   -0.9785374|                   -0.9670209|                   -0.9645293|       -0.9719163|       -0.9634285|       -0.9797578|           -0.9521668|           -0.9687761|           -0.9804186|                       -0.9770694|                          -0.9770694|                           -0.9673843|               -0.9614629|                   -0.9675551|               -0.9867976|               -0.9782458|               -0.9411096|                   -0.9806468|                   -0.9663567|                   -0.9633824|       -0.9765743|       -0.9662857|       -0.9823367|                       -0.9832553|                               -0.9653446|                   -0.9696075|                       -0.9716666| LAYING              |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

The following tables describe all the variables in the clean data-set:

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

<br/>

> **Note:**
>
> Acceleration Units: Number of g's.
>
> Prefix 't' stands for "time domain signal", 'f' for "frequency domain signal".

<br/>

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

<br/>

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

<br/>

> **Note:**
>
> "Acceleration Jerk" or simply [jerk](https://en.wikipedia.org/wiki/Jerk_(physics)) is the rate of change of the acceleration.
>
> Jerk Units: Number of g's per second.

<br/>

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

<br/>

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

<br/>

> **Note:**
>
> Giro (Angular Velocity) Units: radians per second.

<br/>

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

<br/>

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

<br/>

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
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
