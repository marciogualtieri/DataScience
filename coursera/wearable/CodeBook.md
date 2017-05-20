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

    ## [1] "tBodyGyroJerk-std()-Y"               
    ## [2] "fBodyAccJerk-entropy()-X"            
    ## [3] "tBodyAcc-energy()-Y"                 
    ## [4] "fBodyAcc-bandsEnergy()-25,48"        
    ## [5] "angle(tBodyGyroJerkMean,gravityMean)"
    ## [6] "tGravityAcc-arCoeff()-X,1"

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

    ## [1] "fBodyBodyGyroJerkMag-sma()"       "fBodyAccJerk-bandsEnergy()-25,32"
    ## [3] "fBodyAccJerk-max()-Y"             "fBodyAcc-bandsEnergy()-1,8"      
    ## [5] "tGravityAcc-correlation()-X,Y"    "fBodyAcc-sma()"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAccJerk-mean()-X" "tBodyGyroMag-mean()"   "tBodyAcc-mean()-Y"    
    ## [4] "tBodyAccJerk-mean()-Y" "tBodyGyro-mean()-X"    "tBodyAcc-mean()-Z"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAcc-std()-X"       "fBodyGyro-std()-Y"     
    ## [3] "fBodyAccJerk-std()-X"   "fBodyBodyGyroMag-std()"
    ## [5] "tGravityAccMag-std()"   "tBodyAccJerkMag-std()"

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

    ## [1] "fBodyBodyGyroMag-iqr()"          "fBodyAcc-bandsEnergy()-41,48"   
    ## [3] "tBodyGyroJerk-correlation()-Y,Z" "fBodyGyro-bandsEnergy()-49,64"  
    ## [5] "fBodyGyro-bandsEnergy()-17,32"   "fBodyAcc-entropy()-X"

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
| 332  |               0.2884612|              -0.0236801|              -0.1178259|                  0.8513792|                  0.2836989|                  0.2356848|                   0.0847041|                   0.0096719|                   0.0030417|      -0.0383786|      -0.1150702|       0.2872291|          -0.0926080|          -0.0368024|          -0.0863166|                      -0.9819238|                         -0.9819238|                          -0.9939058|              -0.9084345|                  -0.9957305|              -0.9916540|              -0.9840191|              -0.9871937|                  -0.9941680|                  -0.9892555|                  -0.9928916|      -0.9881287|      -0.9898145|      -0.9536449|                      -0.9878608|                              -0.9965395|                  -0.9680343|                      -0.9963686|               -0.9886401|               -0.9771982|               -0.9785168|                  -0.9770109|                  -0.9742080|                  -0.9747600|                   -0.9941434|                   -0.9889833|                   -0.9948820|       -0.9917748|       -0.9839173|       -0.9466307|           -0.9928140|           -0.9960871|           -0.9950591|                       -0.9841141|                          -0.9841141|                           -0.9970382|               -0.9484538|                   -0.9964652|               -0.9872788|               -0.9743228|               -0.9744621|                   -0.9946243|                   -0.9893955|                   -0.9956348|       -0.9929538|       -0.9809671|       -0.9491153|                       -0.9832252|                               -0.9966429|                   -0.9456883|                       -0.9964851|           4|
| 1792 |               0.2409767|              -0.0107686|              -0.0450379|                  0.9237196|                 -0.3182152|                  0.0309672|                  -0.0600556|                  -0.4495608|                   0.2067692|       0.1371375|      -0.1642014|       0.1011089|           0.1917997|          -0.3957789|          -0.2113921|                      -0.0844552|                         -0.0844552|                          -0.0941424|              -0.2183827|                  -0.3437980|              -0.2556215|               0.2323097|              -0.2902148|                  -0.1501716|                   0.0370048|                  -0.3992281|       0.0118283|      -0.3667546|      -0.2506354|                      -0.1474342|                              -0.0023652|                  -0.2922554|                      -0.5178434|               -0.2535089|                0.2639254|               -0.3390155|                  -0.9723024|                  -0.9437803|                  -0.9537404|                   -0.0506132|                    0.1158787|                   -0.4389594|       -0.2637658|       -0.4283099|       -0.4077446|           -0.0439349|           -0.5931500|           -0.1740250|                       -0.2139875|                          -0.2139875|                            0.0179230|               -0.3023512|                   -0.4850721|               -0.2526020|                0.2006374|               -0.4250350|                   -0.0323126|                    0.1288629|                   -0.4758176|       -0.3527200|       -0.4739385|       -0.5236779|                       -0.3761275|                                0.0373388|                   -0.4330365|                       -0.4799691|           1|
| 2290 |               0.2574917|              -0.0155332|              -0.1060165|                 -0.6902758|                  0.7881960|                  0.6244838|                   0.0881199|                   0.0089396|                  -0.0127209|      -0.0372909|      -0.1301297|       0.1309195|          -0.0956696|          -0.0323125|          -0.0787933|                      -0.9869838|                         -0.9869838|                          -0.9923371|              -0.9653296|                  -0.9971260|              -0.9835428|              -0.9904871|              -0.9902420|                  -0.9896075|                  -0.9912381|                  -0.9932551|      -0.9950647|      -0.9862903|      -0.9619684|                      -0.9843665|                              -0.9934798|                  -0.9734457|                      -0.9978414|               -0.9818967|               -0.9923985|               -0.9906825|                  -0.9551415|                  -0.9928913|                  -0.9891454|                   -0.9898610|                   -0.9909981|                   -0.9929304|       -0.9957284|       -0.9789598|       -0.9545072|           -0.9973808|           -0.9963668|           -0.9959532|                       -0.9818838|                          -0.9818838|                           -0.9936201|               -0.9558056|                   -0.9980167|               -0.9810428|               -0.9929221|               -0.9908257|                   -0.9910890|                   -0.9913066|                   -0.9909346|       -0.9958688|       -0.9753373|       -0.9561619|                       -0.9820516|                               -0.9923867|                   -0.9529913|                       -0.9980992|           6|
| 1363 |               0.2440453|              -0.0025404|               0.0316164|                  0.9695732|                 -0.2212116|                 -0.0756962|                  -0.0224930|                  -0.0412645|                  -0.3407036|      -0.2004080|       0.2667009|      -0.2569273|          -0.0095320|          -0.1041398|           0.0249466|                      -0.4974132|                         -0.4974132|                          -0.8984696|              -0.5689474|                  -0.8042937|              -0.8548630|              -0.8799245|              -0.4620692|                  -0.8978769|                  -0.9386915|                  -0.8335649|      -0.8579401|      -0.4416324|      -0.7828010|                      -0.5675879|                              -0.8518066|                  -0.4178721|                      -0.6679314|               -0.8654334|               -0.7746714|                0.0508167|                  -0.7617119|                  -0.8865528|                  -0.1485757|                   -0.8980692|                   -0.9423253|                   -0.8593778|       -0.9137615|       -0.3896576|       -0.8147624|           -0.9048569|           -0.6908805|           -0.8575180|                       -0.4215796|                          -0.4215796|                           -0.8480200|               -0.3139762|                   -0.6541387|               -0.8696907|               -0.7473041|                0.1839309|                   -0.9076176|                   -0.9516142|                   -0.8857990|       -0.9340252|       -0.3638815|       -0.8433703|                       -0.4432797|                               -0.8426767|                   -0.3623295|                       -0.6604793|           5|
| 1229 |               0.1665200|               0.0135549|              -0.1067224|                  0.8183248|                  0.2957494|                  0.3481667|                   0.1198337|                  -0.1204820|                  -0.0902269|      -0.0609181|      -0.3319518|       0.3676935|          -0.0980450|          -0.0537620|          -0.0668656|                      -0.8754948|                         -0.8754948|                          -0.9724410|              -0.8203931|                  -0.9749164|              -0.9428957|              -0.8142940|              -0.8803175|                  -0.9810987|                  -0.9607062|                  -0.9693626|      -0.9499772|      -0.9598498|      -0.9697028|                      -0.8037408|                              -0.9705346|                  -0.9560273|                      -0.9584884|               -0.9301963|               -0.7655327|               -0.8310466|                  -0.8173199|                  -0.7558657|                  -0.7630494|                   -0.9806473|                   -0.9608014|                   -0.9742757|       -0.9658374|       -0.9671171|       -0.9625241|           -0.9529785|           -0.9684317|           -0.9844544|                       -0.7650262|                          -0.7650262|                           -0.9735605|               -0.9506486|                   -0.9558676|               -0.9254276|               -0.7566977|               -0.8187895|                   -0.9818401|                   -0.9637547|                   -0.9780220|       -0.9710975|       -0.9727297|       -0.9635482|                       -0.7810655|                               -0.9768022|                   -0.9551594|                       -0.9551717|           4|
| 1428 |               0.2904561|              -0.0181239|              -0.1102997|                 -0.3463766|                  0.9744216|                 -0.1046237|                   0.0764827|                   0.0130095|                  -0.0000528|      -0.0317715|      -0.0781130|       0.0859641|          -0.1015956|          -0.0385447|          -0.0579861|                      -0.9858058|                         -0.9858058|                          -0.9800774|              -0.9816780|                  -0.9847580|              -0.9839948|              -0.9783692|              -0.9756021|                  -0.9819556|                  -0.9734650|                  -0.9742638|      -0.9670980|      -0.9774707|      -0.9725800|                      -0.9772274|                              -0.9714870|                  -0.9660541|                      -0.9739948|               -0.9857474|               -0.9833967|               -0.9782770|                  -0.9884134|                  -0.9965106|                  -0.9902544|                   -0.9827986|                   -0.9719536|                   -0.9754977|       -0.9792284|       -0.9805919|       -0.9748334|           -0.9678217|           -0.9822323|           -0.9827722|                       -0.9803592|                          -0.9803592|                           -0.9716767|               -0.9649801|                   -0.9713656|               -0.9864163|               -0.9865874|               -0.9810288|                   -0.9854295|                   -0.9720403|                   -0.9750369|       -0.9834903|       -0.9828841|       -0.9778060|                       -0.9846374|                               -0.9700503|                   -0.9700978|                       -0.9695742|           6|

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
| 813  |               0.2982851|              -0.0285071|              -0.1405585|                  0.9373501|                 -0.2225149|                 -0.1318245|                   0.5431963|                  -0.0885424|                  -0.1873893|      -0.4498534|      -0.0041158|       0.1806431|          -0.0824112|          -0.0399783|          -0.0399954|                      -0.2537807|                         -0.2537807|                          -0.4224605|              -0.2399493|                  -0.7015266|              -0.1979453|              -0.3519617|              -0.5108088|                  -0.2996037|                  -0.4411650|                  -0.6424926|      -0.5430773|      -0.5662860|      -0.3482860|                      -0.2662723|                              -0.3428046|                  -0.6120638|                      -0.7178601|               -0.2515663|               -0.2790896|               -0.4669751|                  -0.9018621|                  -0.8835514|                  -0.9164730|                   -0.3008820|                   -0.4516574|                   -0.6577340|       -0.5540702|       -0.5248767|       -0.2185825|           -0.6537998|           -0.7503091|           -0.6095824|                       -0.2810856|                          -0.2810856|                           -0.3368480|               -0.4896888|                   -0.7339419|               -0.2736817|               -0.2877062|               -0.4843005|                   -0.3666914|                   -0.5055009|                   -0.6705692|       -0.5619652|       -0.5042681|       -0.2518842|                       -0.4008807|                               -0.3333997|                   -0.5004388|                       -0.7754853| WALKING\_UPSTAIRS   |
| 345  |               0.1874192|              -0.0115332|              -0.1065096|                  0.9303674|                 -0.3469315|                  0.0249367|                   0.2166230|                   0.1923421|                  -0.0945864|       0.0223199|      -0.1614986|       0.1166894|          -0.0369617|          -0.0611784|           0.0641776|                      -0.3391323|                         -0.3391323|                          -0.3682003|              -0.4965733|                  -0.6516866|              -0.3646523|              -0.1630175|              -0.5037622|                  -0.3273473|                  -0.2592226|                  -0.5996663|      -0.5190686|      -0.6069575|      -0.4418593|                      -0.4400490|                              -0.2956881|                  -0.5683698|                      -0.7039621|               -0.4508537|               -0.1963086|               -0.4598695|                  -0.9684282|                  -0.9812337|                  -0.9775041|                   -0.3259246|                   -0.2416080|                   -0.6307145|       -0.6264193|       -0.5420361|       -0.5263441|           -0.5501595|           -0.7319334|           -0.5724387|                       -0.4945695|                          -0.4945695|                           -0.3101275|               -0.5977214|                   -0.7079671|               -0.4887438|               -0.2655642|               -0.4777487|                   -0.3862257|                   -0.2746842|                   -0.6595094|       -0.6604761|       -0.5092714|       -0.6008760|                       -0.6063131|                               -0.3306176|                   -0.6933645|                       -0.7340308| WALKING             |
| 1023 |               0.3531140|               0.0130442|              -0.0942455|                  0.9620382|                 -0.2108264|                  0.0057383|                  -0.0192930|                   0.1586730|                  -0.0827534|       0.5105321|      -0.3058416|       0.2000764|          -0.1816346|           0.1724938|          -0.1001816|                       0.0199764|                          0.0199764|                          -0.0979285|              -0.1850243|                  -0.4366210|              -0.0905608|              -0.0321357|              -0.3225924|                  -0.0937825|                  -0.1298699|                  -0.4387536|      -0.3424118|      -0.4457924|      -0.1982762|                       0.0114103|                              -0.0510113|                  -0.4212690|                      -0.5964293|                0.0246663|               -0.0057649|               -0.3278427|                  -0.9788348|                  -0.8641432|                  -0.9072174|                   -0.0468931|                   -0.0157264|                   -0.4802163|       -0.5631769|       -0.4866748|       -0.3130444|           -0.2330403|           -0.6356092|           -0.2799612|                       -0.0329202|                          -0.0329202|                           -0.1283409|               -0.3904138|                   -0.5886126|                0.0666950|               -0.0545808|               -0.3856688|                   -0.0818031|                    0.0427642|                   -0.5191056|       -0.6379933|       -0.5172246|       -0.4179798|                       -0.2092028|                               -0.2404824|                   -0.4738784|                       -0.6071148| WALKING\_DOWNSTAIRS |
| 1687 |               0.2741095|              -0.0053650|              -0.0973274|                  0.9669196|                 -0.0086505|                  0.1115528|                   0.0798728|                  -0.0200239|                  -0.0205464|      -0.0134945|      -0.0819938|       0.1317926|          -0.1044043|          -0.0332349|          -0.0589029|                      -0.9645981|                         -0.9645981|                          -0.9655250|              -0.9616693|                  -0.9817671|              -0.9808126|              -0.9369315|              -0.9745488|                  -0.9708216|                  -0.9501592|                  -0.9766448|      -0.9757434|      -0.9751776|      -0.9564507|                      -0.9687992|                              -0.9727357|                  -0.9732773|                      -0.9830627|               -0.9862845|               -0.9326201|               -0.9740407|                  -0.9947329|                  -0.9625983|                  -0.9732928|                   -0.9704853|                   -0.9491490|                   -0.9805898|       -0.9809474|       -0.9738747|       -0.9554330|           -0.9794937|           -0.9841233|           -0.9748513|                       -0.9705374|                          -0.9705374|                           -0.9759454|               -0.9703995|                   -0.9847864|               -0.9891712|               -0.9335612|               -0.9748826|                   -0.9727497|                   -0.9515159|                   -0.9833244|       -0.9825335|       -0.9731659|       -0.9589827|                       -0.9750604|                               -0.9793402|                   -0.9732395|                       -0.9882550| SITTING             |
| 1373 |               0.2400289|              -0.0150752|              -0.1014941|                  0.9477692|                 -0.1603794|                 -0.0902047|                   0.0277469|                   0.0266840|                  -0.0151231|      -0.0157990|      -0.0999190|       0.0092137|           0.0143244|          -0.0948409|          -0.0515339|                      -0.0523964|                         -0.0523964|                          -0.2753381|              -0.4892697|                  -0.4701831|              -0.2267621|              -0.1591852|              -0.2475160|                  -0.3679645|                  -0.1948347|                  -0.3295904|      -0.4532207|      -0.3872656|      -0.5209058|                      -0.0701835|                              -0.2707396|                  -0.4385376|                      -0.4614194|               -0.0449841|               -0.1867990|               -0.2538605|                  -0.9515118|                  -0.9788506|                  -0.9570205|                   -0.3263009|                   -0.1794904|                   -0.3712898|       -0.6170727|       -0.4803177|       -0.5952516|           -0.4587069|           -0.4118384|           -0.5721059|                       -0.1014559|                          -0.1014559|                           -0.2131873|               -0.5313033|                   -0.4124921|                0.0178651|               -0.2534142|               -0.3184932|                   -0.3420281|                   -0.2198784|                   -0.4099430|       -0.6708706|       -0.5510368|       -0.6598406|                       -0.2590334|                               -0.1493874|                   -0.7015791|                       -0.3932934| WALKING\_DOWNSTAIRS |
| 2876 |              -0.5920043|               0.1469833|               0.0525608|                  0.0942958|                  0.7600206|                  0.4341949|                   0.4032685|                  -0.4944821|                   0.0776206|       0.1069460|      -0.1800828|       0.5863902|          -0.0753031|          -0.1228472|          -0.0212718|                      -0.3552521|                         -0.3552521|                          -0.8959882|              -0.6845302|                  -0.8893179|              -0.5014898|              -0.3303945|              -0.7822620|                  -0.8313287|                  -0.8347357|                  -0.8516083|      -0.9076998|      -0.7326530|      -0.8770516|                      -0.1097176|                              -0.7460609|                  -0.7518159|                      -0.7221136|               -0.4243634|               -0.2201935|               -0.7041766|                   0.3319482|                  -0.2619098|                  -0.6292920|                   -0.8472062|                   -0.8322283|                   -0.8840189|       -0.9224270|       -0.7721474|       -0.8986281|           -0.9382154|           -0.7839559|           -0.9094523|                        0.1926584|                           0.1926584|                           -0.7570652|               -0.7857214|                   -0.7341502|               -0.3964483|               -0.2153501|               -0.6874500|                   -0.8826829|                   -0.8412016|                   -0.9217036|       -0.9271026|       -0.8020301|       -0.9160244|                        0.1462056|                               -0.7711571|                   -0.8552519|                       -0.7678528| LAYING              |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityName      |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 1895 |               0.3075485|              -0.0535180|              -0.1211625|                  0.9137619|                 -0.3121488|                 -0.0077094|                   0.0781224|                   0.0502699|                  -0.2040537|      -0.2226498|       0.0284094|       0.0470541|           0.0119530|          -0.0878167|          -0.1885158|                       0.1865479|                          0.1865479|                          -0.1460976|              -0.1799286|                  -0.5971083|              -0.0878852|               0.0242307|              -0.2278635|                  -0.0657723|                  -0.2339884|                  -0.4063719|      -0.2024800|      -0.5359983|      -0.3173175|                      -0.1760031|                              -0.1411108|                  -0.4836161|                      -0.6817186|                0.0637129|                0.1605520|               -0.0825527|                  -0.9803692|                  -0.9861238|                  -0.9455897|                   -0.0477052|                   -0.2056514|                   -0.4845452|       -0.2315110|       -0.4896404|       -0.2629004|           -0.4200371|           -0.7271343|           -0.5658046|                       -0.2257607|                          -0.2257607|                           -0.1797832|               -0.3087521|                   -0.7005000|                0.1178560|                0.1546558|               -0.0773720|                   -0.1143321|                   -0.2283332|                   -0.5649532|       -0.2476495|       -0.4665064|       -0.3131974|                       -0.3751910|                               -0.2375572|                   -0.3189122|                       -0.7477620| WALKING\_UPSTAIRS |
| 1167 |               0.3190192|               0.0078644|              -0.1418566|                  0.9310316|                 -0.2660423|                 -0.0318911|                  -0.0308223|                  -0.1160500|                   0.1615609|      -0.1015731|       0.0243147|       0.0303446|          -0.2309803|           0.1388671|          -0.2412161|                      -0.0599942|                         -0.0599942|                          -0.0269549|              -0.0122447|                  -0.3022152|              -0.0686738|               0.0005371|              -0.2947007|                   0.0465607|                  -0.1760422|                  -0.3374184|       0.1137893|      -0.2998978|      -0.0688926|                      -0.0957562|                              -0.0192464|                  -0.2555172|                      -0.4028270|               -0.1400897|                0.0287991|               -0.3128640|                  -0.9575329|                  -0.9808416|                  -0.9821556|                    0.0778641|                   -0.1135283|                   -0.4010932|       -0.0720888|       -0.2949580|       -0.1329424|            0.0237577|           -0.4993275|           -0.2642281|                       -0.2305737|                          -0.2305737|                           -0.0833871|               -0.1442879|                   -0.4174922|               -0.1698913|               -0.0212270|               -0.3802180|                    0.0147074|                   -0.1032434|                   -0.4632559|       -0.1319033|       -0.2968608|       -0.2342320|                       -0.4383353|                               -0.1766949|                   -0.2159113|                       -0.4788016| WALKING           |
| 7210 |               0.2861512|              -0.0184259|              -0.1039380|                 -0.3828135|                  0.3939804|                  0.9389009|                   0.0732929|                   0.0133980|                  -0.0027726|      -0.0274845|      -0.0635147|       0.0759888|          -0.1017229|          -0.0438518|          -0.0510015|                      -0.9859558|                         -0.9859558|                          -0.9880730|              -0.9840522|                  -0.9865953|              -0.9862768|              -0.9902771|              -0.9862634|                  -0.9870438|                  -0.9935575|                  -0.9831495|      -0.9888395|      -0.9796257|      -0.9955728|                      -0.9904004|                              -0.9874391|                  -0.9832146|                      -0.9860938|               -0.9833125|               -0.9866974|               -0.9885340|                  -0.9870717|                  -0.9910681|                  -0.9917880|                   -0.9873165|                   -0.9937785|                   -0.9842881|       -0.9902520|       -0.9787134|       -0.9955475|           -0.9893487|           -0.9821418|           -0.9968149|                       -0.9911698|                          -0.9911698|                           -0.9882189|               -0.9831421|                   -0.9856760|               -0.9819631|               -0.9846544|               -0.9902329|                   -0.9887957|                   -0.9945298|                   -0.9837876|       -0.9906304|       -0.9782034|       -0.9958341|                       -0.9921585|                               -0.9878349|                   -0.9858692|                       -0.9855184| LAYING            |
| 2223 |               0.2192938|              -0.0548403|              -0.1556137|                  0.6661296|                 -0.3385428|                 -0.5175059|                  -0.0258174|                   0.4803761|                  -0.0792655|       0.0544454|      -0.3675995|      -0.2505248|          -0.0222920|           0.1648237|          -0.4907983|                       0.1126124|                          0.1126124|                          -0.2827698|               0.3756388|                  -0.3938508|              -0.4155049|               0.1356312|               0.1304193|                  -0.4145352|                  -0.2538180|                  -0.2401510|      -0.4806444|       0.1607773|       0.2969249|                      -0.1135441|                              -0.2666222|                   0.1239972|                      -0.4310582|               -0.3919140|                0.3799210|                0.5327450|                  -0.9495364|                  -0.9298043|                  -0.9147781|                   -0.4015614|                   -0.2429657|                   -0.3356230|       -0.4851813|        0.4834427|        0.7969612|           -0.6654662|           -0.3439047|           -0.4394940|                       -0.1289820|                          -0.1289820|                           -0.3223863|                0.3401093|                   -0.4784272|               -0.3827550|                0.4081806|                0.6108940|                   -0.4415626|                   -0.2843173|                   -0.4332863|       -0.4923890|        0.6411998|        0.7681488|                       -0.2731019|                               -0.4046165|                    0.2531656|                       -0.5868100| WALKING\_UPSTAIRS |
| 6107 |               0.2775332|              -0.0190837|              -0.1064508|                 -0.2211238|                  0.4864058|                  0.8582971|                   0.0716195|                   0.0123067|                   0.0024838|      -0.0286954|      -0.0659424|       0.0867587|          -0.0989605|          -0.0399800|          -0.0542067|                      -0.9719416|                         -0.9719416|                          -0.9920189|              -0.9774278|                  -0.9909892|              -0.9850811|              -0.9750278|              -0.9796989|                  -0.9910117|                  -0.9880725|                  -0.9892258|      -0.9795338|      -0.9839292|      -0.9925356|                      -0.9833611|                              -0.9925526|                  -0.9841055|                      -0.9928262|               -0.9798731|               -0.9514414|               -0.9700323|                  -0.9772455|                  -0.9826236|                  -0.9831515|                   -0.9909579|                   -0.9902123|                   -0.9914285|       -0.9759051|       -0.9817283|       -0.9928904|           -0.9883274|           -0.9905474|           -0.9959761|                       -0.9741450|                          -0.9741450|                           -0.9929674|               -0.9813669|                   -0.9938502|               -0.9777541|               -0.9439180|               -0.9661078|                   -0.9916900|                   -0.9943445|                   -0.9923194|       -0.9752248|       -0.9804657|       -0.9935557|                       -0.9721718|                               -0.9921594|                   -0.9824209|                       -0.9957329| LAYING            |
| 1947 |               0.2857453|               0.0101255|              -0.1337699|                  0.7965339|                 -0.2664645|                 -0.4120323|                  -0.3325038|                  -0.2223589|                   0.3214668|       0.5518136|      -0.1712401|      -0.2854384|           0.0469548|           0.0973239|           0.0358642|                       0.1487795|                          0.1487795|                          -0.1586358|               0.2279157|                  -0.4165312|              -0.2158558|               0.2518686|               0.0699455|                  -0.3056626|                  -0.0877328|                  -0.2760820|      -0.4256406|      -0.1283677|       0.1573763|                      -0.2220349|                              -0.3173907|                  -0.2600427|                      -0.4547411|               -0.1683051|                0.3054035|                0.2882715|                  -0.8752522|                  -0.9656472|                  -0.8677282|                   -0.3040220|                   -0.1257561|                   -0.3267124|       -0.5495200|       -0.0912776|        0.5781915|           -0.5551233|           -0.3929152|           -0.4231603|                       -0.2068455|                          -0.2068455|                           -0.3878995|               -0.1851463|                   -0.4830185|               -0.1502075|                0.2507165|                0.3017863|                   -0.3660028|                   -0.2415574|                   -0.3743607|       -0.5887910|       -0.0754915|        0.5488666|                       -0.3215086|                               -0.4961241|                   -0.2734568|                       -0.5605717| WALKING\_UPSTAIRS |

### Resulting Clean Data-set

Let's bind together the transformed training and testing data-sets:

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

The following tables describe all the variables in the clean data-set:

> \*\*<Notes:**>
>
> Acceleration Units: Number of g's.
>
> "Acceleration Jerk" or simply [jerk](https://en.wikipedia.org/wiki/Jerk_(physics)) is the rate of change of the acceleration.
>
> Jerk Units: Number of g's per second.
>
> Giro (Angular Velocity) Units: radians per second.
>
> Prefix 't' stands for "time domain signal", 'f' for "frequency domain signal".

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
```

    ## Warning in dir.create("./tidy_data"): './tidy_data' already exists

``` r
write.table(all_data, "./tidy_data/activity_data.txt", row.name = FALSE)
write.table(averages_data, "./tidy_data/activity_averages_data.txt", row.name = FALSE )
```
