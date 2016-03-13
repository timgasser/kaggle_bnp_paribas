# Read in CSV files from the data directory

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

source("data_load.R")

# Libraries
library("caTools")
library("xgboost")

claims.data.ID <- claims.data$ID
claims.data$ID <- NULL
claims.data.target <- claims.data$target
claims.data$target <- NULL
claims.sub.ID <- claims.sub$ID
claims.sub$ID <- NULL

# # Only leave in the top 10 features to avoid overfitting
# cols.keep <- c("v94", "v18", "v39", "v72", "v76", "v50", "v24", "v15", "v75",
#                "v14", "v91", "v17")
# claims.data <- subset(claims.data, select = cols.keep)
# claims.sub <- subset(claims.sub, select = cols.keep)

# split = sample.split(claims.data$target, SplitRatio = 0.8) 
# claims.train = subset(claims.data, split == TRUE)
# claims.test = subset(claims.data, split == FALSE)

# claims.train.target <- claims.train$target
# claims.test.target <- claims.test$target
# claims.train$target <- NULL
# claims.test$target <- NULL

# dtrain <- xgb.DMatrix(data = data.matrix(claims.train), label = claims.train.target)
# dtest  <- xgb.DMatrix(data = data.matrix(claims.test), label = claims.test.target)
claims.data.matrix  <- xgb.DMatrix(data = data.matrix(claims.data), label = claims.data.target)


###############################################################################
# Model Cross-validation
xgb.cv.nround <- 500
xgb.cv.nfold <- 3

etas <- c(0.01, 0.05, 0.1)
max_depths <- c(6, 8, 10)
min_child_weights <- c(0.5, 1)
subsamples <- c(0.4, 0.8)
colsample_bytrees <- c(0.4, 0.8)

eta_vals <- vector()
max_depth_vals <- vector()
min_child_weight_vals <- vector()
subsample_vals <- vector()
colsample_bytree_vals <- vector()

train_results <- vector()
test_results <- vector()

for (eta in etas) {
  for (max_depth in max_depths) {
    for (min_child_weight in min_child_weights) {
      for (subsample in subsamples) {
        for (colsample_bytree in colsample_bytrees) {

            xgb.params <- list(  objective           = "binary:logistic", 
                                 booster             = "gbtree",
                                 eval_metric         = "logloss",
                                 eta                 = eta, 
                                 max_depth           = max_depths,
                                 subsample           = subsample,
                                 colsample_bytree    = colsample_bytree,
                                 min_child_weight    = min_child_weight)
            
            xgb.cv.output = xgb.cv( params  = xgb.params            ,
                                    data    = claims.data.matrix    ,
                                    label   = claims.data.target    ,
                                    nfold   = xgb.cv.nfold          ,
                                    nrounds = xgb.cv.nround+1       ,
                                    verbose = TRUE                  ,
                                    print.every.n = xgb.cv.nround/5 ,
                                    maximize = FALSE                ,
                                    nthread = 8
            )
            
            # Add a dataframe 
            eta_vals <- c(eta_vals, eta)
            max_depth_vals <- c(max_depth_vals, max_depth)
            min_child_weight_vals <- c(min_child_weight_vals, min_child_weight)
            subsample_vals <- c(subsample_vals, subsample)
            colsample_bytree_vals <- c(colsample_bytree_vals, colsample_bytree)

            train_results <- c(train_results, xgb.cv.output$train.logloss.mean[length(xgb.cv.output$train.logloss.mean)])
            test_results <- c(test_results, xgb.cv.output$test.logloss.mean[length(xgb.cv.output$test.logloss.mean)])
            
            rm(xgb.cv.output)
            gc()
        }
      }
    }
  }

}

xval <- data.frame(eta_vals, max_depth_vals, min_child_weight_vals, subsample_vals,
                   colsample_bytree_vals, train_results, test_results)
xval <- xval[order(test_results),]
write.csv(xval, file = "xval.csv")

###############################################################################
# Model training

models <- 5
nrounds <- 1500

claims.sub.xgb <- xgb.DMatrix(data = data.matrix(claims.sub))
xgb.watchlist <- list(eval = claims.data.matrix)
ensemble <- rep(0, nrow(claims.sub))

for (model in 1:models) {

  xval.entry <- xval[model,]

  xgb.params <- list( objective           = "binary:logistic", 
                      booster             = "gbtree",
                      eval_metric         = "logloss",
                      eta                 = xval.entry$eta ,
                      max_depth           = xval.entry$max_depth,
                      subsample           = xval.entry$subsample,
                      colsample_bytree    = xval.entry$colsample_bytree,
                      min_child_weight    = xval.entry$min_child_weight
                      )

  xgb.model <- xgb.train(
    params              = xgb.params           , 
    data                = claims.data.matrix   , 
    nrounds             = nrounds+1            , # change to 1500 to run outside of kaggle
    verbose             = 1                    ,  #0 if full training set and no watchlist provided
    watchlist           = xgb.watchlist        ,
    print.every.n       = nrounds/10           ,
    maximize            = FALSE         ,
    nthread             = 8
  )
  
  xgb.sub <- predict(xgb.model, newdata = claims.sub.xgb)
  ensemble <- ensemble + xgb.sub
}

ensemble <- ensemble / models

###############################################################################
# Model diagnostics

# xgb.model.importance <- xgb.importance(model = xgb.model)
# print(xgb.model.importance)
# xgb.plot.importance(xgb.model.importance)
# xgb.dump(xgb.model, with.stats = TRUE)
# xgb.save(xgb.model, "xgboost.model")

###############################################################################
# Submission data

xgb.sub.vector <- as.vector(ensemble)
# xgb.sub.vector[is.na(xgb.sub) == TRUE] <- 0.5 # Put 50% probability in NA outputs

sub <- data.frame(as.numeric(claims.sub.ID))
colnames(sub) <- "ID"
sub$PredictedProb <- xgb.sub.vector
write.table(sub, file = "test_sub.csv", row.names = FALSE, sep = ",")

