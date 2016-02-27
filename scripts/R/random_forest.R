# Read in CSV files from the data directory
#

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Libraries
library("caTools")
library(caret)
library(e1071)
library(rpart)
library(randomForest)

claims.data <- read.csv("../../data/train.csv")
summary(claims.data)
str(claims.data)

split = sample.split(claims.data$target, SplitRatio = 0.8) 
claims.train = subset(claims.data, split == TRUE)
claims.test = subset(claims.data, split == FALSE)

# Added the first 10 columns without NAs
rf.model <- randomForest(target ~ v3 + v24 + v31 + v38 + v62 + v66 + v74, data = claims.train)
# summary(rfmodel)
rf.pred <- predict(rf.model, newdata = claims.test)
summary(rf.pred)
table(claims.test$target, rf.pred > 0.5)

# Accuracy is
# FALSE  TRUE
# 0    10  5450
# 1    15 17369


# Calculate log loss on the test set
rf.pred.vector <- as.vector(rf.pred)
rf.pred.vector[is.na(rf.pred.vector) == TRUE] <- 0.5 # Put 50% probability in NA outputs
pos.probs <- claims.test$target * ln(rf.pred.vector)
neg.probs <- (1 - claims.test$target) * ln(1 - rf.pred.vector)
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

