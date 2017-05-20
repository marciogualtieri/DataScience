-   [Installing the Required Packages](#installing-the-required-packages)
-   [Importing the Required Packages](#importing-the-required-packages)
-   [Loading Data](#loading-data)
-   [Raw Data](#raw-data)
-   [Loading Data](#loading-data-1)

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

Raw Data
========

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

    ## [1] "fBodyGyro-bandsEnergy()-25,32" "fBodyGyro-bandsEnergy()-1,8"  
    ## [3] "fBodyBodyGyroJerkMag-sma()"    "tBodyGyroMag-arCoeff()4"      
    ## [5] "tBodyAcc-energy()-X"           "angle(Z,gravityMean)"

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

    ## [1] "tBodyAcc-arCoeff()-X,3"           "fBodyAccJerk-bandsEnergy()-49,56"
    ## [3] "fBodyGyro-maxInds-Z"              "fBodyBodyAccJerkMag-iqr()"       
    ## [5] "fBodyBodyGyroJerkMag-std()"       "tBodyAcc-entropy()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyBodyGyroMag-mean()" "fBodyGyro-mean()-X"     
    ## [3] "fBodyGyro-mean()-Y"      "tGravityAcc-mean()-Z"   
    ## [5] "fBodyAccJerk-mean()-Z"   "fBodyAccJerk-mean()-X"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAcc-std()-X"      "fBodyAcc-std()-X"      "tGravityAcc-std()-Y"  
    ## [4] "fBodyAcc-std()-Z"      "tBodyGyroJerk-std()-Z" "tBodyGyroMag-std()"

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

    ## [1] "tBodyAcc-correlation()-X,Z"       "tGravityAcc-entropy()-X"         
    ## [3] "fBodyAcc-max()-Z"                 "fBodyBodyGyroMag-mean()"         
    ## [5] "fBodyBodyAccJerkMag-std()"        "fBodyAccJerk-bandsEnergy()-41,48"

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
| 78   |               0.3236850|              -0.0157140|              -0.1109454|                 -0.5398008|                  0.7671188|                  0.6397799|                   0.0724810|                   0.0135652|                  -0.0134100|      -0.0248364|      -0.0749692|       0.0936919|          -0.1004867|          -0.0366715|          -0.0648845|                      -0.9758552|                         -0.9758552|                          -0.9921009|              -0.9849166|                  -0.9965863|              -0.9863952|              -0.9906107|              -0.9887742|                  -0.9921429|                  -0.9899236|                  -0.9910112|      -0.9957970|      -0.9915984|      -0.9796551|                      -0.9873106|                              -0.9938003|                  -0.9906138|                      -0.9966822|               -0.9781284|               -0.9926269|               -0.9888523|                  -0.9586241|                  -0.9959934|                  -0.9894430|                   -0.9926459|                   -0.9897246|                   -0.9910848|       -0.9960019|       -0.9895845|       -0.9703464|           -0.9980162|           -0.9955732|           -0.9936948|                       -0.9747988|                          -0.9747988|                           -0.9940893|               -0.9881456|                   -0.9966008|               -0.9750910|               -0.9932075|               -0.9888847|                   -0.9939711|                   -0.9901788|                   -0.9894962|       -0.9959939|       -0.9883985|       -0.9701515|                       -0.9714328|                               -0.9929709|                   -0.9882294|                       -0.9962983|           6|
| 1291 |               0.1968700|              -0.0267271|              -0.1238362|                  0.9776803|                 -0.1445651|                 -0.0297892|                  -0.0848633|                   0.2552071|                   0.4327247|       0.0007386|      -0.1231216|       0.0365010|          -0.1362894|          -0.1173504|           0.1226178|                      -0.1799084|                         -0.1799084|                          -0.2427798|              -0.4401642|                  -0.6004787|              -0.1809235|              -0.2089343|              -0.2835908|                  -0.2353444|                  -0.2529219|                  -0.3839013|      -0.5578258|      -0.5844607|      -0.2217414|                      -0.3360283|                              -0.2418882|                  -0.5430412|                      -0.6496845|               -0.2258047|               -0.2578722|               -0.3317969|                  -0.9877611|                  -0.9692298|                  -0.9767735|                   -0.2079968|                   -0.2235974|                   -0.4337555|       -0.6052508|       -0.5849591|       -0.2192662|           -0.5743234|           -0.6638987|           -0.4455074|                       -0.3470304|                          -0.3470304|                           -0.2041635|               -0.5122806|                   -0.6489230|               -0.2441771|               -0.3325120|               -0.4178633|                   -0.2495982|                   -0.2436918|                   -0.4811397|       -0.6217653|       -0.5881534|       -0.2897442|                       -0.4544352|                               -0.1626119|                   -0.5745630|                       -0.6716058|           1|
| 2858 |               0.2548677|              -0.0170420|              -0.1034222|                 -0.2540328|                  0.7475828|                  0.6609685|                   0.0774950|                   0.0037946|                   0.0066425|      -0.0288010|      -0.0664225|       0.0891989|          -0.0978837|          -0.0534424|          -0.0536676|                      -0.9860934|                         -0.9860934|                          -0.9910350|              -0.9827602|                  -0.9873932|              -0.9888359|              -0.9863325|              -0.9899149|                  -0.9891863|                  -0.9869760|                  -0.9913536|      -0.9871729|      -0.9791401|      -0.9963311|                      -0.9907525|                              -0.9936677|                  -0.9830464|                      -0.9908205|               -0.9864722|               -0.9889401|               -0.9900488|                  -0.9803637|                  -0.9984661|                  -0.9899660|                   -0.9890435|                   -0.9869566|                   -0.9935618|       -0.9915731|       -0.9743997|       -0.9973867|           -0.9823159|           -0.9878814|           -0.9951679|                       -0.9902433|                          -0.9902433|                           -0.9934461|               -0.9812781|                   -0.9912512|               -0.9853445|               -0.9901222|               -0.9900244|                   -0.9898387|                   -0.9878562|                   -0.9945438|       -0.9930638|       -0.9718478|       -0.9980857|                       -0.9903920|                               -0.9915172|                   -0.9830186|                       -0.9921368|           6|
| 1697 |               0.2796935|              -0.0027169|              -0.1079111|                  0.9603861|                 -0.1932047|                  0.1080418|                   0.0791107|                   0.0261403|                   0.0016338|      -0.0475175|      -0.0725863|       0.0684008|          -0.1191559|          -0.0337669|          -0.0548803|                      -0.9530096|                         -0.9530096|                          -0.9695656|              -0.9371052|                  -0.9613094|              -0.9857133|              -0.9379280|              -0.9570175|                  -0.9810197|                  -0.9450366|                  -0.9719012|      -0.9598091|      -0.9302600|      -0.9275099|                      -0.9604303|                              -0.9566301|                  -0.9343852|                      -0.9404860|               -0.9889347|               -0.9357070|               -0.9294191|                  -0.9952085|                  -0.9764419|                  -0.9732989|                   -0.9799059|                   -0.9381600|                   -0.9752290|       -0.9663744|       -0.9338976|       -0.9290152|           -0.9805398|           -0.9486187|           -0.9331138|                       -0.9621334|                          -0.9621334|                           -0.9567895|               -0.9357636|                   -0.9378288|               -0.9904871|               -0.9375231|               -0.9204361|                   -0.9804000|                   -0.9345122|                   -0.9770754|       -0.9684002|       -0.9366460|       -0.9358403|                       -0.9679906|                               -0.9556066|                   -0.9480230|                       -0.9383398|           5|
| 990  |               0.2538781|              -0.0011955|              -0.1467726|                  0.9544710|                 -0.2031290|                  0.0341599|                   0.2785709|                  -0.0493242|                   0.0422907|      -0.0910770|      -0.0544465|       0.2009096|          -0.1861135|          -0.1328509|          -0.3053695|                      -0.1532152|                         -0.1532152|                          -0.0799330|              -0.1540901|                  -0.3749455|              -0.1771194|               0.2235941|              -0.3635933|                  -0.0881410|                   0.2673448|                  -0.3945435|      -0.2855308|      -0.3255480|      -0.0247207|                      -0.0500132|                               0.1319577|                  -0.2790531|                      -0.4327172|               -0.2684376|                0.1203456|               -0.3466060|                  -0.9875521|                  -0.9761138|                  -0.9793801|                   -0.0723461|                    0.3148563|                   -0.4319868|       -0.3761263|       -0.2774689|       -0.0713835|           -0.3428949|           -0.4174810|           -0.2366850|                       -0.1888219|                          -0.1888219|                            0.1521811|               -0.3110351|                   -0.4080138|               -0.3076645|               -0.0110093|               -0.3891748|                   -0.1392983|                    0.2780092|                   -0.4664625|       -0.4065421|       -0.2543526|       -0.1720402|                       -0.4054698|                                0.1698588|                   -0.4581646|                       -0.4172183|           1|
| 2386 |               0.2244080|              -0.0252667|              -0.1371396|                  0.7214071|                 -0.4857721|                 -0.3234063|                   0.2880655|                  -0.0382986|                  -0.2985484|       0.2398939|      -0.4162781|      -0.1909020|          -0.0596657|          -0.0385254|           0.0740223|                      -0.1308040|                         -0.1308040|                          -0.3471466|              -0.1703958|                  -0.4660593|              -0.3193708|              -0.2802296|              -0.3254949|                  -0.3856979|                  -0.4822187|                  -0.4682704|      -0.5282965|      -0.2907034|      -0.1459448|                      -0.2971897|                              -0.4015791|                  -0.3746940|                      -0.5000906|               -0.2402702|               -0.0560105|               -0.2486112|                  -0.9001203|                  -0.9324955|                  -0.9664972|                   -0.3101316|                   -0.4515194|                   -0.5213939|       -0.6664364|       -0.2398024|       -0.0359429|           -0.5304241|           -0.4671963|           -0.4107162|                       -0.3111420|                          -0.3111420|                           -0.4130364|               -0.3866279|                   -0.5137526|               -0.2111656|               -0.0139036|               -0.2653595|                   -0.2937097|                   -0.4541066|                   -0.5731404|       -0.7115746|       -0.2153047|       -0.0906064|                       -0.4258744|                               -0.4314769|                   -0.5040201|                       -0.5674580|           2|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------|
| 2844 |               0.2676915|              -0.0170453|              -0.1025847|                 -0.2270096|                  0.8610217|                  0.4901365|                   0.0728813|                   0.0074670|                   0.0019025|      -0.0284563|      -0.0729446|       0.0852796|          -0.0957112|          -0.0448363|          -0.0499272|                      -0.9923659|                         -0.9923659|                          -0.9936434|              -0.9908413|                  -0.9934962|              -0.9915964|              -0.9924143|              -0.9909739|                  -0.9929783|                  -0.9921953|                  -0.9907931|      -0.9949705|      -0.9883051|      -0.9902108|                      -0.9933881|                              -0.9925480|                  -0.9911476|                      -0.9932143|               -0.9903306|               -0.9948016|               -0.9908947|                  -0.9918004|                  -0.9976859|                  -0.9920927|                   -0.9929264|                   -0.9924189|                   -0.9915582|       -0.9953513|       -0.9872586|       -0.9921891|           -0.9966034|           -0.9917101|           -0.9917797|                       -0.9930529|                          -0.9930529|                           -0.9931884|               -0.9918791|                   -0.9938739|               -0.9896292|               -0.9955288|               -0.9906542|                   -0.9934822|                   -0.9932680|                   -0.9907155|       -0.9953988|       -0.9866104|       -0.9936511|                       -0.9929139|                               -0.9928737|                   -0.9938383|                       -0.9950346| LAYING        |
| 1509 |               0.2468740|               0.0452894|              -0.1039866|                  0.9267274|                  0.1223199|                  0.2198337|                   0.0794745|                   0.0432424|                   0.0563248|      -0.0434834|      -0.2250269|       0.2420308|          -0.1060425|          -0.0455618|          -0.0300983|                      -0.8843665|                         -0.8843665|                          -0.9654316|              -0.8989107|                  -0.9767723|              -0.9793670|              -0.9161095|              -0.9156113|                  -0.9703107|                  -0.9552431|                  -0.9610389|      -0.9814045|      -0.9583480|      -0.9452555|                      -0.9291829|                              -0.9615503|                  -0.9537736|                      -0.9657682|               -0.9831878|               -0.8716073|               -0.8873921|                  -0.9747700|                  -0.8875670|                  -0.8800313|                   -0.9671176|                   -0.9586799|                   -0.9649034|       -0.9871334|       -0.9629036|       -0.9561540|           -0.9842347|           -0.9701440|           -0.9656201|                       -0.9082152|                          -0.9082152|                           -0.9594748|               -0.9467030|                   -0.9665705|               -0.9849230|               -0.8597535|               -0.8806146|                   -0.9665349|                   -0.9666374|                   -0.9672001|       -0.9890007|       -0.9662249|       -0.9643594|                       -0.9108785|                               -0.9552567|                   -0.9507705|                       -0.9696966| SITTING       |
| 2005 |               0.2830212|               0.0207079|              -0.1597719|                  0.9692694|                 -0.0622169|                  0.1183299|                   0.0751591|                   0.0022828|                   0.0073938|      -0.0450867|      -0.0944333|       0.0582266|          -0.0829440|          -0.0307513|          -0.0333211|                      -0.9293820|                         -0.9293820|                          -0.9837802|              -0.9472828|                  -0.9823561|              -0.9938063|              -0.9479882|              -0.9800711|                  -0.9917193|                  -0.9702965|                  -0.9861523|      -0.9674812|      -0.9713010|      -0.9422265|                      -0.9659672|                              -0.9875360|                  -0.9725728|                      -0.9852918|               -0.9955914|               -0.9179921|               -0.9579934|                  -0.9943281|                  -0.9292283|                  -0.9298146|                   -0.9921060|                   -0.9695017|                   -0.9876823|       -0.9745465|       -0.9662083|       -0.9246714|           -0.9816552|           -0.9839772|           -0.9767177|                       -0.9243146|                          -0.9243146|                           -0.9883687|               -0.9684052|                   -0.9858904|               -0.9965376|               -0.9093586|               -0.9497400|                   -0.9933155|                   -0.9706575|                   -0.9876616|       -0.9767217|       -0.9634742|       -0.9262676|                       -0.9179624|                               -0.9882332|                   -0.9707045|                       -0.9872542| STANDING      |
| 2277 |               0.2797248|              -0.0080883|              -0.1038517|                  0.9594740|                 -0.2255902|                  0.0175640|                   0.0716546|                  -0.0042020|                  -0.0243695|      -0.0150076|      -0.0827168|       0.0884308|          -0.1171324|          -0.0495069|          -0.0481293|                      -0.9410553|                         -0.9410553|                          -0.9462789|              -0.9097406|                  -0.9639005|              -0.9645179|              -0.8862745|              -0.9480922|                  -0.9535134|                  -0.9102958|                  -0.9674925|      -0.9011199|      -0.9727571|      -0.9274138|                      -0.9275985|                              -0.9425299|                  -0.9327266|                      -0.9692971|               -0.9744116|               -0.8822806|               -0.9322658|                  -0.9944966|                  -0.9682984|                  -0.9715368|                   -0.9539085|                   -0.9137726|                   -0.9727624|       -0.8966779|       -0.9743700|       -0.9249669|           -0.9423334|           -0.9805743|           -0.9528155|                       -0.9275480|                          -0.9275480|                           -0.9491752|               -0.9168701|                   -0.9718246|               -0.9795815|               -0.8865951|               -0.9281013|                   -0.9585868|                   -0.9247877|                   -0.9769139|       -0.8967658|       -0.9755278|       -0.9308369|                       -0.9376423|                               -0.9583789|                   -0.9204797|                       -0.9774054| STANDING      |
| 1606 |               0.2758906|              -0.0110854|              -0.1103230|                  0.9756003|                 -0.0890559|                 -0.0511822|                   0.0763895|                   0.0027498|                  -0.0110710|      -0.0480923|      -0.0321939|       0.0498085|          -0.0881833|          -0.0480640|          -0.0210171|                      -0.9865428|                         -0.9865428|                          -0.9837174|              -0.9613392|                  -0.9912215|              -0.9901129|              -0.9742132|              -0.9789637|                  -0.9867946|                  -0.9782816|                  -0.9833339|      -0.9736815|      -0.9847567|      -0.9576991|                      -0.9832352|                              -0.9884502|                  -0.9697904|                      -0.9916002|               -0.9920999|               -0.9784553|               -0.9796397|                  -0.9959999|                  -0.9812837|                  -0.9833298|                   -0.9857163|                   -0.9776977|                   -0.9862635|       -0.9735685|       -0.9838713|       -0.9539570|           -0.9879938|           -0.9911439|           -0.9918312|                       -0.9847011|                          -0.9847011|                           -0.9883918|               -0.9519444|                   -0.9920742|               -0.9930162|               -0.9813206|               -0.9808270|                   -0.9857203|                   -0.9785258|                   -0.9879005|       -0.9737074|       -0.9833410|       -0.9567568|                       -0.9870935|                               -0.9867810|                   -0.9494987|                       -0.9929840| SITTING       |
| 1843 |               0.2814219|              -0.0255686|              -0.0832249|                  0.9555436|                  0.1380046|                  0.0258699|                   0.0661745|                  -0.0125653|                   0.0366541|      -0.0784001|       0.0100017|       0.0679725|          -0.0684342|          -0.0612346|          -0.0288209|                      -0.9581504|                         -0.9581504|                          -0.9844662|              -0.9188213|                  -0.9901169|              -0.9888586|              -0.9474891|              -0.9705238|                  -0.9881202|                  -0.9695782|                  -0.9840364|      -0.9537508|      -0.9719394|      -0.9413151|                      -0.9727213|                              -0.9794550|                  -0.9478810|                      -0.9890420|               -0.9901120|               -0.9336754|               -0.9573312|                  -0.9848707|                  -0.9815364|                  -0.9650513|                   -0.9891706|                   -0.9701816|                   -0.9861623|       -0.9620044|       -0.9604636|       -0.9116365|           -0.9919195|           -0.9891880|           -0.9841166|                       -0.9713817|                          -0.9713817|                           -0.9815827|               -0.9264052|                   -0.9889107|               -0.9905763|               -0.9302357|               -0.9526484|                   -0.9915648|                   -0.9731468|                   -0.9868087|       -0.9645555|       -0.9548068|       -0.9115045|                       -0.9738751|                               -0.9835349|                   -0.9256212|                       -0.9890954| SITTING       |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------|
| 6085 |               0.2783098|              -0.0163853|              -0.1112288|                 -0.4838919|                  0.9836050|                  0.0896439|                   0.0772577|                   0.0168319|                   0.0314731|      -0.0324051|      -0.0608830|       0.0802238|          -0.0956514|          -0.0447245|          -0.0456165|                      -0.9695044|                         -0.9695044|                          -0.9708284|              -0.9671994|                  -0.9673686|              -0.9822882|              -0.9714517|              -0.9511940|                  -0.9783965|                  -0.9694578|                  -0.9639426|      -0.9580507|      -0.9594954|      -0.9774325|                      -0.9721672|                              -0.9678149|                  -0.9596581|                      -0.9660608|               -0.9854065|               -0.9754059|               -0.9424771|                  -0.9910219|                  -0.9993014|                  -0.9556151|                   -0.9785374|                   -0.9670209|                   -0.9645293|       -0.9719163|       -0.9634285|       -0.9797578|           -0.9521668|           -0.9687761|           -0.9804186|                       -0.9770694|                          -0.9770694|                           -0.9673843|               -0.9614629|                   -0.9675551|               -0.9867976|               -0.9782458|               -0.9411096|                   -0.9806468|                   -0.9663567|                   -0.9633824|       -0.9765743|       -0.9662857|       -0.9823367|                       -0.9832553|                               -0.9653446|                   -0.9696075|                       -0.9716666| LAYING        |
| 5231 |               0.2749241|              -0.0268882|              -0.1483909|                  0.9456736|                  0.0849200|                 -0.1545450|                   0.0742852|                   0.0142040|                   0.0002422|      -0.0227362|      -0.0950004|       0.0882492|          -0.1081213|          -0.0247246|          -0.0521334|                      -0.9624838|                         -0.9624838|                          -0.9912658|              -0.9693567|                  -0.9924226|              -0.9931662|              -0.9747116|              -0.9879007|                  -0.9910577|                  -0.9863638|                  -0.9906814|      -0.9716959|      -0.9789901|      -0.9848533|                      -0.9822033|                              -0.9941505|                  -0.9774604|                      -0.9937048|               -0.9942708|               -0.9550354|               -0.9839379|                  -0.9979794|                  -0.9711354|                  -0.9472818|                   -0.9900915|                   -0.9871364|                   -0.9932893|       -0.9707545|       -0.9740769|       -0.9797102|           -0.9869234|           -0.9938210|           -0.9941261|                       -0.9735352|                          -0.9735352|                           -0.9942399|               -0.9695988|                   -0.9943265|               -0.9947334|               -0.9485795|               -0.9818631|                   -0.9898217|                   -0.9891543|                   -0.9948099|       -0.9707301|       -0.9714394|       -0.9797769|                       -0.9718890|                               -0.9929616|                   -0.9695078|                       -0.9953943| STANDING      |
| 5441 |               0.2929965|              -0.0367458|              -0.1117818|                  0.9547116|                 -0.1647298|                  0.1235804|                   0.0801811|                   0.0244788|                  -0.0461772|       0.0181883|       0.1659327|       0.1730379|          -0.1185882|          -0.0859553|          -0.0900071|                      -0.9145996|                         -0.9145996|                          -0.9331966|              -0.8412806|                  -0.9285342|              -0.9330112|              -0.8750431|              -0.9122470|                  -0.8973174|                  -0.9084975|                  -0.9476101|      -0.9069445|      -0.8855332|      -0.7878041|                      -0.8908579|                              -0.8955606|                  -0.8540774|                      -0.8709505|               -0.9535713|               -0.8639289|               -0.8707858|                  -0.9715720|                  -0.9323893|                  -0.9186244|                   -0.9017282|                   -0.9131253|                   -0.9544498|       -0.9283563|       -0.8933141|       -0.8548357|           -0.9213436|           -0.9254956|           -0.8019449|                       -0.8789954|                          -0.8789954|                           -0.8832908|               -0.8469897|                   -0.8598087|               -0.9648077|               -0.8658432|               -0.8594664|                   -0.9162701|                   -0.9258776|                   -0.9600241|       -0.9351046|       -0.8991037|       -0.8986522|                       -0.8902946|                               -0.8679284|                   -0.8682681|                       -0.8551405| STANDING      |
| 828  |               0.3136798|               0.0134911|              -0.0945908|                  0.9139860|                 -0.3053371|                 -0.1513724|                   0.3018050|                  -0.1709028|                   0.0462783|      -0.0394590|      -0.0325995|       0.0714098|          -0.2138513|           0.1611751|          -0.3122717|                      -0.1519606|                         -0.1519606|                          -0.3100480|              -0.2747395|                  -0.5355490|              -0.2978635|              -0.0615180|              -0.3587165|                  -0.3730126|                  -0.2428466|                  -0.4470587|      -0.2716851|      -0.5130134|      -0.2650882|                      -0.4056173|                              -0.2868318|                  -0.4843351|                      -0.6180040|               -0.3013036|                0.0173711|               -0.3454546|                  -0.9779798|                  -0.9772187|                  -0.9700689|                   -0.3157533|                   -0.1973172|                   -0.4725604|       -0.3504630|       -0.4748253|       -0.3392533|           -0.3071195|           -0.6836018|           -0.4829610|                       -0.4337462|                          -0.4337462|                           -0.2426084|               -0.4447050|                   -0.6137229|               -0.3025774|               -0.0065926|               -0.3903641|                   -0.3165798|                   -0.2005135|                   -0.4951928|       -0.3779101|       -0.4561623|       -0.4258220|                       -0.5378198|                               -0.1936318|                   -0.5125384|                       -0.6352193| WALKING       |
| 4154 |               0.2788784|              -0.0219463|              -0.1114593|                  0.8930003|                  0.1542046|                  0.2955288|                   0.0737116|                   0.0155795|                  -0.0024813|      -0.0296602|      -0.0739737|       0.0878206|          -0.0980226|          -0.0418319|          -0.0568779|                      -0.9872401|                         -0.9872401|                          -0.9927914|              -0.9904202|                  -0.9970722|              -0.9952358|              -0.9901243|              -0.9844804|                  -0.9963831|                  -0.9909658|                  -0.9878822|      -0.9977951|      -0.9906904|      -0.9936566|                      -0.9883666|                              -0.9930927|                  -0.9927101|                      -0.9969030|               -0.9934399|               -0.9915596|               -0.9736260|                  -0.9934033|                  -0.9881123|                  -0.9830998|                   -0.9966084|                   -0.9912164|                   -0.9889523|       -0.9979262|       -0.9850112|       -0.9932819|           -0.9982844|           -0.9953926|           -0.9966841|                       -0.9883351|                          -0.9883351|                           -0.9938762|               -0.9905593|                   -0.9971882|               -0.9925270|               -0.9918230|               -0.9689171|                   -0.9972098|                   -0.9921894|                   -0.9884269|       -0.9979014|       -0.9821717|       -0.9936177|                       -0.9890999|                               -0.9935765|                   -0.9904464|                       -0.9974807| SITTING       |
| 3921 |               0.2791863|              -0.0254729|              -0.1247197|                  0.9650726|                  0.0872283|                  0.0425655|                   0.0803459|                  -0.0153154|                  -0.0406247|      -0.0348863|      -0.1017187|       0.1326934|          -0.0967351|          -0.0332589|          -0.0670701|                      -0.9717802|                         -0.9717802|                          -0.9842604|              -0.9646717|                  -0.9870831|              -0.9911320|              -0.9586810|              -0.9579821|                  -0.9878576|                  -0.9769439|                  -0.9817659|      -0.9775391|      -0.9747455|      -0.9669368|                      -0.9696749|                              -0.9826219|                  -0.9766883|                      -0.9849135|               -0.9942246|               -0.9567001|               -0.9537386|                  -0.9976659|                  -0.9905913|                  -0.9853645|                   -0.9879543|                   -0.9766201|                   -0.9832822|       -0.9817330|       -0.9744644|       -0.9651240|           -0.9835041|           -0.9848012|           -0.9825845|                       -0.9621526|                          -0.9621526|                           -0.9833958|               -0.9711894|                   -0.9818138|               -0.9960180|               -0.9572890|               -0.9539540|                   -0.9891506|                   -0.9778552|                   -0.9831860|       -0.9829926|       -0.9743708|       -0.9675221|                       -0.9627504|                               -0.9830757|                   -0.9721945|                       -0.9788902| SITTING       |

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

|       |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|-------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 2837  |               0.2684599|              -0.0186532|              -0.1084824|                 -0.7018459|                  0.7902342|                  0.6222879|                   0.0736246|                   0.0145340|                   0.0058085|      -0.0283468|      -0.0697176|       0.0890420|          -0.0988483|          -0.0419684|          -0.0552915|                      -0.9855132|                         -0.9855132|                          -0.9820059|              -0.9859970|                  -0.9919250|              -0.9870700|              -0.9708226|              -0.9824198|                  -0.9864573|                  -0.9721287|                  -0.9836498|      -0.9838141|      -0.9866656|      -0.9805434|                      -0.9823539|                              -0.9796671|                  -0.9837436|                      -0.9892601|               -0.9880295|               -0.9750101|               -0.9817428|                  -0.9946768|                  -0.9983101|                  -0.9927427|                   -0.9861836|                   -0.9715704|                   -0.9821968|       -0.9857932|       -0.9863588|       -0.9841921|           -0.9881018|           -0.9920760|           -0.9852001|                       -0.9840176|                          -0.9840176|                           -0.9804546|               -0.9811968|                   -0.9887353|               -0.9883240|               -0.9780280|               -0.9818431|                   -0.9870743|                   -0.9728794|                   -0.9791088|       -0.9863616|       -0.9861648|       -0.9870018|                       -0.9866538|                               -0.9799922|                   -0.9824082|                       -0.9883637| LAYING              |
| 6743  |               0.2781186|              -0.0157025|              -0.1059429|                  0.9360090|                 -0.0349011|                 -0.2484707|                   0.0688925|                   0.0150060|                   0.0032226|      -0.0283118|      -0.0773414|       0.0861886|          -0.0981462|          -0.0463391|          -0.0571064|                      -0.9908830|                         -0.9908830|                          -0.9902364|              -0.9915295|                  -0.9934585|              -0.9927872|              -0.9815657|              -0.9878416|                  -0.9919548|                  -0.9793712|                  -0.9920125|      -0.9955698|      -0.9873466|      -0.9928456|                      -0.9897167|                              -0.9909664|                  -0.9911282|                      -0.9929004|               -0.9950810|               -0.9857657|               -0.9822483|                  -0.9959012|                  -0.9968356|                  -0.9829118|                   -0.9918672|                   -0.9790666|                   -0.9943104|       -0.9973626|       -0.9867513|       -0.9937980|           -0.9952472|           -0.9911538|           -0.9941455|                       -0.9915027|                          -0.9915027|                           -0.9918343|               -0.9916584|                   -0.9932730|               -0.9963492|               -0.9882355|               -0.9794289|                   -0.9924738|                   -0.9801571|                   -0.9954571|       -0.9980264|       -0.9863760|       -0.9946565|                       -0.9933165|                               -0.9918889|                   -0.9934568|                       -0.9938857| SITTING             |
| 5367  |               0.3127763|              -0.0504094|              -0.0430286|                  0.9281394|                 -0.2679981|                 -0.0266851|                   0.0152943|                  -0.0498283|                   0.1198283|      -0.1507958|       0.1661826|      -0.0764483|           0.1855506|          -0.4293283|           0.0027923|                       0.0719702|                          0.0719702|                           0.0143614|               0.1405307|                  -0.1735035|               0.0222516|               0.1959375|              -0.1973113|                  -0.0254534|                   0.0541462|                  -0.3342541|       0.0078448|       0.1774687|       0.0267349|                       0.0837419|                               0.0232700|                   0.0546208|                      -0.1518346|                0.0262848|                0.1682779|               -0.1861995|                  -0.8785750|                  -0.9111073|                  -0.8637939|                    0.0341175|                    0.1143442|                   -0.3588855|       -0.0692355|        0.0377726|       -0.0792891|           -0.3597814|           -0.0920774|           -0.1939951|                        0.0514778|                           0.0514778|                           -0.0304111|                0.0153324|                   -0.1599566|                0.0278792|                0.0789091|               -0.2455594|                    0.0053442|                    0.1064062|                   -0.3805907|       -0.0992332|       -0.0662977|       -0.2010214|                       -0.1307006|                               -0.1091518|                   -0.1920945|                       -0.2310757| WALKING\_DOWNSTAIRS |
| 8291  |               0.2771372|              -0.0176593|              -0.1098729|                  0.9688123|                 -0.1392240|                  0.0757176|                   0.0763098|                   0.0088733|                  -0.0144891|      -0.0285748|      -0.0780390|       0.0868793|          -0.0976385|          -0.0453258|          -0.0567875|                      -0.9977558|                         -0.9977558|                          -0.9937988|              -0.9940432|                  -0.9962995|              -0.9992983|              -0.9862510|              -0.9918613|                  -0.9990770|                  -0.9864461|                  -0.9906106|      -0.9931575|      -0.9930583|      -0.9956002|                      -0.9934901|                              -0.9927920|                  -0.9958806|                      -0.9973636|               -0.9993033|               -0.9888654|               -0.9938884|                  -0.9998238|                  -0.9981106|                  -0.9987809|                   -0.9991647|                   -0.9861518|                   -0.9917983|       -0.9945053|       -0.9928326|       -0.9966254|           -0.9937755|           -0.9965078|           -0.9958658|                       -0.9948552|                          -0.9948552|                           -0.9936601|               -0.9955442|                   -0.9974513|               -0.9992726|               -0.9900577|               -0.9950298|                   -0.9993586|                   -0.9867406|                   -0.9914526|       -0.9948716|       -0.9926435|       -0.9973406|                       -0.9959435|                               -0.9937992|                   -0.9958838|                       -0.9973643| STANDING            |
| 332   |               0.3513643|              -0.0125866|              -0.0981162|                  0.8907909|                 -0.3760702|                  0.0197773|                  -0.2824500|                  -0.0585934|                   0.2463754|      -0.0143125|      -0.0754096|      -0.0057702|          -0.5744998|          -0.0192957|          -0.0276668|                       0.2507506|                          0.2507506|                           0.1902940|               0.2734845|                   0.0747165|               0.0068000|               0.8347932|              -0.3234784|                   0.0159704|                   0.6117192|                  -0.3493146|       0.0192144|       0.2523636|      -0.0056115|                       0.2156412|                               0.3181792|                   0.0932910|                      -0.0805587|               -0.0693122|                0.9801063|               -0.2617142|                  -0.9659938|                  -0.9430490|                  -0.9644818|                    0.1090189|                    0.6956034|                   -0.3346371|       -0.1938442|        0.4469027|       -0.2023288|           -0.0793287|            0.1281339|           -0.0506847|                        0.0744363|                           0.0744363|                            0.3039031|                0.0953754|                   -0.0135964|               -0.1010296|                0.9283586|               -0.2855767|                    0.1078062|                    0.6745584|                   -0.3204955|       -0.2613858|        0.5447844|       -0.3516605|                       -0.1813703|                                0.2830977|                   -0.0954225|                        0.0014016| WALKING             |
| 10078 |               0.2744432|              -0.0161117|              -0.1096222|                 -0.3721637|                  0.7820641|                  0.6331957|                   0.0765016|                   0.0160852|                   0.0106239|      -0.0270143|      -0.0760914|       0.0847612|          -0.0957643|          -0.0435952|          -0.0552575|                      -0.9714461|                         -0.9714461|                          -0.9699546|              -0.9705552|                  -0.9790654|              -0.9707328|              -0.9531385|              -0.9583528|                  -0.9688517|                  -0.9595396|                  -0.9652710|      -0.9735993|      -0.9574417|      -0.9808715|                      -0.9586760|                              -0.9602045|                  -0.9578896|                      -0.9652064|               -0.9757576|               -0.9536322|               -0.9609993|                  -0.9926811|                  -0.9960209|                  -0.9936767|                   -0.9686359|                   -0.9600105|                   -0.9697777|       -0.9768411|       -0.9573631|       -0.9836534|           -0.9791537|           -0.9687714|           -0.9832857|                       -0.9602962|                          -0.9602962|                           -0.9590186|               -0.9535001|                   -0.9649177|               -0.9780058|               -0.9557544|               -0.9650595|                   -0.9712165|                   -0.9635264|                   -0.9729057|       -0.9778333|       -0.9575198|       -0.9861087|                       -0.9663677|                               -0.9560058|                   -0.9582019|                       -0.9665964| LAYING              |
