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
# library("Amelia")
library("caret")
library("corrgram")
# library("multicore")


# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/kaggle_bnp_paribas/scripts/R")

# Read the training and the test data in and print summary
# system.time(claims.data.read.csv <- read.csv("../../data/train.csv")) # Takes 23.3s
claims.data <- fread("../../data/train.csv", header = T, sep = ",", stringsAsFactors = TRUE)
claims.sub  <- fread("../../data/test.csv", header = T, sep = ",", stringsAsFactors = TRUE)

# Combine all the claims in one big dataframe. The target value will be NA for the 
# submission dataset. Save the target in another vector
claims.all <- rbind(claims.data, claims.sub, fill = TRUE)
claims.all.target <- claims.all$target
claims.all[,target := NULL]
claims.all.ID <- claims.all$ID
claims.all[,ID := NULL]


###############################################################################
# Drop useless and tentative columns from Boruta run

claims.all[,v3   := NULL] 
claims.all[,v22  := NULL] 
claims.all[,v52  := NULL] 
claims.all[,v91  := NULL] 
claims.all[,v107 := NULL] 


###############################################################################
# Create some metadata on which columns are ordinal 
# Ordinal have some sense of ordering. Factors are just categories

# cols.factor <- c('v3', 'v22', 'v24', 'v30', 'v31', 'v47', 'v52', 'v56', 'v66', 'v71', 'v74', 
#                  'v75', 'v79', 'v91', 'v107', 'v110', 'v112', 'v113', 'v125')
# cols.ord    <- c('v38', 'v62', 'v72', 'v129')
# 
# # Convert ordinal columns from ints
# claims.all$v38  <- factor(claims.all$v38, ordered = TRUE)
# claims.all$v62  <- factor(claims.all$v62, ordered = TRUE)
# claims.all$v72  <- factor(claims.all$v72, ordered = TRUE)
# claims.all$v129 <- factor(claims.all$v129, ordered = TRUE)
# 
# # Binarize the factors
# claims.all <- cbind(claims.all, model.matrix(~v24  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v30  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v31  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v47  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v56  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v66  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v71  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v74  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v75  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v79  -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v110 -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v112 -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v113 -1, claims.all)[,-1])
# claims.all <- cbind(claims.all, model.matrix(~v125 -1, claims.all)[,-1])

###############################################################################
# Create a matrix of all NA values, use this to pick out blocks of NAs

