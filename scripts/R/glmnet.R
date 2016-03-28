# Read in CSV files from the data directory

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/kaggle_bnp_paribas/scripts/R")

source("data_load.R")

# Libraries
library("glmnet")

claims.data.ID <- claims.data$ID
claims.data$ID <- NULL
claims.data.target <- claims.data$target
claims.data$target <- NULL
claims.sub.ID <- claims.sub$ID
claims.sub$ID <- NULL


claims.data.matrix <- data.matrix(claims.data)
glmnet.model <- glmnet(claims.data.matrix, claims.data.target)

# Debug model
print(glmnet.model)

# todo ! Need to add a log-loss function
glmnet.cvfit <- cv.glmnet(claims.data.matrix, claims.data.target, nfolds = 5)
lambda.min <- glmnet.cvfit$lambda_min

claims.sub.matrix <- data.matrix(claims.sub)
glmnet.pred <- predict(glmnet.cvfit, newx = claims.sub.matrix, type = "response")

# claims.train.target <- claims.train$target
# claims.test.target <- claims.test$target
# claims.train$target <- NULL
# claims.test$target <- NULL



###############################################################################
# Submission data

xgb.sub.vector <- as.vector(glmnet.pred)
# xgb.sub.vector[is.na(xgb.sub) == TRUE] <- 0.5 # Put 50% probability in NA outputs

sub <- data.frame(as.numeric(claims.sub.ID))
colnames(sub) <- "ID"
sub$PredictedProb <- xgb.sub.vector
write.table(sub, file = "test_sub.csv", row.names = FALSE, sep = ",")

