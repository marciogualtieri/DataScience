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

    ## [1] "fBodyAccJerk-bandsEnergy()-57,64" "fBodyBodyAccJerkMag-min()"       
    ## [3] "fBodyAccJerk-bandsEnergy()-25,48" "tBodyAcc-arCoeff()-Y,2"          
    ## [5] "tBodyAccJerk-mean()-X"            "fBodyGyro-std()-Y"

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

    ## [1] "tBodyAcc-arCoeff()-Y,2"       "tBodyGyro-arCoeff()-X,4"     
    ## [3] "tBodyGyro-arCoeff()-X,2"      "fBodyGyro-bandsEnergy()-1,16"
    ## [5] "tBodyGyro-mad()-Z"            "fBodyAcc-bandsEnergy()-17,24"

``` r
sample(mean_variables, 6)
```

    ## [1] "fBodyBodyAccJerkMag-mean()" "tBodyAcc-mean()-X"         
    ## [3] "tGravityAcc-mean()-Y"       "tGravityAccMag-mean()"     
    ## [5] "tBodyAccMag-mean()"         "tBodyGyro-mean()-Y"

``` r
sample(std_variables, 6)
```

    ## [1] "fBodyBodyAccJerkMag-std()"  "fBodyBodyGyroJerkMag-std()"
    ## [3] "fBodyAccMag-std()"          "tBodyAccMag-std()"         
    ## [5] "tBodyGyroJerk-std()-X"      "tBodyGyro-std()-Y"

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

    ## [1] "fBodyGyro-bandsEnergy()-25,32" "tBodyGyro-arCoeff()-X,2"      
    ## [3] "tBodyGyroJerk-mean()-X"        "fBodyGyro-bandsEnergy()-9,16" 
    ## [5] "tGravityAccMag-arCoeff()4"     "fBodyAccJerk-skewness()-X"

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

    ##      tBodyAccelerationMeanX tBodyAccelerationMeanY tBodyAccelerationMeanZ
    ## 643               0.2922747           -0.022419970            -0.13985486
    ## 502               0.2661967           -0.014443952            -0.07534266
    ## 2392              0.2757282            0.009255694            -0.06003432
    ## 316               0.2826089           -0.018082290            -0.12286608
    ## 1570              0.2750864           -0.011080783            -0.10919569
    ## 2455              0.2746165           -0.005498583            -0.14048385
    ##      tGravityAccelerationMeanX tGravityAccelerationMeanY
    ## 643                  0.9492167                0.02329042
    ## 502                  0.7006348                0.52780049
    ## 2392                 0.7057469               -0.48931308
    ## 316                  0.9446780               -0.06368147
    ## 1570                 0.9700054               -0.08835319
    ## 2455                 0.9754913               -0.06956794
    ##      tGravityAccelerationMeanZ tBodyAccelerationJerkMeanX
    ## 643                 0.18334071                 0.08022931
    ## 502                 0.07144835                 0.06984728
    ## 2392               -0.36101116                 0.21406047
    ## 316                 0.22492254                 0.07785334
    ## 1570               -0.11673501                 0.07697329
    ## 2455               -0.04691056                 0.07632550
    ##      tBodyAccelerationJerkMeanY tBodyAccelerationJerkMeanZ tBodyGyroMeanX
    ## 643                 0.022547222               -0.036365915    -0.03019858
    ## 502                -0.010732837               -0.008335485    -0.03077582
    ## 2392               -0.328643070               -0.145717000    -0.33409747
    ## 316                 0.021017607               -0.010612153    -0.01291836
    ## 1570                0.007399689               -0.009145436    -0.02811472
    ## 2455                0.027818479               -0.002863821    -0.03110392
    ##      tBodyGyroMeanY tBodyGyroMeanZ tBodyGyroJerkMeanX tBodyGyroJerkMeanY
    ## 643     -0.13150658     0.12624070        -0.09013967        -0.03743406
    ## 502     -0.07043389     0.08626989        -0.10355708        -0.05300087
    ## 2392     0.26675762     0.48291389        -0.01594827        -0.09270031
    ## 316     -0.07788912     0.08610416        -0.09270223        -0.03949975
    ## 1570    -0.08059085     0.08690124        -0.09854283        -0.03994750
    ## 2455    -0.09544394     0.06984640        -0.09781114        -0.04515042
    ##      tBodyGyroJerkMeanZ tBodyAccelerationMagnitudeMean
    ## 643         -0.05662488                    -0.95728176
    ## 502         -0.05261822                    -0.94511288
    ## 2392        -0.07903784                    -0.02339976
    ## 316         -0.05187419                    -0.97327856
    ## 1570        -0.05286713                    -0.99104171
    ## 2455        -0.04363400                    -0.96022656
    ##      tGravityAccelerationMagnitudeMean tBodyAccelerationJerkMagnitudeMean
    ## 643                        -0.95728176                         -0.9734527
    ## 502                        -0.94511288                         -0.9471936
    ## 2392                       -0.02339976                         -0.3145480
    ## 316                        -0.97327856                         -0.9864494
    ## 1570                       -0.99104171                         -0.9916281
    ## 2455                       -0.96022656                         -0.9889497
    ##      tBodyGyroMagnitudeMean tBodyGyroJerkMagnitudeMean
    ## 643             -0.95671999                 -0.9790006
    ## 502             -0.94779711                 -0.9604143
    ## 2392            -0.04982267                 -0.3968820
    ## 316             -0.95807872                 -0.9903647
    ## 1570            -0.99253039                 -0.9954932
    ## 2455            -0.96728575                 -0.9888291
    ##      fBodyAccelerationMeanX fBodyAccelerationMeanY fBodyAccelerationMeanZ
    ## 643              -0.9810646             -0.9626271             -0.9487815
    ## 502              -0.9658391             -0.8928477             -0.9650333
    ## 2392             -0.1867278             -0.1239194             -0.3405561
    ## 316              -0.9929321             -0.9704171             -0.9751279
    ## 1570             -0.9967035             -0.9894917             -0.9831493
    ## 2455             -0.9937316             -0.9708721             -0.9651682
    ##      fBodyAccelerationJerkMeanX fBodyAccelerationJerkMeanY
    ## 643                  -0.9768373                 -0.9778694
    ## 502                  -0.9601074                 -0.9107578
    ## 2392                 -0.2592148                 -0.3538802
    ## 316                  -0.9917808                 -0.9771750
    ## 1570                 -0.9951972                 -0.9899440
    ## 2455                 -0.9930095                 -0.9821591
    ##      fBodyAccelerationJerkMeanZ fBodyGyroMeanX fBodyGyroMeanY
    ## 643                  -0.9623037     -0.9640632     -0.9691981
    ## 502                  -0.9629780     -0.9577439     -0.9538075
    ## 2392                 -0.4787913     -0.4192027     -0.1711724
    ## 316                  -0.9833329     -0.9686732     -0.9806921
    ## 1570                 -0.9857085     -0.9941290     -0.9917109
    ## 2455                 -0.9833913     -0.9819965     -0.9696179
    ##      fBodyGyroMeanZ fBodyAccelerationMagnitudeMean
    ## 643     -0.97684887                     -0.9607954
    ## 502     -0.89836272                     -0.9410331
    ## 2392     0.00429621                     -0.2302734
    ## 316     -0.97998917                     -0.9824883
    ## 1570    -0.99207003                     -0.9915450
    ## 2455    -0.97836922                     -0.9721531
    ##      fBodyBodyAccelerationJerkMagnitudeMean fBodyBodyGyroMagnitudeMean
    ## 643                              -0.9715948                 -0.9687779
    ## 502                              -0.9413418                 -0.9355646
    ## 2392                             -0.2184065                 -0.3262143
    ## 316                              -0.9865838                 -0.9757536
    ## 1570                             -0.9910517                 -0.9937989
    ## 2455                             -0.9902067                 -0.9691553
    ##      fBodyBodyGyroJerkMagnitudeMean tBodyAccelerationSigmaX
    ## 643                      -0.9773761             -0.98517645
    ## 502                      -0.9604496             -0.97416506
    ## 2392                     -0.4429420             -0.09895631
    ## 316                      -0.9908316             -0.99428651
    ## 1570                     -0.9958329             -0.99764341
    ## 2455                     -0.9897130             -0.99500738
    ##      tBodyAccelerationSigmaY tBodyAccelerationSigmaZ
    ## 643              -0.94290182              -0.9508372
    ## 502              -0.89833168              -0.9701421
    ## 2392             -0.03518488              -0.2223062
    ## 316              -0.96604286              -0.9537551
    ## 1570             -0.98924996              -0.9832088
    ## 2455             -0.96986057              -0.9332168
    ##      tGravityAccelerationSigmaX tGravityAccelerationSigmaY
    ## 643                  -0.9857101                 -0.9682512
    ## 502                  -0.9817646                 -0.9845365
    ## 2392                 -0.9706426                 -0.9632359
    ## 316                  -0.9954251                 -0.9902532
    ## 1570                 -0.9984302                 -0.9870286
    ## 2455                 -0.9978042                 -0.9796301
    ##      tGravityAccelerationSigmaZ tBodyAccelerationJerkSigmaX
    ## 643                  -0.9482341                  -0.9757357
    ## 502                  -0.9507689                  -0.9634137
    ## 2392                 -0.9618424                  -0.2332078
    ## 316                  -0.9811031                  -0.9921770
    ## 1570                 -0.9901231                  -0.9954361
    ## 2455                 -0.9341850                  -0.9933036
    ##      tBodyAccelerationJerkSigmaY tBodyAccelerationJerkSigmaZ
    ## 643                   -0.9787201                  -0.9690650
    ## 502                   -0.9078451                  -0.9676320
    ## 2392                  -0.3343337                  -0.5206112
    ## 316                   -0.9783589                  -0.9846603
    ## 1570                  -0.9912574                  -0.9871246
    ## 2455                  -0.9837449                  -0.9872755
    ##      tBodyGyroSigmaX tBodyGyroSigmaY tBodyGyroSigmaZ tBodyGyroJerkSigmaX
    ## 643       -0.9743299      -0.9673021      -0.9764172          -0.9691987
    ## 502       -0.9705309      -0.9495946      -0.9034052          -0.9557048
    ## 2392      -0.5553825      -0.1577849       0.0987965          -0.4521338
    ## 316       -0.9570634      -0.9705397      -0.9755002          -0.9865897
    ## 1570      -0.9956976      -0.9901028      -0.9925515          -0.9945525
    ## 2455      -0.9833508      -0.9548433      -0.9747611          -0.9896900
    ##      tBodyGyroJerkSigmaY tBodyGyroJerkSigmaZ
    ## 643           -0.9792619          -0.9858063
    ## 502           -0.9678127          -0.9298859
    ## 2392          -0.3978956          -0.3353758
    ## 316           -0.9910203          -0.9907530
    ## 1570          -0.9947635          -0.9947494
    ## 2455          -0.9868747          -0.9906899
    ##      tBodyAccelerationMagnitudeSigma tGravityAccelerationMagnitudeSigma
    ## 643                       -0.9610505                         -0.9610505
    ## 502                       -0.9487440                         -0.9487440
    ## 2392                      -0.2291069                         -0.2291069
    ## 316                       -0.9753497                         -0.9753497
    ## 1570                      -0.9922461                         -0.9922461
    ## 2455                      -0.9518985                         -0.9518985
    ##      tBodyAccelerationJerkMagnitudeSigma tBodyGyroMagnitudeSigma
    ## 643                           -0.9738224              -0.9679249
    ## 502                           -0.9462720              -0.9238707
    ## 2392                          -0.2547476              -0.2685027
    ## 316                           -0.9864660              -0.9592744
    ## 1570                          -0.9923163              -0.9926445
    ## 2455                          -0.9910630              -0.9547060
    ##      tBodyGyroJerkMagnitudeSigma fBodyAccelerationSigmaX
    ## 643                   -0.9785101             -0.98713631
    ## 502                   -0.9577183             -0.97829752
    ## 2392                  -0.4398378             -0.06656975
    ## 316                   -0.9923374             -0.99489624
    ## 1570                  -0.9960713             -0.99813940
    ## 2455                  -0.9896713             -0.99559464
    ##      fBodyAccelerationSigmaY fBodyAccelerationSigmaZ
    ## 643               -0.9368156              -0.9552882
    ## 502               -0.9068496              -0.9753830
    ## 2392              -0.0512094              -0.2200939
    ## 316               -0.9648684              -0.9459351
    ## 1570              -0.9886758              -0.9836835
    ## 2455              -0.9701163              -0.9225148
    ##      fBodyAccelerationJerkSigmaX fBodyAccelerationJerkSigmaY
    ## 643                   -0.9766247                  -0.9814269
    ## 502                   -0.9711622                  -0.9108423
    ## 2392                  -0.2739646                  -0.3582699
    ## 316                   -0.9933934                  -0.9815815
    ## 1570                  -0.9961555                  -0.9938715
    ## 2455                  -0.9942831                  -0.9872325
    ##      fBodyAccelerationJerkSigmaZ fBodyGyroSigmaX fBodyGyroSigmaY
    ## 643                   -0.9750137      -0.9776347      -0.9662910
    ## 502                   -0.9708874      -0.9747120      -0.9473774
    ## 2392                  -0.5601002      -0.5986877      -0.1555600
    ## 316                   -0.9843704      -0.9550610      -0.9656305
    ## 1570                  -0.9869651      -0.9961684      -0.9891273
    ## 2455                  -0.9902295      -0.9837601      -0.9477753
    ##      fBodyGyroSigmaZ fBodyAccelerationMagnitudeSigma
    ## 643      -0.97824963                      -0.9661335
    ## 502      -0.91380613                      -0.9608465
    ## 2392      0.02761251                      -0.3480471
    ## 316      -0.97612523                      -0.9741224
    ## 1570     -0.99329813                      -0.9930403
    ## 2455     -0.97571151                      -0.9487814
    ##      fBodyBodyAccelerationJerkMagnitudeSigma fBodyBodyGyroMagnitudeSigma
    ## 643                               -0.9757180                  -0.9727001
    ## 502                               -0.9522358                  -0.9288140
    ## 2392                              -0.3090358                  -0.3541289
    ## 316                               -0.9847494                  -0.9565418
    ## 1570                              -0.9931589                  -0.9928461
    ## 2455                              -0.9910643                  -0.9534369
    ##      fBodyBodyGyroJerkMagnitudeSigma ActivityID
    ## 643                       -0.9812886          4
    ## 502                       -0.9567497          4
    ## 2392                      -0.4746132          2
    ## 316                       -0.9952630          5
    ## 1570                      -0.9963488          4
    ## 2455                      -0.9899321          4

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

    ##      tBodyAccelerationMeanX tBodyAccelerationMeanY tBodyAccelerationMeanZ
    ## 1360             0.07103529            -0.01565618            -0.09426345
    ## 685              0.24087944            -0.05149986            -0.13256991
    ## 2937             0.28849576            -0.01660288            -0.11479092
    ## 2617             0.26705667            -0.01997890            -0.09987999
    ## 2151             0.27946201            -0.02580207            -0.12651279
    ## 1426             0.27566806            -0.01660373            -0.10490660
    ##      tGravityAccelerationMeanX tGravityAccelerationMeanY
    ## 1360                 0.9100274             -0.3463980900
    ## 685                  0.8526682             -0.3191547500
    ## 2937                -0.2564353              0.7473965100
    ## 2617                -0.1072815              0.4482545500
    ## 2151                 0.9655436             -0.1585127000
    ## 1426                 0.8932393              0.0009512439
    ##      tGravityAccelerationMeanZ tBodyAccelerationJerkMeanX
    ## 1360                0.01677825                 0.33037553
    ## 685                -0.29949063                -0.24184801
    ## 2937                0.66311286                 0.07113505
    ## 2617                0.86103815                 0.08504063
    ## 2151                0.09107682                 0.07351260
    ## 1426                0.34494749                 0.07410398
    ##      tBodyAccelerationJerkMeanY tBodyAccelerationJerkMeanZ tBodyGyroMeanX
    ## 1360               -0.136581290               -0.207749160     0.02086814
    ## 685                 0.128462200                0.342438670     0.11872590
    ## 2937                0.016184405               -0.004437981    -0.02762940
    ## 2617                0.013032851               -0.021768478    -0.02562457
    ## 2151                0.030136904                0.016137670    -0.03196181
    ## 1426                0.007731043                0.002213382    -0.02808716
    ##      tBodyGyroMeanY tBodyGyroMeanZ tBodyGyroJerkMeanX tBodyGyroJerkMeanY
    ## 1360    -0.19800124     0.12828895         0.11365886         0.09764690
    ## 685     -0.20763082     0.01265237         0.05557614         0.03070939
    ## 2937    -0.06972106     0.08645602        -0.09898477        -0.03347421
    ## 2617    -0.07981623     0.08231598        -0.08949872        -0.05145600
    ## 2151    -0.08835405     0.07056651        -0.09855652        -0.03356302
    ## 1426    -0.06685764     0.08218691        -0.10033989        -0.03872336
    ##      tBodyGyroJerkMeanZ tBodyAccelerationMagnitudeMean
    ## 1360         0.00508973                     -0.1576554
    ## 685         -0.29985592                     -0.2789236
    ## 2937        -0.05349545                     -0.9824439
    ## 2617        -0.05784321                     -0.9633218
    ## 2151        -0.06338640                     -0.9796911
    ## 1426        -0.05243510                     -0.9968115
    ##      tGravityAccelerationMagnitudeMean tBodyAccelerationJerkMagnitudeMean
    ## 1360                        -0.1576554                         -0.2558886
    ## 685                         -0.2789236                         -0.5878678
    ## 2937                        -0.9824439                         -0.9880591
    ## 2617                        -0.9633218                         -0.9884005
    ## 2151                        -0.9796911                         -0.9909059
    ## 1426                        -0.9968115                         -0.9919002
    ##      tBodyGyroMagnitudeMean tBodyGyroJerkMagnitudeMean
    ## 1360             -0.4013467                 -0.6638004
    ## 685              -0.3855475                 -0.7814152
    ## 2937             -0.9826654                 -0.9840703
    ## 2617             -0.9694414                 -0.9887338
    ## 2151             -0.9855775                 -0.9976663
    ## 1426             -0.9960410                 -0.9957803
    ##      fBodyAccelerationMeanX fBodyAccelerationMeanY fBodyAccelerationMeanZ
    ## 1360             -0.1585478             0.02340674             -0.4378183
    ## 685              -0.4049967            -0.29200336             -0.3992424
    ## 2937             -0.9842251            -0.98410926             -0.9871695
    ## 2617             -0.9803223            -0.97828066             -0.9759037
    ## 2151             -0.9968776            -0.97627503             -0.9767562
    ## 1426             -0.9961949            -0.98945861             -0.9902982
    ##      fBodyAccelerationJerkMeanX fBodyAccelerationJerkMeanY
    ## 1360                -0.08794246                 -0.1098598
    ## 685                 -0.56253852                 -0.5407505
    ## 2937                -0.98761601                 -0.9812232
    ## 2617                -0.98687239                 -0.9863535
    ## 2151                -0.99516329                 -0.9891874
    ## 1426                -0.99452025                 -0.9890186
    ##      fBodyAccelerationJerkMeanZ fBodyGyroMeanX fBodyGyroMeanY
    ## 1360                 -0.4886153     -0.4267173     -0.6075654
    ## 685                  -0.6691620     -0.5446705     -0.6537065
    ## 2937                 -0.9889417     -0.9859649     -0.9783602
    ## 2617                 -0.9851849     -0.9807056     -0.9741034
    ## 2151                 -0.9851040     -0.9896712     -0.9924877
    ## 1426                 -0.9880571     -0.9948641     -0.9929625
    ##      fBodyGyroMeanZ fBodyAccelerationMagnitudeMean
    ## 1360     -0.3301569                    0.001564421
    ## 685      -0.3744656                   -0.401943380
    ## 2937     -0.9948363                   -0.986583610
    ## 2617     -0.9923078                   -0.977549430
    ## 2151     -0.9888660                   -0.982597550
    ## 1426     -0.9955929                   -0.993005270
    ##      fBodyBodyAccelerationJerkMagnitudeMean fBodyBodyGyroMagnitudeMean
    ## 1360                            -0.02554353                 -0.6273039
    ## 685                             -0.52017792                 -0.6546136
    ## 2937                            -0.99055833                 -0.9829404
    ## 2617                            -0.98899424                 -0.9778939
    ## 2151                            -0.99154828                 -0.9907247
    ## 1426                            -0.99180529                 -0.9932755
    ##      fBodyBodyGyroJerkMagnitudeMean tBodyAccelerationSigmaX
    ## 1360                     -0.6906595              -0.2134244
    ## 685                      -0.8246425              -0.3944444
    ## 2937                     -0.9874496              -0.9793243
    ## 2617                     -0.9836295              -0.9723770
    ## 2151                     -0.9968634              -0.9980825
    ## 1426                     -0.9941162              -0.9972427
    ##      tBodyAccelerationSigmaY tBodyAccelerationSigmaZ
    ## 1360              0.06590692              -0.3796234
    ## 685              -0.18841746              -0.2568926
    ## 2937             -0.98757232              -0.9837625
    ## 2617             -0.95411434              -0.9552422
    ## 2151             -0.96803489              -0.9757512
    ## 1426             -0.99208412              -0.9916209
    ##      tGravityAccelerationSigmaX tGravityAccelerationSigmaY
    ## 1360                 -0.9101254                 -0.9497827
    ## 685                  -0.9744837                 -0.9566557
    ## 2937                 -0.9758150                 -0.9990863
    ## 2617                 -0.9756675                 -0.9822956
    ## 2151                 -0.9976895                 -0.9695286
    ## 1426                 -0.9976562                 -0.9980114
    ##      tGravityAccelerationSigmaZ tBodyAccelerationJerkSigmaX
    ## 1360                 -0.9385759                  -0.1620789
    ## 685                  -0.9448582                  -0.5590313
    ## 2937                 -0.9832412                  -0.9877402
    ## 2617                 -0.9719629                  -0.9879509
    ## 2151                 -0.9605465                  -0.9951334
    ## 1426                 -0.9972523                  -0.9944044
    ##      tBodyAccelerationJerkSigmaY tBodyAccelerationJerkSigmaZ
    ## 1360                 -0.07004678                  -0.5631303
    ## 685                  -0.53803245                  -0.7126126
    ## 2937                 -0.98261054                  -0.9910455
    ## 2617                 -0.98720860                  -0.9871647
    ## 2151                 -0.99007568                  -0.9871915
    ## 1426                 -0.98799731                  -0.9895355
    ##      tBodyGyroSigmaX tBodyGyroSigmaY tBodyGyroSigmaZ tBodyGyroJerkSigmaX
    ## 1360      -0.5081751      -0.5699593      -0.3932082          -0.5917730
    ## 685       -0.5190363      -0.5731619      -0.3179742          -0.7954450
    ## 2937      -0.9904639      -0.9753136      -0.9962233          -0.9796855
    ## 2617      -0.9769611      -0.9644328      -0.9877032          -0.9903379
    ## 2151      -0.9871941      -0.9898209      -0.9902349          -0.9948584
    ## 1426      -0.9965550      -0.9936207      -0.9970854          -0.9953690
    ##      tBodyGyroJerkSigmaY tBodyGyroJerkSigmaZ
    ## 1360          -0.7502038          -0.5050846
    ## 685           -0.8052139          -0.7292374
    ## 2937          -0.9841715          -0.9944863
    ## 2617          -0.9816974          -0.9970501
    ## 2151          -0.9981541          -0.9948445
    ## 1426          -0.9938457          -0.9940041
    ##      tBodyAccelerationMagnitudeSigma tGravityAccelerationMagnitudeSigma
    ## 1360                     -0.08018111                        -0.08018111
    ## 685                      -0.34177501                        -0.34177501
    ## 2937                     -0.98540954                        -0.98540954
    ## 2617                     -0.97006386                        -0.97006386
    ## 2151                     -0.97490208                        -0.97490208
    ## 1426                     -0.99457907                        -0.99457907
    ##      tBodyAccelerationJerkMagnitudeSigma tBodyGyroMagnitudeSigma
    ## 1360                         -0.07730187              -0.5999560
    ## 685                          -0.53957182              -0.5326638
    ## 2937                         -0.99165581              -0.9831249
    ## 2617                         -0.98869826              -0.9728821
    ## 2151                         -0.99324718              -0.9858090
    ## 1426                         -0.99226209              -0.9926260
    ##      tBodyGyroJerkMagnitudeSigma fBodyAccelerationSigmaX
    ## 1360                  -0.7041897              -0.2360934
    ## 685                   -0.8279397              -0.3902086
    ## 2937                  -0.9889891              -0.9773021
    ## 2617                  -0.9813752              -0.9693641
    ## 2151                  -0.9969348              -0.9988037
    ## 1426                  -0.9937535              -0.9977879
    ##      fBodyAccelerationSigmaY fBodyAccelerationSigmaZ
    ## 1360              0.02082441              -0.3961082
    ## 685              -0.18845911              -0.2408057
    ## 2937             -0.98942301              -0.9820166
    ## 2617             -0.94639727              -0.9476153
    ## 2151             -0.96505890              -0.9761297
    ## 1426             -0.99311506              -0.9923541
    ##      fBodyAccelerationJerkSigmaX fBodyAccelerationJerkSigmaY
    ## 1360                  -0.3368990                 -0.08864286
    ## 685                   -0.5954247                 -0.56820618
    ## 2937                  -0.9889910                 -0.98585953
    ## 2617                  -0.9904861                 -0.98934519
    ## 2151                  -0.9955183                 -0.99207393
    ## 1426                  -0.9947447                 -0.98752553
    ##      fBodyAccelerationJerkSigmaZ fBodyGyroSigmaX fBodyGyroSigmaY
    ## 1360                  -0.6412226      -0.5349031      -0.5512142
    ## 685                   -0.7565192      -0.5190129      -0.5330914
    ## 2937                  -0.9917965      -0.9919474      -0.9736207
    ## 2617                  -0.9876574      -0.9762444      -0.9595866
    ## 2151                  -0.9878162      -0.9866254      -0.9883155
    ## 1426                  -0.9894857      -0.9971108      -0.9940453
    ##      fBodyGyroSigmaZ fBodyAccelerationMagnitudeSigma
    ## 1360      -0.4707988                      -0.2727250
    ## 685       -0.3626616                      -0.4121456
    ## 2937      -0.9971554                      -0.9858340
    ## 2617      -0.9872162                      -0.9694776
    ## 2151      -0.9915497                      -0.9734827
    ## 1426      -0.9980509                      -0.9959191
    ##      fBodyBodyAccelerationJerkMagnitudeSigma fBodyBodyGyroMagnitudeSigma
    ## 1360                              -0.1535822                  -0.6496027
    ## 685                               -0.5678743                  -0.5375040
    ## 2937                              -0.9921421                  -0.9860755
    ## 2617                              -0.9867485                  -0.9739006
    ## 2151                              -0.9951063                  -0.9848708
    ## 1426                              -0.9915801                  -0.9932208
    ##      fBodyBodyGyroJerkMagnitudeSigma      ActivityLabel
    ## 1360                      -0.7441943 WALKING_DOWNSTAIRS
    ## 685                       -0.8444878   WALKING_UPSTAIRS
    ## 2937                      -0.9920103             LAYING
    ## 2617                      -0.9793556             LAYING
    ## 2151                      -0.9968804           STANDING
    ## 1426                      -0.9932152            SITTING

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

    ##      tBodyAccelerationMeanX tBodyAccelerationMeanY tBodyAccelerationMeanZ
    ## 100               0.1546883          -0.0320367760            -0.05229587
    ## 163               0.3175705          -0.0472429560            -0.14655123
    ## 1952              0.2382692           0.0001239682            -0.09375162
    ## 858               0.2685001          -0.0033435583            -0.15329391
    ## 3374              0.2751846          -0.0147078520            -0.11523448
    ## 7042              0.1778633          -0.0897141380            -0.04913649
    ##      tGravityAccelerationMeanX tGravityAccelerationMeanY
    ## 100                  0.9411408                -0.2065985
    ## 163                  0.9550427                -0.1426577
    ## 1952                 0.8767053                -0.3875496
    ## 858                  0.9477647                -0.2330878
    ## 3374                 0.8880575                 0.1774774
    ## 7042                -0.5831844                 0.4775424
    ##      tGravityAccelerationMeanZ tBodyAccelerationJerkMeanX
    ## 100                 0.17058379                -0.03608885
    ## 163                 0.09754280                -0.39756674
    ## 1952               -0.08353627                 0.13215298
    ## 858                -0.09411400                 0.17864597
    ## 3374                0.28803309                 0.07911912
    ## 7042                0.90029586                 0.04694570
    ##      tBodyAccelerationJerkMeanY tBodyAccelerationJerkMeanZ tBodyGyroMeanX
    ## 100                 0.213074890                 0.11252004   -0.404601750
    ## 163                 0.040320108                -0.08296367    0.014890473
    ## 1952                0.396098500                -0.01969352   -0.193617880
    ## 858                 0.231257640                 0.10181481    0.019920051
    ## 3374                0.009765922                -0.01004399   -0.016146828
    ## 7042                0.195404180                -0.05171220   -0.009808616
    ##      tBodyGyroMeanY tBodyGyroMeanZ tBodyGyroJerkMeanX tBodyGyroJerkMeanY
    ## 100      0.13830041    -0.14148904       -0.002105339       -0.350394680
    ## 163     -0.07695203     0.06236206        0.030851694       -0.170507530
    ## 1952     0.15668429     0.12812349       -0.121212250       -0.226204560
    ## 858     -0.12494199     0.07396422       -0.249597490        0.005536719
    ## 3374    -0.08686583     0.12386736       -0.098032580       -0.039749598
    ## 7042    -0.02785436     0.03036810       -0.169952690       -0.030502027
    ##      tBodyGyroJerkMeanZ tBodyAccelerationMagnitudeMean
    ## 100          0.07496611                     -0.2945801
    ## 163         -0.30314550                     -0.1235004
    ## 1952         0.04948070                     -0.1261997
    ## 858          0.06116850                     -0.3165991
    ## 3374        -0.05515650                     -0.9952981
    ## 7042        -0.09482310                     -0.7858511
    ##      tGravityAccelerationMagnitudeMean tBodyAccelerationJerkMagnitudeMean
    ## 100                         -0.2945801                         -0.4303724
    ## 163                         -0.1235004                         -0.2154265
    ## 1952                        -0.1261997                         -0.4488786
    ## 858                         -0.3165991                         -0.4067794
    ## 3374                        -0.9952981                         -0.9934387
    ## 7042                        -0.7858511                         -0.8811937
    ##      tBodyGyroMagnitudeMean tBodyGyroJerkMagnitudeMean
    ## 100              -0.3596552                 -0.6566210
    ## 163              -0.3488278                 -0.4957281
    ## 1952             -0.2047305                 -0.6096989
    ## 858              -0.4496520                 -0.5992157
    ## 3374             -0.9804093                 -0.9973816
    ## 7042             -0.7826661                 -0.8853686
    ##      fBodyAccelerationMeanX fBodyAccelerationMeanY fBodyAccelerationMeanZ
    ## 100              -0.3724413            -0.12137405             -0.5719793
    ## 163              -0.1734514            -0.04956753             -0.2963205
    ## 1952             -0.3939461            -0.17579039             -0.4865685
    ## 858              -0.4980303            -0.07191988             -0.4777980
    ## 3374             -0.9970740            -0.98709707             -0.9933632
    ## 7042             -0.8615093            -0.64973815             -0.8679142
    ##      fBodyAccelerationJerkMeanX fBodyAccelerationJerkMeanY
    ## 100                  -0.4430764                 -0.2865960
    ## 163                  -0.2393274                 -0.1826306
    ## 1952                 -0.4521897                 -0.4290299
    ## 858                  -0.5195134                 -0.2309603
    ## 3374                 -0.9965977                 -0.9864559
    ## 7042                 -0.8752896                 -0.8406179
    ##      fBodyAccelerationJerkMeanZ fBodyGyroMeanX fBodyGyroMeanY
    ## 100                  -0.6792302     -0.5867620     -0.5463189
    ## 163                  -0.3219345     -0.3170312     -0.5823871
    ## 1952                 -0.7269261     -0.5471395     -0.4012328
    ## 858                  -0.6000857     -0.4339798     -0.6170651
    ## 3374                 -0.9927906     -0.9951356     -0.9950350
    ## 7042                 -0.8979482     -0.7807196     -0.7878162
    ##      fBodyGyroMeanZ fBodyAccelerationMagnitudeMean
    ## 100      -0.3964855                     -0.4277965
    ## 163      -0.1570053                     -0.3387536
    ## 1952     -0.5085232                     -0.3508924
    ## 858      -0.3991909                     -0.4639919
    ## 3374     -0.9911814                     -0.9964184
    ## 7042     -0.8095356                     -0.7518935
    ##      fBodyBodyAccelerationJerkMagnitudeMean fBodyBodyGyroMagnitudeMean
    ## 100                              -0.4085509                 -0.5903921
    ## 163                              -0.1639943                 -0.5051902
    ## 1952                             -0.4073478                 -0.3765722
    ## 858                              -0.4962922                 -0.5836092
    ## 3374                             -0.9960747                 -0.9945211
    ## 7042                             -0.8562910                 -0.7840193
    ##      fBodyBodyGyroJerkMagnitudeMean tBodyAccelerationSigmaX
    ## 100                      -0.7513199              -0.4232460
    ## 163                      -0.6118672              -0.2433398
    ## 1952                     -0.6377606              -0.3342548
    ## 858                      -0.6740281              -0.4771622
    ## 3374                     -0.9980560              -0.9976497
    ## 7042                     -0.8584400              -0.8775198
    ##      tBodyAccelerationSigmaY tBodyAccelerationSigmaZ
    ## 100              -0.11063208             -0.46405450
    ## 163              -0.05625287             -0.28808235
    ## 1952             -0.05086474             -0.02182232
    ## 858              -0.10774600             -0.39525778
    ## 3374             -0.98993505             -0.99439829
    ## 7042             -0.63835369             -0.86815556
    ##      tGravityAccelerationSigmaX tGravityAccelerationSigmaY
    ## 100                  -0.9506757                 -0.9284288
    ## 163                  -0.9712239                 -0.9773512
    ## 1952                 -0.9617605                 -0.9373879
    ## 858                  -0.9913940                 -0.9821161
    ## 3374                 -0.9978866                 -0.9964958
    ## 7042                 -0.9070794                 -0.7772419
    ##      tGravityAccelerationSigmaZ tBodyAccelerationJerkSigmaX
    ## 100                  -0.9008164                  -0.4470810
    ## 163                  -0.9474641                  -0.2449172
    ## 1952                 -0.9277859                  -0.3929702
    ## 858                  -0.9427330                  -0.5086147
    ## 3374                 -0.9926251                  -0.9965672
    ## 7042                 -0.8566871                  -0.8678763
    ##      tBodyAccelerationJerkSigmaY tBodyAccelerationJerkSigmaZ
    ## 100                   -0.2228283                  -0.7130126
    ## 163                   -0.2056220                  -0.3536105
    ## 1952                  -0.3766617                  -0.7266330
    ## 858                   -0.1810970                  -0.6303697
    ## 3374                  -0.9858701                  -0.9938815
    ## 7042                  -0.8486719                  -0.9013256
    ##      tBodyGyroSigmaX tBodyGyroSigmaY tBodyGyroSigmaZ tBodyGyroJerkSigmaX
    ## 100       -0.6542319     -0.51862617      -0.4762295          -0.5709928
    ## 163       -0.4347368     -0.58982779      -0.2549379          -0.4267351
    ## 1952      -0.6021345     -0.02463892      -0.5935024          -0.5964749
    ## 858       -0.5526762     -0.57330772      -0.4001609          -0.4093785
    ## 3374      -0.9961747     -0.99322110      -0.9899442          -0.9958593
    ## 7042      -0.8008866     -0.79486591      -0.7729818          -0.8818983
    ##      tBodyGyroJerkSigmaY tBodyGyroJerkSigmaZ
    ## 100           -0.7446723          -0.5868094
    ## 163           -0.6038488          -0.3882128
    ## 1952          -0.6272668          -0.6068848
    ## 858           -0.6895942          -0.5626104
    ## 3374          -0.9974324          -0.9957629
    ## 7042          -0.8575381          -0.9157416
    ##      tBodyAccelerationMagnitudeSigma tGravityAccelerationMagnitudeSigma
    ## 100                       -0.4698735                         -0.4698735
    ## 163                       -0.3937437                         -0.3937437
    ## 1952                      -0.3551745                         -0.3551745
    ## 858                       -0.4886306                         -0.4886306
    ## 3374                      -0.9972679                         -0.9972679
    ## 7042                      -0.7274355                         -0.7274355
    ##      tBodyAccelerationJerkMagnitudeSigma tBodyGyroMagnitudeSigma
    ## 100                           -0.4094498              -0.4886783
    ## 163                           -0.2298062              -0.4950624
    ## 1952                          -0.4386743              -0.2516760
    ## 858                           -0.4489546              -0.5428992
    ## 3374                          -0.9959656              -0.9910634
    ## 7042                          -0.8356269              -0.7148361
    ##      tBodyGyroJerkMagnitudeSigma fBodyAccelerationSigmaX
    ## 100                   -0.7471914              -0.4444643
    ## 163                   -0.6391705              -0.2726388
    ## 1952                  -0.6590225              -0.3120325
    ## 858                   -0.6193778              -0.4690354
    ## 3374                  -0.9982220              -0.9979072
    ## 7042                  -0.8478548              -0.8843465
    ##      fBodyAccelerationSigmaY fBodyAccelerationSigmaZ
    ## 100              -0.16092766             -0.44963273
    ## 163              -0.11951089             -0.34079214
    ## 1952             -0.04938267              0.09885004
    ## 858              -0.18408739             -0.39788912
    ## 3374             -0.99122486             -0.99470669
    ## 7042             -0.65440998             -0.87820099
    ##      fBodyAccelerationJerkSigmaX fBodyAccelerationJerkSigmaY
    ## 100                   -0.5026593                  -0.2040523
    ## 163                   -0.3209703                  -0.2943950
    ## 1952                  -0.3854462                  -0.3602425
    ## 858                   -0.5411618                  -0.1804393
    ## 3374                  -0.9968235                  -0.9860996
    ## 7042                  -0.8716389                  -0.8708733
    ##      fBodyAccelerationJerkSigmaZ fBodyGyroSigmaX fBodyGyroSigmaY
    ## 100                   -0.7456321      -0.6759302      -0.5055452
    ## 163                   -0.3821795      -0.4724521      -0.5973475
    ## 1952                  -0.7248135      -0.6207276       0.1412352
    ## 858                   -0.6583887      -0.5903133      -0.5512894
    ## 3374                  -0.9934640      -0.9964534      -0.9921363
    ## 7042                  -0.9028348      -0.8081524      -0.8007374
    ##      fBodyGyroSigmaZ fBodyAccelerationMagnitudeSigma
    ## 100       -0.5530485                      -0.5770034
    ## 163       -0.3580903                      -0.5210368
    ## 1952      -0.6627743                      -0.4573988
    ## 858       -0.4552026                      -0.5820397
    ## 3374      -0.9902642                      -0.9976186
    ## 7042      -0.7827070                      -0.7558352
    ##      fBodyBodyAccelerationJerkMagnitudeSigma fBodyBodyGyroMagnitudeSigma
    ## 100                               -0.4139197                  -0.5105734
    ## 163                               -0.3281798                  -0.5756999
    ## 1952                              -0.4841261                  -0.2975895
    ## 858                               -0.3941995                  -0.5931575
    ## 3374                              -0.9942541                  -0.9901128
    ## 7042                              -0.8114423                  -0.7202379
    ##      fBodyBodyGyroJerkMagnitudeSigma    ActivityLabel
    ## 100                       -0.7589872          WALKING
    ## 163                       -0.7059109          WALKING
    ## 1952                      -0.7137743 WALKING_UPSTAIRS
    ## 858                       -0.5824309          WALKING
    ## 3374                      -0.9982649          SITTING
    ## 7042                      -0.8448990           LAYING

