# Notes

Credit Paribas challenge. 

## Useful links

* [Public Leaderboard](https://www.kaggle.com/c/bnp-paribas-cardif-claims-management/leaderboard)
* [Forum](https://www.kaggle.com/c/bnp-paribas-cardif-claims-management/forums)
    * [Boruta package script](https://www.kaggle.com/jimthompson/bnp-paribas-cardif-claims-management/using-the-boruta-package-to-determine-fe)
    * 

Amelia manual - https://cran.r-project.org/web/packages/Amelia/vignettes/amelia.pdf

xgboost example - https://www.kaggle.com/justfor/bnp-paribas-cardif-claims-management/xgb-cross-val-and-feat-select

Another xgboost - https://www.kaggle.com/gunner4life/bnp-paribas-cardif-claims-management/xgboost-r-script-giving-0-45846-on-lb



## Bookmarks

[Mastering Scientific Computing with R](https://www.safaribooksonline.com/library/view/mastering-scientific-computing/9781783555253/ch10s06.html)

[R in action](https://www.safaribooksonline.com/library/view/r-in-action/9781617291388/kindle_split_030.html)

[Machine learning with R](https://www.safaribooksonline.com/library/view/machine-learning-with/9781783982042/ch02s04.html)

[Otto competition xgboost info](https://www.kaggle.com/c/otto-group-product-classification-challenge/forums/t/12947/achieve-0-50776-on-the-leaderboard-in-a-minute-with-xgboost)

[xgboost Otto Kaggle info](https://github.com/dmlc/xgboost/tree/master/demo/kaggle-otto)

### Todo list

* Work out why the log loss is ~0.11 on my machine but ~0.5 on the leaderboard
* Clean up the data, there are too many NAs everywhere
* Run boruta to check which variables are important
* Feature engineering to recognise blocks of NAs across observations.
* Learn how to use xgboost, use this to do a run.
* Maybe use adaboost?
* Do baseline comparisons of logistic regression, CART, random forest, xgboost, SVM (?).
* Work out how to do k-folds validation instead of simple validation scheme
* Do ensembles of trees to try and improve performance

## Feature engineering

Common blocks of NAs:

* v1 - v2
* v4 - v9
* v11
* v13
* v15 - v20
* v23
* v25 - v29
* v32 - v33
* v35 - v37
* v39
* v41 - v46
* v48 - v49
* v51
* v53 - v55
* v57 - v61
* v63 - v65
* v67 - v70
* v73
* v76 - v78
* v80 - v90
* v92 - v106
* v108 - v109
* v115 - v124
* v126 - v128
* v130 - v131

"Grading columns"

* Columns followed by a set of numeric values, blocks of NAs (potentially)
* v1
* v3
* v22
* v24
* v30
* v31
* v38 ?
* v47
* v52
* v56
* v62
* v66
* v71
* v72
* v74
* v75
* v79
* v91
* v107
* v110
* v112
* v113
* v125
* v129

# Baseline xgboost script

param0 <- list(
  # general , non specific params - just guessing
  "objective"  = "binary:logistic"
  , "eval_metric" = "logloss"
  , "eta" = 0.01
  , "subsample" = 0.8
  , "colsample_bytree" = 0.8
  , "min_child_weight" = 1
  , "max_depth" = 10
)

All features added, categorical / ordinals converted to numeric
[0]	train-logloss:0.688937+0.000015	test-logloss:0.689346+0.000028
[100]	train-logloss:0.484554+0.000762	test-logloss:0.515999+0.000679
[200]	train-logloss:0.419978+0.000369	test-logloss:0.478632+0.001335
[300]	train-logloss:0.388413+0.000455	test-logloss:0.469295+0.001701
[400]	train-logloss:0.368299+0.000097	test-logloss:0.466411+0.001896
[500]	train-logloss:0.353010+0.000172	test-logloss:0.464981+0.002057
[600]	train-logloss:0.339983+0.000165	test-logloss:0.464241+0.002189
[700]	train-logloss:0.328716+0.000437	test-logloss:0.463768+0.002182
[800]	train-logloss:0.318004+0.000433	test-logloss:0.463540+0.002264
[900]	train-logloss:0.308025+0.001368	test-logloss:0.463448+0.002384
[1000]	train-logloss:0.298772+0.001136	test-logloss:0.463530+0.002473
[1100]	train-logloss:0.289700+0.001340	test-logloss:0.463599+0.002590
[1200]	train-logloss:0.281052+0.000995	test-logloss:0.463821+0.002609
[1300]	train-logloss:0.272962+0.000692	test-logloss:0.464082+0.002685
[1400]	train-logloss:0.264780+0.000723	test-logloss:0.464412+0.002755
[1500]	train-logloss:0.257481+0.001163	test-logloss:0.464882+0.002822

# My baseline xgboost (all features)
[0]	train-logloss:0.688998+0.000074	test-logloss:0.689384+0.000010
[100]	train-logloss:0.484327+0.000298	test-logloss:0.515533+0.000670
[200]	train-logloss:0.420545+0.000157	test-logloss:0.478352+0.001126
[300]	train-logloss:0.389155+0.000393	test-logloss:0.468989+0.001484
[400]	train-logloss:0.369399+0.000673	test-logloss:0.466089+0.001660
[500]	train-logloss:0.354490+0.000689	test-logloss:0.464704+0.001842
[600]	train-logloss:0.342448+0.001252	test-logloss:0.463996+0.001834
[700]	train-logloss:0.331223+0.000125	test-logloss:0.463529+0.001953
[800]	train-logloss:0.320871+0.000317	test-logloss:0.463301+0.002081
[900]	train-logloss:0.311199+0.000545	test-logloss:0.463229+0.002157
[1000]	train-logloss:0.301229+0.000752	test-logloss:0.463254+0.002289
[1100]	train-logloss:0.292122+0.000843	test-logloss:0.463409+0.002393
[1200]	train-logloss:0.283459+0.000272	test-logloss:0.463665+0.002473
[1300]	train-logloss:0.275136+0.000169	test-logloss:0.463906+0.002578
[1400]	train-logloss:0.266898+0.000654	test-logloss:0.464250+0.002603
[1500]	train-logloss:0.259344+0.001110	test-logloss:0.464676+0.002703

# XGBoost parameters

eta = 0.01
max_depth_vals = 10
min_child = 0.5
subsample_vals = 0.8
colsample_bytree_vals = 0.4



# XGBoost hyperparameter search with all features

"","eta_vals","max_depth_vals","min_child_weight_vals","subsample_vals","colsample_bytree_vals","train_results","test_results"
"11",0.01,8,0.5,0.8,0.4,0.344197,0.462839
"12",0.01,8,0.5,0.8,0.8,0.344962,0.463587
"15",0.01,8,1,0.8,0.4,0.348377,0.463944
"8",0.01,6,1,0.8,0.8,0.410083,0.465193
"4",0.01,6,0.5,0.8,0.8,0.408822,0.465623
"14",0.01,8,1,0.4,0.8,0.356972,0.465892
"7",0.01,6,1,0.8,0.4,0.41382,0.466183
"10",0.01,8,0.5,0.4,0.8,0.358843,0.466212
"3",0.01,6,0.5,0.8,0.4,0.412843,0.466249
"9",0.01,8,0.5,0.4,0.4,0.356586,0.466354
"13",0.01,8,1,0.4,0.4,0.359846,0.466748
"2",0.01,6,0.5,0.4,0.8,0.409911,0.467302
"6",0.01,6,1,0.4,0.8,0.411639,0.467564
"1",0.01,6,0.5,0.4,0.4,0.41491,0.468227
"5",0.01,6,1,0.4,0.4,0.416509,0.468325


# Boruta results
Boruta performed 100 iterations in 1.23696 days.
 123 attributes confirmed important: v1, v10, v100, v101, v102 and 118 more.
 5 attributes confirmed unimportant: v107, v22, v3, v52, v91.
 3 tentative attributes left: v125, v71, v75.
 
 
 
# Feature Engineering results

Spot check with an xgboost with the following settings

set.seed(2016)
xgb.cv.nround <- 500
xgb.cv.nfold <- 3

etas <- c(0.01)
max_depths <- c(10)
min_child_weights <- c(1)
subsamples <- c(0.8)
colsample_bytrees <- c(0.8)

* Basic feature set.  Replace NA with -1.

```
[0]	train-logloss:0.688998+0.000074	test-logloss:0.689384+0.000010
[100]	train-logloss:0.484327+0.000298	test-logloss:0.515533+0.000670
[200]	train-logloss:0.420545+0.000157	test-logloss:0.478352+0.001126
[300]	train-logloss:0.389155+0.000393	test-logloss:0.468989+0.001484
[400]	train-logloss:0.369399+0.000673	test-logloss:0.466089+0.001660
[500]	train-logloss:0.354490+0.000689	test-logloss:0.464704+0.001842
```

* As above, Drop v3, 22, 52, 91, 107. plus binarized factors

```
[0]	train-logloss:0.688968+0.000016	test-logloss:0.689351+0.000020
[100]	train-logloss:0.484838+0.001102	test-logloss:0.514337+0.000493
[200]	train-logloss:0.422621+0.000607	test-logloss:0.476777+0.000964
[300]	train-logloss:0.393905+0.000478	test-logloss:0.467513+0.001349
[400]	train-logloss:0.376651+0.000631	test-logloss:0.464690+0.001535
[500]	train-logloss:0.364300+0.000537	test-logloss:0.463428+0.001721
```

* As above, with NA-based features (counts and true/negative)

```
[0]	train-logloss:0.688991+0.000048	test-logloss:0.689417+0.000081
[100]	train-logloss:0.484312+0.000758	test-logloss:0.514083+0.000624
[200]	train-logloss:0.422305+0.000419	test-logloss:0.476742+0.001034
[300]	train-logloss:0.394066+0.000532	test-logloss:0.467466+0.001281
[400]	train-logloss:0.376555+0.000585	test-logloss:0.464582+0.001447
[500]	train-logloss:0.364487+0.000979	test-logloss:0.463371+0.001583
```

* As above, with Amelia-imputation of NA values

```
[0]	train-logloss:0.688977+0.000024	test-logloss:0.689345+0.000014
[100]	train-logloss:0.484132+0.000971	test-logloss:0.516791+0.000947
[200]	train-logloss:0.416524+0.000581	test-logloss:0.479364+0.001388
[300]	train-logloss:0.382588+0.000967	test-logloss:0.470329+0.001730
[400]	train-logloss:0.361213+0.000961	test-logloss:0.467851+0.001871
[500]	train-logloss:0.345256+0.000915	test-logloss:0.466826+0.002038
```


# Amelia run

I tried imputing the factor and ordinal variables, but this blew up the running time to around 8 hours (!) and gave crashes at the end anyway. Setting the categorical variables to "idvars" in the amelia command excludes them from imputation and runs in under a minute.

### Notes

Before running amelia, you need to:

* Remove highly correlated variables. This will make the covariance matrix singular, and Amelia can't process this. To do this you can use the snippet below. To check correlation using caret's findCorrelation, you can't have NAs in the data ! The complete.cases() function is used to only select rows where values aren't NA.

```R
claims.imp.in = claims.all
cols.factor <- c('v3', 'v22', 'v24', 'v30', 'v31', 'v47', 'v52', 'v56', 'v66', 'v71',
                 'v74', 'v75', 'v79', 'v91', 'v107', 'v110', 'v112', 'v113', 'v125')
cols.ord    <- c('v38', 'v62', 'v72', 'v129')

claims.data.complete <- claims.imp.in[complete.cases(claims.imp.in) == TRUE]
claims.data.numeric <- claims.data.complete[,c(cols.factor) := NULL]
claims.data.numeric <- claims.data.complete[,c(cols.ord) := NULL]

correlation <- cor(claims.data.numeric)
hc <- findCorrelation(correlation, cutoff = 0.9)
hc <- sort(hc)
hc
claims.imp.in <- claims.imp.in[,c(hc) := NULL]
```

* 