# claims.all.na <- is.na(claims.all)
# claims.all.na.matrix <- as.matrix(claims.all.na)
# 
# claims.all$v1v2NaSum      <- rowSums(claims.all.na.matrix[,1:2])
# claims.all$v1v2Na         <- rowSums(claims.all.na.matrix[,1:2]) == 2
# claims.all$v3Na           <- claims.all.na.matrix[,3]
# claims.all$v4v9NaSum      <- rowSums(claims.all.na.matrix[,4:9])
# claims.all$v4v9Na         <- rowSums(claims.all.na.matrix[,4:9]) == 6
# claims.all$v11v13NaSum    <- rowSums(claims.all.na.matrix[,11:13])
# claims.all$v11v13Na       <- rowSums(claims.all.na.matrix[,11:13]) == 3
# claims.all$v15v20NaSum    <- rowSums(claims.all.na.matrix[,15:20])
# claims.all$v15v20Na       <- rowSums(claims.all.na.matrix[,15:20]) == 6
# claims.all$v23Na          <- claims.all.na.matrix[,23]
# claims.all$v25v29NaSum    <- rowSums(claims.all.na.matrix[,25:29])
# claims.all$v25v29Na       <- rowSums(claims.all.na.matrix[,25:29]) == 5
# claims.all$v31Na          <- claims.all.na.matrix[,31]
# claims.all$v32v37NaSum    <- rowSums(claims.all.na.matrix[,32:37])
# claims.all$v32v37Na       <- rowSums(claims.all.na.matrix[,32:37]) == 6
# claims.all$v39Na          <- claims.all.na.matrix[,39]
# claims.all$v41v46NaSum    <- rowSums(claims.all.na.matrix[,41:46])
# claims.all$v41v46Na       <- rowSums(claims.all.na.matrix[,41:46]) == 6
# claims.all$v47Na          <- claims.all.na.matrix[,47]
# claims.all$v48v51NaSum    <- rowSums(claims.all.na.matrix[,48:51])
# claims.all$v48v51Na       <- rowSums(claims.all.na.matrix[,48:51]) == 4
# claims.all$v52Na          <- claims.all.na.matrix[,52]
# claims.all$v53v55NaSum    <- rowSums(claims.all.na.matrix[,53:55])
# claims.all$v53v55Na       <- rowSums(claims.all.na.matrix[,53:55]) == 3
# claims.all$v56Na          <- claims.all.na.matrix[,56]
# claims.all$v57v61NaSum    <- rowSums(claims.all.na.matrix[,57:61])
# claims.all$v57v61Na       <- rowSums(claims.all.na.matrix[,57:61]) == 5
# claims.all$v62Na          <- claims.all.na.matrix[,62]
# claims.all$v66Na          <- claims.all.na.matrix[,66]
# claims.all$v67v70NaSum    <- rowSums(claims.all.na.matrix[,67:70])
# claims.all$v67v70Na       <- rowSums(claims.all.na.matrix[,67:70]) == 4
# claims.all$v71Na          <- claims.all.na.matrix[,71]
# claims.all$v72Na          <- claims.all.na.matrix[,72]
# claims.all$v73Na          <- claims.all.na.matrix[,73]
# claims.all$v76v78NaSum    <- rowSums(claims.all.na.matrix[,76:78])
# claims.all$v76v78Na       <- rowSums(claims.all.na.matrix[,76:78]) == 3
# claims.all$v79Na          <- claims.all.na.matrix[,79]
# claims.all$v80v90NaSum    <- rowSums(claims.all.na.matrix[,80:90])
# claims.all$v80v90Na       <- rowSums(claims.all.na.matrix[,80:90]) == 11
# claims.all$v91Na          <- claims.all.na.matrix[,91]
# claims.all$v92v106NaSum   <- rowSums(claims.all.na.matrix[,92:106])
# claims.all$v92v106Na      <- rowSums(claims.all.na.matrix[,92:106]) == 15
# claims.all$v107Na          <- claims.all.na.matrix[,107]
# claims.all$v108v109NaSum  <- rowSums(claims.all.na.matrix[,108:109])
# claims.all$v108v109Na     <- rowSums(claims.all.na.matrix[,108:109]) == 2
# claims.all$v110Na          <- claims.all.na.matrix[,110]
# claims.all$v111v113NaSum  <- rowSums(claims.all.na.matrix[,111:113])
# claims.all$v111v113Na     <- rowSums(claims.all.na.matrix[,111:113]) == 3
# claims.all$v114v124NaSum  <- rowSums(claims.all.na.matrix[,114:124])
# claims.all$v114v124Na     <- rowSums(claims.all.na.matrix[,114:124]) == 11
# claims.all$v126v128NaSum  <- rowSums(claims.all.na.matrix[,126:128])
# claims.all$v126v128Na     <- rowSums(claims.all.na.matrix[,126:128]) == 3
# claims.all$v130v131NaSum  <- rowSums(claims.all.na.matrix[,130:131])
# claims.all$v130v131Na     <- rowSums(claims.all.na.matrix[,130:131]) == 2



###############################################################################
# Replacing missing values - what to try?
# Amelia imputation
# Replace with -1
# Replace with the median

claims.all[is.na(claims.all)] <- -1



# # First of all remove all rows with NA and factor columns. 
# # Then check for correlation between remaining numeric columns and remove them.
# claims.all.complete <- claims.all[complete.cases(claims.all) == TRUE]
# claims.all.numeric <- claims.all.complete[,c(cols.factor) := NULL]
# correlation <- cor(claims.all.numeric)
# hc <- findCorrelation(correlation, cutoff = 0.9)
# hc <- sort(hc)
# hc
# claims.all <- claims.all[,c(hc) := NULL]

# # Create some utility vectors based on de-correlated data.
# col.names <- sapply(claims.all, names)
# col.types <- sapply(claims.all, class)
# col.factors <- names(col.types[col.types == 'factor'])
# 
# #Amelia section (Imputed missing values)
# max.cores <- parallel::detectCores()
# claims.all.imp <- amelia(claims.all, m = 1, p2s = 1, parallel = 'multicore', ncpus = max.cores-1,
#                                   ords = c('v3', 'v24', 'v30', 'v31', 'v66', 'v71', 
#                                   'v74', 'v75', 'v79', 'v107', 'v110', 'v112', 'v113', 'v125'))
# 
# 
# 
# # Now separate out the submission data, put the target back in training data.
# claims.all <- claims.all.imp$imputations$imp1
claims.all$target <- claims.all.target
claims.all$ID <- claims.all.ID
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