``` r
all_data <- rbind(test_data, train_data)
dim(all_data)
```

    ## [1] 10299    67

``` r
activity_averages_data <- all_data %>% group_by(ActivityLabel) %>% summarise_each(funs(mean))
activity_averages_data
```

    ## # A tibble: 6 × 67
    ##        ActivityLabel tBodyAccelerationMeanX tBodyAccelerationMeanY
    ##               <fctr>                  <dbl>                  <dbl>
    ## 1             LAYING              0.2686486            -0.01831773
    ## 2            SITTING              0.2730596            -0.01268957
    ## 3           STANDING              0.2791535            -0.01615189
    ## 4            WALKING              0.2763369            -0.01790683
    ## 5 WALKING_DOWNSTAIRS              0.2881372            -0.01631193
    ## 6   WALKING_UPSTAIRS              0.2622946            -0.02592329
    ## # ... with 64 more variables: tBodyAccelerationMeanZ <dbl>,
    ## #   tGravityAccelerationMeanX <dbl>, tGravityAccelerationMeanY <dbl>,
    ## #   tGravityAccelerationMeanZ <dbl>, tBodyAccelerationJerkMeanX <dbl>,
    ## #   tBodyAccelerationJerkMeanY <dbl>, tBodyAccelerationJerkMeanZ <dbl>,
    ## #   tBodyGyroMeanX <dbl>, tBodyGyroMeanY <dbl>, tBodyGyroMeanZ <dbl>,
    ## #   tBodyGyroJerkMeanX <dbl>, tBodyGyroJerkMeanY <dbl>,
    ## #   tBodyGyroJerkMeanZ <dbl>, tBodyAccelerationMagnitudeMean <dbl>,
    ## #   tGravityAccelerationMagnitudeMean <dbl>,
    ## #   tBodyAccelerationJerkMagnitudeMean <dbl>,
    ## #   tBodyGyroMagnitudeMean <dbl>, tBodyGyroJerkMagnitudeMean <dbl>,
    ## #   fBodyAccelerationMeanX <dbl>, fBodyAccelerationMeanY <dbl>,
    ## #   fBodyAccelerationMeanZ <dbl>, fBodyAccelerationJerkMeanX <dbl>,
    ## #   fBodyAccelerationJerkMeanY <dbl>, fBodyAccelerationJerkMeanZ <dbl>,
    ## #   fBodyGyroMeanX <dbl>, fBodyGyroMeanY <dbl>, fBodyGyroMeanZ <dbl>,
    ## #   fBodyAccelerationMagnitudeMean <dbl>,
    ## #   fBodyBodyAccelerationJerkMagnitudeMean <dbl>,
    ## #   fBodyBodyGyroMagnitudeMean <dbl>,
    ## #   fBodyBodyGyroJerkMagnitudeMean <dbl>, tBodyAccelerationSigmaX <dbl>,
    ## #   tBodyAccelerationSigmaY <dbl>, tBodyAccelerationSigmaZ <dbl>,
    ## #   tGravityAccelerationSigmaX <dbl>, tGravityAccelerationSigmaY <dbl>,
    ## #   tGravityAccelerationSigmaZ <dbl>, tBodyAccelerationJerkSigmaX <dbl>,
    ## #   tBodyAccelerationJerkSigmaY <dbl>, tBodyAccelerationJerkSigmaZ <dbl>,
    ## #   tBodyGyroSigmaX <dbl>, tBodyGyroSigmaY <dbl>, tBodyGyroSigmaZ <dbl>,
    ## #   tBodyGyroJerkSigmaX <dbl>, tBodyGyroJerkSigmaY <dbl>,
    ## #   tBodyGyroJerkSigmaZ <dbl>, tBodyAccelerationMagnitudeSigma <dbl>,
    ## #   tGravityAccelerationMagnitudeSigma <dbl>,
    ## #   tBodyAccelerationJerkMagnitudeSigma <dbl>,
    ## #   tBodyGyroMagnitudeSigma <dbl>, tBodyGyroJerkMagnitudeSigma <dbl>,
    ## #   fBodyAccelerationSigmaX <dbl>, fBodyAccelerationSigmaY <dbl>,
    ## #   fBodyAccelerationSigmaZ <dbl>, fBodyAccelerationJerkSigmaX <dbl>,
    ## #   fBodyAccelerationJerkSigmaY <dbl>, fBodyAccelerationJerkSigmaZ <dbl>,
    ## #   fBodyGyroSigmaX <dbl>, fBodyGyroSigmaY <dbl>, fBodyGyroSigmaZ <dbl>,
    ## #   fBodyAccelerationMagnitudeSigma <dbl>,
    ## #   fBodyBodyAccelerationJerkMagnitudeSigma <dbl>,
    ## #   fBodyBodyGyroMagnitudeSigma <dbl>,
    ## #   fBodyBodyGyroJerkMagnitudeSigma <dbl>

