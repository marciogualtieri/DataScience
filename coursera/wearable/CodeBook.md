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
        -   [Activity Label Data](#activity-label-data)
    -   [Pertinent Variables (Mean, Standard Deviation & Activity)](#pertinent-variables-mean-standard-deviation-activity)
    -   [Binding Feature and Label Data Together](#binding-feature-and-label-data-together)
    -   [Re-Naming the Data-set Variables](#re-naming-the-data-set-variables)
    -   [Filtering Out Non-Pertinent Variables](#filtering-out-non-pertinent-variables)
    -   [Normalizing Variable Names](#normalizing-variable-names)
    -   [Joining with Activity Label Data](#joining-with-activity-label-data)
    -   [Putting All Transformations Together](#putting-all-transformations-together)
    -   [Resulting Clean Data-set](#resulting-clean-data-set)
-   [Computing Averages per Activity](#computing-averages-per-activity)
-   [Saving Clean Data to Disk](#saving-clean-data-to-disk)

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

Here's a list of the the unzipped files:

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

The pre-processed data ("Inertial Signals" folders) has been collected from human subjects carrying cellphones equipped with built-in accelerometers and gyroscopes. The purpose of the experiment that collected this data is to use these measurements to classify different categories of human activities performed by human subjects (walking, sitting, standing, etc).

The accelerometers and gyroscopes produce tri-axial measurements (carthesian X, Y & Z components) for the acceleration (in number of g's, where "g" is the Earth's gravitational acceleration, that is, ~ 9.764 m/s2) and angular velocity (in radians per second) respectively.

These measurements are collected overtime at a constant rate of 50 Hz, that is, a measurement is performed every 1/50 seconds (thus, the respective variables prefixed with 't', which stands for "time domain signal").

The acceleration measured has components due to the Earth's gravity and due to the subject's body motion. Given that the Earth's gravity is constant (therefore low frequency), a low-pass filter was used to separate the action due to the Earth's gravity from the action due to body motion. The body variables are infixed with "body", while gravity variables are infixed with "gravity".

A Fast Fourier Transform for the given sampling frequency of 50 Hz and with a number of bins equal to the number of observations was applied to the time based signal variables, generationg the "frequency domain signal" variables (which are prefixed with 'f').

Finally, these measurements were used to estimate variables for mean, standard deviation, median, max, min, etc (you will find the full list of estimated variables in `features_info.txt`). These estimated variables comprise the data for the given training and testing data-sets.

For the purpose of data exploration, we are not interested in the pre-processed data nor the subject id's, thus, we're going to work with the following files:

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

#### Feature Names

The feature data contains 561 feature variables and 1122 observations (adding up testing and training data-sets).

``` r
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
str(features)
```

    ## 'data.frame':    561 obs. of  2 variables:
    ##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

As expected, the list of feature names contains 2 entries, which matches with the number of columns in the feature data.

Given that we only need the feature names, let's create a new variable without the indexes (columns in the feature data are ordered in the same way as feature names, thus indexes are not necessary):

``` r
feature_names <- features[, 2]
sample(feature_names, 6)
```

    ## [1] "tBodyAcc-arCoeff()-X,4"       "fBodyAcc-bandsEnergy()-25,48"
    ## [3] "fBodyAcc-energy()-Y"          "tBodyAccMag-arCoeff()1"      
    ## [5] "fBodyGyro-iqr()-Z"            "tBodyAccJerk-arCoeff()-X,2"

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

#### Activity Label Data

``` r
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
dim(activities)
```

    ## [1] 6 2

### Pertinent Variables (Mean, Standard Deviation & Activity)

Let's create a list of all variables, which include the features names and label name:

``` r
variables <- c(feature_names, "ActivityID")
```

Let's also create a list of the variables we are interested in (means and standard deviations):

``` r
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "fBodyAccJerk-kurtosis()-Y" "fBodyAcc-min()-Z"         
    ## [3] "tBodyGyro-energy()-Y"      "tBodyGyro-entropy()-Y"    
    ## [5] "tBodyGyroJerkMag-iqr()"    "tBodyGyroJerk-iqr()-Y"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-Z"      "tBodyAccJerkMag-mean()"
    ## [3] "tGravityAcc-mean()-Z"   "tBodyGyro-mean()-Z"    
    ## [5] "fBodyAccMag-mean()"     "fBodyAcc-mean()-Z"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyBodyGyroMag-std()"     "tBodyAccMag-std()"         
    ## [3] "tGravityAccMag-std()"       "fBodyAccMag-std()"         
    ## [5] "tGravityAcc-std()-Z"        "fBodyBodyGyroJerkMag-std()"

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

### Re-Naming the Data-set Variables

``` r
add_variable_names <- function(data) {
  names(data) <- variables
  data
}

test_data <- add_variable_names(test_data)
sample(names(test_data), 6)
```

    ## [1] "tGravityAccMag-arCoeff()4"        "fBodyBodyAccJerkMag-meanFreq()"  
    ## [3] "tBodyAccJerk-mad()-Y"             "fBodyGyro-std()-X"               
    ## [5] "fBodyGyro-bandsEnergy()-1,16"     "fBodyAccJerk-bandsEnergy()-57,64"

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
| 32   |               0.2964871|              -0.0146849|              -0.1398085|                  0.9520132|                 -0.1271969|                  0.1732477|                   0.0741676|                  -0.0884296|                  -0.0005751|      -0.0501715|      -0.0732115|       0.1837903|          -0.0927421|          -0.0166998|          -0.1195596|                      -0.9287386|                         -0.9287386|                          -0.9776674|              -0.9428486|                  -0.9848091|              -0.9875327|              -0.8594018|              -0.9618836|                  -0.9862276|                  -0.9445365|                  -0.9747708|      -0.9748450|      -0.9618009|      -0.9159782|                      -0.8988205|                              -0.9644336|                  -0.9349389|                      -0.9817328|               -0.9877137|               -0.8342424|               -0.9410504|                  -0.9744282|                  -0.8778561|                  -0.9336702|                   -0.9876615|                   -0.9506227|                   -0.9804875|       -0.9822225|       -0.9587079|       -0.9299422|           -0.9783698|           -0.9858060|           -0.9740108|                       -0.8983803|                          -0.8983803|                           -0.9657416|               -0.9286031|                   -0.9794538|               -0.9876369|               -0.8314823|               -0.9341067|                   -0.9907321|                   -0.9634317|                   -0.9856140|       -0.9846029|       -0.9570630|       -0.9415162|                       -0.9127882|                               -0.9660779|                   -0.9362245|                       -0.9775839|           4|
| 1718 |               0.2829059|              -0.0077707|              -0.1084010|                  0.9412245|                 -0.2938321|                  0.0410636|                   0.0724531|                   0.0269284|                  -0.0005736|      -0.0275529|      -0.0710277|       0.0749863|          -0.0936928|          -0.0458241|          -0.0521927|                      -0.9869996|                         -0.9869996|                          -0.9935467|              -0.9830348|                  -0.9948857|              -0.9952733|              -0.9790059|              -0.9895474|                  -0.9954399|                  -0.9887010|                  -0.9904152|      -0.9896813|      -0.9888692|      -0.9828114|                      -0.9903286|                              -0.9927739|                  -0.9932534|                      -0.9953810|               -0.9957563|               -0.9804355|               -0.9853363|                  -0.9968132|                  -0.9891862|                  -0.9921311|                   -0.9955072|                   -0.9889188|                   -0.9918689|       -0.9905558|       -0.9836199|       -0.9812836|           -0.9936463|           -0.9957386|           -0.9902315|                       -0.9889040|                          -0.9889040|                           -0.9940254|               -0.9916364|                   -0.9954851|               -0.9959018|               -0.9813778|               -0.9830118|                   -0.9959874|                   -0.9900063|                   -0.9918403|       -0.9907721|       -0.9809198|       -0.9822969|                       -0.9886347|                               -0.9948593|                   -0.9916926|                       -0.9955578|           5|
| 2534 |               0.4163791|               0.0666006|              -0.0731887|                  0.8669529|                 -0.3673844|                  0.0618619|                   0.4600631|                  -0.4210784|                   0.0606524|      -0.5452935|       0.7079295|      -0.1102397|          -0.0618528|          -0.0768623|           0.2269049|                       0.2315060|                          0.2315060|                          -0.0569009|               0.1706225|                  -0.2418711|              -0.1048245|               0.6217423|              -0.3002118|                  -0.3239283|                   0.3561775|                  -0.4427900|      -0.0417804|      -0.1681127|       0.4508672|                       0.0716161|                               0.0274635|                  -0.0080951|                      -0.1965834|               -0.0148832|                0.8222554|               -0.2619776|                  -0.8775901|                  -0.6871071|                  -0.8935638|                   -0.2498842|                    0.4779492|                   -0.4433411|       -0.2837089|       -0.1609553|        0.3044892|           -0.0093647|           -0.3809960|            0.2304371|                        0.0978044|                           0.0978044|                            0.0336272|                0.0738125|                   -0.1245333|                0.0184526|                0.8061784|               -0.2990339|                   -0.2398102|                    0.5139887|                   -0.4425379|       -0.3611020|       -0.1624972|        0.1334571|                       -0.0585684|                                0.0365919|                   -0.0539413|                       -0.0973677|           3|
| 2137 |               0.2447147|              -0.0121917|              -0.0508673|                  0.9030106|                 -0.2645499|                 -0.2304575|                   0.1357769|                  -0.1021262|                   0.2989444|      -0.0415611|      -0.0190752|       0.1504023|          -0.0997120|          -0.1228637|          -0.1547369|                      -0.2752235|                         -0.2752235|                          -0.3710640|              -0.5208334|                  -0.6411358|              -0.3962668|              -0.3292946|              -0.3658326|                  -0.4388137|                  -0.4411364|                  -0.5032535|      -0.6812484|      -0.5165971|      -0.5181581|                      -0.4413606|                              -0.4310892|                  -0.5650676|                      -0.6766507|               -0.3780528|               -0.2916952|               -0.3136065|                  -0.9782783|                  -0.9868840|                  -0.9500383|                   -0.3772668|                   -0.3803702|                   -0.5601886|       -0.7440536|       -0.4901046|       -0.4611645|           -0.6979540|           -0.6476521|           -0.6273731|                       -0.4868149|                          -0.4868149|                           -0.4644981|               -0.5622825|                   -0.7070993|               -0.3709219|               -0.3165350|               -0.3385733|                   -0.3687218|                   -0.3547407|                   -0.6169436|       -0.7639643|       -0.4779300|       -0.4928599|                       -0.5936758|                               -0.5101418|                   -0.6365827|                       -0.7756339|           1|
| 876  |               0.4392122|              -0.0358208|              -0.1251064|                  0.9058495|                  0.0041966|                 -0.1826469|                   0.2722680|                   0.0523626|                  -0.1991986|       0.0346167|      -0.0482134|       0.0350873|           0.0841179|          -0.0795529|          -0.0594026|                       0.1325903|                          0.1325903|                          -0.0985159|              -0.0406424|                  -0.3887330|               0.2603576|              -0.3070446|               0.0653973|                   0.1374194|                  -0.3335925|                  -0.1813680|      -0.2581005|      -0.2337313|      -0.0561060|                       0.4714200|                               0.1720518|                  -0.3095410|                      -0.2778540|                0.2261079|               -0.3927946|                0.2345338|                  -0.9433894|                  -0.9394816|                  -0.9505054|                    0.1054510|                   -0.3497801|                   -0.2558800|       -0.1916368|       -0.2877769|       -0.1067281|           -0.4859755|           -0.3263030|           -0.2355004|                        0.4211394|                           0.4211394|                            0.1217369|               -0.3599081|                   -0.2877284|                0.2123283|               -0.4829366|                0.2280695|                   -0.0354957|                   -0.4188315|                   -0.3284463|       -0.1867612|       -0.3284100|       -0.2055910|                        0.1705095|                                0.0477720|                   -0.5158434|                       -0.3516170|           3|
| 2452 |               0.2817597|              -0.0214768|              -0.0758912|                  0.9749764|                 -0.0587010|                 -0.0579661|                   0.0761883|                  -0.0062889|                  -0.0259934|      -0.0245164|      -0.0591116|       0.1057903|          -0.0970672|          -0.0357122|          -0.0464057|                      -0.9640077|                         -0.9640077|                          -0.9880438|              -0.9766673|                  -0.9865662|              -0.9927729|              -0.9703997|              -0.9689872|                  -0.9927624|                  -0.9784534|                  -0.9865468|      -0.9839363|      -0.9742652|      -0.9721872|                      -0.9784565|                              -0.9881128|                  -0.9744970|                      -0.9860885|               -0.9934508|               -0.9710141|               -0.9458092|                  -0.9950793|                  -0.9939632|                  -0.9239363|                   -0.9927712|                   -0.9772525|                   -0.9895002|       -0.9851616|       -0.9731009|       -0.9765001|           -0.9909995|           -0.9843319|           -0.9833244|                       -0.9656622|                          -0.9656622|                           -0.9894384|               -0.9697521|                   -0.9863966|               -0.9936613|               -0.9720835|               -0.9376895|                   -0.9934191|                   -0.9773343|                   -0.9912899|       -0.9855191|       -0.9724798|       -0.9801898|                       -0.9634416|                               -0.9902411|                   -0.9714590|                       -0.9873706|           4|

### Joining with Activity Label Data

``` r
names(activities) <- c("ActivityID", "ActivityLabel")
str(activities)
```

    ## 'data.frame':    6 obs. of  2 variables:
    ##  $ ActivityID   : int  1 2 3 4 5 6
    ##  $ ActivityLabel: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1

``` r
add_activity_label_variable <- function(data, activities) {
  data <- merge(data, activities)
  data <- data[, !names(data) %in% c("ActivityID")]
  data
}

test_data <- add_activity_label_variable(test_data, activities)
sample_data_frame(test_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel     |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 694  |               0.4020164|               0.0324574|              -0.0632265|                  0.7744249|                 -0.5266602|                  0.0600614|                   0.0196580|                  -0.5025905|                  -0.1362744|      -0.0074878|      -0.1505786|       0.1833807|          -0.3674260|           0.2701205|           0.0414302|                       0.0387675|                          0.0387675|                          -0.2744427|              -0.0360365|                  -0.3100560|              -0.1727992|               0.0792044|              -0.3895121|                  -0.2936646|                  -0.2848109|                  -0.5547786|      -0.3101751|      -0.0480318|       0.0197614|                      -0.2618311|                              -0.3039090|                  -0.2440370|                      -0.4330220|               -0.1368524|                0.3014292|               -0.2510326|                  -0.9340139|                  -0.8809578|                  -0.8633062|                   -0.2232611|                   -0.1982750|                   -0.5609212|       -0.5071840|       -0.0344648|        0.1818649|           -0.5029536|           -0.2974402|           -0.2261575|                       -0.2254105|                          -0.2254105|                           -0.2534150|               -0.1936005|                   -0.3931455|               -0.1230418|                0.3248123|               -0.2371473|                   -0.2188960|                   -0.1571097|                   -0.5651149|       -0.5711939|       -0.0329841|        0.1222780|                       -0.3258334|                               -0.1976067|                   -0.2973008|                       -0.3855509| WALKING\_UPSTAIRS |
| 1530 |               0.2837859|              -0.0304895|              -0.1085227|                  0.9600144|                  0.0932425|                  0.0482181|                   0.0743343|                   0.0129560|                   0.0107719|      -0.0290263|      -0.0659456|       0.0797365|          -0.0938342|          -0.0486299|          -0.0551136|                      -0.9761105|                         -0.9761105|                          -0.9840366|              -0.9766909|                  -0.9825730|              -0.9914465|              -0.9693499|              -0.9723804|                  -0.9894618|                  -0.9736214|                  -0.9831470|      -0.9737264|      -0.9755366|      -0.9662850|                      -0.9754800|                              -0.9852501|                  -0.9692869|                      -0.9809470|               -0.9934705|               -0.9660473|               -0.9639975|                  -0.9904348|                  -0.9573112|                  -0.9747175|                   -0.9895908|                   -0.9756181|                   -0.9838089|       -0.9810119|       -0.9760097|       -0.9674779|           -0.9761132|           -0.9836551|           -0.9778682|                       -0.9695578|                          -0.9695578|                           -0.9859824|               -0.9670629|                   -0.9811418|               -0.9944612|               -0.9653871|               -0.9611429|                   -0.9906798|                   -0.9802597|                   -0.9827954|       -0.9833310|       -0.9763864|       -0.9707020|                       -0.9698069|                               -0.9856577|                   -0.9709459|                       -0.9823419| SITTING           |
| 42   |               0.3021843|              -0.0337868|              -0.1307272|                  0.9786278|                 -0.1001194|                  0.0311875|                  -0.0825355|                   0.1901062|                  -0.1073661|      -0.0638602|      -0.0726452|       0.0957046|           0.0393341|          -0.0519993|          -0.1559080|                      -0.2481901|                         -0.2481901|                          -0.3947133|              -0.3953381|                  -0.6681085|              -0.4459578|              -0.2566108|              -0.3130241|                  -0.5042708|                  -0.4293812|                  -0.4924498|      -0.4517586|      -0.6471984|      -0.5144351|                      -0.4217662|                              -0.4081518|                  -0.6188959|                      -0.7544692|               -0.4305362|               -0.2549636|               -0.1117998|                  -0.9893785|                  -0.9770440|                  -0.9903950|                   -0.4400765|                   -0.3824789|                   -0.4788226|       -0.4246644|       -0.6392952|       -0.4556565|           -0.6856184|           -0.7150804|           -0.5972148|                       -0.4751179|                          -0.4751179|                           -0.4147093|               -0.5703564|                   -0.7656320|               -0.4244557|               -0.3008682|               -0.0791005|                   -0.4240477|                   -0.3716233|                   -0.4655314|       -0.4254552|       -0.6369795|       -0.4873332|                       -0.5889571|                               -0.4257600|                   -0.6108238|                       -0.7982361| WALKING           |
| 252  |               0.2407515|              -0.0218536|              -0.1606405|                  0.9307024|                  0.0199705|                 -0.2353452|                  -0.2609424|                  -0.0668042|                  -0.1971020|      -0.1127970|      -0.1609143|       0.1470008|          -0.0412793|          -0.2462985|           0.4506321|                      -0.0503159|                         -0.0503159|                          -0.0975747|              -0.1467727|                  -0.3798503|              -0.2017852|              -0.1698787|              -0.1901508|                  -0.1571618|                  -0.2427240|                  -0.3182845|      -0.2224511|      -0.2345533|      -0.0813703|                      -0.1327883|                              -0.1217587|                  -0.3365515|                      -0.4444618|               -0.1461893|               -0.2071588|               -0.0503805|                  -0.9637230|                  -0.9725073|                  -0.9449713|                   -0.0173238|                   -0.1966611|                   -0.3559456|       -0.3440863|       -0.2864271|       -0.1530436|           -0.4038969|           -0.3798514|           -0.4176120|                       -0.2651407|                          -0.2651407|                           -0.1098708|               -0.3616482|                   -0.4458867|               -0.1251615|               -0.2780610|               -0.0502410|                    0.0351709|                   -0.1992356|                   -0.3904689|       -0.3835047|       -0.3255473|       -0.2552256|                       -0.4659478|                               -0.1011691|                   -0.4942264|                       -0.4861487| WALKING           |
| 797  |               0.4020390|               0.0162277|              -0.1046300|                  0.9173622|                  0.1408079|                 -0.0124189|                   0.0534539|                   0.4862777|                  -0.0182216|      -0.2937709|      -0.1760062|       0.0466317|          -0.4857204|           0.2052315|           0.2136497|                      -0.0360927|                         -0.0360927|                          -0.2500308|               0.0653723|                  -0.5143968|              -0.1672764|               0.0081162|              -0.2036084|                  -0.1168582|                  -0.2308856|                  -0.5010148|      -0.2093233|      -0.2680670|      -0.3588926|                      -0.1097316|                              -0.0229131|                  -0.2936089|                      -0.5486142|               -0.2176398|               -0.0224422|                0.1347140|                  -0.9730504|                  -0.9427117|                  -0.8526129|                   -0.1212741|                   -0.1901207|                   -0.5600434|       -0.2108905|        0.0820944|       -0.4498612|           -0.4555289|           -0.5414800|           -0.5437311|                       -0.1322769|                          -0.1322769|                           -0.1192198|               -0.0882287|                   -0.5674243|               -0.2383616|               -0.1011539|                0.2089406|                   -0.2073896|                   -0.1992851|                   -0.6192468|       -0.2207299|        0.2429240|       -0.5334575|                       -0.2798680|                               -0.2666284|                   -0.1147379|                       -0.6242672| WALKING\_UPSTAIRS |
| 745  |               0.2298878|              -0.0548944|              -0.2644614|                  0.9589194|                 -0.1705291|                 -0.1761873|                  -0.1371735|                   0.0565016|                  -0.0360573|      -0.0366613|      -0.0813373|       0.0231113|           0.0107776|           0.0100627|           0.0976745|                      -0.1797468|                         -0.1797468|                          -0.4262683|              -0.4799291|                  -0.6392625|              -0.3901840|              -0.2030266|              -0.3450138|                  -0.5594176|                  -0.4374500|                  -0.4896440|      -0.5671740|      -0.5764634|      -0.3932010|                      -0.3037636|                              -0.4605006|                  -0.5921434|                      -0.6931065|               -0.2993341|               -0.0758044|               -0.2646130|                  -0.8986480|                  -0.8699974|                  -0.7478775|                   -0.4959964|                   -0.4056725|                   -0.5194593|       -0.6803472|       -0.5670284|       -0.2964466|           -0.6221846|           -0.6652282|           -0.6174299|                       -0.2756426|                          -0.2756426|                           -0.5013425|               -0.5865614|                   -0.6929932|               -0.2664708|               -0.0719417|               -0.2783331|                   -0.4763448|                   -0.4102151|                   -0.5465236|       -0.7166491|       -0.5642983|       -0.3317137|                       -0.3725815|                               -0.5618496|                   -0.6545713|                       -0.7138800| WALKING\_UPSTAIRS |

### Putting All Transformations Together

Let's create a single function which puts every single transformation we've made together:

``` r
cleanup_data <- function(data, labels) {
  data <- add_labels(data, labels)
  data <- add_variable_names(data)
  data <- select_mean_and_std_variables(data)
  data <- normalize_variable_names(data)
  add_activity_label_variable(data, activities)
}
```

Which we can apply to the training data-set as well:

``` r
train_data <- cleanup_data(train_data, train_labels)
sample_data_frame(train_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 4758 |               0.2792417|              -0.0172902|              -0.1139404|                  0.9250657|                 -0.3437151|                 -0.0031755|                   0.0721948|                   0.0119410|                  -0.0000576|      -0.0284409|      -0.0756227|       0.0857701|          -0.0936568|          -0.0394941|          -0.0546715|                      -0.9941694|                         -0.9941694|                          -0.9932599|              -0.9950998|                  -0.9976207|              -0.9976818|              -0.9875938|              -0.9876821|                  -0.9960956|                  -0.9864383|                  -0.9899710|      -0.9921620|      -0.9974694|      -0.9953713|                      -0.9911081|                              -0.9918580|                  -0.9963535|                      -0.9982111|               -0.9982846|               -0.9891352|               -0.9861729|                  -0.9988373|                  -0.9977726|                  -0.9874882|                   -0.9962002|                   -0.9863870|                   -0.9909444|       -0.9925565|       -0.9975611|       -0.9965818|           -0.9960725|           -0.9979221|           -0.9955874|                       -0.9916720|                          -0.9916720|                           -0.9913220|               -0.9954480|                   -0.9985078|               -0.9985909|               -0.9896117|               -0.9853718|                   -0.9966678|                   -0.9872771|                   -0.9903373|       -0.9926208|       -0.9975637|       -0.9974002|                       -0.9924288|                               -0.9889212|                   -0.9953491|                       -0.9988178| STANDING            |
| 615  |               0.2697936|              -0.0272160|              -0.1225540|                  0.9493353|                 -0.1261211|                  0.1321228|                  -0.3215543|                   0.1506135|                   0.2983435|      -0.0427206|       0.0942671|       0.0668835|          -0.1035206|           0.0127920|           0.1203697|                      -0.1322475|                         -0.1322475|                          -0.3388114|              -0.3164433|                  -0.5628311|              -0.1798789|              -0.1466897|              -0.3495777|                  -0.3378615|                  -0.2028873|                  -0.5158931|      -0.5506913|      -0.3950391|      -0.3604208|                      -0.3607567|                              -0.2185892|                  -0.4588368|                      -0.6801771|               -0.2208782|               -0.1498219|               -0.2542048|                  -0.9821096|                  -0.9715052|                  -0.9753134|                   -0.3222894|                   -0.1633932|                   -0.5510698|       -0.6705492|       -0.2003079|       -0.4062362|           -0.5284431|           -0.6209520|           -0.5391480|                       -0.3537374|                          -0.3537374|                           -0.2293585|               -0.3943648|                   -0.6763713|               -0.2375514|               -0.2051025|               -0.2609768|                   -0.3666050|                   -0.1759071|                   -0.5837750|       -0.7091016|       -0.1062991|       -0.4762546|                       -0.4498675|                               -0.2482848|                   -0.4540756|                       -0.6938992| WALKING             |
| 802  |               0.2501258|              -0.0226856|              -0.0647997|                  0.9243349|                 -0.3169042|                 -0.1240374|                   0.1506988|                   0.0482754|                  -0.0229145|       0.0713307|      -0.1415893|      -0.0210508|          -0.0951714|          -0.1422554|          -0.0769989|                      -0.2699472|                         -0.2699472|                          -0.3062908|              -0.2903208|                  -0.3775238|              -0.4534363|              -0.1695050|              -0.4266406|                  -0.3806740|                  -0.2793066|                  -0.5328861|      -0.4602415|      -0.2782544|      -0.4242618|                      -0.3047777|                              -0.2796107|                  -0.3318530|                      -0.4804871|               -0.4441813|               -0.0022361|               -0.2962436|                  -0.9813355|                  -0.9537816|                  -0.9030647|                   -0.3291416|                   -0.1242416|                   -0.5261679|       -0.5259928|       -0.1939141|       -0.4883361|           -0.3362014|           -0.3876892|           -0.4844248|                       -0.3382044|                          -0.3382044|                           -0.2550946|               -0.2732770|                   -0.4485300|               -0.4404705|                0.0146384|               -0.2829841|                   -0.3345126|                   -0.0215395|                   -0.5188296|       -0.5482293|       -0.1515775|       -0.5579242|                       -0.4603662|                               -0.2294655|                   -0.3575461|                       -0.4467099| WALKING             |
| 68   |               0.2197550|              -0.0464343|              -0.1310563|                  0.9510928|                 -0.2096309|                  0.0937766|                  -0.2828860|                   0.2226218|                  -0.1567822|      -0.0067918|      -0.0854682|       0.1210381|          -0.1257030|          -0.1812127|           0.0579165|                      -0.2099542|                         -0.2099542|                          -0.2839636|              -0.3964258|                  -0.5778271|              -0.2652501|               0.0472017|              -0.5363064|                  -0.3196172|                  -0.1007798|                  -0.6285054|      -0.4774664|      -0.5637969|      -0.3742123|                      -0.3758836|                              -0.2142278|                  -0.5465135|                      -0.6953373|               -0.3484896|                0.0635959|               -0.5348024|                  -0.9877954|                  -0.9644309|                  -0.9800859|                   -0.2729943|                   -0.0282009|                   -0.6566592|       -0.5656903|       -0.4280955|       -0.4321973|           -0.4773679|           -0.6688313|           -0.5284312|                       -0.4238676|                          -0.4238676|                           -0.2185975|               -0.5154698|                   -0.6831683|               -0.3842899|                0.0050783|               -0.5712477|                   -0.2882416|                   -0.0124714|                   -0.6825064|       -0.5939974|       -0.3622800|       -0.5044040|                       -0.5419958|                               -0.2294445|                   -0.5771654|                       -0.6893345| WALKING             |
| 6743 |               0.2833040|              -0.0166405|              -0.1113246|                 -0.1617676|                  0.9553195|                  0.0391534|                   0.0779259|                   0.0171553|                  -0.0324415|      -0.0228639|      -0.0761991|       0.0862908|          -0.0901204|          -0.0381161|          -0.0634036|                      -0.9847182|                         -0.9847182|                          -0.9851634|              -0.9908922|                  -0.9946040|              -0.9901084|              -0.9722989|              -0.9693591|                  -0.9887654|                  -0.9751991|                  -0.9820348|      -0.9821290|      -0.9971703|      -0.9866438|                      -0.9757276|                              -0.9808039|                  -0.9867098|                      -0.9943960|               -0.9905551|               -0.9746370|               -0.9706462|                  -0.9908741|                  -0.9976732|                  -0.9837630|                   -0.9892047|                   -0.9734480|                   -0.9850563|       -0.9868386|       -0.9976593|       -0.9899822|           -0.9863711|           -0.9980378|           -0.9926767|                       -0.9765947|                          -0.9765947|                           -0.9820008|               -0.9853386|                   -0.9933960|               -0.9906181|               -0.9764932|               -0.9729744|                   -0.9907381|                   -0.9731369|                   -0.9867702|       -0.9883081|       -0.9979777|       -0.9922694|                       -0.9797172|                               -0.9824008|                   -0.9866586|                       -0.9920757| LAYING              |
| 2608 |               0.4419032|              -0.0452483|              -0.1193313|                  0.9500989|                 -0.1781449|                  0.0033388|                  -0.2981955|                   0.3204748|                   0.1165941|      -0.4805770|       0.1673443|      -0.0080061|          -0.0034853|           0.1096405|          -0.0195098|                       0.2778843|                          0.2778843|                          -0.0258876|              -0.0972889|                  -0.4041307|               0.3684513|               0.2047330|              -0.5885570|                   0.1300049|                   0.0059994|                  -0.6436856|      -0.1358238|      -0.3810349|      -0.0272562|                       0.2634078|                               0.1183820|                  -0.2337023|                      -0.4261135|                0.3847453|                0.2627926|               -0.5722022|                  -0.9774857|                  -0.9629987|                  -0.9804151|                    0.1397780|                    0.1372233|                   -0.6628322|       -0.1999445|       -0.4495906|       -0.1923654|           -0.3484500|           -0.5383312|           -0.0251848|                        0.3634670|                           0.3634670|                            0.0755423|               -0.0090433|                   -0.4332798|                0.3910646|                0.2130953|               -0.5965960|                    0.0464055|                    0.2041866|                   -0.6795449|       -0.2251822|       -0.5005366|       -0.3284482|                        0.2041344|                                0.0102281|                   -0.0371437|                       -0.4832387| WALKING\_DOWNSTAIRS |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

Here's a full description of the variables from the clean data-set:

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
<td>ActivityLabel</td>
<td>A descriptive label for the activity, i.e.: LAYING, SITTING, WALKING, WALKING_UPSTAIRS or WALKING_DOWNSTAIRS.</td>
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

The following data-set has been grouped by activity and all columns summarised into means:

``` r
averages_data <- all_data %>% group_by(ActivityLabel) %>% summarise_each(funs(mean))
averages_data
```

| ActivityLabel       |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|:--------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
| LAYING              |               0.2686486|              -0.0183177|              -0.1074356|                 -0.3750213|                  0.6222704|                  0.5556125|                   0.0818474|                   0.0111724|                  -0.0048598|      -0.0167253|      -0.0934107|       0.1258851|          -0.1018643|          -0.0381981|          -0.0638498|                      -0.9411107|                         -0.9411107|                          -0.9792088|              -0.9384360|                  -0.9827266|              -0.9668121|              -0.9526784|              -0.9600180|                  -0.9801977|                  -0.9713836|                  -0.9766145|      -0.9629150|      -0.9675821|      -0.9641844|                      -0.9476727|                              -0.9743001|                  -0.9548545|                      -0.9779682|               -0.9609324|               -0.9435072|               -0.9480693|                  -0.9433197|                  -0.9631917|                  -0.9518687|                   -0.9803818|                   -0.9711476|                   -0.9794766|       -0.9678924|       -0.9631925|       -0.9635092|           -0.9761248|           -0.9804736|           -0.9847825|                       -0.9321600|                          -0.9321600|                           -0.9742406|               -0.9405961|                   -0.9767550|               -0.9590315|               -0.9424610|               -0.9456436|                   -0.9824596|                   -0.9730512|                   -0.9809719|       -0.9697473|       -0.9613654|       -0.9667252|                       -0.9349167|                               -0.9731834|                   -0.9421157|                       -0.9766482|
| SITTING             |               0.2730596|              -0.0126896|              -0.1055170|                  0.8797312|                  0.1087135|                  0.1537741|                   0.0758788|                   0.0050469|                  -0.0024867|      -0.0384313|      -0.0721208|       0.0777771|          -0.0956521|          -0.0407798|          -0.0507555|                      -0.9546439|                         -0.9546439|                          -0.9824444|              -0.9467241|                  -0.9878801|              -0.9830920|              -0.9479180|              -0.9570310|                  -0.9851888|                  -0.9739882|                  -0.9795620|      -0.9772673|      -0.9724576|      -0.9610287|                      -0.9524104|                              -0.9786844|                  -0.9642961|                      -0.9853356|               -0.9834462|               -0.9348806|               -0.9389816|                  -0.9796822|                  -0.9576727|                  -0.9473574|                   -0.9849972|                   -0.9738832|                   -0.9822965|       -0.9810222|       -0.9667081|       -0.9580075|           -0.9857051|           -0.9865023|           -0.9838055|                       -0.9393242|                          -0.9393242|                           -0.9789071|               -0.9511990|                   -0.9846076|               -0.9837473|               -0.9325335|               -0.9343367|                   -0.9861850|                   -0.9757509|                   -0.9836708|       -0.9823333|       -0.9640337|       -0.9610302|                       -0.9420002|                               -0.9781548|                   -0.9516417|                       -0.9844914|
| STANDING            |               0.2791535|              -0.0161519|              -0.1065869|                  0.9414796|                 -0.1842465|                 -0.0140520|                   0.0750279|                   0.0088053|                  -0.0045821|      -0.0266871|      -0.0677119|       0.0801422|          -0.0997293|          -0.0423171|          -0.0520955|                      -0.9541797|                         -0.9541797|                          -0.9771180|              -0.9421525|                  -0.9786971|              -0.9816223|              -0.9431324|              -0.9573597|                  -0.9800087|                  -0.9645474|                  -0.9761578|      -0.9436543|      -0.9653028|      -0.9583850|                      -0.9558681|                              -0.9710904|                  -0.9479085|                      -0.9748860|               -0.9844347|               -0.9325087|               -0.9399135|                  -0.9880152|                  -0.9693518|                  -0.9530825|                   -0.9799686|                   -0.9643428|                   -0.9794859|       -0.9455284|       -0.9612933|       -0.9570531|           -0.9669579|           -0.9802633|           -0.9770671|                       -0.9465348|                          -0.9465348|                           -0.9714530|               -0.9295312|                   -0.9735286|               -0.9858598|               -0.9311330|               -0.9354396|                   -0.9818261|                   -0.9668316|                   -0.9815093|       -0.9469716|       -0.9594986|       -0.9606892|                       -0.9496016|                               -0.9709480|                   -0.9306367|                       -0.9734611|
| WALKING             |               0.2763369|              -0.0179068|              -0.1088817|                  0.9349916|                 -0.1967135|                 -0.0538251|                   0.0767187|                   0.0115062|                  -0.0023194|      -0.0347276|      -0.0694200|       0.0863626|          -0.0943007|          -0.0445701|          -0.0540065|                      -0.1679379|                         -0.1679379|                          -0.2414520|              -0.2748660|                  -0.4605115|              -0.2978909|              -0.0423392|              -0.3418407|                  -0.3111274|                  -0.1703951|                  -0.4510105|      -0.3482374|      -0.3883849|      -0.3104062|                      -0.2755581|                              -0.2146540|                  -0.4091730|                      -0.5155168|               -0.3146445|               -0.0235829|               -0.2739208|                  -0.9776121|                  -0.9669039|                  -0.9545976|                   -0.2672882|                   -0.1031411|                   -0.4791471|       -0.4699148|       -0.3479218|       -0.3384486|           -0.3762214|           -0.5126191|           -0.4474272|                       -0.3377540|                          -0.3377540|                           -0.2145559|               -0.3826290|                   -0.4988410|               -0.3228358|               -0.0772063|               -0.2960783|                   -0.2878977|                   -0.0908699|                   -0.5063291|       -0.5104320|       -0.3319615|       -0.4105691|                       -0.4800023|                               -0.2216178|                   -0.4738331|                       -0.5144048|
| WALKING\_DOWNSTAIRS |               0.2881372|              -0.0163119|              -0.1057616|                  0.9264574|                 -0.1685072|                 -0.0479709|                   0.0892267|                   0.0007467|                  -0.0087286|      -0.0840345|      -0.0529929|       0.0946782|          -0.0728532|          -0.0512640|          -0.0546962|                       0.1012497|                          0.1012497|                          -0.1118018|              -0.1297856|                  -0.4168916|               0.0352597|               0.0566827|              -0.2137292|                  -0.0722968|                  -0.1163806|                  -0.3331903|      -0.2179229|      -0.3175927|      -0.1656251|                       0.1428494|                               0.0047625|                  -0.2895258|                      -0.4380073|                0.1007663|                0.0595486|               -0.1908045|                  -0.9497488|                  -0.9342661|                  -0.9124606|                   -0.0338826|                   -0.0736744|                   -0.3886661|       -0.3338175|       -0.3396314|       -0.2728099|           -0.3826898|           -0.4659438|           -0.3264560|                        0.1164889|                           0.1164889|                           -0.0112207|               -0.2514278|                   -0.4409293|                0.1219380|               -0.0082337|               -0.2458729|                   -0.0821905|                   -0.0914165|                   -0.4435547|       -0.3751275|       -0.3618537|       -0.3804100|                       -0.0754252|                               -0.0422714|                   -0.3612310|                       -0.4864430|
| WALKING\_UPSTAIRS   |               0.2622946|              -0.0259233|              -0.1205379|                  0.8750034|                 -0.2813772|                 -0.1407957|                   0.0767293|                   0.0087589|                  -0.0060095|       0.0068245|      -0.0885225|       0.0598938|          -0.1121175|          -0.0386193|          -0.0525810|                      -0.1002041|                         -0.1002041|                          -0.3909386|              -0.1782811|                  -0.6080471|              -0.2934068|              -0.1349505|              -0.3681221|                  -0.3898968|                  -0.3646668|                  -0.5916701|      -0.3942482|      -0.4592535|      -0.2968577|                      -0.2620281|                              -0.3539620|                  -0.4497814|                      -0.6586945|               -0.2379897|               -0.0160325|               -0.1754497|                  -0.9481913|                  -0.9255493|                  -0.9019056|                   -0.3608634|                   -0.3392265|                   -0.6270636|       -0.4676071|       -0.3442318|       -0.2371368|           -0.5531328|           -0.6673392|           -0.5609892|                       -0.2498752|                          -0.2498752|                           -0.3854004|               -0.3371421|                   -0.6668367|               -0.2188880|               -0.0218110|               -0.1466018|                   -0.3889928|                   -0.3576329|                   -0.6615908|       -0.4952540|       -0.2931818|       -0.2920413|                       -0.3617535|                               -0.4342067|                   -0.3814064|                       -0.7030835|

Saving Clean Data to Disk
-------------------------

Let's finally save our clean data-sets to `*.csv` files:

``` r
write.csv(all_data, "./tidy_data/activity_data.csv")
write.csv(averages_data, "./tidy_data/activity_averages_data.csv")
```
