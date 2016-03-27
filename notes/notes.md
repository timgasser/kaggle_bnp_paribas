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

[0]	train-logloss:0.688998+0.000074	test-logloss:0.689384+0.000010
[100]	train-logloss:0.484327+0.000298	test-logloss:0.515533+0.000670
[200]	train-logloss:0.420545+0.000157	test-logloss:0.478352+0.001126
[300]	train-logloss:0.389155+0.000393	test-logloss:0.468989+0.001484
[400]	train-logloss:0.369399+0.000673	test-logloss:0.466089+0.001660
[500]	train-logloss:0.354490+0.000689	test-logloss:0.464704+0.001842

* As above, Drop v3, 22, 52, 91, 107. plus binarized factors

[0]	train-logloss:0.688968+0.000016	test-logloss:0.689351+0.000020
[100]	train-logloss:0.484838+0.001102	test-logloss:0.514337+0.000493
[200]	train-logloss:0.422621+0.000607	test-logloss:0.476777+0.000964
[300]	train-logloss:0.393905+0.000478	test-logloss:0.467513+0.001349
[400]	train-logloss:0.376651+0.000631	test-logloss:0.464690+0.001535
[500]	train-logloss:0.364300+0.000537	test-logloss:0.463428+0.001721

* As above, with NA-based features (counts and true/negative)

[0]	train-logloss:0.688991+0.000048	test-logloss:0.689417+0.000081
[100]	train-logloss:0.484312+0.000758	test-logloss:0.514083+0.000624
[200]	train-logloss:0.422305+0.000419	test-logloss:0.476742+0.001034
[300]	train-logloss:0.394066+0.000532	test-logloss:0.467466+0.001281
[400]	train-logloss:0.376555+0.000585	test-logloss:0.464582+0.001447
[500]	train-logloss:0.364487+0.000979	test-logloss:0.463371+0.001583



# Amelia run

