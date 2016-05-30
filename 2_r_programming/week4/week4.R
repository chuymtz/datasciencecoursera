#################
outcome <- read.csv("outcome-of-care-measures.csv", 
                    colClasses = "character", nrows = 4710L)

head(outcome)
ncol(outcome)
nrow(outcome)
names(outcome)
str(outcome)
summary(outcome)

outcome[, 11] <- as.numeric(outcome[, 11])
head(outcome[, 11])
hist(outcome[, 11])

#################