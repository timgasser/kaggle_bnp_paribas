# Source this file first ! It does the following
#
# 1. Loads the train.csv and test.csv files using the fast data.table
# 2. Converts the columns in the file to an appropriate type
# 3. Removes highly correlated columns in the data structure.
# 4. Creates new features using NAs (based on NMAR assumptions)
# 5. Imputes missing NA features for later modelling

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

library("data.table")
# library("mice")
# library("VIM")
library("Amelia")
library("caret")
library("corrgram")
# library("multicore")


# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Read the training and the test data in and print summary
# system.time(claims.data.read.csv <- read.csv("../../data/train.csv")) # Takes 23.3s
claims.data <- fread("../../data/train.csv", header = T, sep = ",", stringsAsFactors = TRUE)
claims.sub  <- fread("../../data/test.csv", header = T, sep = ",", stringsAsFactors = TRUE)

# Combine all the claims in one big dataframe. The target value will be NA for the 
# submission dataset. Save the target in another vector
claims.all <- rbind(claims.data, claims.sub, fill = TRUE)
claims.all.target <- claims.all$target
claims.all$target <- NULL

# note: v22 has 18211 levels !! Is this really a factor ?!

# Create some metadata on which columns are ordinal 
# Ordinal have some sense of ordering. Factors are just categories
cols.factor <- c('v3', 'v22', 'v24', 'v30', 'v31', 'v47', 'v52', 'v56', 'v66', 'v71', 'v74', 
                 'v75', 'v79', 'v91', 'v107', 'v110', 'v112', 'v113', 'v125')
cols.ord    <- c('v38', 'v62', 'v72', 'v129')


# First of all remove all rows with NA and factor columns. 
# Then check for correlation between remaining numeric columns and remove them.
claims.all.complete <- claims.all[complete.cases(claims.all) == TRUE]
claims.all.numeric <- claims.all.complete[,c(cols.factor) := NULL]
correlation <- cor(claims.all.numeric)
hc <- findCorrelation(correlation, cutoff = 0.9)
hc <- sort(hc)
hc
claims.all <- claims.all[,c(hc) := NULL]

# Create some utility vectors based on de-correlated data.
col.names <- sapply(claims.all, names)
col.types <- sapply(claims.all, class)
col.factors <- names(col.types[col.types == 'factor'])

#Amelia section (Imputed missing values)
max.cores <- parallel::detectCores()
claims.all.imp <- amelia(claims.all, m = 1, p2s = 1, parallel = 'multicore', ncpus = max.cores-1,
                                  ords = c('v3', 'v24', 'v30', 'v31', 'v66', 'v71', 
                                  'v74', 'v75', 'v79', 'v107', 'v110', 'v112', 'v113', 'v125'))



# Now separate out the submission data, put the target back in training data.
claims.all <- claims.all.imp$imputations$imp1
claims.all$target <- claims.all.target
claims.data <- subset(claims.all, !is.na(target))
claims.sub <- subset(claims.all, is.na(target))
claims.sub$target <- NULL

# system.time(imputed.data <- mice(claims.data.small, m=1))
# MICE section

# md.pattern(claims.data)
# p <- md.pairs(claims.data)
# system.time(claims.data.mice <- mice(data = claims.data.small, m = 1, printFlag = TRUE))
# 
# # VIM
# marginplot(as.matrix(claims.data), col = c("blue", "red", "orange"))


# 
# col.median <- colMeans(claims.data.fread, na.rm = TRUE)
# 
# summary(claims.data.fread)
# summary(claims.data)
# str(claims.data)
# 
# claims.sub <- read.csv("../../data/test.csv")
# summary(claims.sub)
# str(claims.sub)
# 



