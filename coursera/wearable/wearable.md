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

    ## [1] "fBodyAccMag-skewness()"           "tBodyAccJerkMag-arCoeff()2"      
    ## [3] "fBodyGyro-entropy()-Y"            "fBodyAccJerk-bandsEnergy()-17,24"
    ## [5] "fBodyAccMag-mad()"                "fBodyAcc-skewness()-X"

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

    ## [1] "fBodyAccJerk-mean()-Y" "tBodyAcc-min()-Z"      "tBodyAcc-energy()-Y"  
    ## [4] "fBodyAcc-maxInds-Y"    "tBodyGyro-iqr()-Y"     "tBodyGyro-min()-X"

``` r
sample(mean_variables, 6)
```

    ## [1] "tGravityAcc-mean()-Z"       "fBodyBodyAccJerkMag-mean()"
    ## [3] "fBodyGyro-mean()-X"         "tGravityAcc-mean()-X"      
    ## [5] "fBodyBodyGyroMag-mean()"    "tBodyGyro-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAccJerk-std()-Y"       "fBodyBodyGyroJerkMag-std()"
    ## [3] "fBodyAccJerk-std()-Z"       "tBodyAccMag-std()"         
    ## [5] "fBodyAccMag-std()"          "tGravityAcc-std()-Z"

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

    ## [1] "fBodyGyro-bandsEnergy()-33,48" "tGravityAcc-arCoeff()-Y,4"    
    ## [3] "fBodyBodyAccJerkMag-iqr()"     "tBodyAccJerk-arCoeff()-Y,4"   
    ## [5] "fBodyBodyGyroMag-sma()"        "tBodyAcc-min()-Y"

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

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["tBodyAccelerationMeanX"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanY"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanZ"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanX"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanY"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanZ"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanX"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanY"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanZ"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanX"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanY"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanZ"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanX"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanY"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanZ"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeMean"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeMean"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeMean"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeMean"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeMean"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanX"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanY"],"name":[22],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanZ"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanX"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanY"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanZ"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanX"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanY"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanZ"],"name":[29],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeMean"],"name":[30],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeMean"],"name":[31],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeMean"],"name":[32],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeMean"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaX"],"name":[34],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaY"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaZ"],"name":[36],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaX"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaY"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaZ"],"name":[39],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaX"],"name":[40],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaY"],"name":[41],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaZ"],"name":[42],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaX"],"name":[43],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaY"],"name":[44],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaZ"],"name":[45],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaX"],"name":[46],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaY"],"name":[47],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaZ"],"name":[48],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeSigma"],"name":[49],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeSigma"],"name":[50],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeSigma"],"name":[51],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeSigma"],"name":[52],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeSigma"],"name":[53],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaX"],"name":[54],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaY"],"name":[55],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaZ"],"name":[56],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaX"],"name":[57],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaY"],"name":[58],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaZ"],"name":[59],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaX"],"name":[60],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaY"],"name":[61],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaZ"],"name":[62],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeSigma"],"name":[63],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeSigma"],"name":[64],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeSigma"],"name":[65],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeSigma"],"name":[66],"type":["dbl"],"align":["right"]},{"label":["ActivityID"],"name":[67],"type":["int"],"align":["right"]}],"data":[{"1":"0.24332452","2":"-0.044998625","3":"-0.09509671","4":"0.9026523","5":"-0.25850014","6":"-0.2470913","7":"-0.04613631","8":"0.29659279","9":"0.311756970","10":"-0.2805746200","11":"0.23639724","12":"0.27487324","13":"-0.12138969","14":"-0.120768290","15":"0.03723890","16":"-0.34361787","17":"-0.34361787","18":"-0.4034357","19":"-0.4325349","20":"-0.6612891","21":"-0.39511926","22":"-0.22709722","23":"-0.4198646","24":"-0.3929629","25":"-0.4247427","26":"-0.5762197","27":"-0.6732707","28":"-0.5402168","29":"-0.487582310","30":"-0.4037281","31":"-0.4398061","32":"-0.6140920","33":"-0.7076351","34":"-0.4455641","35":"-0.278751930","36":"-0.3545498","37":"-0.9746484","38":"-0.9250464","39":"-0.9694687","40":"-0.3795128","41":"-0.3697655","42":"-0.5861170","43":"-0.7645675","44":"-0.5013028","45":"-0.48390951","46":"-0.6731258","47":"-0.6633030","48":"-0.6517747","49":"-0.4483261","50":"-0.4483261","51":"-0.3981929","52":"-0.6213603","53":"-0.6893572","54":"-0.4666863","55":"-0.353688170","56":"-0.3691636","57":"-0.4209608","58":"-0.3509924","59":"-0.5938003","60":"-0.7941288","61":"-0.4821449","62":"-0.5297648","63":"-0.5604698","64":"-0.3518908","65":"-0.6936700","66":"-0.6876920","67":"1"},{"1":"0.27628845","2":"-0.020230299","3":"-0.09963941","4":"-0.5414290","5":"0.76868403","6":"0.6368557","7":"0.08653591","8":"0.01449172","9":"-0.008230449","10":"-0.0274997140","11":"-0.08080613","12":"0.09787710","13":"-0.09901715","14":"-0.042829335","15":"-0.04967633","16":"-0.97905506","17":"-0.97905506","18":"-0.9928484","19":"-0.9884898","20":"-0.9940009","21":"-0.98145542","22":"-0.99025497","23":"-0.9891044","24":"-0.9935156","25":"-0.9900781","26":"-0.9924262","27":"-0.9949523","28":"-0.9890520","29":"-0.984164880","30":"-0.9867530","31":"-0.9961644","32":"-0.9906415","33":"-0.9930842","34":"-0.9720728","35":"-0.992895820","36":"-0.9877673","37":"-0.9731477","38":"-0.9926566","39":"-0.9836611","40":"-0.9936987","41":"-0.9894089","42":"-0.9930083","43":"-0.9945620","44":"-0.9901102","45":"-0.98234863","46":"-0.9975120","47":"-0.9918892","48":"-0.9912178","49":"-0.9822294","50":"-0.9822294","51":"-0.9967387","52":"-0.9903973","53":"-0.9931524","54":"-0.9686450","55":"-0.993897490","56":"-0.9869430","57":"-0.9944929","58":"-0.9892735","59":"-0.9919864","60":"-0.9943908","61":"-0.9908317","62":"-0.9831685","63":"-0.9812214","64":"-0.9958627","65":"-0.9917148","66":"-0.9932431","67":"6"},{"1":"0.27516514","2":"0.014548966","3":"-0.11910002","4":"0.9024935","5":"-0.26903690","6":"-0.2281986","7":"0.41474291","8":"-0.29758702","9":"-0.201569630","10":"-0.0412244940","11":"-0.12304200","12":"0.09978471","13":"-0.16461337","14":"-0.031542730","15":"-0.16757061","16":"-0.31788841","17":"-0.31788841","18":"-0.4013154","19":"-0.5480328","20":"-0.6527941","21":"-0.36441167","22":"-0.29330273","23":"-0.4466714","24":"-0.3942385","25":"-0.4124321","26":"-0.5414050","27":"-0.6846640","28":"-0.5488368","29":"-0.537627020","30":"-0.4687234","31":"-0.4046346","32":"-0.6114233","33":"-0.7188573","34":"-0.4083355","35":"-0.297738290","36":"-0.3586021","37":"-0.9821937","38":"-0.9751727","39":"-0.9799724","40":"-0.3727995","41":"-0.3962171","42":"-0.5863682","43":"-0.7762704","44":"-0.5156335","45":"-0.49611179","46":"-0.6874239","47":"-0.6699857","48":"-0.6376366","49":"-0.4624929","50":"-0.4624929","51":"-0.4144316","52":"-0.6141574","53":"-0.7277555","54":"-0.4264475","55":"-0.344186650","56":"-0.3612086","57":"-0.4059685","58":"-0.4198270","59":"-0.6298378","60":"-0.8061335","61":"-0.4995465","62":"-0.5291375","63":"-0.5417595","64":"-0.4281193","65":"-0.6839983","66":"-0.7595682","67":"1"},{"1":"0.30247452","2":"-0.015351499","3":"-0.12844592","4":"0.9667836","5":"-0.05963691","6":"0.1093626","7":"0.09760113","8":"-0.31139606","9":"-0.126473110","10":"0.0004958671","11":"-0.13814931","12":"0.08425103","13":"-0.19754881","14":"-0.007687948","15":"-0.14178503","16":"-0.28084576","17":"-0.28084576","18":"-0.3240827","19":"-0.5138002","20":"-0.6770779","21":"-0.39924164","22":"-0.10919298","23":"-0.6516182","24":"-0.3269111","25":"-0.1934037","26":"-0.7685244","27":"-0.4099395","28":"-0.6977935","29":"-0.628728400","30":"-0.4100664","31":"-0.2164898","32":"-0.5710167","33":"-0.6959011","34":"-0.4094373","35":"-0.009933594","36":"-0.6347918","37":"-0.9840507","38":"-0.9735169","39":"-0.9635668","40":"-0.2727178","41":"-0.1339591","42":"-0.8000030","43":"-0.5066822","44":"-0.6473162","45":"-0.69702913","46":"-0.4651020","47":"-0.8148435","48":"-0.6425217","49":"-0.5029860","50":"-0.5029860","51":"-0.3165616","52":"-0.5537370","53":"-0.7236571","54":"-0.4134203","55":"-0.022583491","56":"-0.6537578","57":"-0.2802788","58":"-0.1256481","59":"-0.8315810","60":"-0.5378304","61":"-0.6218029","62":"-0.7508238","63":"-0.6414194","64":"-0.4661506","65":"-0.6184571","66":"-0.7847139","67":"1"},{"1":"-0.04766363","2":"-0.125494490","3":"-0.29959720","4":"0.8668262","5":"-0.36697929","6":"-0.2085306","7":"0.12556070","8":"0.65442163","9":"0.228261690","10":"0.1247322100","11":"-0.25577520","12":"-0.12528652","13":"-0.18189704","14":"-0.077807488","15":"0.10219247","16":"-0.06056975","17":"-0.06056975","18":"-0.3481592","19":"-0.2074150","20":"-0.4981378","21":"-0.28487375","22":"-0.03029173","23":"-0.2629478","24":"-0.3762892","25":"-0.4007624","26":"-0.5055935","27":"-0.4930221","28":"-0.3333360","29":"-0.066275208","30":"-0.3221534","31":"-0.3578977","32":"-0.4934882","33":"-0.6086863","34":"-0.2718410","35":"0.024252817","36":"-0.2004487","37":"-0.7358211","38":"-0.6663107","39":"-0.6186106","40":"-0.3219609","41":"-0.3868720","42":"-0.5626219","43":"-0.6085036","44":"-0.2638948","45":"-0.09315256","46":"-0.5040809","47":"-0.5756738","48":"-0.3342927","49":"-0.3403234","50":"-0.3403234","51":"-0.4250453","52":"-0.4892300","53":"-0.6037233","54":"-0.2666977","55":"-0.011942013","56":"-0.2288208","57":"-0.3251771","58":"-0.4140347","59":"-0.6195336","60":"-0.6451710","61":"-0.2292186","62":"-0.1849912","63":"-0.4529727","64":"-0.5268486","65":"-0.5754807","66":"-0.6249880","67":"2"},{"1":"0.21142785","2":"0.008268257","3":"-0.13856570","4":"0.7898993","5":"-0.43081434","6":"-0.2777749","7":"0.68629566","8":"0.04112172","9":"-0.026928940","10":"0.0419811360","11":"-0.20942012","12":"-0.09779790","13":"-0.04124205","14":"-0.070497669","15":"0.21671278","16":"-0.06329246","17":"-0.06329246","18":"-0.3064843","19":"-0.1373724","20":"-0.4921716","21":"-0.09176252","22":"-0.18939575","23":"-0.3364209","24":"-0.3011290","25":"-0.4536082","26":"-0.5351625","27":"-0.4921210","28":"-0.3019621","29":"0.005885385","30":"-0.2697047","31":"-0.3318368","32":"-0.4666341","33":"-0.6058830","34":"-0.1705029","35":"-0.016628200","36":"-0.2050859","37":"-0.8546671","38":"-0.9210090","39":"-0.8266907","40":"-0.2376645","41":"-0.4229987","42":"-0.5515582","43":"-0.5619262","44":"-0.1736645","45":"-0.02071076","46":"-0.5779903","47":"-0.5504555","48":"-0.3273628","49":"-0.2700480","50":"-0.2700480","51":"-0.3830493","52":"-0.4559073","53":"-0.6131547","54":"-0.2035322","55":"0.003306288","56":"-0.1978016","57":"-0.2389293","58":"-0.4276607","59":"-0.5654130","60":"-0.5849685","61":"-0.1092590","62":"-0.1190433","63":"-0.3832562","64":"-0.4580775","65":"-0.5430054","66":"-0.6506836","67":"2"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

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

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["tBodyAccelerationMeanX"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanY"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanZ"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanX"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanY"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanZ"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanX"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanY"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanZ"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanX"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanY"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanZ"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanX"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanY"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanZ"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeMean"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeMean"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeMean"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeMean"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeMean"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanX"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanY"],"name":[22],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanZ"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanX"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanY"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanZ"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanX"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanY"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanZ"],"name":[29],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeMean"],"name":[30],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeMean"],"name":[31],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeMean"],"name":[32],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeMean"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaX"],"name":[34],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaY"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaZ"],"name":[36],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaX"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaY"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaZ"],"name":[39],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaX"],"name":[40],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaY"],"name":[41],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaZ"],"name":[42],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaX"],"name":[43],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaY"],"name":[44],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaZ"],"name":[45],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaX"],"name":[46],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaY"],"name":[47],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaZ"],"name":[48],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeSigma"],"name":[49],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeSigma"],"name":[50],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeSigma"],"name":[51],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeSigma"],"name":[52],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeSigma"],"name":[53],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaX"],"name":[54],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaY"],"name":[55],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaZ"],"name":[56],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaX"],"name":[57],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaY"],"name":[58],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaZ"],"name":[59],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaX"],"name":[60],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaY"],"name":[61],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaZ"],"name":[62],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeSigma"],"name":[63],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeSigma"],"name":[64],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeSigma"],"name":[65],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeSigma"],"name":[66],"type":["dbl"],"align":["right"]},{"label":["ActivityLabel"],"name":[67],"type":["fctr"],"align":["left"]}],"data":[{"1":"0.2780196","2":"-0.01759768","3":"-0.10687870","4":"-0.2606872","5":"0.9183712","6":"0.3733782600","7":"0.076712771","8":"0.00883801","9":"-0.01115566","10":"-0.02713083","11":"-0.07678607","12":"0.087893516","13":"-0.09771817","14":"-0.04186572","15":"-0.057874692","16":"-0.995681410","17":"-0.995681410","18":"-0.99101516","19":"-0.9967757","20":"-0.9971515","21":"-0.99150390","22":"-0.99212692","23":"-0.9890294","24":"-0.9895924","25":"-0.99074001","26":"-0.9881789","27":"-0.99844412","28":"-0.9948955","29":"-0.9949723","30":"-0.9915405","31":"-0.99148795","32":"-0.9974406","33":"-0.9977936","34":"-0.9927775","35":"-0.99449086","36":"-0.9913776","37":"-0.9966996","38":"-0.9987210","39":"-0.9931465","40":"-0.9899940","41":"-0.99025159","42":"-0.9897846","43":"-0.9986582","44":"-0.9947964","45":"-0.9962474","46":"-0.99913020","47":"-0.9959061","48":"-0.9954702","49":"-0.99335616","50":"-0.99335616","51":"-0.991513670","52":"-0.9977988","53":"-0.9978437","54":"-0.9932999","55":"-0.9952168","56":"-0.9929456","57":"-0.99140746","58":"-0.990287030","59":"-0.9898853","60":"-0.9986789","61":"-0.9946772","62":"-0.9971160","63":"-0.9950138200","64":"-0.99009022","65":"-0.9984488","66":"-0.9976791","67":"LAYING"},{"1":"0.2106495","2":"0.01110482","3":"-0.11941218","4":"0.9410855","5":"-0.2171524","6":"-0.0393184540","7":"-0.126344540","8":"-0.14857495","9":"0.17904999","10":"0.09689738","11":"-0.07720853","12":"0.024544177","13":"-0.11585034","14":"-0.04534631","15":"-0.308006830","16":"0.203046140","17":"0.203046140","18":"0.08712339","19":"-0.1678365","20":"-0.3595256","21":"0.13141001","22":"0.73336424","23":"-0.4485315","24":"0.1211250","25":"0.50956322","26":"-0.4236276","27":"0.07500267","28":"-0.3793026","29":"-0.1545882","30":"0.4789281","31":"0.40608521","32":"-0.2831115","33":"-0.2960347","34":"0.1456023","35":"0.67224114","36":"-0.4805739","37":"-0.9751182","38":"-0.9564104","39":"-0.9563131","40":"0.1027149","41":"0.63103445","42":"-0.4962222","43":"-0.1745073","44":"-0.4561612","45":"-0.3682120","46":"0.01409475","47":"-0.4937171","48":"-0.3308116","49":"0.30982922","50":"0.30982922","51":"0.344624240","52":"-0.2812217","53":"-0.3220132","54":"0.1511312","55":"0.5315746","56":"-0.5435943","57":"-0.02094454","58":"0.656716300","59":"-0.5699773","60":"-0.2538682","61":"-0.5135064","62":"-0.5145189","63":"-0.0003586798","64":"0.25369333","65":"-0.4058369","66":"-0.4059615","67":"WALKING_DOWNSTAIRS"},{"1":"0.3258940","2":"-0.02524963","3":"-0.11410032","4":"-0.2867666","5":"0.7484816","6":"0.6700479300","7":"0.069040343","8":"0.02120605","9":"0.01712800","10":"0.10327519","11":"-0.23564822","12":"0.275607730","13":"-0.14575890","14":"-0.04163106","15":"-0.101879520","16":"-0.954278180","17":"-0.954278180","18":"-0.98039412","19":"-0.8202961","20":"-0.9817786","21":"-0.97576097","22":"-0.97110397","23":"-0.9741582","24":"-0.9840082","25":"-0.98062951","26":"-0.9775128","27":"-0.92474952","28":"-0.9657391","29":"-0.9364206","30":"-0.9776992","31":"-0.98412963","32":"-0.9138976","33":"-0.9814048","34":"-0.9584927","35":"-0.96423522","36":"-0.9747212","37":"-0.9210031","38":"-0.9675708","39":"-0.9720986","40":"-0.9817009","41":"-0.98123303","42":"-0.9811336","43":"-0.9331824","44":"-0.9523344","45":"-0.9335064","46":"-0.97704163","47":"-0.9804656","48":"-0.9945305","49":"-0.96579596","50":"-0.96579596","51":"-0.986916250","52":"-0.8680984","53":"-0.9833698","54":"-0.9528008","55":"-0.9620421","56":"-0.9762241","57":"-0.98075893","58":"-0.983411450","59":"-0.9834756","60":"-0.9359815","61":"-0.9457470","62":"-0.9384348","63":"-0.9639123400","64":"-0.99059208","65":"-0.8638171","66":"-0.9870488","67":"LAYING"},{"1":"0.2859050","2":"-0.00774473","3":"-0.10273652","4":"0.8903391","5":"-0.4143163","6":"0.0630735390","7":"0.073692837","8":"0.02229919","9":"0.02417221","10":"-0.03044696","11":"-0.06925109","12":"0.084129975","13":"-0.13741057","14":"-0.02984939","15":"-0.038735438","16":"-0.981200810","17":"-0.981200810","18":"-0.99091628","19":"-0.9849504","20":"-0.9926947","21":"-0.99314892","22":"-0.97608060","23":"-0.9859263","24":"-0.9939254","25":"-0.98397812","26":"-0.9877838","27":"-0.96317983","28":"-0.9854868","29":"-0.9872565","30":"-0.9865740","31":"-0.99027880","32":"-0.9667138","33":"-0.9882959","34":"-0.9918838","35":"-0.96571091","36":"-0.9841587","37":"-0.9859646","38":"-0.9705593","39":"-0.9838750","40":"-0.9944824","41":"-0.98340546","42":"-0.9901586","43":"-0.9784643","44":"-0.9851175","45":"-0.9827670","46":"-0.98464085","47":"-0.9934695","48":"-0.9909837","49":"-0.98298022","50":"-0.98298022","51":"-0.991435770","52":"-0.9673878","53":"-0.9890627","54":"-0.9911825","55":"-0.9620189","56":"-0.9833565","57":"-0.99572980","58":"-0.983831580","59":"-0.9912240","60":"-0.9842031","61":"-0.9848904","62":"-0.9827415","63":"-0.9823281700","64":"-0.99199851","65":"-0.9734883","66":"-0.9906287","67":"STANDING"},{"1":"0.3151317","2":"-0.06610142","3":"-0.09645631","4":"0.8964080","5":"-0.3860280","6":"-0.0002848996","7":"-0.008554478","8":"-0.16296048","9":"-0.09204712","10":"-0.37726233","11":"0.13327122","12":"0.094942816","13":"0.29201254","14":"-0.37331861","15":"-0.181091530","16":"0.005116491","17":"0.005116491","18":"-0.24738784","19":"-0.1584266","20":"-0.5957658","21":"-0.22798931","22":"0.20347032","23":"-0.4624369","24":"-0.2919794","25":"-0.05699100","26":"-0.6341428","27":"-0.26654483","28":"-0.4374213","29":"-0.1324150","30":"-0.2624487","31":"-0.23424237","32":"-0.4694981","33":"-0.6737106","34":"-0.1601505","35":"0.35608806","36":"-0.3191593","37":"-0.9221443","38":"-0.8849417","39":"-0.7576382","40":"-0.3127283","41":"0.06638170","42":"-0.6698987","43":"-0.4564212","44":"-0.3412584","45":"-0.1666806","46":"-0.53581599","47":"-0.7731436","48":"-0.2837002","49":"-0.15081628","50":"-0.15081628","51":"-0.274531710","52":"-0.3717256","53":"-0.6830935","54":"-0.1348067","55":"0.3459711","56":"-0.2985084","57":"-0.40143108","58":"0.129423730","59":"-0.7041815","60":"-0.5172339","61":"-0.2927937","62":"-0.2543532","63":"-0.2259595300","64":"-0.33377041","65":"-0.4144075","66":"-0.7187467","67":"WALKING_UPSTAIRS"},{"1":"0.2382135","2":"0.02918896","3":"-0.08610633","4":"0.9544955","5":"-0.1727113","6":"-0.1113253600","7":"-0.067147304","8":"0.12182938","9":"0.01595918","10":"-0.10331017","11":"0.02358184","12":"0.003040666","13":"-0.11026529","14":"-0.12994655","15":"-0.001113488","16":"-0.093572865","17":"-0.093572865","18":"-0.19091734","19":"-0.1954857","20":"-0.4350749","21":"-0.08807494","22":"0.04122578","23":"-0.2862856","24":"-0.1568317","25":"-0.04950676","26":"-0.3952402","27":"-0.10815377","28":"-0.3750974","29":"-0.2130600","30":"0.1122131","31":"-0.03578775","32":"-0.2680673","33":"-0.4247954","34":"-0.1014219","35":"-0.01073232","36":"-0.2599054","37":"-0.9279339","38":"-0.9234432","39":"-0.9227182","40":"-0.1409522","41":"0.01053469","42":"-0.4213356","43":"-0.2031782","44":"-0.4412290","45":"-0.3104721","46":"-0.30864779","47":"-0.4261264","48":"-0.4251672","49":"0.01564278","50":"0.01564278","51":"0.002226953","52":"-0.2179104","53":"-0.3627109","54":"-0.1067047","55":"-0.1026818","56":"-0.3040311","57":"-0.20151929","58":"0.009597257","59":"-0.4445156","60":"-0.2364489","61":"-0.4903299","62":"-0.4086250","63":"-0.2012091900","64":"0.04200827","65":"-0.3172021","66":"-0.3320256","67":"WALKING_DOWNSTAIRS"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

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

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["tBodyAccelerationMeanX"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanY"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanZ"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanX"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanY"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanZ"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanX"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanY"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanZ"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanX"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanY"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanZ"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanX"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanY"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanZ"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeMean"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeMean"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeMean"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeMean"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeMean"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanX"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanY"],"name":[22],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanZ"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanX"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanY"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanZ"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanX"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanY"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanZ"],"name":[29],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeMean"],"name":[30],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeMean"],"name":[31],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeMean"],"name":[32],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeMean"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaX"],"name":[34],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaY"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaZ"],"name":[36],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaX"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaY"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaZ"],"name":[39],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaX"],"name":[40],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaY"],"name":[41],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaZ"],"name":[42],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaX"],"name":[43],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaY"],"name":[44],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaZ"],"name":[45],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaX"],"name":[46],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaY"],"name":[47],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaZ"],"name":[48],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeSigma"],"name":[49],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeSigma"],"name":[50],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeSigma"],"name":[51],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeSigma"],"name":[52],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeSigma"],"name":[53],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaX"],"name":[54],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaY"],"name":[55],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaZ"],"name":[56],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaX"],"name":[57],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaY"],"name":[58],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaZ"],"name":[59],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaX"],"name":[60],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaY"],"name":[61],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaZ"],"name":[62],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeSigma"],"name":[63],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeSigma"],"name":[64],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeSigma"],"name":[65],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeSigma"],"name":[66],"type":["dbl"],"align":["right"]},{"label":["ActivityLabel"],"name":[67],"type":["fctr"],"align":["left"]}],"data":[{"1":"0.2725186","2":"0.01204297","3":"-0.08062814","4":"0.9469538","5":"0.07306651","6":"-0.15978495","7":"0.07177713","8":"0.04554071","9":"4.018563e-02","10":"-0.04691832","11":"-0.06259178","12":"0.09285596","13":"-0.04159858","14":"-0.06736723","15":"-0.052577103","16":"-0.8923290","17":"-0.8923290","18":"-0.9683274","19":"-0.8939155","20":"-0.9787210","21":"-0.9755405","22":"-0.8716383","23":"-0.9148782","24":"-0.9778784","25":"-0.9291784","26":"-0.9754687","27":"-0.8632140","28":"-0.9589480","29":"-0.9349830","30":"-0.8892388","31":"-0.9576258","32":"-0.8876998","33":"-0.9727864","34":"-0.9787886","35":"-0.7971679","36":"-0.8130137","37":"-0.9929193","38":"-0.9159917","39":"-0.9178466","40":"-0.9779565","41":"-0.9297990","42":"-0.9785775","43":"-0.8470578","44":"-0.9538407","45":"-0.9268221","46":"-0.9586264","47":"-0.9838761","48":"-0.9688171","49":"-0.8092319","50":"-0.8092319","51":"-0.9511211","52":"-0.8163305","53":"-0.9694232","54":"-0.9801425","55":"-0.7780405","56":"-0.7841022","57":"-0.9800407","58":"-0.9357053","59":"-0.9802319","60":"-0.8452295","61":"-0.9511194","62":"-0.9307626","63":"-0.8042543","64":"-0.9418672","65":"-0.8075135","66":"-0.9669265","67":"STANDING"},{"1":"0.2175461","2":"-0.04839795","3":"-0.12793966","4":"0.7976132","5":"-0.30228036","6":"-0.41073651","7":"0.05359236","8":"0.07810551","9":"2.525597e-01","10":"0.28588981","11":"-0.26245049","12":"-0.30088683","13":"-0.20761914","14":"-0.04577695","15":"0.002434206","16":"-0.2857259","17":"-0.2857259","18":"-0.4659440","19":"-0.1730026","20":"-0.7220081","21":"-0.4264287","22":"-0.2445278","23":"-0.3902236","24":"-0.4238018","25":"-0.4290797","26":"-0.5912950","27":"-0.3715968","28":"-0.6764604","29":"-0.3638132","30":"-0.3612357","31":"-0.4171497","32":"-0.5288807","33":"-0.7825870","34":"-0.4199805","35":"-0.1364975","36":"-0.2546273","37":"-0.9497819","38":"-0.9298638","39":"-0.9632083","40":"-0.4257360","41":"-0.4025238","42":"-0.6418386","43":"-0.2876462","44":"-0.6233203","45":"-0.1858286","46":"-0.6723444","47":"-0.7841625","48":"-0.6527687","49":"-0.3277702","50":"-0.3277702","51":"-0.4117336","52":"-0.3521339","53":"-0.7898824","54":"-0.4173551","55":"-0.1376035","56":"-0.2418270","57":"-0.4807507","58":"-0.4133496","59":"-0.6926409","60":"-0.2781507","61":"-0.5964665","62":"-0.2098114","63":"-0.4137668","64":"-0.4079465","65":"-0.3552924","66":"-0.8146501","67":"WALKING_UPSTAIRS"},{"1":"0.2693517","2":"-0.02365692","3":"-0.11125013","4":"0.9382493","5":"-0.26900840","6":"0.11923972","7":"0.07249135","8":"-0.05369995","9":"-8.805103e-03","10":"0.04978988","11":"0.11415427","12":"-0.07860942","13":"-0.10263696","14":"-0.06624018","15":"-0.014242145","16":"-0.8909564","17":"-0.8909564","18":"-0.9235575","19":"-0.8051653","20":"-0.9319055","21":"-0.9413052","22":"-0.7563379","23":"-0.9210118","24":"-0.9221869","25":"-0.8094645","26":"-0.9400655","27":"-0.8221532","28":"-0.9024228","29":"-0.8493503","30":"-0.8458823","31":"-0.8365453","32":"-0.8563009","33":"-0.8915823","34":"-0.9542055","35":"-0.7569884","36":"-0.9080241","37":"-0.9933890","38":"-0.9014214","39":"-0.9438448","40":"-0.9151868","41":"-0.8181555","42":"-0.9521767","43":"-0.8429407","44":"-0.9178193","45":"-0.8749533","46":"-0.8619368","47":"-0.9295933","48":"-0.8960773","49":"-0.8559077","50":"-0.8559077","51":"-0.8333497","52":"-0.8243201","53":"-0.8738699","54":"-0.9604068","55":"-0.7718418","56":"-0.9070950","57":"-0.9152204","58":"-0.8433832","59":"-0.9646361","60":"-0.8499590","61":"-0.9295253","62":"-0.8959862","63":"-0.8833692","64":"-0.8288951","65":"-0.8332558","66":"-0.8612761","67":"STANDING"},{"1":"0.2785916","2":"-0.01693934","3":"-0.11012823","4":"0.9633924","5":"0.08863628","6":"0.07237443","7":"0.07522135","8":"0.01309883","9":"-1.747487e-02","10":"-0.02683110","11":"-0.07844942","12":"0.08627493","13":"-0.09956320","14":"-0.03825232","15":"-0.052229505","16":"-0.9902695","17":"-0.9902695","18":"-0.9928484","19":"-0.9928434","20":"-0.9978784","21":"-0.9943679","22":"-0.9915434","23":"-0.9860682","24":"-0.9921478","25":"-0.9955057","26":"-0.9888277","27":"-0.9952387","28":"-0.9937727","29":"-0.9933317","30":"-0.9921715","31":"-0.9940193","32":"-0.9945675","33":"-0.9985507","34":"-0.9955863","35":"-0.9856251","36":"-0.9799564","37":"-0.9982484","38":"-0.9948845","39":"-0.9911820","40":"-0.9919768","41":"-0.9960320","42":"-0.9903145","43":"-0.9957810","44":"-0.9906633","45":"-0.9913335","46":"-0.9966991","47":"-0.9973958","48":"-0.9973016","49":"-0.9910260","50":"-0.9910260","51":"-0.9944755","52":"-0.9924667","53":"-0.9986955","54":"-0.9961607","55":"-0.9826885","56":"-0.9770448","57":"-0.9924681","58":"-0.9970920","59":"-0.9902892","60":"-0.9958815","61":"-0.9889673","62":"-0.9912721","63":"-0.9906012","64":"-0.9938643","65":"-0.9920686","66":"-0.9986949","67":"SITTING"},{"1":"0.2691860","2":"-0.01580374","3":"-0.10201784","4":"0.3651582","5":"0.42644296","6":"0.69663713","7":"0.07021754","8":"0.01660450","9":"2.507903e-05","10":"-0.02867918","11":"-0.06937016","12":"0.08352240","13":"-0.09668769","14":"-0.04544390","15":"-0.048790222","16":"-0.9878658","17":"-0.9878658","18":"-0.9917583","19":"-0.9909735","20":"-0.9968190","21":"-0.9916740","22":"-0.9888919","23":"-0.9853779","24":"-0.9930844","25":"-0.9889374","26":"-0.9889109","27":"-0.9968871","28":"-0.9913326","29":"-0.9874941","30":"-0.9872006","31":"-0.9920106","32":"-0.9911188","33":"-0.9968524","34":"-0.9890715","35":"-0.9908499","36":"-0.9787834","37":"-0.9882012","38":"-0.9959084","39":"-0.9838203","40":"-0.9926867","41":"-0.9892006","42":"-0.9903211","43":"-0.9976576","44":"-0.9881096","45":"-0.9860280","46":"-0.9975232","47":"-0.9958553","48":"-0.9947453","49":"-0.9862509","50":"-0.9862509","51":"-0.9932119","52":"-0.9891381","53":"-0.9970820","54":"-0.9878568","55":"-0.9914910","56":"-0.9757163","57":"-0.9928354","58":"-0.9903312","59":"-0.9902081","60":"-0.9978698","61":"-0.9863373","62":"-0.9866274","63":"-0.9866963","64":"-0.9939687","65":"-0.9893741","66":"-0.9972980","67":"SITTING"},{"1":"0.2785856","2":"-0.01608787","3":"-0.10997454","4":"-0.3976381","5":"0.65221530","6":"0.77597370","7":"0.07479341","8":"0.01896351","9":"-4.343499e-04","10":"-0.02651765","11":"-0.07457533","12":"0.08703214","13":"-0.09974388","14":"-0.03785742","15":"-0.052293335","16":"-0.9945053","17":"-0.9945053","18":"-0.9934832","19":"-0.9986240","20":"-0.9987113","21":"-0.9938006","22":"-0.9855592","23":"-0.9950321","24":"-0.9924618","25":"-0.9865049","26":"-0.9932761","27":"-0.9983269","28":"-0.9985602","29":"-0.9944463","30":"-0.9961548","31":"-0.9933984","32":"-0.9987803","33":"-0.9993107","34":"-0.9938451","35":"-0.9864148","36":"-0.9951048","37":"-0.9952364","38":"-0.9964123","39":"-0.9960484","40":"-0.9926523","41":"-0.9868033","42":"-0.9949221","43":"-0.9987092","44":"-0.9991026","45":"-0.9954946","46":"-0.9988628","47":"-0.9987805","48":"-0.9955362","49":"-0.9965285","50":"-0.9965285","51":"-0.9937073","52":"-0.9989870","53":"-0.9993451","54":"-0.9937365","55":"-0.9866440","56":"-0.9946394","57":"-0.9935477","58":"-0.9881554","59":"-0.9952199","60":"-0.9988013","61":"-0.9995165","62":"-0.9962852","63":"-0.9965330","64":"-0.9927809","65":"-0.9992924","66":"-0.9991023","67":"LAYING"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

