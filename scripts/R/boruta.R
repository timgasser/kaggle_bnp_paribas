# Read in CSV files from the data directory
#

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Libraries
library(Boruta)
library(caret)


claims.data <- read.csv("../../data/train.csv")
# target <- claims.data$target
# claims.data$target <- NULL
# summary(claims.data)
# str(claims.data)


Boruta(target ~ ., data = claims.data, doTrace = 1)->Bor.son;
print(Bor.son)


