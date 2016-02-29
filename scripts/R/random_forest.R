# Read in CSV files from the data directory
#

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Libraries
library(caTools)
# library(caret)
# library(e1071)
# library(rpart)
library(randomForest)

claims.data.idonly <- read.csv("../../data/train.csv")
claims.data$ID <- claims.data.idonly$ID
claims.data$target <- claims.data.idonly$target
# summary(claims.data)
# str(claims.data)
# source("data_load.R")
claims.data$v125 <- NULL
split = sample.split(claims.data$target, SplitRatio = 0.7) 
claims.train = subset(claims.data, split == TRUE)
claims.test = subset(claims.data, split == FALSE)

# Added the first 10 columns without NAs
rf.model <- randomForest(target ~ ., data = claims.train)
# summary(rfmodel)
rf.pred <- predict(rf.model, newdata = claims.test)
# summary(rf.pred)
# table(claims.test$target, rf.pred > 0.5)

# Calculate log loss on the test set
rf.pred.vector <- as.vector(rf.pred)
rf.pred.vector[is.na(rf.pred.vector) == TRUE] <- 0.5 # Put 50% probability in NA outputs
pos.probs <- claims.test$target * log(rf.pred.vector)
neg.probs <- (1 - claims.test$target) * log(1 - rf.pred.vector)
norm.probs <- -1 / length(rf.pred.vector)
ylogp <- norm.probs * (sum(pos.probs - neg.probs))

### Submission data
claims.sub <- read.csv("../../data/test.csv")
rf.sub <- predict(rf.model, newdata = claims.sub)
rf.sub.vector <- as.vector(rf.sub)
rf.sub.vector[is.na(rf.sub) == TRUE] <- 0.5 # Put 50% probability in NA outputs

sub <- data.frame(as.numeric(claims.sub$ID))
colnames(sub) <- "ID"
sub$PredictedProb <- rf.sub.vector
write.table(sub, file = "test_sub.csv", row.names = FALSE, sep = ",")

