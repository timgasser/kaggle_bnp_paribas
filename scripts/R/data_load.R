# Load dataset from CSV, do any pre-processing and cleaning
#

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Read the training and the test data in and print summary
claims.data <- read.csv("../../data/train.csv")
summary(claims.data)
str(claims.data)

claims.sub <- read.csv("../../data/test.csv")
summary(claims.sub)
str(claims.sub)