``` r
sample_data_frame(all_data, 6)
```

    ##      tBodyAccelerationMeanX tBodyAccelerationMeanY tBodyAccelerationMeanZ
    ## 1392              0.2470322           -0.018727508            -0.09016628
    ## 1926              0.2837899           -0.001923844            -0.11793031
    ## 4556              0.2464297           -0.012349029            -0.14813915
    ## 7850              0.2807510           -0.016298394            -0.10413659
    ## 8735              0.2773111           -0.022700053            -0.11256009
    ## 2952              0.3141912           -0.008695973            -0.12456099
    ##      tGravityAccelerationMeanX tGravityAccelerationMeanY
    ## 1392                 0.4942534               -0.42109987
    ## 1926                 0.9646963                0.02857348
    ## 4556                 0.9612110               -0.21972450
    ## 7850                 0.9376325               -0.26979409
    ## 8735                 0.9755571               -0.10242390
    ## 2952                 0.8923025               -0.14698181
    ##      tGravityAccelerationMeanZ tBodyAccelerationJerkMeanX
    ## 1392              0.6631266300                 0.06645359
    ## 1926             -0.1036563800                 0.08797095
    ## 4556              0.0004278825                 0.36497926
    ## 7850              0.1009102100                 0.07836346
    ## 8735              0.0082320115                 0.07853193
    ## 2952             -0.3414188400                -0.22561772
    ##      tBodyAccelerationJerkMeanY tBodyAccelerationJerkMeanZ tBodyGyroMeanX
    ## 1392                 0.00893503                0.009924988    -0.02498161
    ## 1926                -0.05170076               -0.014469680    -0.04359348
    ## 4556                 0.31467202                0.090403217     0.26184795
    ## 7850                 0.01313397                0.018962359    -0.02870365
    ## 8735                 0.01067914                0.015813128    -0.02385019
    ## 2952                -0.06986427               -0.093682416     0.03343477
    ##      tBodyGyroMeanY tBodyGyroMeanZ tBodyGyroJerkMeanX tBodyGyroJerkMeanY
    ## 1392    -0.06107092    0.094104120        -0.10553160       -0.032942356
    ## 1926     0.13524246    0.262037410        -0.02414991       -0.004855479
    ## 4556    -0.16400590    0.007328827        -0.14422273       -0.154757860
    ## 7850    -0.05047943    0.076475547        -0.09046966       -0.034253293
    ## 8735    -0.08678527    0.083687567        -0.10796325       -0.035449505
    ## 2952    -0.09689290   -0.009683151        -0.20300504       -0.163778370
    ##      tBodyGyroJerkMeanZ tBodyAccelerationMagnitudeMean
    ## 1392        -0.04350270                    -0.94611544
    ## 1926        -0.13496150                    -0.90778469
    ## 4556        -0.09124779                     0.01728548
    ## 7850        -0.05168083                    -0.98640520
    ## 8735        -0.05839373                    -0.98964149
    ## 2952         0.05743416                    -0.05080089
    ##      tGravityAccelerationMagnitudeMean tBodyAccelerationJerkMagnitudeMean
    ## 1392                       -0.94611544                         -0.9608720
    ## 1926                       -0.90778469                         -0.9468444
    ## 4556                        0.01728548                         -0.2730844
    ## 7850                       -0.98640520                         -0.9912980
    ## 8735                       -0.98964149                         -0.9936364
    ## 2952                       -0.05080089                         -0.1670148
    ##      tBodyGyroMagnitudeMean tBodyGyroJerkMagnitudeMean
    ## 1392             -0.9537291                 -0.9633124
    ## 1926             -0.8282444                 -0.9388022
    ## 4556             -0.2759577                 -0.4480095
    ## 7850             -0.9833829                 -0.9937430
    ## 8735             -0.9871522                 -0.9930779
    ## 2952             -0.3110577                 -0.3424777
    ##      fBodyAccelerationMeanX fBodyAccelerationMeanY fBodyAccelerationMeanZ
    ## 1392             -0.9421591            -0.93870560             -0.9343611
    ## 1926             -0.9570842            -0.86348147             -0.8966699
    ## 4556             -0.2524665             0.06572466             -0.4668319
    ## 7850             -0.9952511            -0.98273971             -0.9780107
    ## 8735             -0.9972678            -0.98229394             -0.9847757
    ## 2952             -0.3773970            -0.19145692              0.1928709
    ##      fBodyAccelerationJerkMeanX fBodyAccelerationJerkMeanY
    ## 1392                 -0.9350485                 -0.9526211
    ## 1926                 -0.9581418                 -0.9253821
    ## 4556                 -0.3658391                 -0.2293572
    ## 7850                 -0.9946288                 -0.9851012
    ## 8735                 -0.9973361                 -0.9876202
    ## 2952                 -0.4655601                 -0.2017483
    ##      fBodyAccelerationJerkMeanZ fBodyGyroMeanX fBodyGyroMeanY
    ## 1392               -0.949054960     -0.9485606     -0.9220779
    ## 1926               -0.933332440     -0.8454685     -0.8887244
    ## 4556               -0.629088360     -0.2916561     -0.4962971
    ## 7850               -0.986327120     -0.9812354     -0.9903557
    ## 8735               -0.989287720     -0.9812137     -0.9924737
    ## 2952                0.003832792     -0.3471714     -0.2480109
    ##      fBodyGyroMeanZ fBodyAccelerationMagnitudeMean
    ## 1392     -0.9288382                     -0.9216749
    ## 1926     -0.8307666                     -0.9191788
    ## 4556     -0.0950125                     -0.2288790
    ## 7850     -0.9911948                     -0.9835721
    ## 8735     -0.9853656                     -0.9917189
    ## 2952     -0.4522306                     -0.1676230
    ##      fBodyBodyAccelerationJerkMagnitudeMean fBodyBodyGyroMagnitudeMean
    ## 1392                            -0.90724263                 -0.9056865
    ## 1926                            -0.93327951                 -0.8242006
    ## 4556                            -0.34240522                 -0.4131642
    ## 7850                            -0.99046800                 -0.9859141
    ## 8735                            -0.99057076                 -0.9850642
    ## 2952                            -0.08101258                 -0.2549877
    ##      fBodyBodyGyroJerkMagnitudeMean tBodyAccelerationSigmaX
    ## 1392                     -0.9142449              -0.9535308
    ## 1926                     -0.9274205              -0.9641360
    ## 4556                     -0.5337219              -0.1226490
    ## 7850                     -0.9944036              -0.9963668
    ## 8735                     -0.9942910              -0.9977125
    ## 2952                     -0.2944630              -0.3558778
    ##      tBodyAccelerationSigmaY tBodyAccelerationSigmaZ
    ## 1392              -0.9294752              -0.9260316
    ## 1926              -0.8545586              -0.8555861
    ## 4556               0.1796811              -0.2075055
    ## 7850              -0.9846170              -0.9678125
    ## 8735              -0.9794184              -0.9834087
    ## 2952              -0.1657995               0.4067294
    ##      tGravityAccelerationSigmaX tGravityAccelerationSigmaY
    ## 1392                 -0.9840143                 -0.9949527
    ## 1926                 -0.9940927                 -0.9609743
    ## 4556                 -0.8833769                 -0.8649711
    ## 7850                 -0.9978147                 -0.9975440
    ## 8735                 -0.9984124                 -0.9835686
    ## 2952                 -0.9797578                 -0.9614864
    ##      tGravityAccelerationSigmaZ tBodyAccelerationJerkSigmaX
    ## 1392                 -0.9792712                  -0.9371096
    ## 1926                 -0.8284631                  -0.9595144
    ## 4556                 -0.7687708                  -0.2762064
    ## 7850                 -0.9818357                  -0.9945615
    ## 8735                 -0.9732513                  -0.9971003
    ## 2952                 -0.9408524                  -0.4530050
    ##      tBodyAccelerationJerkSigmaY tBodyAccelerationJerkSigmaZ
    ## 1392                  -0.9525456                -0.948523000
    ## 1926                  -0.9231302                -0.939920760
    ## 4556                  -0.1207490                -0.649471940
    ## 7850                  -0.9847205                -0.989107870
    ## 8735                  -0.9878546                -0.990583540
    ## 2952                  -0.1215335                -0.004428889
    ##      tBodyGyroSigmaX tBodyGyroSigmaY tBodyGyroSigmaZ tBodyGyroJerkSigmaX
    ## 1392      -0.9616122      -0.9351349      -0.9411348          -0.9505563
    ## 1926      -0.8913709      -0.8698838      -0.8371512          -0.9033988
    ## 4556      -0.5138889      -0.4049893      -0.2483305          -0.2557009
    ## 7850      -0.9853481      -0.9884538      -0.9924785          -0.9868869
    ## 8735      -0.9855117      -0.9923228      -0.9875922          -0.9876751
    ## 2952      -0.5360588      -0.2388226      -0.3617996          -0.2354965
    ##      tBodyGyroJerkSigmaY tBodyGyroJerkSigmaZ
    ## 1392          -0.9370443          -0.9509053
    ## 1926          -0.9431984          -0.9181508
    ## 4556          -0.6076524          -0.2106162
    ## 7850          -0.9960334          -0.9942325
    ## 8735          -0.9960673          -0.9904509
    ## 2952          -0.2785062          -0.5591653
    ##      tBodyAccelerationMagnitudeSigma tGravityAccelerationMagnitudeSigma
    ## 1392                      -0.9175442                         -0.9175442
    ## 1926                      -0.8872927                         -0.8872927
    ## 4556                      -0.2284695                         -0.2284695
    ## 7850                      -0.9822101                         -0.9822101
    ## 8735                      -0.9871693                         -0.9871693
    ## 2952                      -0.1929635                         -0.1929635
    ##      tBodyAccelerationJerkMagnitudeSigma tBodyGyroMagnitudeSigma
    ## 1392                         -0.90810090              -0.9098840
    ## 1926                         -0.92663726              -0.7947402
    ## 4556                         -0.35075927              -0.3600336
    ## 7850                         -0.99003284              -0.9859962
    ## 8735                         -0.99193614              -0.9841042
    ## 2952                         -0.06740565              -0.2602736
    ##      tBodyGyroJerkMagnitudeSigma fBodyAccelerationSigmaX
    ## 1392                  -0.9146840              -0.9588334
    ## 1926                  -0.9177935              -0.9672756
    ## 4556                  -0.4921961              -0.0763744
    ## 7850                  -0.9945608              -0.9969102
    ## 8735                  -0.9949754              -0.9978912
    ## 2952                  -0.2548952              -0.3474635
    ##      fBodyAccelerationSigmaY fBodyAccelerationSigmaZ
    ## 1392              -0.9282635              -0.9261855
    ## 1926              -0.8581266              -0.8452807
    ## 4556               0.1623863              -0.1464640
    ## 7850              -0.9855777              -0.9637902
    ## 8735              -0.9781330              -0.9829239
    ## 2952              -0.2047424               0.4095688
    ##      fBodyAccelerationJerkSigmaX fBodyAccelerationJerkSigmaY
    ## 1392                  -0.9454228                 -0.95586934
    ## 1926                  -0.9649181                 -0.92583537
    ## 4556                  -0.2494383                 -0.06183851
    ## 7850                  -0.9949499                 -0.98529964
    ## 8735                  -0.9970435                 -0.98904172
    ## 2952                  -0.4887732                 -0.09159212
    ##      fBodyAccelerationJerkSigmaZ fBodyGyroSigmaX fBodyGyroSigmaY
    ## 1392                 -0.94630761      -0.9657398      -0.9451425
    ## 1926                 -0.94495219      -0.9063810      -0.8602448
    ## 4556                 -0.66735317      -0.5876970      -0.3590733
    ## 7850                 -0.99065365      -0.9865900      -0.9873270
    ## 8735                 -0.99034159      -0.9868180      -0.9921852
    ## 2952                 -0.01098646      -0.5976350      -0.2385604
    ##      fBodyGyroSigmaZ fBodyAccelerationMagnitudeSigma
    ## 1392      -0.9511156                      -0.9268618
    ## 1926      -0.8540308                      -0.8885541
    ## 4556      -0.3748135                      -0.3479334
    ## 7850      -0.9935868                      -0.9830090
    ## 8735      -0.9894953                      -0.9853815
    ## 2952      -0.3930415                      -0.3328146
    ##      fBodyBodyAccelerationJerkMagnitudeSigma fBodyBodyGyroMagnitudeSigma
    ## 1392                             -0.90820498                  -0.9290707
    ## 1926                             -0.91731746                  -0.8099327
    ## 4556                             -0.36573774                  -0.4331315
    ## 7850                             -0.98781724                  -0.9883590
    ## 8735                             -0.99280691                  -0.9859509
    ## 2952                             -0.05616894                  -0.3944225
    ##      fBodyBodyGyroJerkMagnitudeSigma    ActivityLabel
    ## 1392                      -0.9209789          SITTING
    ## 1926                      -0.9114715         STANDING
    ## 4556                      -0.4757280 WALKING_UPSTAIRS
    ## 7850                      -0.9947941         STANDING
    ## 8735                      -0.9961289         STANDING
    ## 2952                      -0.2558076          WALKING
