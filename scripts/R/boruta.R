# Read in CSV files from the data directory
#

# # Clear objects from Memory
# rm(list=ls())
# # Clear Console:
# cat("\014")

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Libraries
library(Boruta)
library(caret)



# claims.data <- read.csv("../../data/train.csv")
# target <- claims.data$target
# claims.data$target <- NULL
# summary(claims.data)
# str(claims.data)

# Create a sub-sample of the data using precentage p
idx <- createDataPartition(claims.data$target, p=0.00001, list = FALSE)
claims.data.boruta <- claims.data[idx,]

boruta.results <- Boruta(claims.data, 
                         claims.data$target, 
                         maxRuns = 101, 
                         doTrace = 1)
print(Bor.son)
# 
# stats<-attStats(Bor.son);
# print(stats);
# plot(normHits~meanImp,col=stats$decision,data=stats);
# 
# 