``` r
activity_averages_data <- all_data %>% group_by(ActivityLabel) %>% summarise_each(funs(mean))
activity_averages_data
```

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["ActivityLabel"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["tBodyAccelerationMeanX"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanY"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanZ"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanX"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanY"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanZ"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanX"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanY"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanZ"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanX"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanY"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanZ"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanX"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanY"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanZ"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeMean"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeMean"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeMean"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeMean"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeMean"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanX"],"name":[22],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanY"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanZ"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanX"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanY"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanZ"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanX"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanY"],"name":[29],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanZ"],"name":[30],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeMean"],"name":[31],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeMean"],"name":[32],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeMean"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeMean"],"name":[34],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaX"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaY"],"name":[36],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaZ"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaX"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaY"],"name":[39],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaZ"],"name":[40],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaX"],"name":[41],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaY"],"name":[42],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaZ"],"name":[43],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaX"],"name":[44],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaY"],"name":[45],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaZ"],"name":[46],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaX"],"name":[47],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaY"],"name":[48],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaZ"],"name":[49],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeSigma"],"name":[50],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeSigma"],"name":[51],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeSigma"],"name":[52],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeSigma"],"name":[53],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeSigma"],"name":[54],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaX"],"name":[55],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaY"],"name":[56],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaZ"],"name":[57],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaX"],"name":[58],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaY"],"name":[59],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaZ"],"name":[60],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaX"],"name":[61],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaY"],"name":[62],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaZ"],"name":[63],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeSigma"],"name":[64],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeSigma"],"name":[65],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeSigma"],"name":[66],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeSigma"],"name":[67],"type":["dbl"],"align":["right"]}],"data":[{"1":"LAYING","2":"0.2686486","3":"-0.01831773","4":"-0.1074356","5":"-0.3750213","6":"0.6222704","7":"0.55561247","8":"0.08184739","9":"0.0111723565","10":"-0.004859769","11":"-0.016725340","12":"-0.09341071","13":"0.12588514","14":"-0.10186430","15":"-0.03819809","16":"-0.06384982","17":"-0.9411107","18":"-0.9411107","19":"-0.9792088","20":"-0.9384360","21":"-0.9827266","22":"-0.96681207","23":"-0.95267842","24":"-0.9600180","25":"-0.98019766","26":"-0.9713836","27":"-0.9766145","28":"-0.9629150","29":"-0.9675821","30":"-0.9641844","31":"-0.9476727","32":"-0.974300115","33":"-0.9548545","34":"-0.9779682","35":"-0.9609324","36":"-0.94350719","37":"-0.9480693","38":"-0.9433197","39":"-0.9631917","40":"-0.9518687","41":"-0.98038181","42":"-0.97114757","43":"-0.9794766","44":"-0.9678924","45":"-0.9631925","46":"-0.9635092","47":"-0.9761248","48":"-0.9804736","49":"-0.9847825","50":"-0.9321600","51":"-0.9321600","52":"-0.97424057","53":"-0.9405961","54":"-0.9767550","55":"-0.9590315","56":"-0.942460971","57":"-0.9456436","58":"-0.98245960","59":"-0.97305124","60":"-0.9809719","61":"-0.9697473","62":"-0.9613654","63":"-0.9667252","64":"-0.93491667","65":"-0.97318340","66":"-0.9421157","67":"-0.9766482"},{"1":"SITTING","2":"0.2730596","3":"-0.01268957","4":"-0.1055170","5":"0.8797312","6":"0.1087135","7":"0.15377409","8":"0.07587885","9":"0.0050469053","10":"-0.002486661","11":"-0.038431317","12":"-0.07212081","13":"0.07777715","14":"-0.09565211","15":"-0.04077978","16":"-0.05075553","17":"-0.9546439","18":"-0.9546439","19":"-0.9824444","20":"-0.9467241","21":"-0.9878801","22":"-0.98309197","23":"-0.94791797","24":"-0.9570310","25":"-0.98518877","26":"-0.9739882","27":"-0.9795620","28":"-0.9772673","29":"-0.9724576","30":"-0.9610287","31":"-0.9524104","32":"-0.978684370","33":"-0.9642961","34":"-0.9853356","35":"-0.9834462","36":"-0.93488056","37":"-0.9389816","38":"-0.9796822","39":"-0.9576727","40":"-0.9473574","41":"-0.98499723","42":"-0.97388316","43":"-0.9822965","44":"-0.9810222","45":"-0.9667081","46":"-0.9580075","47":"-0.9857051","48":"-0.9865023","49":"-0.9838055","50":"-0.9393242","51":"-0.9393242","52":"-0.97890708","53":"-0.9511990","54":"-0.9846076","55":"-0.9837473","56":"-0.932533490","57":"-0.9343367","58":"-0.98618495","59":"-0.97575086","60":"-0.9836708","61":"-0.9823333","62":"-0.9640337","63":"-0.9610302","64":"-0.94200015","65":"-0.97815477","66":"-0.9516417","67":"-0.9844914"},{"1":"STANDING","2":"0.2791535","3":"-0.01615189","4":"-0.1065869","5":"0.9414796","6":"-0.1842465","7":"-0.01405196","8":"0.07502792","9":"0.0088052586","10":"-0.004582061","11":"-0.026687141","12":"-0.06771187","13":"0.08014224","14":"-0.09972928","15":"-0.04231711","16":"-0.05209555","17":"-0.9541797","18":"-0.9541797","19":"-0.9771180","20":"-0.9421525","21":"-0.9786971","22":"-0.98162230","23":"-0.94313238","24":"-0.9573597","25":"-0.98000869","26":"-0.9645474","27":"-0.9761578","28":"-0.9436543","29":"-0.9653028","30":"-0.9583850","31":"-0.9558681","32":"-0.971090424","33":"-0.9479085","34":"-0.9748860","35":"-0.9844347","36":"-0.93250871","37":"-0.9399135","38":"-0.9880152","39":"-0.9693518","40":"-0.9530825","41":"-0.97996856","42":"-0.96434275","43":"-0.9794859","44":"-0.9455284","45":"-0.9612933","46":"-0.9570531","47":"-0.9669579","48":"-0.9802633","49":"-0.9770671","50":"-0.9465348","51":"-0.9465348","52":"-0.97145298","53":"-0.9295312","54":"-0.9735286","55":"-0.9858598","56":"-0.931132967","57":"-0.9354396","58":"-0.98182608","59":"-0.96683163","60":"-0.9815093","61":"-0.9469716","62":"-0.9594986","63":"-0.9606892","64":"-0.94960161","65":"-0.97094797","66":"-0.9306367","67":"-0.9734611"},{"1":"WALKING","2":"0.2763369","3":"-0.01790683","4":"-0.1088817","5":"0.9349916","6":"-0.1967135","7":"-0.05382512","8":"0.07671874","9":"0.0115061925","10":"-0.002319386","11":"-0.034727577","12":"-0.06942004","13":"0.08636265","14":"-0.09430071","15":"-0.04457011","16":"-0.05400647","17":"-0.1679379","18":"-0.1679379","19":"-0.2414520","20":"-0.2748660","21":"-0.4605115","22":"-0.29789093","23":"-0.04233922","24":"-0.3418407","25":"-0.31112744","26":"-0.1703951","27":"-0.4510105","28":"-0.3482374","29":"-0.3883849","30":"-0.3104062","31":"-0.2755581","32":"-0.214653972","33":"-0.4091730","34":"-0.5155168","35":"-0.3146445","36":"-0.02358295","37":"-0.2739208","38":"-0.9776121","39":"-0.9669039","40":"-0.9545976","41":"-0.26728816","42":"-0.10314114","43":"-0.4791471","44":"-0.4699148","45":"-0.3479218","46":"-0.3384486","47":"-0.3762214","48":"-0.5126191","49":"-0.4474272","50":"-0.3377540","51":"-0.3377540","52":"-0.21455589","53":"-0.3826290","54":"-0.4988410","55":"-0.3228358","56":"-0.077206342","57":"-0.2960783","58":"-0.28789769","59":"-0.09086991","60":"-0.5063291","61":"-0.5104320","62":"-0.3319615","63":"-0.4105691","64":"-0.48000228","65":"-0.22161777","66":"-0.4738331","67":"-0.5144048"},{"1":"WALKING_DOWNSTAIRS","2":"0.2881372","3":"-0.01631193","4":"-0.1057616","5":"0.9264574","6":"-0.1685072","7":"-0.04797090","8":"0.08922669","9":"0.0007467491","10":"-0.008728604","11":"-0.084034543","12":"-0.05299286","13":"0.09467820","14":"-0.07285323","15":"-0.05126398","16":"-0.05469615","17":"0.1012497","18":"0.1012497","19":"-0.1118018","20":"-0.1297856","21":"-0.4168916","22":"0.03525967","23":"0.05668265","24":"-0.2137292","25":"-0.07229678","26":"-0.1163806","27":"-0.3331903","28":"-0.2179229","29":"-0.3175927","30":"-0.1656251","31":"0.1428494","32":"0.004762459","33":"-0.2895258","34":"-0.4380073","35":"0.1007663","36":"0.05954862","37":"-0.1908045","38":"-0.9497488","39":"-0.9342661","40":"-0.9124606","41":"-0.03388265","42":"-0.07367441","43":"-0.3886661","44":"-0.3338175","45":"-0.3396314","46":"-0.2728099","47":"-0.3826898","48":"-0.4659438","49":"-0.3264560","50":"0.1164889","51":"0.1164889","52":"-0.01122067","53":"-0.2514278","54":"-0.4409293","55":"0.1219380","56":"-0.008233671","57":"-0.2458729","58":"-0.08219052","59":"-0.09141646","60":"-0.4435547","61":"-0.3751275","62":"-0.3618537","63":"-0.3804100","64":"-0.07542517","65":"-0.04227142","66":"-0.3612310","67":"-0.4864430"},{"1":"WALKING_UPSTAIRS","2":"0.2622946","3":"-0.02592329","4":"-0.1205379","5":"0.8750034","6":"-0.2813772","7":"-0.14079567","8":"0.07672932","9":"0.0087588896","10":"-0.006009534","11":"0.006824496","12":"-0.08852253","13":"0.05989381","14":"-0.11211746","15":"-0.03861927","16":"-0.05258103","17":"-0.1002041","18":"-0.1002041","19":"-0.3909386","20":"-0.1782811","21":"-0.6080471","22":"-0.29340675","23":"-0.13495051","24":"-0.3681221","25":"-0.38989677","26":"-0.3646668","27":"-0.5916701","28":"-0.3942482","29":"-0.4592535","30":"-0.2968577","31":"-0.2620281","32":"-0.353962000","33":"-0.4497814","34":"-0.6586945","35":"-0.2379897","36":"-0.01603251","37":"-0.1754497","38":"-0.9481913","39":"-0.9255493","40":"-0.9019056","41":"-0.36086343","42":"-0.33922650","43":"-0.6270636","44":"-0.4676071","45":"-0.3442318","46":"-0.2371368","47":"-0.5531328","48":"-0.6673392","49":"-0.5609892","50":"-0.2498752","51":"-0.2498752","52":"-0.38540035","53":"-0.3371421","54":"-0.6668367","55":"-0.2188880","56":"-0.021811037","57":"-0.1466018","58":"-0.38899276","59":"-0.35763293","60":"-0.6615908","61":"-0.4952540","62":"-0.2931818","63":"-0.2920413","64":"-0.36175346","65":"-0.43420673","66":"-0.3814064","67":"-0.7030835"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