Using ' multicore ' parallel backend with 7 cores.
amelia starting
beginning prep functions
Variables used:  v1 v2 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v23 v25 v26 v27 v28 v29 v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43 v44 v45 v46 v48 v49 v50 v51 v53 v54 v55 v57 v58 v59 v60 v61 v62 v63 v64 v65 v67 v68 v69 v70 v72 v73 v76 v77 v78 v80 v81 v82 v83 v84 v85 v86 v87 v88 v89 v90 v92 v93 v94 v95 v96 v97 v98 v99 v100 v101 v102 v103 v104 v105 v106 v108 v109 v111 v114 v115 v116 v117 v118 v119 v120 v121 v122 v123 v124 v126 v127 v128 v129 v130 v131 v1v2NaSum v1v2Na v3Na v4v9NaSum v4v9Na v11v13NaSum v11v13Na v15v20NaSum v15v20Na v23Na v25v29NaSum v25v29Na v31Na v32v37NaSum v32v37Na v39Na v41v46NaSum v41v46Na v48v51NaSum v48v51Na v52Na v53v55NaSum v53v55Na v56Na v57v61NaSum v57v61Na v63v65NaSum v63v65Na v67v70NaSum v67v70Na v73Na v76v78NaSum v76v78Na v80v90NaSum v80v90Na v91Na v92v106NaSum v92v106Na v107Na v108v109NaSum v108v109Na v111v113NaSum v111v113Na v114v124NaSum v114v124Na v126v128NaSum v126v128Na v130v131NaSum v130v131Na v24B v24C v24D v24E v30A v30B v30C v30D v30E v30F v30G v31A v31B v31C v47B v47C v47D v47E v47F v47G v47H v47I v47J v56A v56AA v56AB v56AC v56AE v56AF v56AG v56AH v56AI v56AJ v56AK v56AL v56AM v56AN v56AO v56AP v56AR v56AS v56AT v56AU v56AV v56AW v56AX v56AY v56AZ v56B v56BA v56BC v56BD v56BE v56BF v56BG v56BH v56BI v56BJ v56BK v56BL v56BM v56BN v56BO v56BP v56BQ v56BR v56BS v56BT v56BU v56BV v56BW v56BX v56BY v56BZ v56C v56CA v56CB v56CC v56CD v56CE v56CF v56CG v56CH v56CI v56CJ v56CK v56CL v56CM v56CN v56CO v56CP v56CQ v56CS v56CT v56CV v56CW v56CX v56CY v56CZ v56D v56DA v56DB v56DC v56DD v56DE v56DF v56DG v56DH v56DI v56DJ v56DK v56DL v56DM v56DN v56DO v56DP v56DQ v56DR v56DS v56DT v56DU v56DV v56DW v56DX v56DY v56DZ v56E v56F v56G v56H v56I v56L v56M v56N v56O v56P v56Q v56R v56T v56U v56V v56W v56X v56Y v56Z v56AD v56AQ v56BB v56CR v56CU v56J v56K v56S v66B v66C v71B v71C v71D v71F v71G v71I v71K v71L v71E v71H v71J v74B v74C v75B v75C v75D v79B v79C v79D v79E v79F v79G v79H v79I v79J v79K v79L v79M v79N v79O v79P v79Q v79R v110B v110C v112A v112B v112C v112D v112E v112F v112G v112H v112I v112J v112K v112L v112M v112N v112O v112P v112Q v112R v112S v112T v112U v112V v113A v113AA v113AB v113AC v113AD v113AE v113AF v113AG v113AH v113AI v113AJ v113AK v113B v113C v113D v113E v113F v113G v113H v113I v113J v113L v113M v113N v113O v113P v113Q v113R v113S v113T v113U v113V v113W v113X v113Y v113Z v113K v125A v125AA v125AB v125AC v125AD v125AE v125AF v125AG v125AH v125AI v125AJ v125AK v125AL v125AM v125AN v125AO v125AP v125AQ v125AR v125AS v125AT v125AU v125AV v125AW v125AX v125AY v125AZ v125B v125BA v125BB v125BC v125BD v125BE v125BF v125BG v125BH v125BI v125BJ v125BK v125BL v125BM v125BN v125BO v125BP v125BQ v125BR v125BS v125BT v125BU v125BV v125BW v125BX v125BY v125BZ v125C v125CA v125CB v125CC v125CD v125CE v125CF v125CG v125CH v125CI v125CJ v125CK v125CL v125D v125E v125F v125G v125H v125I v125J v125K v125L v125M v125N v125O v125P v125Q v125R v125S v125T v125U v125V v125W v125X v125Y v125Z noms.v24.2 noms.v24.3 noms.v24.4 noms.v24.5 noms.v30.2 noms.v30.3 noms.v30.4 noms.v30.5 noms.v30.6 noms.v30.7 noms.v47.2 noms.v47.3 noms.v47.4 noms.v47.5 noms.v47.6 noms.v47.7 noms.v47.8 noms.v47.9 noms.v47.10 noms.v56.2 noms.v56.3 noms.v56.4 noms.v56.5 noms.v56.6 noms.v56.7 noms.v56.8 noms.v56.9 noms.v56.10 noms.v56.11 noms.v56.12 noms.v56.13 noms.v56.14 noms.v56.15 noms.v56.16 noms.v56.17 noms.v56.18 noms.v56.19 noms.v56.20 noms.v56.21 noms.v56.22 noms.v56.23 noms.v56.24 noms.v56.25 noms.v56.26 noms.v56.27 noms.v56.28 noms.v56.29 noms.v56.30 noms.v56.31 noms.v56.32 noms.v56.33 noms.v56.34 noms.v56.35 noms.v56.36 noms.v56.37 noms.v56.38 noms.v56.39 noms.v56.40 noms.v56.41 noms.v56.42 noms.v56.43 noms.v56.44 noms.v56.45 noms.v56.46 noms.v56.47 noms.v56.48 noms.v56.49 noms.v56.50 noms.v56.51 noms.v56.52 noms.v56.53 noms.v56.54 noms.v56.55 noms.v56.56 noms.v56.57 noms.v56.58 noms.v56.59 noms.v56.60 noms.v56.61 noms.v56.62 noms.v56.63 noms.v56.64 noms.v56.65 noms.v56.66 noms.v56.67 noms.v56.68 noms.v56.69 noms.v56.70 noms.v56.71 noms.v56.72 noms.v56.73 noms.v56.74 noms.v56.75 noms.v56.76 noms.v56.77 noms.v56.78 noms.v56.79 noms.v56.80 noms.v56.81 noms.v56.82 noms.v56.83 noms.v56.84 noms.v56.85 noms.v56.86 noms.v56.87 noms.v56.88 noms.v56.89 noms.v56.90 noms.v56.91 noms.v56.92 noms.v56.93 noms.v56.94 noms.v56.95 noms.v56.96 noms.v56.97 noms.v56.98 noms.v56.99 noms.v56.100 noms.v56.101 noms.v56.102 noms.v56.103 noms.v56.104 noms.v56.105 noms.v56.106 noms.v56.107 noms.v56.108 noms.v56.109 noms.v56.110 noms.v56.111 noms.v56.112 noms.v56.113 noms.v56.114 noms.v56.115 noms.v56.116 noms.v56.117 noms.v56.118 noms.v56.119 noms.v56.120 noms.v56.121 noms.v56.122 noms.v56.123 noms.v56.124 noms.v56.125 noms.v56.126 noms.v56.127 noms.v56.128 noms.v56.129 noms.v56.130 noms.v66.2 noms.v66.3 noms.v71.2 noms.v71.3 noms.v71.4 noms.v71.5 noms.v71.6 noms.v71.7 noms.v71.8 noms.v71.9 noms.v71.10 noms.v71.11 noms.v71.12 noms.v74.2 noms.v74.3 noms.v75.2 noms.v75.3 noms.v75.4 noms.v79.2 noms.v79.3 noms.v79.4 noms.v79.5 noms.v79.6 noms.v79.7 noms.v79.8 noms.v79.9 noms.v79.10 noms.v79.11 noms.v79.12 noms.v79.13 noms.v79.14 noms.v79.15 noms.v79.16 noms.v79.17 noms.v79.18 noms.v110.2 noms.v110.3 noms.v112.2 noms.v112.3 noms.v112.4 noms.v112.5 noms.v112.6 noms.v112.7 noms.v112.8 noms.v112.9 noms.v112.10 noms.v112.11 noms.v112.12 noms.v112.13 noms.v112.14 noms.v112.15 noms.v112.16 noms.v112.17 noms.v112.18 noms.v112.19 noms.v112.20 noms.v112.21 noms.v112.22 noms.v113.2 noms.v113.3 noms.v113.4 noms.v113.5 noms.v113.6 noms.v113.7 noms.v113.8 noms.v113.9 noms.v113.10 noms.v113.11 noms.v113.12 noms.v113.13 noms.v113.14 noms.v113.15 noms.v113.16 noms.v113.17 noms.v113.18 noms.v113.19 noms.v113.20 noms.v113.21 noms.v113.22 noms.v113.23 noms.v113.24 noms.v113.25 noms.v113.26 noms.v113.27 noms.v113.28 noms.v113.29 noms.v113.30 noms.v113.31 noms.v113.32 noms.v113.33 noms.v113.34 noms.v113.35 noms.v113.36 noms.v113.37 noms.v125.2 noms.v125.3 noms.v125.4 noms.v125.5 noms.v125.6 noms.v125.7 noms.v125.8 noms.v125.9 noms.v125.10 noms.v125.11 noms.v125.12 noms.v125.13 noms.v125.14 noms.v125.15 noms.v125.16 noms.v125.17 noms.v125.18 noms.v125.19 noms.v125.20 noms.v125.21 noms.v125.22 noms.v125.23 noms.v125.24 noms.v125.25 noms.v125.26 noms.v125.27 noms.v125.28 noms.v125.29 noms.v125.30 noms.v125.31 noms.v125.32 noms.v125.33 noms.v125.34 noms.v125.35 noms.v125.36 noms.v125.37 noms.v125.38 noms.v125.39 noms.v125.40 noms.v125.41 noms.v125.42 noms.v125.43 noms.v125.44 noms.v125.45 noms.v125.46 noms.v125.47 noms.v125.48 noms.v125.49 noms.v125.50 noms.v125.51 noms.v125.52 noms.v125.53 noms.v125.54 noms.v125.55 noms.v125.56 noms.v125.57 noms.v125.58 noms.v125.59 noms.v125.60 noms.v125.61 noms.v125.62 noms.v125.63 noms.v125.64 noms.v125.65 noms.v125.66 noms.v125.67 noms.v125.68 noms.v125.69 noms.v125.70 noms.v125.71 noms.v125.72 noms.v125.73 noms.v125.74 noms.v125.75 noms.v125.76 noms.v125.77 noms.v125.78 noms.v125.79 noms.v125.80 noms.v125.81 noms.v125.82 noms.v125.83 noms.v125.84 noms.v125.85 noms.v125.86 noms.v125.87 noms.v125.88 noms.v125.89 noms.v125.90 
Warning messages:
1: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  : 

