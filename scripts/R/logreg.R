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

claims.data <- read.csv("../../data/train.csv")
summary(claims.data)
str(claims.data)

split = sample.split(claims.data$target, SplitRatio = 0.8) 
claims.train = subset(claims.data, split == TRUE)
claims.test = subset(claims.data, split == FALSE)

# Added the first 10 columns without NAs
glm.model <- glm(target ~ v50 + v66 + v12 + v114 + v34 + v40 + v10, family = binomial, data = claims.train)
summary(glm.model)
glm.pred <- predict(glm.model, type = "response", newdata = claims.test)
summary(glm.pred)
table(claims.test$target, glm.pred > 0.5)

# Accuracy is
# FALSE  TRUE
# 0    10  5450
# 1    15 17369


# Calculate log loss on the test set
glm.pred.vector <- as.vector(glm.pred)
glm.pred.vector[is.na(glm.pred.vector) == TRUE] <- 0.5 # Put 50% probability in NA outputs
pos.probs <- claims.test$target * log(glm.pred.vector)
neg.probs <- (1 - claims.test$target) * log(1 - glm.pred.vector)
norm.probs <- -1 / length(glm.pred.vector)
ylogp <- norm.probs * (sum(pos.probs - neg.probs))

### Submission data
claims.sub <- read.csv("../../data/test.csv")
glm.sub <- predict(glm.model, type = "response", newdata = claims.sub)
glm.sub.vector <- as.vector(glm.sub)
glm.sub.vector[is.na(glm.sub) == TRUE] <- 0.5 # Put 50% probability in NA outputs

sub <- data.frame(as.numeric(claims.sub$ID))
colnames(sub) <- "ID"
sub$PredictedProb <- glm.sub.vector
write.table(sub, file = "test_sub.csv", row.names = FALSE, sep = ",")