``` r
sample_data_frame(all_data, 6)
```

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["tBodyAccelerationMeanX"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanY"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMeanZ"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanX"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanY"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMeanZ"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanX"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanY"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMeanZ"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanX"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanY"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMeanZ"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanX"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanY"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMeanZ"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeMean"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeMean"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeMean"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeMean"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeMean"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanX"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanY"],"name":[22],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMeanZ"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanX"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanY"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkMeanZ"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanX"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanY"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroMeanZ"],"name":[29],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeMean"],"name":[30],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeMean"],"name":[31],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeMean"],"name":[32],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeMean"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaX"],"name":[34],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaY"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationSigmaZ"],"name":[36],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaX"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaY"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationSigmaZ"],"name":[39],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaX"],"name":[40],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaY"],"name":[41],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkSigmaZ"],"name":[42],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaX"],"name":[43],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaY"],"name":[44],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroSigmaZ"],"name":[45],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaX"],"name":[46],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaY"],"name":[47],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkSigmaZ"],"name":[48],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationMagnitudeSigma"],"name":[49],"type":["dbl"],"align":["right"]},{"label":["tGravityAccelerationMagnitudeSigma"],"name":[50],"type":["dbl"],"align":["right"]},{"label":["tBodyAccelerationJerkMagnitudeSigma"],"name":[51],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroMagnitudeSigma"],"name":[52],"type":["dbl"],"align":["right"]},{"label":["tBodyGyroJerkMagnitudeSigma"],"name":[53],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaX"],"name":[54],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaY"],"name":[55],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationSigmaZ"],"name":[56],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaX"],"name":[57],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaY"],"name":[58],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationJerkSigmaZ"],"name":[59],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaX"],"name":[60],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaY"],"name":[61],"type":["dbl"],"align":["right"]},{"label":["fBodyGyroSigmaZ"],"name":[62],"type":["dbl"],"align":["right"]},{"label":["fBodyAccelerationMagnitudeSigma"],"name":[63],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyAccelerationJerkMagnitudeSigma"],"name":[64],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroMagnitudeSigma"],"name":[65],"type":["dbl"],"align":["right"]},{"label":["fBodyBodyGyroJerkMagnitudeSigma"],"name":[66],"type":["dbl"],"align":["right"]},{"label":["ActivityLabel"],"name":[67],"type":["fctr"],"align":["left"]}],"data":[{"1":"0.2939460","2":"-0.018341179","3":"-0.1199161","4":"0.9680263","5":"-0.14622349","6":"0.08151165","7":"0.15332792","8":"0.027729012","9":"-0.110460630","10":"-0.03155100","11":"-0.10819060","12":"0.06421290","13":"-0.06868645","14":"-0.008885797","15":"-0.102334850","16":"-0.43413787","17":"-0.43413787","18":"-0.57519880","19":"-0.45156255","20":"-0.7052503","21":"-0.6262756","22":"-0.30808858","23":"-0.5225622","24":"-0.64699012","25":"-0.4584159","26":"-0.65117400","27":"-0.48087895","28":"-0.7163738","29":"-0.6307293","30":"-0.6140082","31":"-0.56706209","32":"-0.60568508","33":"-0.80413537","34":"-0.62719763","35":"-0.21656585","36":"-0.4247637","37":"-0.9849014","38":"-0.9614139","39":"-0.9725517","40":"-0.64863722","41":"-0.4228751","42":"-0.66072291","43":"-0.45697806","44":"-0.62164255","45":"-0.6233785","46":"-0.5418360","47":"-0.81140191","48":"-0.7169583","49":"-0.6028353","50":"-0.6028353","51":"-0.54205615","52":"-0.55456448","53":"-0.7784608","54":"-0.6274250","55":"-0.22037682","56":"-0.4177719","57":"-0.68290048","58":"-0.4219253","59":"-0.6680660","60":"-0.45808676","61":"-0.57595526","62":"-0.6552756","63":"-0.65760637","64":"-0.5138733","65":"-0.5960126","66":"-0.76301298","67":"WALKING"},{"1":"0.4398099","2":"-0.014659927","3":"-0.1193363","4":"0.9558239","5":"-0.05519612","6":"0.08902462","7":"0.39474844","8":"0.128439960","9":"0.067035529","10":"0.04793806","11":"-0.09562048","12":"0.07223858","13":"0.14621999","14":"-0.031686381","15":"0.113147490","16":"0.19025511","17":"0.19025511","18":"-0.15618401","19":"0.03203877","20":"-0.5738033","21":"0.2797318","22":"-0.10274105","23":"-0.2521206","24":"0.07866121","25":"-0.3062065","26":"-0.43851873","27":"-0.03161317","28":"-0.4115005","29":"-0.1900778","30":"0.1548143","31":"-0.01780661","32":"-0.34943124","33":"-0.58953524","34":"0.26598963","35":"-0.13280115","36":"-0.1264734","37":"-0.9268547","38":"-0.8943987","39":"-0.7489715","40":"0.04167680","41":"-0.2946698","42":"-0.51585049","43":"0.02765038","44":"-0.34266123","45":"-0.2772809","46":"-0.4176915","47":"-0.66876703","48":"-0.4605923","49":"0.2086154","50":"0.2086154","51":"-0.06739214","52":"-0.20969514","53":"-0.5977686","54":"0.2605084","55":"-0.20426178","56":"-0.1276745","57":"-0.09994396","58":"-0.3314436","59":"-0.5959992","60":"0.02845256","61":"-0.30807650","62":"-0.3743305","63":"0.04960944","64":"-0.1417150","65":"-0.2536720","66":"-0.63776855","67":"WALKING_DOWNSTAIRS"},{"1":"0.2833874","2":"-0.017463746","3":"-0.1123500","4":"-0.1669282","5":"0.95752160","6":"0.04326061","7":"0.08026219","8":"0.006451375","9":"0.007609873","10":"-0.02486831","11":"-0.07149153","12":"0.08363917","13":"-0.09767386","14":"-0.043713433","15":"-0.066398650","16":"-0.99347005","17":"-0.99347005","18":"-0.99168899","19":"-0.98648439","20":"-0.9938970","21":"-0.9935213","22":"-0.98587934","23":"-0.9884447","24":"-0.99250851","25":"-0.9870081","26":"-0.98965796","27":"-0.98552821","28":"-0.9952824","29":"-0.9754358","30":"-0.9938749","31":"-0.99144593","32":"-0.98755964","33":"-0.99454484","34":"-0.99480473","35":"-0.98893143","36":"-0.9894182","37":"-0.9926651","38":"-0.9987394","39":"-0.9857510","40":"-0.99263252","41":"-0.9873457","42":"-0.99061083","43":"-0.98838782","44":"-0.99382842","45":"-0.9753160","46":"-0.9883146","47":"-0.99822556","48":"-0.9888866","49":"-0.9946737","50":"-0.9946737","51":"-0.99205725","52":"-0.98490948","53":"-0.9949659","54":"-0.9953889","55":"-0.99042159","56":"-0.9900511","57":"-0.99344279","58":"-0.9887120","59":"-0.9899755","60":"-0.98922692","61":"-0.99292390","62":"-0.9773571","63":"-0.99523255","64":"-0.9916476","65":"-0.9854212","66":"-0.99556270","67":"LAYING"},{"1":"0.2709182","2":"-0.009621631","3":"-0.1196300","4":"0.9608513","5":"-0.16222360","6":"-0.12502392","7":"0.08400851","8":"0.036552963","9":"0.034451143","10":"-0.03359753","11":"-0.02263841","12":"0.02513090","13":"-0.09402074","14":"-0.047698147","15":"-0.037470058","16":"-0.95660081","17":"-0.95660081","18":"-0.97958196","19":"-0.95737027","20":"-0.9917432","21":"-0.9849088","22":"-0.95919064","23":"-0.9468587","24":"-0.98484632","25":"-0.9765216","26":"-0.97672902","27":"-0.97813431","28":"-0.9869153","29":"-0.9672528","30":"-0.9679319","31":"-0.98055735","32":"-0.97693774","33":"-0.99321268","34":"-0.98776634","35":"-0.95923690","36":"-0.9160972","37":"-0.9848153","38":"-0.9867341","39":"-0.9090816","40":"-0.98284738","41":"-0.9751740","42":"-0.97940828","43":"-0.97514391","44":"-0.98145762","45":"-0.9630841","46":"-0.9876272","47":"-0.99375385","48":"-0.9884194","49":"-0.9560384","50":"-0.9560384","51":"-0.98189899","52":"-0.96301466","53":"-0.9933466","54":"-0.9890652","55":"-0.96074686","56":"-0.9065718","57":"-0.98212179","58":"-0.9752281","59":"-0.9805750","60":"-0.97460630","61":"-0.97863563","62":"-0.9649252","63":"-0.95557280","64":"-0.9825362","65":"-0.9609107","66":"-0.99360124","67":"STANDING"},{"1":"0.3024590","2":"-0.001790357","3":"-0.1068953","4":"0.9096168","5":"-0.10860351","6":"0.30047609","7":"0.05343793","8":"-0.120026000","9":"-0.036147386","10":"-0.06085721","11":"-0.04422784","12":"0.03960524","13":"-0.18327123","14":"-0.017394342","15":"0.001763466","16":"-0.46238280","17":"-0.46238280","18":"-0.57039102","19":"-0.45252472","20":"-0.6811498","21":"-0.6515549","22":"-0.26816665","23":"-0.5948248","24":"-0.64509251","25":"-0.4714196","26":"-0.69625942","27":"-0.43831843","28":"-0.7103182","29":"-0.5797414","30":"-0.5599159","31":"-0.53883195","32":"-0.59593857","33":"-0.77597971","34":"-0.63918402","35":"-0.16594906","36":"-0.5113948","37":"-0.9870585","38":"-0.9770827","39":"-0.9629231","40":"-0.63728749","41":"-0.3676442","42":"-0.70587564","43":"-0.46276037","44":"-0.63435933","45":"-0.5564868","46":"-0.4919456","47":"-0.80883249","48":"-0.6721381","49":"-0.5297207","50":"-0.5297207","51":"-0.52180335","52":"-0.53499670","53":"-0.7532998","54":"-0.6342665","55":"-0.16792095","56":"-0.5050677","57":"-0.66155461","58":"-0.3007268","59":"-0.7132913","60":"-0.47500804","61":"-0.59687031","62":"-0.5895140","63":"-0.58594131","64":"-0.5029307","65":"-0.5734603","66":"-0.74231876","67":"WALKING"},{"1":"0.3899025","2":"-0.010243786","3":"-0.1337752","4":"0.9224140","5":"-0.09969985","6":"-0.17568747","7":"0.57806164","8":"-0.037523127","9":"0.072760396","10":"-0.41797736","11":"0.09450964","12":"0.21770230","13":"0.13563780","14":"-0.045987614","15":"0.120365980","16":"0.05910926","17":"0.05910926","18":"0.02706206","19":"-0.07669801","20":"-0.1734176","21":"0.2226797","22":"0.03886155","23":"0.2436828","24":"0.09092853","25":"-0.1108598","26":"0.09494284","27":"-0.37296316","28":"0.1141092","29":"-0.1450852","30":"0.2352117","31":"0.14496348","32":"0.06758378","33":"-0.02661192","34":"-0.01386079","35":"0.02426558","36":"0.2255831","37":"-0.9548442","38":"-0.9290828","39":"-0.9726464","40":"0.08006925","41":"-0.1228126","42":"-0.04399301","43":"-0.50656932","44":"0.01323618","45":"-0.2726072","46":"-0.3801737","47":"0.01311722","48":"-0.3526353","49":"0.2163596","50":"0.2163596","51":"0.17200423","52":"-0.01220321","53":"-0.0047824","54":"-0.1242938","55":"-0.04853039","56":"0.1139005","57":"-0.03232968","58":"-0.2024475","59":"-0.1871575","60":"-0.54893415","61":"-0.06174596","62":"-0.3861932","63":"0.01658358","64":"0.1969785","65":"-0.2548757","66":"-0.04152125","67":"WALKING_DOWNSTAIRS"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
