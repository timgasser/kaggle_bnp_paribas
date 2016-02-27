# Read in CSV files from the data directory
#

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

source("data_load.R")

# Libraries
library("caTools")

split = sample.split(claims.data$target, SplitRatio = 0.8) 
claims.train = subset(claims.data, split == TRUE)
claims.test = subset(claims.data, split == FALSE)

# Create General Linear model
glm.model <- glm(target ~ ., family = binomial, data = claims.train)
summary(glm.model)
glm.pred <- predict(glm.model, type = "response", newdata = claims.test)
summary(glm.pred)
table(claims.test$target, glm.pred > 0.5)

# Accuracy is
# FALSE  TRUE
# 0    10  5450
# 1    15 17369



### Test data
claims.sub <- read.csv("../../data/test.csv")
glm.sub <- predict(glm.model, type = "response", newdata = claims.sub)

glm.sub[is.na(glm.sub)] <- 0.7612
glm.sub <- cbind(claims.sub$ID, glm.sub)
write.csv(glm.sub, row.names = FALSE, file = "../../data/submission.csv")
