# Source this file first ! It does the following
#
# 1. Loads the train.csv and test.csv files using the fast data.table
# 2. Converts the columns in the file to an appropriate type
# 3. Removes highly correlated columns in the data structure.
# 4. Creates new features using NAs (based on NMAR assumptions)
# 5. Imputes missing NA features for later modelling

library("data.table")
# library("mice")
# library("VIM")
library("Amelia")
# library("caret")
library("corrgram")
# library("multicore")

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# tim : Need to change directory 
setwd("/Users/tim/Dropbox/projects/kaggle/2016_04_bnp_paribas/scripts/R")

# Read the training and the test data in and print summary
# system.time(claims.data.read.csv <- read.csv("../../data/train.csv")) # Takes 23.3s
system.time(claims.data <- fread("../../data/train.csv", header = T, sep = ",", stringsAsFactors = TRUE)) # Wow 1.2s !!
system.time(claims.sub  <- fread("../../data/test.csv", header = T, sep = ",", stringsAsFactors = TRUE)) # Wow 1.2s !!
# all.equal(claims.data.read.csv, claims.data.fread)


# Create some metadata on which columns are ordinal 
cols.ord   <- c('v3', 'v22', 'v24', 'v30', 'v31', 'v38', 'v47', 'v52', 'v56', 'v62', 'v66', 'v71', 'v72', 'v74', 'v75', 'v79', 'v91', 'v107', 'v110', 'v112', 'v113', 'v125')
amelia.ord <- c('v3', 'v22', 'v24', 'v30', 'v31',        'v47', 'v52', 'v56',        'v66', 'v71',        'v74', 'v75', 'v79', 'v91', 'v107', 'v110', 'v112', 'v113', 'v125')


col.names <- sapply(claims.data, names)
col.types <- sapply(claims.data, class)


# First of all remove all rows with NA
claims.data.complete <- claims.data[complete.cases(claims.data) == TRUE]


claims.data.numeric <- claims.data.complete


# Hack to get rid of factors too
claims.data.numeric$v3 <- NULL
claims.data.numeric$v22 <- NULL
claims.data.numeric$v24 <- NULL
claims.data.numeric$v30 <- NULL
claims.data.numeric$v31 <- NULL
claims.data.numeric$v47 <- NULL
claims.data.numeric$v52 <- NULL
claims.data.numeric$v56 <- NULL
claims.data.numeric$v66 <- NULL
claims.data.numeric$v71 <- NULL
claims.data.numeric$v74 <- NULL
claims.data.numeric$v74 <- NULL
claims.data.numeric$v75 <- NULL
claims.data.numeric$v79 <- NULL
claims.data.numeric$v91 <- NULL
claims.data.numeric$v107 <- NULL
claims.data.numeric$v110 <- NULL
claims.data.numeric$v112 <- NULL
claims.data.numeric$v113 <- NULL
claims.data.numeric$v125 <- NULL


correlation <- cor(claims.data.numeric)
summary(correlation)

# corrgram(correlation)

hc <- findCorrelation(correlation, cutoff = 0.9)
hc <- sort(hc)
hc

reduced.data <- claims.data[,c(hc) := NULL]
claims.data <- reduced.data

# Some variables don't change in the dataset !
# 
# claims.data[,cols.ord] <- as.factor(claims.data[,cols.ord])

summary(claims.data)
str(claims.data)

# Simple (probably bad) approach to NA's. Just drop any line containing them.
# claims.data.complete <- claims.data.fread[complete.cases(claims.data.fread) == TRUE]

# Remove ID and dependent variable, reduce to just 100 observations
# claims.data$ID <- NULL
# claims.data$target <- NULL
claims.data <- data.frame(claims.data)
claims.data.small <- claims.data[1:1000,]

#Amelia II section
claims.data.small.imp <- amelia(claims.data, m = 5, p2s = 1, parallel = 'multicore', ncpus = 4, 
                                idvars = c('ID', 'target'), 
                                ords = c('v3', 'v24', 'v30', 'v31', 'v66', 'v71', 'v74', 'v75', 
                                         'v79', 'v107', 'v110', 'v112', 'v113', 'v125'))

claims.data <- claims.data.small.imp$imputations$imp1

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



