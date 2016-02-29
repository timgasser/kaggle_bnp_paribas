# Read in CSV files from the data directory

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

source("data_load.R")

# Libraries
library("caTools")
library("xgboost")

claims.data$ID <- NULL

# # Only leave in the top 10 features to avoid overfitting
# cols.keep <- c("v94", "v18", "v39", "v72", "v76", "v50", "v24", "v15", "v75",
#                "v14", "v91", "v17")
# claims.data <- subset(claims.data, select = cols.keep)
# claims.sub <- subset(claims.sub, select = cols.keep)

split = sample.split(claims.data$target, SplitRatio = 0.8) 
claims.train = subset(claims.data, split == TRUE)
claims.test = subset(claims.data, split == FALSE)

# claims.train.target <- claims.train$target
# claims.test$target <- NULL

dtrain <- xgb.DMatrix(data = data.matrix(claims.train), label = claims.train$target)
dtest  <- xgb.DMatrix(data = data.matrix(claims.test), label = claims.test$target)

xgb.watchlist <- list(eval = dtest, train = dtrain)

xgb.params <- list(  objective           = "binary:logistic", 
                     booster             = "gbtree",
                     eval_metric         = "logloss",
                     eta                 = 0.01, 
                     max_depth           = 6,
                     subsample           = 0.8,
                     colsample_bytree    = 0.8,
                     min_child_weight    = 1
                     
)

xgb.model <- xgb.train(
  params              = xgb.params, 
  data                = dtrain, 
  nrounds             = 1000, # change to 1500 to run outside of kaggle
  verbose             = 1,  #0 if full training set and no watchlist provided
  watchlist           = xgb.watchlist,
  print.every.n       = 100,
  maximize            = FALSE
)

xgb.model.importance <- xgb.importance(model = xgb.model)
print(xgb.model.importance)
xgb.plot.importance(xgb.model.importance)

stop

### Submission data
claims.sub.xgb <- xgb.DMatrix(data = data.matrix(claims.sub))
xgb.sub <- predict(xgb.model, newdata = claims.sub.xgb)
xgb.sub.vector <- as.vector(xgb.sub)
xgb.sub.vector[is.na(xgb.sub) == TRUE] <- 0.5 # Put 50% probability in NA outputs

sub <- data.frame(as.numeric(claims.sub$ID))
colnames(sub) <- "ID"
sub$PredictedProb <- xgb.sub.vector
write.table(sub, file = "test_sub.csv", row.names = FALSE, sep = ",")

