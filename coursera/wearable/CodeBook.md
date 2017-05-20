-   [Installing the Required Packages](#installing-the-required-packages)
-   [Importing the Required Packages](#importing-the-required-packages)
-   [Loading Data](#loading-data)
-   [Description of Raw Data](#description-of-raw-data)
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

    ## [1] "fBodyAcc-bandsEnergy()-1,24" "tBodyAccMag-mad()"          
    ## [3] "fBodyAccJerk-entropy()-Z"    "tBodyAccJerk-mean()-Y"      
    ## [5] "tBodyGyroMag-arCoeff()1"     "fBodyAccJerk-mean()-X"

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

    ## [1] "fBodyAcc-bandsEnergy()-1,8"    "tBodyAcc-max()-X"             
    ## [3] "fBodyGyro-bandsEnergy()-49,56" "fBodyGyro-bandsEnergy()-17,24"
    ## [5] "fBodyAcc-bandsEnergy()-41,48"  "fBodyAccMag-sma()"

``` r
sample(mean_variables, 6)
```

    ## [1] "tBodyAcc-mean()-Y"       "tBodyGyroMag-mean()"    
    ## [3] "tBodyGyro-mean()-X"      "fBodyBodyGyroMag-mean()"
    ## [5] "fBodyAcc-mean()-X"       "fBodyAccJerk-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "tBodyAcc-std()-X"           "tBodyGyro-std()-Z"         
    ## [3] "tBodyGyro-std()-Y"          "fBodyAccJerk-std()-X"      
    ## [5] "tBodyAccJerkMag-std()"      "fBodyBodyGyroJerkMag-std()"

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

    ## [1] "fBodyGyro-std()-Z"           "tBodyGyro-correlation()-X,Y"
    ## [3] "fBodyAcc-kurtosis()-Z"       "fBodyBodyAccJerkMag-mad()"  
    ## [5] "tBodyGyro-arCoeff()-X,3"     "tBodyAcc-min()-Y"

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
| 995  |               0.3477308|              -0.0321568|              -0.0988225|                  0.9604000|                 -0.2154150|                  0.0434083|                  -0.2474108|                  -0.0651314|                  -0.0914600|       0.0558847|      -0.0409960|       0.0745144|           0.0679639|          -0.1885751|           0.0764621|                      -0.1090735|                         -0.1090735|                          -0.0463759|              -0.1528897|                  -0.4035593|              -0.1259728|               0.1410536|              -0.3799354|                  -0.1805646|                   0.2908899|                  -0.4893853|      -0.2484200|      -0.2638722|      -0.0432116|                       0.0357455|                               0.0725064|                  -0.3822866|                      -0.4295545|               -0.1561742|                0.0430341|               -0.3576778|                  -0.9922398|                  -0.9590523|                  -0.9648575|                   -0.0502975|                    0.3810028|                   -0.5286914|       -0.3682129|       -0.2837252|       -0.1331690|           -0.3640948|           -0.4358266|           -0.2578421|                       -0.1150333|                          -0.1150333|                            0.1168669|               -0.3776903|                   -0.4063870|               -0.1683237|               -0.0803565|               -0.3962072|                   -0.0038392|                    0.3887325|                   -0.5656014|       -0.4069316|       -0.3013325|       -0.2440208|                       -0.3507907|                                0.1628252|                   -0.4827493|                       -0.4147250|           1|
| 27   |               0.2764271|              -0.0262776|              -0.1269413|                  0.8865360|                 -0.4173922|                  0.0653486|                   0.0745093|                   0.0177029|                   0.0349012|      -0.0249820|      -0.0702652|       0.0928645|          -0.1008578|          -0.0402331|          -0.0709650|                      -0.9741019|                         -0.9741019|                          -0.9892921|              -0.9791362|                  -0.9924207|              -0.9928278|              -0.9725783|              -0.9741882|                  -0.9921867|                  -0.9820810|                  -0.9890226|      -0.9829260|      -0.9866335|      -0.9738634|                      -0.9785476|                              -0.9923149|                  -0.9873502|                      -0.9936636|               -0.9929888|               -0.9656195|               -0.9657378|                  -0.9949715|                  -0.9721748|                  -0.9531763|                   -0.9912279|                   -0.9833434|                   -0.9906548|       -0.9847049|       -0.9844418|       -0.9705104|           -0.9887654|           -0.9929821|           -0.9917164|                       -0.9736912|                          -0.9736912|                           -0.9931691|               -0.9833563|                   -0.9934345|               -0.9929307|               -0.9633092|               -0.9627117|                   -0.9908626|                   -0.9863528|                   -0.9908127|       -0.9852218|       -0.9831744|       -0.9719235|                       -0.9738442|                               -0.9931633|                   -0.9832974|                       -0.9931561|           5|
| 2934 |               0.3639427|              -0.0222116|              -0.1254371|                  0.9504010|                 -0.1576973|                 -0.1403994|                  -0.0567817|                   0.0375420|                   0.1945675|       0.0040686|      -0.0719858|       0.1201224|           0.0139851|           0.0559584|          -0.0221690|                      -0.0457076|                         -0.0457076|                          -0.2079415|              -0.2784204|                  -0.4732061|              -0.1756810|               0.0552644|              -0.2134172|                  -0.3108674|                  -0.0925127|                  -0.2876629|      -0.2191714|      -0.3888065|      -0.4157321|                       0.0066451|                              -0.1685607|                  -0.4165861|                      -0.5112199|               -0.0411798|                0.0207773|               -0.2436069|                  -0.9627234|                  -0.9168374|                  -0.9567510|                   -0.2799249|                   -0.0396514|                   -0.3359741|       -0.3457921|       -0.4280003|       -0.4961268|           -0.3246380|           -0.5241588|           -0.4739263|                        0.0664916|                           0.0664916|                           -0.1306854|               -0.4525816|                   -0.4935708|                0.0069668|               -0.0630306|               -0.3245885|                   -0.3110951|                   -0.0453178|                   -0.3812531|       -0.3866423|       -0.4576796|       -0.5715282|                       -0.0672801|                               -0.0877614|                   -0.5792945|                       -0.5058002|           3|
| 1626 |               0.2419846|              -0.0154896|              -0.1170145|                  0.8847073|                 -0.2748836|                 -0.3029066|                   0.1835046|                   0.2003659|                   0.6535237|       0.0206650|      -0.0997877|       0.0923479|           0.0039122|           0.1184852|           0.1122401|                      -0.1852348|                         -0.1852348|                          -0.1500447|              -0.2812696|                  -0.2578726|              -0.3121608|               0.0686811|              -0.0155610|                  -0.3209301|                  -0.0959327|                  -0.2334631|      -0.3187549|      -0.1795368|      -0.2597079|                      -0.1765541|                              -0.1383144|                  -0.2675273|                      -0.2733900|               -0.4069702|                0.0234448|               -0.0810838|                  -0.9850580|                  -0.9668592|                  -0.9547076|                   -0.2692867|                   -0.0164082|                   -0.2756266|       -0.5305831|       -0.2419032|       -0.3620444|           -0.3093136|           -0.2088671|           -0.4169616|                       -0.2985980|                          -0.2985980|                           -0.1608143|               -0.3667993|                   -0.2873322|               -0.4487366|               -0.0667378|               -0.1993065|                   -0.2797272|                    0.0060313|                   -0.3144656|       -0.6007616|       -0.2885320|       -0.4577406|                       -0.4871752|                               -0.1948459|                   -0.5717123|                       -0.3497062|           1|
| 2101 |               0.2946739|              -0.0169586|              -0.1082850|                 -0.2572891|                  0.5254626|                  0.8566554|                   0.0769352|                   0.0104123|                   0.0007272|      -0.0323102|      -0.0577079|       0.0564615|          -0.1019405|          -0.0308418|          -0.0600853|                      -0.9851128|                         -0.9851128|                          -0.9872561|              -0.9764584|                  -0.9884220|              -0.9837545|              -0.9828236|              -0.9876358|                  -0.9836427|                  -0.9816493|                  -0.9891956|      -0.9879263|      -0.9703007|      -0.9906654|                      -0.9850865|                              -0.9854445|                  -0.9745762|                      -0.9842062|               -0.9844229|               -0.9857020|               -0.9837898|                  -0.9843236|                  -0.9965609|                  -0.9926458|                   -0.9844251|                   -0.9816712|                   -0.9907116|       -0.9902823|       -0.9697988|       -0.9920429|           -0.9921070|           -0.9830252|           -0.9929790|                       -0.9860643|                          -0.9860643|                           -0.9870289|               -0.9710986|                   -0.9843006|               -0.9845584|               -0.9872468|               -0.9817922|                   -0.9868331|                   -0.9830091|                   -0.9907289|       -0.9909619|       -0.9696014|       -0.9932261|                       -0.9878793|                               -0.9882320|                   -0.9734065|                       -0.9851394|           6|
| 2058 |               0.2752860|              -0.0163351|              -0.1161343|                  0.9199891|                 -0.2385235|                 -0.2209499|                   0.0748456|                   0.0022984|                  -0.0157064|      -0.0267571|      -0.0978637|       0.1063581|          -0.0959675|          -0.0406770|          -0.0555849|                      -0.9908148|                         -0.9908148|                          -0.9904446|              -0.9808842|                  -0.9937371|              -0.9925459|              -0.9861866|              -0.9821643|                  -0.9915270|                  -0.9900018|                  -0.9861244|      -0.9869785|      -0.9869840|      -0.9863852|                      -0.9888381|                              -0.9901968|                  -0.9847894|                      -0.9932993|               -0.9940016|               -0.9877139|               -0.9837495|                  -0.9945272|                  -0.9916822|                  -0.9897166|                   -0.9914754|                   -0.9898638|                   -0.9881826|       -0.9843179|       -0.9851460|       -0.9863415|           -0.9935144|           -0.9928915|           -0.9913533|                       -0.9900741|                          -0.9900741|                           -0.9919665|               -0.9789881|                   -0.9937284|               -0.9946625|               -0.9882651|               -0.9852684|                   -0.9921632|                   -0.9903858|                   -0.9887948|       -0.9837436|       -0.9840660|       -0.9874176|                       -0.9915843|                               -0.9936347|                   -0.9785946|                       -0.9944635|           5|

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel     |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 2389 |               0.2742421|              -0.0208368|              -0.1143246|                  0.8680810|                 -0.4366017|                  0.0086679|                   0.0702023|                   0.0033228|                  -0.0071392|      -0.0276043|      -0.0814551|       0.0927917|          -0.0962583|          -0.0487295|          -0.0429617|                      -0.9801131|                         -0.9801131|                          -0.9897595|              -0.9781680|                  -0.9893675|              -0.9886189|              -0.9645052|              -0.9869769|                  -0.9916951|                  -0.9801813|                  -0.9921010|      -0.9852214|      -0.9831762|      -0.9675392|                      -0.9801046|                              -0.9917446|                  -0.9824575|                      -0.9906559|               -0.9881518|               -0.9530545|               -0.9846554|                  -0.9928469|                  -0.9864340|                  -0.9974038|                   -0.9923013|                   -0.9794158|                   -0.9934082|       -0.9844357|       -0.9826207|       -0.9671720|           -0.9903727|           -0.9909787|           -0.9804348|                       -0.9749408|                          -0.9749408|                           -0.9929985|               -0.9789580|                   -0.9907377|               -0.9877865|               -0.9495634|               -0.9834764|                   -0.9938018|                   -0.9798870|                   -0.9932399|       -0.9842818|       -0.9822983|       -0.9698686|                       -0.9747383|                               -0.9938391|                   -0.9799214|                       -0.9910283| STANDING          |
| 930  |               0.2597209|              -0.0307859|              -0.0957118|                  0.9113144|                 -0.2486901|                 -0.2035981|                  -0.0364701|                   0.0780877|                   0.0215808|       0.3766401|      -0.2034266|      -0.1591657|          -0.1763419|          -0.0724647|          -0.0998459|                      -0.2350268|                         -0.2350268|                          -0.4491687|              -0.3110713|                  -0.6581411|              -0.4396825|              -0.3551622|              -0.3172861|                  -0.4778940|                  -0.5407783|                  -0.4411556|      -0.5987620|      -0.5532965|      -0.4284260|                      -0.2974015|                              -0.3853432|                  -0.5761303|                      -0.6647682|               -0.3111553|               -0.1923093|               -0.2536017|                  -0.9372263|                  -0.9389076|                  -0.9603201|                   -0.4274396|                   -0.5222025|                   -0.4923429|       -0.6923404|       -0.5410017|       -0.2503330|           -0.6715382|           -0.6431590|           -0.6261313|                       -0.2724120|                          -0.2724120|                           -0.3877668|               -0.5090685|                   -0.6430162|               -0.2664882|               -0.1672344|               -0.2771072|                   -0.4255887|                   -0.5339758|                   -0.5417282|       -0.7220654|       -0.5367530|       -0.2690110|                       -0.3715199|                               -0.3944936|                   -0.5479600|                       -0.6404467| WALKING\_UPSTAIRS |
| 1623 |               0.2891046|              -0.0329174|              -0.1694339|                  0.9690898|                  0.0073858|                  0.0893695|                   0.0702542|                   0.0627107|                   0.0026604|      -0.0165374|      -0.1093818|       0.0725889|          -0.1086104|          -0.0080123|          -0.0852035|                      -0.8619990|                         -0.8619990|                          -0.9396442|              -0.9019361|                  -0.9504674|              -0.9569706|              -0.8281169|              -0.9111136|                  -0.9481951|                  -0.9102760|                  -0.9373127|      -0.9201675|      -0.9149504|      -0.8950961|                      -0.8961784|                              -0.9265175|                  -0.9179388|                      -0.9478525|               -0.9679189|               -0.7559846|               -0.8718871|                  -0.9856184|                  -0.9139088|                  -0.8901827|                   -0.9487182|                   -0.9067158|                   -0.9476982|       -0.9392002|       -0.9104681|       -0.8626078|           -0.9339671|           -0.9505734|           -0.9516580|                       -0.8837821|                          -0.8837821|                           -0.9236137|               -0.8965707|                   -0.9447526|               -0.9734372|               -0.7389604|               -0.8614028|                   -0.9540303|                   -0.9090071|                   -0.9575098|       -0.9452066|       -0.9083216|       -0.8657284|                       -0.8940740|                               -0.9187214|                   -0.9002366|                       -0.9436450| SITTING           |
| 722  |               0.2328520|              -0.0623503|              -0.0873655|                  0.9460243|                 -0.1446752|                 -0.1635630|                   0.4746062|                  -0.0768440|                   0.0825955|       0.1401820|      -0.1178494|       0.1187403|          -0.1865796|          -0.1500583|          -0.1804185|                      -0.2734519|                         -0.2734519|                          -0.4182831|              -0.2561268|                  -0.6927811|              -0.3317780|              -0.3070249|              -0.4380557|                  -0.3873078|                  -0.5272343|                  -0.5835759|      -0.5207834|      -0.5538814|      -0.2823394|                      -0.3870343|                              -0.3688552|                  -0.6088980|                      -0.7672156|               -0.4115131|               -0.0986026|               -0.3678628|                  -0.9835868|                  -0.9180538|                  -0.9456824|                   -0.3346374|                   -0.4645286|                   -0.6200482|       -0.5642194|       -0.5031809|        0.0594918|           -0.6850120|           -0.7339990|           -0.6479069|                       -0.4209108|                          -0.4209108|                           -0.3886576|               -0.5392880|                   -0.7715373|               -0.4459649|               -0.0604634|               -0.3789064|                   -0.3384256|                   -0.4319442|                   -0.6546023|       -0.5801013|       -0.4776899|        0.0526190|                       -0.5305258|                               -0.4183872|                   -0.5717018|                       -0.7935254| WALKING\_UPSTAIRS |
| 1992 |               0.2754349|              -0.0069992|              -0.1071885|                  0.9619580|                 -0.0730965|                  0.1561396|                   0.0798978|                   0.0002464|                  -0.0218310|      -0.0462196|      -0.0846391|       0.0820495|          -0.1027327|          -0.0482806|          -0.0408766|                      -0.9449364|                         -0.9449364|                          -0.9388186|              -0.9411754|                  -0.9635750|              -0.9763926|              -0.9100159|              -0.9420601|                  -0.9668051|                  -0.9143366|                  -0.9516816|      -0.9250678|      -0.9688447|      -0.9475063|                      -0.9428944|                              -0.9485063|                  -0.9505736|                      -0.9659129|               -0.9801120|               -0.9085073|               -0.9301060|                  -0.9951674|                  -0.9707729|                  -0.9582629|                   -0.9565101|                   -0.9141581|                   -0.9542003|       -0.9427802|       -0.9659750|       -0.9478754|           -0.9337277|           -0.9795548|           -0.9689820|                       -0.9552907|                          -0.9552907|                           -0.9531558|               -0.9490783|                   -0.9695543|               -0.9817314|               -0.9124454|               -0.9280084|                   -0.9503700|                   -0.9201430|                   -0.9549703|       -0.9483626|       -0.9644189|       -0.9525865|                       -0.9705221|                               -0.9587181|                   -0.9566681|                       -0.9771200| STANDING          |
| 506  |               0.1314322|              -0.0396629|              -0.0709345|                  0.8718341|                 -0.4241977|                 -0.0195661|                   0.1528750|                   0.4735616|                   0.1283803|      -0.2466755|       0.1043933|      -0.0547808|           0.0067632|          -0.2391913|           0.1704051|                      -0.0665658|                         -0.0665658|                          -0.3916244|              -0.3005401|                  -0.6446515|              -0.3423814|               0.1239052|              -0.5074469|                  -0.4560922|                  -0.2710502|                  -0.6787704|      -0.4224801|      -0.5463286|      -0.2716252|                      -0.3417846|                              -0.4374758|                  -0.4675667|                      -0.7287898|               -0.2555179|                0.2917633|               -0.3922628|                  -0.8792463|                  -0.8512166|                  -0.9708129|                   -0.4479448|                   -0.1795288|                   -0.7216710|       -0.4742534|       -0.4287947|       -0.3354789|           -0.5975719|           -0.7623217|           -0.4443353|                       -0.2856202|                          -0.2856202|                           -0.4670457|               -0.3955611|                   -0.7331190|               -0.2238394|                0.2923396|               -0.3793975|                   -0.4891692|                   -0.1343854|                   -0.7651640|       -0.4932779|       -0.3708362|       -0.4184993|                       -0.3666308|                               -0.5096860|                   -0.4502330|                       -0.7577683| WALKING\_UPSTAIRS |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel     |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:------------------|
| 6733 |               0.3203713|              -0.0244886|              -0.0915196|                 -0.4469464|                  0.9414140|                  0.3172827|                   0.0223138|                   0.0434220|                  -0.0017134|      -0.0245833|      -0.1097558|       0.3885082|          -0.1015924|          -0.0358040|          -0.1260260|                      -0.9279765|                         -0.9279765|                          -0.9814940|              -0.8616157|                  -0.9903758|              -0.9346480|              -0.9474841|              -0.9748708|                  -0.9867608|                  -0.9689450|                  -0.9816096|      -0.9851190|      -0.9843985|      -0.8901968|                      -0.9196918|                              -0.9801494|                  -0.9291391|                      -0.9900479|               -0.9165914|               -0.9384634|               -0.9556945|                  -0.8285361|                  -0.9368302|                  -0.9634582|                   -0.9869138|                   -0.9677995|                   -0.9845604|       -0.9889728|       -0.9796802|       -0.8722826|           -0.9865773|           -0.9896929|           -0.9942786|                       -0.9052633|                          -0.9052633|                           -0.9813108|               -0.8896517|                   -0.9906444|               -0.9100748|               -0.9368083|               -0.9486090|                   -0.9882734|                   -0.9686383|                   -0.9861691|       -0.9901647|       -0.9771647|       -0.8783209|                       -0.9112499|                               -0.9816340|                   -0.8854710|                       -0.9918098| LAYING            |
| 524  |               0.2922183|              -0.0262871|              -0.1014341|                  0.9054931|                 -0.0992246|                  0.3066640|                   0.0218830|                  -0.1833467|                  -0.0922422|       0.0239192|      -0.1082967|       0.1338844|           0.0286673|          -0.0334241|          -0.0741259|                      -0.4332252|                         -0.4332252|                          -0.5779549|              -0.4052997|                  -0.6924390|              -0.6715960|              -0.2525310|              -0.6028920|                  -0.6916586|                  -0.4358491|                  -0.7228860|      -0.4791355|      -0.6862113|      -0.5478376|                      -0.5976739|                              -0.6143089|                  -0.6203818|                      -0.7843359|               -0.6138206|               -0.1694796|               -0.4852036|                  -0.9827884|                  -0.9703389|                  -0.9653510|                   -0.6565678|                   -0.4022073|                   -0.7432248|       -0.4365115|       -0.6190620|       -0.5227005|           -0.5494607|           -0.7986814|           -0.6733943|                       -0.5674119|                          -0.5674119|                           -0.6074654|               -0.5876407|                   -0.7778957|               -0.5930588|               -0.1799713|               -0.4650782|                   -0.6506781|                   -0.4047907|                   -0.7614477|       -0.4338302|       -0.5854666|       -0.5582293|                       -0.6177070|                               -0.6005047|                   -0.6356735|                       -0.7848500| WALKING           |
| 1620 |               0.2923939|              -0.0173020|              -0.1248849|                  0.8008366|                 -0.3062750|                 -0.4076670|                  -0.0166833|                   0.0314171|                   0.0275184|      -0.0612110|      -0.0706631|       0.1393712|          -0.2079087|           0.0555831|           0.1051529|                      -0.2479087|                         -0.2479087|                          -0.4498829|              -0.2349614|                  -0.7315778|              -0.3653308|              -0.3153582|              -0.4524595|                  -0.3858063|                  -0.5450221|                  -0.5859082|      -0.4420957|      -0.6696889|      -0.3672283|                      -0.2893556|                              -0.3686344|                  -0.5986190|                      -0.7873084|               -0.3570669|               -0.0777499|               -0.2690820|                  -0.9696235|                  -0.9586078|                  -0.9670254|                   -0.3581044|                   -0.4972922|                   -0.6116764|       -0.3196011|       -0.6390360|       -0.0390038|           -0.6907777|           -0.7710839|           -0.7206766|                       -0.2550301|                          -0.2550301|                           -0.3761723|               -0.4280413|                   -0.7948044|               -0.3537503|               -0.0297731|               -0.2343428|                   -0.3857803|                   -0.4781515|                   -0.6349356|       -0.3024343|       -0.6237746|       -0.0415387|                       -0.3519092|                               -0.3894319|                   -0.4239113|                       -0.8198677| WALKING\_UPSTAIRS |
| 42   |               0.3153397|              -0.0183299|              -0.1104805|                  0.9355008|                 -0.1998167|                 -0.1858335|                  -0.2056565|                   0.3718563|                   0.2368058|       0.0037282|      -0.0119785|      -0.0185206|          -0.2187524|           0.1989106|          -0.0392136|                       0.1540312|                          0.1540312|                           0.2038221|               0.1794268|                   0.1460856|              -0.0812040|               0.2545034|               0.1056061|                  -0.0038222|                   0.1102958|                   0.0760427|       0.1432001|       0.2349873|      -0.0029265|                       0.1064930|                               0.0439392|                   0.0630160|                      -0.1397436|               -0.0265929|                0.3079307|                0.0511768|                  -0.9739537|                  -0.9667576|                  -0.9492571|                    0.0043926|                    0.2119657|                    0.0359553|       -0.1203814|        0.1843912|       -0.1230935|            0.1808104|            0.0736555|           -0.1257189|                       -0.0794947|                          -0.0794947|                           -0.0355142|               -0.0056227|                   -0.1696226|               -0.0058559|                0.2530635|               -0.0701299|                   -0.0783340|                    0.2435199|                   -0.0004389|       -0.2041942|        0.1435874|       -0.2464819|                       -0.3473027|                               -0.1501585|                   -0.2389985|                       -0.2616298| WALKING           |
| 6217 |               0.2793120|              -0.0166407|              -0.1096674|                 -0.1337899|                  0.9340037|                  0.1880021|                   0.0758720|                   0.0075855|                  -0.0028210|      -0.0278505|      -0.0737920|       0.0893597|          -0.0999058|          -0.0401299|          -0.0563289|                      -0.9979454|                         -0.9979454|                          -0.9942589|              -0.9989516|                  -0.9993253|              -0.9973222|              -0.9952681|              -0.9897189|                  -0.9967896|                  -0.9951932|                  -0.9866881|      -0.9969393|      -0.9994520|      -0.9970635|                      -0.9964797|                              -0.9936579|                  -0.9993512|                      -0.9992082|               -0.9976056|               -0.9961913|               -0.9923745|                  -0.9981331|                  -0.9979362|                  -0.9992563|                   -0.9961771|                   -0.9945490|                   -0.9904416|       -0.9976899|       -0.9995261|       -0.9977683|           -0.9974470|           -0.9996132|           -0.9973022|                       -0.9973485|                          -0.9973485|                           -0.9949662|               -0.9991939|                   -0.9992907|               -0.9976842|               -0.9958537|               -0.9941450|                   -0.9957508|                   -0.9940697|                   -0.9934213|       -0.9978951|       -0.9995228|       -0.9982552|                       -0.9977547|                               -0.9961039|                   -0.9990673|                       -0.9991486| LAYING            |
| 6870 |               0.2752802|              -0.0182061|              -0.1074052|                 -0.2849675|                  0.8601378|                  0.4646651|                   0.0760807|                   0.0146049|                  -0.0000045|      -0.0286093|      -0.0744865|       0.0846441|          -0.0975499|          -0.0401643|          -0.0541839|                      -0.9977763|                         -0.9977763|                          -0.9943459|              -0.9983569|                  -0.9984437|              -0.9938739|              -0.9919281|              -0.9972047|                  -0.9915263|                  -0.9919056|                  -0.9963601|      -0.9970264|      -0.9978371|      -0.9967087|                      -0.9976714|                              -0.9975947|                  -0.9983979|                      -0.9991060|               -0.9948148|               -0.9942788|               -0.9972394|                  -0.9975245|                  -0.9961286|                  -0.9974570|                   -0.9910585|                   -0.9922150|                   -0.9970438|       -0.9979381|       -0.9977742|       -0.9970596|           -0.9969627|           -0.9983583|           -0.9971300|                       -0.9982994|                          -0.9982994|                           -0.9979861|               -0.9983518|                   -0.9991052|               -0.9951975|               -0.9950048|               -0.9965810|                   -0.9912733|                   -0.9932021|                   -0.9962096|       -0.9982230|       -0.9976648|       -0.9974048|                       -0.9983793|                               -0.9973570|                   -0.9984801|                       -0.9988133| LAYING            |

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

|      |  tBodyAccelerationMeanX|  tBodyAccelerationMeanY|  tBodyAccelerationMeanZ|  tGravityAccelerationMeanX|  tGravityAccelerationMeanY|  tGravityAccelerationMeanZ|  tBodyAccelerationJerkMeanX|  tBodyAccelerationJerkMeanY|  tBodyAccelerationJerkMeanZ|  tBodyGyroMeanX|  tBodyGyroMeanY|  tBodyGyroMeanZ|  tBodyGyroJerkMeanX|  tBodyGyroJerkMeanY|  tBodyGyroJerkMeanZ|  tBodyAccelerationMagnitudeMean|  tGravityAccelerationMagnitudeMean|  tBodyAccelerationJerkMagnitudeMean|  tBodyGyroMagnitudeMean|  tBodyGyroJerkMagnitudeMean|  fBodyAccelerationMeanX|  fBodyAccelerationMeanY|  fBodyAccelerationMeanZ|  fBodyAccelerationJerkMeanX|  fBodyAccelerationJerkMeanY|  fBodyAccelerationJerkMeanZ|  fBodyGyroMeanX|  fBodyGyroMeanY|  fBodyGyroMeanZ|  fBodyAccelerationMagnitudeMean|  fBodyBodyAccelerationJerkMagnitudeMean|  fBodyBodyGyroMagnitudeMean|  fBodyBodyGyroJerkMagnitudeMean|  tBodyAccelerationSigmaX|  tBodyAccelerationSigmaY|  tBodyAccelerationSigmaZ|  tGravityAccelerationSigmaX|  tGravityAccelerationSigmaY|  tGravityAccelerationSigmaZ|  tBodyAccelerationJerkSigmaX|  tBodyAccelerationJerkSigmaY|  tBodyAccelerationJerkSigmaZ|  tBodyGyroSigmaX|  tBodyGyroSigmaY|  tBodyGyroSigmaZ|  tBodyGyroJerkSigmaX|  tBodyGyroJerkSigmaY|  tBodyGyroJerkSigmaZ|  tBodyAccelerationMagnitudeSigma|  tGravityAccelerationMagnitudeSigma|  tBodyAccelerationJerkMagnitudeSigma|  tBodyGyroMagnitudeSigma|  tBodyGyroJerkMagnitudeSigma|  fBodyAccelerationSigmaX|  fBodyAccelerationSigmaY|  fBodyAccelerationSigmaZ|  fBodyAccelerationJerkSigmaX|  fBodyAccelerationJerkSigmaY|  fBodyAccelerationJerkSigmaZ|  fBodyGyroSigmaX|  fBodyGyroSigmaY|  fBodyGyroSigmaZ|  fBodyAccelerationMagnitudeSigma|  fBodyBodyAccelerationJerkMagnitudeSigma|  fBodyBodyGyroMagnitudeSigma|  fBodyBodyGyroJerkMagnitudeSigma| ActivityLabel       |
|------|-----------------------:|-----------------------:|-----------------------:|--------------------------:|--------------------------:|--------------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------:|-------------------:|-------------------:|-------------------------------:|----------------------------------:|-----------------------------------:|-----------------------:|---------------------------:|-----------------------:|-----------------------:|-----------------------:|---------------------------:|---------------------------:|---------------------------:|---------------:|---------------:|---------------:|-------------------------------:|---------------------------------------:|---------------------------:|-------------------------------:|------------------------:|------------------------:|------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------:|--------------------:|--------------------:|--------------------------------:|-----------------------------------:|------------------------------------:|------------------------:|----------------------------:|------------------------:|------------------------:|------------------------:|----------------------------:|----------------------------:|----------------------------:|----------------:|----------------:|----------------:|--------------------------------:|----------------------------------------:|----------------------------:|--------------------------------:|:--------------------|
| 889  |               0.1725609|              -0.0181376|              -0.1238796|                  0.9260261|                 -0.2919898|                  0.0191298|                  -0.4105215|                   0.2538385|                  -0.0699486|       0.4478108|      -0.5462332|       0.0939832|          -0.1369351|          -0.1440978|          -0.3422605|                      -0.0361481|                         -0.0361481|                          -0.2258542|               0.1011363|                  -0.4478029|              -0.0288735|               0.1370231|              -0.4243659|                  -0.1696319|                  -0.0554251|                  -0.5707056|      -0.1683363|      -0.2399928|      -0.1370150|                      -0.1629076|                              -0.1846018|                  -0.0915195|                      -0.4975566|               -0.2206519|                0.2012562|               -0.2145714|                  -0.9688142|                  -0.9415850|                  -0.8964844|                   -0.2151347|                   -0.0410406|                   -0.6416249|       -0.2661431|        0.0188676|       -0.2270195|           -0.2794745|           -0.5507410|           -0.4414088|                       -0.2927704|                          -0.2927704|                           -0.2651389|                0.0276056|                   -0.5477373|               -0.3104893|                0.1586208|               -0.1721591|                   -0.3448313|                   -0.0924253|                   -0.7180829|       -0.2995459|        0.1430042|       -0.3295515|                       -0.4883408|                               -0.3875232|                   -0.0676508|                       -0.6583559| WALKING\_UPSTAIRS   |
| 1812 |               0.2753817|              -0.0117183|              -0.1077695|                  0.9716878|                  0.0324377|                  0.0426253|                   0.0750916|                   0.0107086|                   0.0090944|      -0.0212903|      -0.0719921|       0.1286988|          -0.0948754|          -0.0375677|          -0.0504065|                      -0.9923385|                         -0.9923385|                          -0.9893645|              -0.9816578|                  -0.9944435|              -0.9976614|              -0.9847317|              -0.9835216|                  -0.9963653|                  -0.9840070|                  -0.9835213|      -0.9959746|      -0.9925782|      -0.9856753|                      -0.9897262|                              -0.9919611|                  -0.9902810|                      -0.9946451|               -0.9983349|               -0.9883546|               -0.9848191|                  -0.9987123|                  -0.9899134|                  -0.9867391|                   -0.9963519|                   -0.9844583|                   -0.9866627|       -0.9965633|       -0.9929634|       -0.9878910|           -0.9979831|           -0.9937930|           -0.9883652|                       -0.9915104|                          -0.9915104|                           -0.9926166|               -0.9890438|                   -0.9941920|               -0.9986920|               -0.9902834|               -0.9860446|                   -0.9966502|                   -0.9861922|                   -0.9885855|       -0.9966844|       -0.9931874|       -0.9897666|                       -0.9933331|                               -0.9922984|                   -0.9898086|                       -0.9935218| SITTING             |
| 3388 |               0.2014525|              -0.0018535|              -0.0978237|                  0.9650309|                 -0.1953691|                  0.0050768|                   0.2227785|                   0.4934546|                   0.6180554|      -0.0383791|       0.0689081|       0.0864299|          -0.1490693|           0.0651445|           0.1703516|                      -0.1023518|                         -0.1023518|                          -0.2134786|              -0.2686303|                  -0.2358814|              -0.3092796|               0.1533817|              -0.0931926|                  -0.3287154|                   0.0271605|                  -0.2771182|      -0.2495057|      -0.1446811|      -0.3076421|                      -0.1336396|                              -0.0270099|                  -0.1552074|                      -0.1005531|               -0.3101708|                0.0855670|                0.0036746|                  -0.9792305|                  -0.9648589|                  -0.9359428|                   -0.3102988|                    0.0595820|                   -0.2703007|       -0.4349007|       -0.2041228|       -0.4097659|           -0.0596867|           -0.1492048|           -0.3828846|                       -0.1864813|                          -0.1864813|                            0.0061809|               -0.1743482|                   -0.0526157|               -0.3104483|               -0.0217556|               -0.0222125|                   -0.3524885|                    0.0228658|                   -0.2630852|       -0.4940823|       -0.2488602|       -0.5013086|                       -0.3441828|                                0.0436575|                   -0.3349379|                       -0.0565752| WALKING             |
| 1327 |               0.2489884|              -0.0544847|              -0.0944294|                  0.9203518|                 -0.3073838|                  0.0924766|                   0.2528133|                  -0.1765338|                   0.0981977|      -0.3163658|       0.0576822|      -0.0328792|           0.1566470|          -0.5317572|          -0.0834874|                       0.0843360|                          0.0843360|                          -0.1456746|               0.3257489|                  -0.3035051|              -0.1904563|               0.5040503|              -0.3132593|                  -0.3940445|                   0.1985126|                  -0.4565842|       0.1790797|      -0.0553450|       0.3249236|                       0.1237948|                              -0.0874203|                   0.0726363|                      -0.3225287|               -0.0699876|                0.5945063|               -0.2986395|                  -0.8980568|                  -0.8649245|                  -0.9556897|                   -0.3197458|                    0.3437091|                   -0.4478459|        0.2116700|       -0.0342687|        0.2082947|           -0.2024597|           -0.4031385|            0.0743387|                        0.1250094|                           0.1250094|                           -0.0198592|                0.2443429|                   -0.2619004|               -0.0265258|                0.5400519|               -0.3465873|                   -0.3037865|                    0.4126803|                   -0.4387969|        0.2043929|       -0.0282010|        0.0570141|                       -0.0494284|                                0.0601567|                    0.1461596|                       -0.2363387| WALKING\_DOWNSTAIRS |
| 1988 |               0.2854892|              -0.0245759|              -0.1407388|                  0.9633119|                 -0.0732867|                  0.1518212|                   0.0725478|                   0.0131527|                  -0.0050231|      -0.0643829|      -0.0900606|       0.0716028|          -0.0760970|          -0.0316490|          -0.0365232|                      -0.9612810|                         -0.9612810|                          -0.9698204|              -0.9125463|                  -0.9755456|              -0.9820816|              -0.9399298|              -0.9806668|                  -0.9737299|                  -0.9497069|                  -0.9789773|      -0.9206760|      -0.9698864|      -0.9443624|                      -0.9688901|                              -0.9675073|                  -0.9504332|                      -0.9789416|               -0.9862653|               -0.9364091|               -0.9838092|                  -0.9957976|                  -0.9755042|                  -0.9645545|                   -0.9700466|                   -0.9507608|                   -0.9812226|       -0.9142898|       -0.9642695|       -0.9358738|           -0.9604653|           -0.9845739|           -0.9713901|                       -0.9696316|                          -0.9696316|                           -0.9656954|               -0.9329163|                   -0.9801627|               -0.9883082|               -0.9375129|               -0.9865332|                   -0.9687234|                   -0.9557408|                   -0.9819199|       -0.9137400|       -0.9612730|       -0.9389043|                       -0.9737145|                               -0.9618198|                   -0.9331880|                       -0.9829551| STANDING            |
| 733  |               0.2133831|               0.0095161|              -0.1329670|                  0.8487489|                  0.0718207|                 -0.3888863|                  -0.0029755|                  -0.1854872|                   0.3802198|      -0.4983933|      -0.1622106|       0.4104517|           0.1246656|           0.0789964|          -0.1327449|                      -0.1713456|                         -0.1713456|                          -0.3546365|               0.0408822|                  -0.6297863|              -0.2807332|              -0.4884504|              -0.2208918|                  -0.3504118|                  -0.6048092|                  -0.5291392|      -0.3675981|      -0.3324264|      -0.4424164|                      -0.1613058|                              -0.3343107|                  -0.5356389|                      -0.6683590|               -0.2086392|               -0.4835583|               -0.0194526|                  -0.9561148|                  -0.9428752|                  -0.8719860|                   -0.2284905|                   -0.6126283|                   -0.5684267|       -0.2874735|       -0.1707592|       -0.4288116|           -0.6558093|           -0.6359598|           -0.6324239|                       -0.1553832|                          -0.1553832|                           -0.3796033|               -0.4020536|                   -0.6828926|               -0.1818801|               -0.5130017|                0.0074233|                   -0.1766727|                   -0.6512555|                   -0.6055961|       -0.2787328|       -0.0907573|       -0.4765136|                       -0.2832004|                               -0.4462601|                   -0.4198725|                       -0.7263140| WALKING\_UPSTAIRS   |