The number of categories in one of the variables marked nominal has greater than 10 categories. Check nominal specification.


2: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  : 

The number of categories in one of the variables marked nominal has greater than 10 categories. Check nominal specification.


3: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  : 

The number of categories in one of the variables marked nominal has greater than 10 categories. Check nominal specification.


4: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  : 

The number of categories in one of the variables marked nominal has greater than 10 categories. Check nominal specification.


5: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  : 

The number of categories in one of the variables marked nominal has greater than 10 categories. Check nominal specification.


6: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  : 

The number of categories in one of the variables marked nominal has greater than 10 categories. Check nominal specification.


7: In amcheck(x = x, m = m, idvars = numopts$idvars, priors = priors,  :
  The variable v91Na is perfectly collinear with another variable in the data.
The variable v92v106NaSum is perfectly collinear with another variable in the data.
The variable v92v106Na is perfectly collinear with another variable in the data.
The variable v108v109Na is perfectly collinear with another variable in the data.
The variable v126v128NaSum is perfectly collinear with another variable in the data.
The variable v24C is perfectly collinear with another variable in the data.
The variable v24D is perfectly collinear with another variable in the data.
The variable v30A is perfectly collinear with another variable in the data.
The variable v56AK is perfectly collinear with another variable in the data.
The variable v56DE is perfectly collinear with another variable in the data.
The variable v56DX is perfectly collinear with another variable in the data.
The variable v56L is perfectly collinear with another variable in the data.
The variable v56R is perfectly collinear with another va [... truncated]
8: In parallel::mclapply(seq_len(m), do.amelia, mc.cores = ncpus) :
  scheduled cores 2, 5 encountered errors in user code, all values of the jobs will be affected
> 
 
 


