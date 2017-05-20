-   [Installing the Required Packages](#installing-the-required-packages)
-   [Importing the Required Packages](#importing-the-required-packages)
-   [Loading Data](#loading-data)
-   [Description of Raw Data](#description-of-raw-data)
-   [Loading Data](#loading-data-1)

<h1>
Wearable Computing: Human Activity Recognition Using Smartphones
</h1>
Installing the Required Packages
================================

You might need to install the following packages if you don't already have them:

``` r
install.packages("xtable")
install.packages("dplyr")
```

Just uncomment the packages you need and run this chunk before you run the remaining ones in this notebook.

Importing the Required Packages
===============================

Once the libraries are installed, they need to be loaded as follows:

``` r
suppressMessages(library(xtable))  # Pretty printing dataframes
suppressMessages(library(dplyr))
```

Loading Data
============

The data is packaged in a zip file and can be downloaded from the given remove URL:

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

Description of Raw Data
=======================

Here are the the unzipped files contained in the data-set package:

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

Follows a short description for each one of the available files:

<table style="width:100%;">
<colgroup>
<col width="23%" />
<col width="76%" />
</colgroup>
<thead>
<tr class="header">
<th>File</th>
<th>Commentary</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>README.txt</td>
<td>An overview of the experiment.</td>
</tr>
<tr class="even">
<td>features_info.txt</td>
<td>A brief description of the measurements contained in the data-set.</td>
</tr>
<tr class="odd">
<td>features.txt</td>
<td>A list of the available variables (measurements) with their respective index numbers.</td>
</tr>
<tr class="even">
<td>activity_labels.txt</td>
<td>A list of activities, i.e., walking, sitting, stading, etc with their respective index numbers.</td>
</tr>
<tr class="odd">
<td>train/X_train.txt</td>
<td>&quot;X&quot; is a matrix with features for training data.</td>
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
<td>&quot;X&quot; is a matrix with features for test data.</td>
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

For the purpose of data exploration, we are not interested in the pre-processed data, thus, we're going to work with the following files:

-   train/X\_train.txt (training feature data)
-   train/y\_train.txt (training label data)
-   test/X\_test.txt (test feature data)
-   test/y\_test.tx (test label data)
-   features.txt (feature names which map to feature index numbers)
-   activity\_labels.txt (human-readable labels which map to activity index numbers)

Loading Data
============

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

The feature data contains 561 feature variables and 1122 observations (adding up testing and training data-sets).

``` r
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
str(features)
```

    ## 'data.frame':    561 obs. of  2 variables:
    ##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

As expected, the feature names data contains 2, which matches with the number of columns in the feature data.

Note that

``` r
feature_names <- features[, 2]
sample(feature_names, 6)
```

    ## [1] "tBodyGyroJerk-mad()-X"           "tBodyGyroJerk-correlation()-X,Y"
    ## [3] "fBodyBodyAccJerkMag-skewness()"  "fBodyBodyAccJerkMag-kurtosis()" 
    ## [5] "tBodyGyro-arCoeff()-Z,3"         "fBodyAcc-std()-X"

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

``` r
variables <- c(feature_names, "ActivityID")
mean_variables <- grep("mean\\(\\)", variables, value = TRUE)
std_variables <- grep("std\\(\\)", variables, value = TRUE)
sample(variables, 6)
```

    ## [1] "fBodyBodyGyroMag-energy()"        "tBodyGyro-arCoeff()-Z,4"         
    ## [3] "fBodyAccJerk-bandsEnergy()-25,32" "fBodyAccJerk-bandsEnergy()-9,16" 
    ## [5] "fBodyBodyAccJerkMag-iqr()"        "fBodyAcc-energy()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyGyroJerk-mean()-Z" "tBodyAcc-mean()-Z"     
    ## [3] "tBodyAccJerk-mean()-Y"  "tBodyGyro-mean()-Z"    
    ## [5] "fBodyAcc-mean()-Y"      "fBodyGyro-mean()-Z"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAcc-std()-X"     "fBodyAccMag-std()"    "fBodyAcc-std()-Z"    
    ## [4] "tBodyAccJerk-std()-Y" "fBodyAccJerk-std()-Y" "fBodyAccJerk-std()-X"

``` r
add_labels <- function(data, labels) {
  data <- cbind(data, labels)
  data
}

test_data <- add_labels(test_data, test_labels)
dim(test_data)
```

    ## [1] 2947  562

``` r
add_variable_names <- function(data) {
  names(data) <- variables
  data
}

test_data <- add_variable_names(test_data)
sample(names(test_data), 6)
```

    ## [1] "fBodyAccJerk-entropy()-Y"     "fBodyAcc-bandsEnergy()-1,8"  
    ## [3] "fBodyAccJerk-kurtosis()-Z"    "fBodyAcc-bandsEnergy()-49,56"
    ## [5] "tBodyAccJerk-mad()-Z"         "fBodyAccJerk-skewness()-X"

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
| 165  |               0.2762706|              -0.0072992|              -0.0802925|                  0.8944051|                 -0.3575671|                  0.1796732|                   0.0779367|                   0.0157757|                  -0.0229197|      -0.0297096|      -0.0672044|       0.0803480|          -0.0952478|          -0.0471880|          -0.0456421|                      -0.9713759|                         -0.9713759|                          -0.9866321|              -0.9841591|                  -0.9925902|              -0.9918092|              -0.9719294|              -0.9777573|                  -0.9878829|                  -0.9762750|                  -0.9893531|      -0.9830883|      -0.9880610|      -0.9815358|                      -0.9799387|                              -0.9878486|                  -0.9838002|                      -0.9936982|               -0.9943126|               -0.9720141|               -0.9685089|                  -0.9987732|                  -0.9758443|                  -0.9445181|                   -0.9873817|                   -0.9765750|                   -0.9908816|       -0.9845930|       -0.9864870|       -0.9819447|           -0.9875820|           -0.9945390|           -0.9910463|                       -0.9740239|                          -0.9740239|                           -0.9879719|               -0.9811979|                   -0.9941841|               -0.9956742|               -0.9727278|               -0.9648913|                   -0.9878954|                   -0.9786612|                   -0.9909142|       -0.9850331|       -0.9855444|       -0.9835818|                       -0.9735852|                               -0.9865099|                   -0.9823646|                       -0.9947216|           5|
| 1734 |               0.2092387|               0.0841499|              -0.0213054|                  0.9931944|                 -0.0353146|                  0.0141950|                   0.1011349|                  -0.0516249|                  -0.0764999|      -0.2330622|      -0.1304243|      -0.4856242|          -0.0758120|          -0.0370607|           0.0836728|                      -0.7650234|                         -0.7650234|                          -0.9537158|              -0.6533396|                  -0.9675656|              -0.9481330|              -0.7741107|              -0.8444503|                  -0.9712376|                  -0.9279990|                  -0.9456617|      -0.9264359|      -0.9433699|      -0.7880917|                      -0.7784494|                              -0.9379630|                  -0.8551839|                      -0.9701300|               -0.9338550|               -0.5487935|               -0.7636901|                  -0.8655204|                  -0.6730618|                  -0.7503190|                   -0.9716330|                   -0.9285314|                   -0.9503747|       -0.9320236|       -0.9255498|       -0.8110164|           -0.9594048|           -0.9729604|           -0.9543604|                       -0.6065480|                          -0.6065480|                           -0.9424050|               -0.8104432|                   -0.9684176|               -0.9286232|               -0.4923350|               -0.7427562|                   -0.9746877|                   -0.9344131|                   -0.9534490|       -0.9340815|       -0.9167038|       -0.8363341|                       -0.5972236|                               -0.9477187|                   -0.8144995|                       -0.9679825|           4|
| 2164 |               0.4013010|              -0.0443396|              -0.0969099|                  0.9178314|                 -0.2400846|                 -0.1910633|                   0.1208819|                   0.1899088|                   0.1442779|       0.3864913|      -0.3667561|      -0.1006714|          -0.1356049|          -0.1043326|           0.1631717|                      -0.1951872|                         -0.1951872|                          -0.3445659|              -0.3674280|                  -0.6547619|              -0.2020174|              -0.1680903|              -0.4109820|                  -0.2899016|                  -0.3023737|                  -0.5440062|      -0.5962231|      -0.5738689|      -0.4454844|                      -0.0522090|                              -0.1872021|                  -0.5795192|                      -0.7010673|               -0.1872975|               -0.1870710|               -0.3573853|                  -0.9787209|                  -0.9631899|                  -0.9553433|                   -0.2422221|                   -0.3058287|                   -0.6105283|       -0.6640317|       -0.6011104|       -0.5079613|           -0.6923957|           -0.6705415|           -0.6286160|                       -0.1171447|                          -0.1171447|                           -0.2574147|               -0.5226555|                   -0.7223299|               -0.1815138|               -0.2487575|               -0.3781230|                   -0.2590653|                   -0.3609300|                   -0.6801833|       -0.6857779|       -0.6217238|       -0.5751831|                       -0.2931892|                               -0.3632836|                   -0.5657542|                       -0.7737427|           3|
| 527  |               0.2890096|              -0.0182824|              -0.1061933|                 -0.3875853|                  0.9664576|                  0.1708432|                   0.0810293|                  -0.0104185|                   0.0136676|      -0.0379950|      -0.0769231|       0.0657572|          -0.0935408|          -0.0438644|          -0.0539246|                      -0.9817805|                         -0.9817805|                          -0.9837110|              -0.9745335|                  -0.9937559|              -0.9895609|              -0.9562543|              -0.9812569|                  -0.9905172|                  -0.9651181|                  -0.9836671|      -0.9798512|      -0.9840185|      -0.9887134|                      -0.9762969|                              -0.9833840|                  -0.9825059|                      -0.9923579|               -0.9908013|               -0.9622108|               -0.9773212|                  -0.9875458|                  -0.9967179|                  -0.9833960|                   -0.9915580|                   -0.9691709|                   -0.9863504|       -0.9820270|       -0.9741098|       -0.9881777|           -0.9866899|           -0.9940156|           -0.9940139|                       -0.9788761|                          -0.9788761|                           -0.9852695|               -0.9765395|                   -0.9913422|               -0.9912687|               -0.9671201|               -0.9757959|                   -0.9937593|                   -0.9775776|                   -0.9876805|       -0.9826766|       -0.9693962|       -0.9889070|                       -0.9829228|                               -0.9869623|                   -0.9764268|                       -0.9901822|           6|
| 2888 |               0.2771493|               0.0037090|              -0.1137419|                  0.9563120|                 -0.1416877|                 -0.1486253|                   0.1527754|                  -0.0935375|                  -0.0675235|      -0.0372668|      -0.0449603|       0.0869550|          -0.0984402|           0.1000872|           0.0302069|                      -0.4020124|                         -0.4020124|                          -0.5005379|              -0.2848686|                  -0.5889879|              -0.6094975|              -0.1696939|              -0.5230681|                  -0.6067835|                  -0.4083306|                  -0.6201349|      -0.3073127|      -0.5689697|      -0.3446535|                      -0.4519453|                              -0.4931802|                  -0.4818806|                      -0.6485566|               -0.5941040|               -0.0933019|               -0.4410252|                  -0.9864170|                  -0.9468154|                  -0.9569282|                   -0.5857073|                   -0.3372922|                   -0.6416175|       -0.2998701|       -0.5844158|       -0.3005640|           -0.5170825|           -0.6370338|           -0.5508377|                       -0.4795784|                          -0.4795784|                           -0.5207106|               -0.3933070|                   -0.6395130|               -0.5880424|               -0.1116221|               -0.4404916|                   -0.6000991|                   -0.3037120|                   -0.6606232|       -0.3065848|       -0.5971540|       -0.3505380|                       -0.5762315|                               -0.5607314|                   -0.4380294|                       -0.6526487|           1|
| 1170 |               0.4331371|              -0.0238230|               0.0015022|                  0.9448743|                  0.0460362|                  0.0508671|                   0.3731169|                  -0.0770183|                   0.0188107|       0.5069368|       0.0450847|       0.1218682|           0.2072596|          -0.2623711|          -0.2891535|                       0.3838158|                          0.3838158|                           0.0982067|              -0.0323485|                  -0.3717017|               0.3975594|              -0.0146878|              -0.2530609|                   0.2736367|                  -0.0953114|                  -0.3149061|      -0.0889273|      -0.3104116|      -0.0707515|                       0.2201707|                               0.2293830|                  -0.2961523|                      -0.4671307|                0.4500468|                0.0399433|               -0.2165315|                  -0.8829722|                  -0.9471266|                  -0.8252706|                    0.3105762|                   -0.0779160|                   -0.3917066|       -0.3514937|       -0.3786061|       -0.1486950|           -0.2850571|           -0.4746076|           -0.3032235|                        0.2098154|                           0.2098154|                            0.1115988|               -0.2973075|                   -0.5217032|                0.4701541|                0.0026493|               -0.2582770|                    0.2324593|                   -0.1231236|                   -0.4685413|       -0.4370128|       -0.4291775|       -0.2536571|                        0.0155299|                               -0.0682277|                   -0.4213919|                       -0.6428825|           3|

``` r
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
dim(activities)
```

    ## [1] 6 2

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 542  |               0.3400433|               0.0161563|              -0.0955764|                  0.9130999|                 -0.3149636|                  0.0834355|                   0.1315334|                   0.0240400|                   0.0843119|      -0.1721163|       0.1623617|       0.0473262|          -0.5183918|           0.0281387|           0.0196279|                      -0.2625816|                         -0.2625816|                          -0.5988362|              -0.3157562|                  -0.7884700|              -0.4677794|              -0.4732191|              -0.6507520|                  -0.5526851|                  -0.6469732|                  -0.8058326|      -0.3200609|      -0.6885772|      -0.5330055|                      -0.4346935|                              -0.6077591|                  -0.5386156|                      -0.8485308|               -0.3374030|               -0.2132554|               -0.3642955|                  -0.9667543|                  -0.9495551|                  -0.9504182|                   -0.5251130|                   -0.6102333|                   -0.8182587|       -0.3961819|       -0.4788505|       -0.5193037|           -0.7567061|           -0.8580966|           -0.6923573|                       -0.3684706|                          -0.3684706|                           -0.5999812|               -0.4649039|                   -0.8539981|               -0.2924029|               -0.1526505|               -0.2892809|                   -0.5380105|                   -0.5956020|                   -0.8286432|       -0.4223924|       -0.3873329|       -0.5586997|                       -0.4318526|                               -0.5919605|                   -0.5069440|                       -0.8716558| WALKING\_UPSTAIRS   |
| 1367 |               0.2724561|               0.0337677|              -0.0788095|                  0.9560179|                 -0.1402064|                 -0.0922129|                  -0.3873399|                   0.0265098|                   0.3377196|      -0.1659818|      -0.0593802|       0.0925870|          -0.2170947|          -0.3113453|          -0.0473886|                      -0.0802065|                         -0.0802065|                          -0.3054629|              -0.2626048|                  -0.5267787|              -0.1928802|              -0.0647873|              -0.2167163|                  -0.4431633|                  -0.2415593|                  -0.3159741|      -0.2145471|      -0.4317933|      -0.3398872|                      -0.0174648|                              -0.3438371|                  -0.3855705|                      -0.5835321|               -0.1141043|               -0.0374448|               -0.2716532|                  -0.9222526|                  -0.8931457|                  -0.9281730|                   -0.4102401|                   -0.1879626|                   -0.3739424|       -0.2723118|       -0.4683239|       -0.4623682|           -0.4128614|           -0.5965119|           -0.4479386|                       -0.0954464|                          -0.0954464|                           -0.2743135|               -0.2944808|                   -0.5678190|               -0.0848167|               -0.0837261|               -0.3673333|                   -0.4276563|                   -0.1826376|                   -0.4296206|       -0.2951038|       -0.4959440|       -0.5584435|                       -0.2829893|                               -0.1980100|                   -0.3538137|                       -0.5757772| WALKING\_DOWNSTAIRS |
| 2386 |               0.2813516|               0.0039865|              -0.1189831|                  0.9671083|                 -0.1669767|                 -0.0275971|                   0.0747172|                   0.0264597|                   0.0000571|      -0.0510728|      -0.0821215|       0.0815518|          -0.0713519|          -0.0519490|          -0.0310248|                      -0.9336570|                         -0.9336570|                          -0.9699546|              -0.9589417|                  -0.9818433|              -0.9762620|              -0.9312904|              -0.9527389|                  -0.9696039|                  -0.9583408|                  -0.9720318|      -0.9495940|      -0.9764909|      -0.9635831|                      -0.9544941|                              -0.9607967|                  -0.9574011|                      -0.9825084|               -0.9822880|               -0.9126180|               -0.9088519|                  -0.9958791|                  -0.9507559|                  -0.9680122|                   -0.9684555|                   -0.9541254|                   -0.9752002|       -0.9602732|       -0.9739440|       -0.9675309|           -0.9750834|           -0.9823458|           -0.9820982|                       -0.9515860|                          -0.9515860|                           -0.9600255|               -0.9508239|                   -0.9814468|               -0.9853218|               -0.9083095|               -0.8950267|                   -0.9699572|                   -0.9523240|                   -0.9768602|       -0.9635908|       -0.9725261|       -0.9718050|                       -0.9562582|                               -0.9575586|                   -0.9545157|                       -0.9808227| STANDING            |
| 1159 |               0.2779060|              -0.0282457|              -0.1077146|                  0.9561049|                 -0.2275247|                  0.0857793|                  -0.0302303|                  -0.0316830|                   0.1373847|       0.0363142|      -0.1315496|       0.0315754|           0.0560540|          -0.2115764|          -0.1118247|                      -0.3412336|                         -0.3412336|                          -0.4201953|              -0.1700666|                  -0.6849783|              -0.2784550|              -0.2683923|              -0.5722857|                  -0.3103772|                  -0.3883743|                  -0.6617633|      -0.1942859|      -0.5841462|      -0.3999234|                      -0.1389915|                              -0.3295184|                  -0.4181229|                      -0.7216942|               -0.3065071|               -0.2769632|               -0.5460743|                  -0.9521582|                  -0.9282387|                  -0.9048355|                   -0.3087918|                   -0.3685164|                   -0.6928188|       -0.0931597|       -0.5385410|       -0.4220334|           -0.5393796|           -0.7765254|           -0.6127323|                       -0.2121909|                          -0.2121909|                           -0.3200060|               -0.2013286|                   -0.7146418|               -0.3178112|               -0.3270646|               -0.5668850|                   -0.3704660|                   -0.3897328|                   -0.7221630|       -0.0822788|       -0.5156158|       -0.4822165|                       -0.3789984|                               -0.3123540|                   -0.2058831|                       -0.7253087| WALKING\_DOWNSTAIRS |
| 2839 |               0.2748507|              -0.0176770|              -0.1050062|                 -0.4303741|                  0.9416372|                  0.3035964|                   0.0735655|                   0.0132258|                  -0.0027199|      -0.0275551|      -0.0739497|       0.0886482|          -0.0996692|          -0.0443456|          -0.0558991|                      -0.9947081|                         -0.9947081|                          -0.9911580|              -0.9936538|                  -0.9917821|              -0.9906194|              -0.9929636|              -0.9909306|                  -0.9910067|                  -0.9899684|                  -0.9891975|      -0.9971149|      -0.9873386|      -0.9961443|                      -0.9930974|                              -0.9926762|                  -0.9900980|                      -0.9892817|               -0.9913995|               -0.9947373|               -0.9922454|                  -0.9931518|                  -0.9995645|                  -0.9932412|                   -0.9906166|                   -0.9899113|                   -0.9903982|       -0.9981420|       -0.9882560|       -0.9959293|           -0.9968913|           -0.9867680|           -0.9957760|                       -0.9939557|                          -0.9939557|                           -0.9928877|               -0.9910549|                   -0.9884285|               -0.9916360|               -0.9950387|               -0.9929276|                   -0.9909652|                   -0.9905450|                   -0.9900425|       -0.9984927|       -0.9888744|       -0.9961041|                       -0.9946640|                               -0.9917963|                   -0.9933894|                       -0.9876726| LAYING              |
| 2911 |               0.2596837|              -0.0084432|              -0.1206901|                 -0.4645555|                  0.7773124|                  0.6513187|                   0.0714343|                   0.0158134|                   0.0029924|      -0.0344797|      -0.0706259|       0.0687698|          -0.1016162|          -0.0477688|          -0.0621504|                      -0.9339886|                         -0.9339886|                          -0.9330455|              -0.9134742|                  -0.9067782|              -0.9371751|              -0.9382098|              -0.9185111|                  -0.9347876|                  -0.9347259|                  -0.9030068|      -0.9227962|      -0.8168214|      -0.9710659|                      -0.9064999|                              -0.8821533|                  -0.7725192|                      -0.8308438|               -0.9351907|               -0.9396308|               -0.9189720|                  -0.9590465|                  -0.9834618|                  -0.9785726|                   -0.9308385|                   -0.9318372|                   -0.8926490|       -0.9505616|       -0.8255056|       -0.9775460|           -0.9116076|           -0.8424109|           -0.9734424|                       -0.9175628|                          -0.9175628|                           -0.8681394|               -0.7906023|                   -0.8134358|               -0.9342152|               -0.9431720|               -0.9249753|                   -0.9326724|                   -0.9331361|                   -0.8821529|       -0.9602141|       -0.8322730|       -0.9821730|                       -0.9365472|                               -0.8509558|                   -0.8430563|                       -0.8048899| LAYING              |

``` r
cleanup_data <- function(data, labels) {
  data <- add_labels(data, labels)
  data <- add_variable_names(data)
  data <- select_mean_and_std_variables(data)
  data <- normalize_variable_names(data)
  add_activity_label_variable(data, activities)
}

train_data <- cleanup_data(train_data, train_labels)
sample_data_frame(train_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 3739 |               0.2779654|              -0.0134270|              -0.1004543|                  0.9623490|                  0.0632301|                 -0.1060938|                   0.0749314|                   0.0130559|                  -0.0056534|      -0.0251161|      -0.0808264|       0.1055108|          -0.0950937|          -0.0403930|          -0.0629864|                      -0.9943609|                         -0.9943609|                          -0.9936390|              -0.9920800|                  -0.9990379|              -0.9976949|              -0.9921599|              -0.9867744|                  -0.9968205|                  -0.9905784|                  -0.9887174|      -0.9958947|      -0.9978811|      -0.9919100|                      -0.9890212|                              -0.9927989|                  -0.9961941|                      -0.9990398|               -0.9983521|               -0.9947080|               -0.9863037|                  -0.9986708|                  -0.9924089|                  -0.9829029|                   -0.9967688|                   -0.9903606|                   -0.9903146|       -0.9971955|       -0.9970211|       -0.9904068|           -0.9971862|           -0.9985896|           -0.9985653|                       -0.9904936|                          -0.9904936|                           -0.9935318|               -0.9931469|                   -0.9991099|               -0.9986989|               -0.9955578|               -0.9861680|                   -0.9969781|                   -0.9907452|                   -0.9904222|       -0.9976124|       -0.9964218|       -0.9905923|                       -0.9921398|                               -0.9931520|                   -0.9921032|                       -0.9989213| SITTING             |
| 1742 |               0.2438183|              -0.0544596|              -0.1607222|                  0.9292338|                 -0.2070464|                  0.0878105|                   0.1755804|                   0.0054676|                  -0.0997028|      -0.0164056|      -0.1719569|       0.1149087|           0.1263740|          -0.1324020|           0.0414022|                      -0.0514880|                         -0.0514880|                          -0.4076000|              -0.0633848|                  -0.6602046|              -0.2544476|              -0.2952329|              -0.3986259|                  -0.3193672|                  -0.5035143|                  -0.7083767|      -0.2625955|      -0.4508861|      -0.4417714|                      -0.1835755|                              -0.2942059|                  -0.4449579|                      -0.7421288|               -0.1402419|               -0.1520868|                0.0576911|                  -0.9581822|                  -0.8948186|                  -0.8648355|                   -0.2231095|                   -0.4777874|                   -0.7176680|       -0.3434643|        0.0086694|       -0.4218792|           -0.5644706|           -0.7418211|           -0.6243374|                       -0.0641010|                          -0.0641010|                           -0.2824956|               -0.2140805|                   -0.7488643|               -0.0991135|               -0.1371379|                0.1747563|                   -0.1943478|                   -0.4842715|                   -0.7247715|       -0.3715202|        0.2013788|       -0.4682321|                       -0.1488464|                               -0.2713718|                   -0.2102423|                       -0.7757235| WALKING\_UPSTAIRS   |
| 3843 |               0.2773297|              -0.0100572|              -0.1174303|                  0.9716420|                 -0.0664498|                 -0.0953655|                   0.0735236|                   0.0303330|                   0.0479806|      -0.0200984|      -0.0741529|       0.0726864|          -0.1084120|          -0.0419220|          -0.0522055|                      -0.9626313|                         -0.9626313|                          -0.9684777|              -0.9529881|                  -0.9780147|              -0.9906441|              -0.9293173|              -0.9573146|                  -0.9895806|                  -0.9406951|                  -0.9675203|      -0.9636797|      -0.9672968|      -0.9496482|                      -0.9548942|                              -0.9574731|                  -0.9633433|                      -0.9803490|               -0.9919587|               -0.9211171|               -0.9598362|                  -0.9983199|                  -0.9812551|                  -0.9814971|                   -0.9891599|                   -0.9375230|                   -0.9719036|       -0.9732550|       -0.9585029|       -0.9332148|           -0.9729034|           -0.9810933|           -0.9737353|                       -0.9600855|                          -0.9600855|                           -0.9615119|               -0.9583129|                   -0.9821127|               -0.9924865|               -0.9208883|               -0.9638901|                   -0.9896057|                   -0.9380779|                   -0.9749288|       -0.9762870|       -0.9539744|       -0.9343734|                       -0.9687088|                               -0.9663279|                   -0.9617551|                       -0.9858166| SITTING             |
| 4508 |               0.2789596|              -0.0185703|              -0.1113295|                  0.9580692|                  0.1100851|                 -0.0327399|                   0.0770732|                   0.0085539|                  -0.0026964|      -0.0289080|      -0.0745498|       0.0914486|          -0.0994156|          -0.0411995|          -0.0583440|                      -0.9981393|                         -0.9981393|                          -0.9923254|              -0.9966478|                  -0.9981138|              -0.9971811|              -0.9855654|              -0.9937390|                  -0.9954048|                  -0.9839068|                  -0.9894890|      -0.9983095|      -0.9977748|      -0.9905331|                      -0.9928442|                              -0.9907956|                  -0.9967527|                      -0.9978502|               -0.9981659|               -0.9892827|               -0.9959181|                  -0.9990805|                  -0.9965113|                  -0.9948887|                   -0.9953806|                   -0.9842425|                   -0.9912332|       -0.9987269|       -0.9977391|       -0.9914343|           -0.9985724|           -0.9983020|           -0.9933649|                       -0.9943267|                          -0.9943267|                           -0.9912767|               -0.9964811|                   -0.9978108|               -0.9987305|               -0.9912388|               -0.9970696|                   -0.9957508|                   -0.9858238|                   -0.9915399|       -0.9988349|       -0.9976489|       -0.9924508|                       -0.9955973|                               -0.9903592|                   -0.9967085|                       -0.9975227| SITTING             |
| 1954 |               0.2146235|              -0.0267911|              -0.1025106|                  0.8810633|                 -0.3833240|                 -0.0802295|                  -0.0966530|                   0.2526386|                   0.0466516|      -0.0354313|      -0.0585567|       0.1521427|          -0.3171382|           0.1032307|          -0.1022304|                      -0.1186519|                         -0.1186519|                          -0.4484318|              -0.1206706|                  -0.5651693|              -0.3674480|              -0.1210788|              -0.3856909|                  -0.4333077|                  -0.3570065|                  -0.6566333|      -0.3792550|      -0.2818129|      -0.4151250|                      -0.3015464|                              -0.3210635|                  -0.3172087|                      -0.6332998|               -0.3689488|                0.0725919|               -0.0111315|                  -0.9792110|                  -0.9849208|                  -0.8990291|                   -0.4187614|                   -0.3133766|                   -0.6634709|       -0.3873598|       -0.0186048|       -0.4787844|           -0.6000350|           -0.5973364|           -0.5286142|                       -0.3174589|                          -0.3174589|                           -0.3764199|               -0.1966302|                   -0.6668927|               -0.3694417|                0.0963829|                0.0821375|                   -0.4553987|                   -0.3107841|                   -0.6682585|       -0.3965888|        0.1065920|       -0.5490486|                       -0.4323536|                               -0.4593123|                   -0.2539654|                       -0.7431474| WALKING\_UPSTAIRS   |
| 3051 |               0.3061349|               0.0072380|              -0.0804041|                  0.9611775|                 -0.0317318|                  0.0132615|                   0.4772672|                   0.1972644|                   0.2432584|       0.4450647|      -0.0194790|       0.0977999|           0.0052786|          -0.1339765|          -0.1237910|                       0.2318353|                          0.2318353|                          -0.1706508|              -0.2733287|                  -0.4801770|               0.1300025|              -0.2230838|              -0.3611901|                  -0.1186239|                  -0.3403152|                  -0.4967120|      -0.5430271|      -0.4211894|      -0.3079938|                       0.1590078|                              -0.0804478|                  -0.4788649|                      -0.5086262|                0.3493190|               -0.1891664|               -0.3536076|                  -0.9505948|                  -0.9385110|                  -0.9654784|                   -0.0295893|                   -0.2194714|                   -0.5332788|       -0.6964522|       -0.4461651|       -0.4292195|           -0.5644486|           -0.5112609|           -0.2389340|                        0.1606171|                           0.1606171|                           -0.1328144|               -0.5161427|                   -0.4960372|                0.4264968|               -0.2223572|               -0.4012680|                   -0.0231572|                   -0.1436750|                   -0.5673226|       -0.7484234|       -0.4660814|       -0.5273369|                       -0.0191869|                               -0.2107017|                   -0.6329211|                       -0.5149439| WALKING\_DOWNSTAIRS |

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

``` r
activity_averages_data <- all_data %>% group_by(ActivityLabel) %>% summarise_each(funs(mean))
activity_averages_data
```

| ActivityLabel       |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma|
|:--------------------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|
| LAYING              |               0.2686486|              -0.0183177|              -0.1074356|                 -0.3750213|                  0.6222704|                  0.5556125|                   0.0818474|                   0.0111724|                  -0.0048598|      -0.0167253|      -0.0934107|       0.1258851|          -0.1018643|          -0.0381981|          -0.0638498|                      -0.9411107|                         -0.9411107|                          -0.9792088|              -0.9384360|                  -0.9827266|              -0.9668121|              -0.9526784|              -0.9600180|                  -0.9801977|                  -0.9713836|                  -0.9766145|      -0.9629150|      -0.9675821|      -0.9641844|                      -0.9476727|                              -0.9743001|                  -0.9548545|                      -0.9779682|               -0.9609324|               -0.9435072|               -0.9480693|                  -0.9433197|                  -0.9631917|                  -0.9518687|                   -0.9803818|                   -0.9711476|                   -0.9794766|       -0.9678924|       -0.9631925|       -0.9635092|           -0.9761248|           -0.9804736|           -0.9847825|                       -0.9321600|                          -0.9321600|                           -0.9742406|               -0.9405961|                   -0.9767550|               -0.9590315|               -0.9424610|               -0.9456436|                   -0.9824596|                   -0.9730512|                   -0.9809719|       -0.9697473|       -0.9613654|       -0.9667252|                       -0.9349167|                               -0.9731834|                   -0.9421157|                       -0.9766482|
| SITTING             |               0.2730596|              -0.0126896|              -0.1055170|                  0.8797312|                  0.1087135|                  0.1537741|                   0.0758788|                   0.0050469|                  -0.0024867|      -0.0384313|      -0.0721208|       0.0777771|          -0.0956521|          -0.0407798|          -0.0507555|                      -0.9546439|                         -0.9546439|                          -0.9824444|              -0.9467241|                  -0.9878801|              -0.9830920|              -0.9479180|              -0.9570310|                  -0.9851888|                  -0.9739882|                  -0.9795620|      -0.9772673|      -0.9724576|      -0.9610287|                      -0.9524104|                              -0.9786844|                  -0.9642961|                      -0.9853356|               -0.9834462|               -0.9348806|               -0.9389816|                  -0.9796822|                  -0.9576727|                  -0.9473574|                   -0.9849972|                   -0.9738832|                   -0.9822965|       -0.9810222|       -0.9667081|       -0.9580075|           -0.9857051|           -0.9865023|           -0.9838055|                       -0.9393242|                          -0.9393242|                           -0.9789071|               -0.9511990|                   -0.9846076|               -0.9837473|               -0.9325335|               -0.9343367|                   -0.9861850|                   -0.9757509|                   -0.9836708|       -0.9823333|       -0.9640337|       -0.9610302|                       -0.9420002|                               -0.9781548|                   -0.9516417|                       -0.9844914|
| STANDING            |               0.2791535|              -0.0161519|              -0.1065869|                  0.9414796|                 -0.1842465|                 -0.0140520|                   0.0750279|                   0.0088053|                  -0.0045821|      -0.0266871|      -0.0677119|       0.0801422|          -0.0997293|          -0.0423171|          -0.0520955|                      -0.9541797|                         -0.9541797|                          -0.9771180|              -0.9421525|                  -0.9786971|              -0.9816223|              -0.9431324|              -0.9573597|                  -0.9800087|                  -0.9645474|                  -0.9761578|      -0.9436543|      -0.9653028|      -0.9583850|                      -0.9558681|                              -0.9710904|                  -0.9479085|                      -0.9748860|               -0.9844347|               -0.9325087|               -0.9399135|                  -0.9880152|                  -0.9693518|                  -0.9530825|                   -0.9799686|                   -0.9643428|                   -0.9794859|       -0.9455284|       -0.9612933|       -0.9570531|           -0.9669579|           -0.9802633|           -0.9770671|                       -0.9465348|                          -0.9465348|                           -0.9714530|               -0.9295312|                   -0.9735286|               -0.9858598|               -0.9311330|               -0.9354396|                   -0.9818261|                   -0.9668316|                   -0.9815093|       -0.9469716|       -0.9594986|       -0.9606892|                       -0.9496016|                               -0.9709480|                   -0.9306367|                       -0.9734611|
| WALKING             |               0.2763369|              -0.0179068|              -0.1088817|                  0.9349916|                 -0.1967135|                 -0.0538251|                   0.0767187|                   0.0115062|                  -0.0023194|      -0.0347276|      -0.0694200|       0.0863626|          -0.0943007|          -0.0445701|          -0.0540065|                      -0.1679379|                         -0.1679379|                          -0.2414520|              -0.2748660|                  -0.4605115|              -0.2978909|              -0.0423392|              -0.3418407|                  -0.3111274|                  -0.1703951|                  -0.4510105|      -0.3482374|      -0.3883849|      -0.3104062|                      -0.2755581|                              -0.2146540|                  -0.4091730|                      -0.5155168|               -0.3146445|               -0.0235829|               -0.2739208|                  -0.9776121|                  -0.9669039|                  -0.9545976|                   -0.2672882|                   -0.1031411|                   -0.4791471|       -0.4699148|       -0.3479218|       -0.3384486|           -0.3762214|           -0.5126191|           -0.4474272|                       -0.3377540|                          -0.3377540|                           -0.2145559|               -0.3826290|                   -0.4988410|               -0.3228358|               -0.0772063|               -0.2960783|                   -0.2878977|                   -0.0908699|                   -0.5063291|       -0.5104320|       -0.3319615|       -0.4105691|                       -0.4800023|                               -0.2216178|                   -0.4738331|                       -0.5144048|
| WALKING\_DOWNSTAIRS |               0.2881372|              -0.0163119|              -0.1057616|                  0.9264574|                 -0.1685072|                 -0.0479709|                   0.0892267|                   0.0007467|                  -0.0087286|      -0.0840345|      -0.0529929|       0.0946782|          -0.0728532|          -0.0512640|          -0.0546962|                       0.1012497|                          0.1012497|                          -0.1118018|              -0.1297856|                  -0.4168916|               0.0352597|               0.0566827|              -0.2137292|                  -0.0722968|                  -0.1163806|                  -0.3331903|      -0.2179229|      -0.3175927|      -0.1656251|                       0.1428494|                               0.0047625|                  -0.2895258|                      -0.4380073|                0.1007663|                0.0595486|               -0.1908045|                  -0.9497488|                  -0.9342661|                  -0.9124606|                   -0.0338826|                   -0.0736744|                   -0.3886661|       -0.3338175|       -0.3396314|       -0.2728099|           -0.3826898|           -0.4659438|           -0.3264560|                        0.1164889|                           0.1164889|                           -0.0112207|               -0.2514278|                   -0.4409293|                0.1219380|               -0.0082337|               -0.2458729|                   -0.0821905|                   -0.0914165|                   -0.4435547|       -0.3751275|       -0.3618537|       -0.3804100|                       -0.0754252|                               -0.0422714|                   -0.3612310|                       -0.4864430|
| WALKING\_UPSTAIRS   |               0.2622946|              -0.0259233|              -0.1205379|                  0.8750034|                 -0.2813772|                 -0.1407957|                   0.0767293|                   0.0087589|                  -0.0060095|       0.0068245|      -0.0885225|       0.0598938|          -0.1121175|          -0.0386193|          -0.0525810|                      -0.1002041|                         -0.1002041|                          -0.3909386|              -0.1782811|                  -0.6080471|              -0.2934068|              -0.1349505|              -0.3681221|                  -0.3898968|                  -0.3646668|                  -0.5916701|      -0.3942482|      -0.4592535|      -0.2968577|                      -0.2620281|                              -0.3539620|                  -0.4497814|                      -0.6586945|               -0.2379897|               -0.0160325|               -0.1754497|                  -0.9481913|                  -0.9255493|                  -0.9019056|                   -0.3608634|                   -0.3392265|                   -0.6270636|       -0.4676071|       -0.3442318|       -0.2371368|           -0.5531328|           -0.6673392|           -0.5609892|                       -0.2498752|                          -0.2498752|                           -0.3854004|               -0.3371421|                   -0.6668367|               -0.2188880|               -0.0218110|               -0.1466018|                   -0.3889928|                   -0.3576329|                   -0.6615908|       -0.4952540|       -0.2931818|       -0.2920413|                       -0.3617535|                               -0.4342067|                   -0.3814064|                       -0.7030835|

``` r
sample_data_frame(all_data, 6)
```

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel     |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 3415 |               0.2873020|              -0.0630419|              -0.1178641|                  0.9678400|                 -0.1389876|                  0.0750408|                   0.0889700|                  -0.0929969|                  -0.0127207|      -0.0887902|      -0.0431046|       0.0608029|           0.1461615|          -0.1098600|          -0.1962516|                      -0.4677298|                         -0.4677298|                          -0.5962851|              -0.4562799|                  -0.7297467|              -0.6348292|              -0.2465614|              -0.5899505|                  -0.6535506|                  -0.4679757|                  -0.7240418|      -0.3592335|      -0.7096285|      -0.5887884|                      -0.5506988|                              -0.5523614|                  -0.4986156|                      -0.7973026|               -0.6564232|               -0.1977401|               -0.4898284|                  -0.9874586|                  -0.9703266|                  -0.9285273|                   -0.6368710|                   -0.4254335|                   -0.7382893|       -0.4160871|       -0.6272203|       -0.6463978|           -0.6090245|           -0.8240474|           -0.6799660|                       -0.5589627|                          -0.5589627|                           -0.5556504|               -0.4263989|                   -0.7916900|               -0.6652130|               -0.2229218|               -0.4772214|                   -0.6513855|                   -0.4165224|                   -0.7502768|       -0.4370392|       -0.5868216|       -0.6997494|                       -0.6315790|                               -0.5616103|                   -0.4757510|                       -0.7984142| WALKING           |
| 4704 |               0.2057398|              -0.0458296|              -0.1189082|                  0.9114810|                 -0.3204874|                 -0.0353453|                  -0.0555290|                   0.4739488|                  -0.1554861|       0.0408733|      -0.1679035|       0.0541600|          -0.3403964|           0.0658874|           0.0702585|                       0.0905491|                          0.0905491|                          -0.1798036|              -0.3558463|                  -0.4738658|              -0.0509755|               0.1618197|              -0.3925124|                  -0.1317097|                  -0.1960175|                  -0.5336951|      -0.2197185|      -0.5065388|      -0.1881127|                      -0.0360650|                              -0.0864208|                  -0.4538148|                      -0.5696987|                0.0245641|                0.2389409|               -0.3552371|                  -0.9724522|                  -0.9311426|                  -0.9448336|                   -0.0639523|                   -0.1404481|                   -0.5943979|       -0.4476936|       -0.5105180|       -0.3087041|           -0.3048897|           -0.6146124|           -0.3039500|                       -0.0764429|                          -0.0764429|                           -0.1588393|               -0.4108927|                   -0.5457753|                0.0528674|                0.2003450|               -0.3852424|                   -0.0757369|                   -0.1361679|                   -0.6563490|       -0.5221612|       -0.5164156|       -0.4164056|                       -0.2433745|                               -0.2658834|                   -0.4823197|                       -0.5467085| WALKING\_UPSTAIRS |
| 9403 |               0.2174244|              -0.0227000|              -0.1064529|                 -0.7995738|                  0.7239980|                  0.6877527|                   0.0887371|                   0.0059648|                  -0.0021486|      -0.0302831|      -0.1062703|       0.0920168|          -0.0971835|          -0.0454574|          -0.0552454|                      -0.9632923|                         -0.9632923|                          -0.9702095|              -0.9741839|                  -0.9698585|              -0.9735843|              -0.9416291|              -0.9820482|                  -0.9767452|                  -0.9301151|                  -0.9818179|      -0.9469163|      -0.9749740|      -0.9851911|                      -0.9514566|                              -0.9445296|                  -0.9524734|                      -0.9565874|               -0.9755846|               -0.9502483|               -0.9831096|                  -0.9141341|                  -0.9903216|                  -0.9922856|                   -0.9740399|                   -0.9244591|                   -0.9846048|       -0.9680975|       -0.9794044|       -0.9897198|           -0.9298194|           -0.9719194|           -0.9838648|                       -0.9532789|                          -0.9532789|                           -0.9431238|               -0.9573341|                   -0.9491810|               -0.9763008|               -0.9576280|               -0.9842963|                   -0.9733559|                   -0.9230522|                   -0.9860136|       -0.9758707|       -0.9827900|       -0.9926883|                       -0.9605461|                               -0.9399570|                   -0.9690332|                       -0.9435730| LAYING            |
| 7063 |               0.2799873|              -0.0182161|              -0.1111523|                  0.6405026|                  0.4869884|                  0.3825950|                   0.0738173|                   0.0089850|                   0.0007503|      -0.0276813|      -0.0723417|       0.0860051|          -0.0973706|          -0.0417996|          -0.0543150|                      -0.9942990|                         -0.9942990|                          -0.9961961|              -0.9946216|                  -0.9978151|              -0.9965697|              -0.9946896|              -0.9911139|                  -0.9964510|                  -0.9939761|                  -0.9939341|      -0.9984081|      -0.9927664|      -0.9961432|                      -0.9942858|                              -0.9973142|                  -0.9950309|                      -0.9982100|               -0.9957833|               -0.9959772|               -0.9847658|                  -0.9933257|                  -0.9966458|                  -0.9878578|                   -0.9960852|                   -0.9938937|                   -0.9947182|       -0.9988500|       -0.9904781|       -0.9961906|           -0.9985072|           -0.9965994|           -0.9970694|                       -0.9932435|                          -0.9932435|                           -0.9972641|               -0.9944936|                   -0.9984118|               -0.9952918|               -0.9958853|               -0.9813748|                   -0.9959601|                   -0.9942070|                   -0.9939555|       -0.9989756|       -0.9891564|       -0.9964581|                       -0.9925742|                               -0.9958138|                   -0.9948474|                       -0.9984580| SITTING           |
| 6350 |               0.2658502|              -0.0355548|              -0.1565164|                  0.9794793|                  0.0102029|                  0.0250018|                   0.0777952|                   0.0477155|                   0.0416659|      -0.0042544|      -0.1844206|       0.1140368|          -0.1426603|          -0.0046268|          -0.0639144|                      -0.9309211|                         -0.9309211|                          -0.9860674|              -0.9373209|                  -0.9902660|              -0.9897014|              -0.9296243|              -0.9506516|                  -0.9905721|                  -0.9730454|                  -0.9780543|      -0.9493332|      -0.9651182|      -0.9857179|                      -0.9595695|                              -0.9811010|                  -0.9664795|                      -0.9876364|               -0.9887521|               -0.9090772|               -0.9171983|                  -0.9781481|                  -0.9202515|                  -0.8845587|                   -0.9906524|                   -0.9756546|                   -0.9843226|       -0.9710375|       -0.9590027|       -0.9876115|           -0.9840450|           -0.9873035|           -0.9939856|                       -0.9291890|                          -0.9291890|                           -0.9822778|               -0.9466795|                   -0.9844110|               -0.9881816|               -0.9041984|               -0.9066085|                   -0.9915792|                   -0.9812744|                   -0.9906536|       -0.9793870|       -0.9557491|       -0.9893626|                       -0.9255336|                               -0.9824556|                   -0.9440376|                       -0.9812687| SITTING           |
| 2753 |               0.2776202|              -0.0179054|              -0.1116377|                 -0.4275756|                  0.9417251|                  0.3064423|                   0.0742165|                   0.0051012|                   0.0034698|      -0.0276794|      -0.0754834|       0.0811682|          -0.0981023|          -0.0400116|          -0.0517131|                      -0.9968174|                         -0.9968174|                          -0.9932991|              -0.9929136|                  -0.9913284|              -0.9942850|              -0.9926826|              -0.9940045|                  -0.9928731|                  -0.9929884|                  -0.9908561|      -0.9969620|      -0.9878952|      -0.9937168|                      -0.9949154|                              -0.9957626|                  -0.9918893|                      -0.9906475|               -0.9947348|               -0.9959732|               -0.9930325|                  -0.9994822|                  -0.9996690|                  -0.9936067|                   -0.9921344|                   -0.9933435|                   -0.9925788|       -0.9977229|       -0.9888972|       -0.9944065|           -0.9971314|           -0.9873125|           -0.9945726|                       -0.9961210|                          -0.9961210|                           -0.9958612|               -0.9929052|                   -0.9902232|               -0.9948437|               -0.9973584|               -0.9920136|                   -0.9919342|                   -0.9943210|                   -0.9928968|       -0.9979339|       -0.9895764|       -0.9950993|                       -0.9969698|                               -0.9946398|                   -0.9949985|                       -0.9898903| LAYING            |
