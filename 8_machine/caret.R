# The R Caret package

# preprocessing, spliting, training/testing, etc

# Examples of algorithms: regression naive bayes, support vector machines, etc



install.packages('caret', dependencies = TRUE)
library(caret)
install.packages('kernlab')
library(kernlab)

data("spam")

# DATA SPLITTING

inTrain <- createDataPartition(spam$type,
                               p=0.75,
                               list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

# FIT A MODEL

set.seed(32343)
modelFit <- train(type~., 
                  data=training, 
                  method='glm')
modelFit

# FINAL MODEL

modelFit$finalModel

# PREDICTION

predictions <- predict(modelFit, newdata=testing)
predictions

# CONFUSION MATRIX

conf_mat <- confusionMatrix(predictions, testing$type)

#----------------------------------------------------------------------------
#----------NOW IN MORE DETAIL=========--------------------
#----------------------------------------------------------------------------


# Let's discuss data splicing in detail

install.packages('caret', dependencies = TRUE)
library(caret)
install.packages('kernlab')
library(kernlab)

data("spam")

inTrain <- createDataPartition(spam$type,
                               p=0.75,
                               list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

# How to do cross-validation

set.seed(32323)
folds <- createFolds(spam$type, 
                     k=10, 
                     list=TRUE,
                     returnTrain=TRUE)
sapply(folds,length)

# For resampling/boostrapping

set.seed(32323)
folds <- createResample(spam$type,
                        times=10,
                        list=TRUE)
sapply(folds, length)

# For Time Slices

set.seed(32323)
tme <- 1:1000
folds <- createTimeSlices(tme, 
                          initialWindow=20,
                          horizon=10)
names(folds)

#----------------------------------------------------------------------------
#----------TRAINING   =========--------------------
#----------------------------------------------------------------------------


install.packages('caret', dependencies = TRUE)
library(caret)
install.packages('kernlab')
library(kernlab)

data("spam")

inTrain <- createDataPartition(spam$type,
                               p=0.75,
                               list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

modelFit <- train(type~., 
                  data=training, 
                  method='glm')

# some other default options for train function

args(train.default)

# metric options: continuous outcomes would be
#                 RMSE or RSquared
# mtric  options: discrete/categorical would be
#                 accuracy or kappa( for kaggle)

# trainControl allows to choose method in resampling, 
#     number of bootstraps or repeats of that repeated
#     of crossvalidation.

# The larger the data the better to learn better
# trainControl options


#----------------------------------------------------------------------------
#----------PLOTTING   =========--------------------
#----------------------------------------------------------------------------

install.packages('ISLR')
library(ISLR)
install.packages('ggplot2')
library(ggplot2)
install.packages('caret', dependencies = TRUE); 
library(caret)

data('Wage')
summary(Wage)

inTrain <- createDataPartition(Wage$wage,
                               p=0.7,
                               list=FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

dim(training); dim(testing)

featurePlot(training[, c('age','education','jobclass')],
            training$wage,
            plot='pairs')

qplot(age, wage, colour=jobclass,data=training)
qq <- qplot(age, wage, colour=education,data=training)
qq
qq+geom_smooth(method='lm', formula = y~x)

# one can cut variable into different categories

install.packages('Hmisc')
library(Hmisc)
cutWage <- cut2(training$wage, g=3)
cutAge <- cut2(training$age, g=3)
table(cutWage)

# so now can vizualize data vs different wage groups
p1 <- qplot(cutWage, 
            age, 
            data=training, 
            fill=cutWage,
            geom=c('boxplot')); p1

p2 <- qplot(cutWage, 
            age, 
            data=training, 
            fill=cutWage,
            geom=c('boxplot','jitter')); p2
grid.arrange(p1,p2,ncol=2)

p3 <- qplot(cutAge, 
            wage, 
            data=training, 
            fill=cutAge,
            geom=c('boxplot')); p3

# look at tables of data:

t1 <- table(cutWage, training$jobclass); t1

prop.table(t1,1)

# Density plots!

qplot(wage,
      colour=education,
      data=training,
      geom = 'density')

#----------------------------------------------------------------------------
#----------PREPROCESSING   =========--------------------
#----------------------------------------------------------------------------

# why? 

install.packages('caret', dependencies = TRUE); 
library(caret)
install.packages('kernlab')
library(kernlab)

data("spam")

inTrain <- createDataPartition(spam$type,
                               p=0.75,
                               list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]
hist(training$capitalAve,
     main = '',
     xlab = 'ave.capital run length')

mean(training$capitalAve)
sd(training$capitalAve)

# must standarize the variables

trainCapAve <- training$capitalAve
trainCapAveS <- (trainCapAve-mean(trainCapAve))/sd(trainCapAve)

mean(trainCapAveS)
sd(trainCapAveS)

mean(testing$capitalAve)
sd(testing$capitalAve)

testCapAve <- testing$capitalAve
testCapAveS <- (testCapAve-mean(trainCapAve))/sd(trainCapAve)

mean(testCapAveS)
sd(testCapAveS)

# some preprocess functions from caret package

preObj <- preProcess(training[,-58],
                     method=c('center','scale'))
trainCapAveS <- predict(preObj,
                        training[,-58])$capitalAve
mean(trainCapAveS)
sd(trainCapAveS)

testCapAveS <- predict(preObj,
                       testing[,-58])$capitalAve
mean(testCapAveS)
sd(testCapAveS)

# can do all at once in train function



#----------------------------------------------------------------------------
#----------COVARIATE CREATION   =========--------------------
#----------------------------------------------------------------------------

# level 1: From raw to covariate

# level 2: trasformaing tidy covariates

library(kernlab)
data(spam)
spam$capitalAveSq <- spam$capitalAve^2

# level 1:
# The balancing act is summarization vs information loss

# level 2: tidy covariates  for new covariates
# more necessary for regression or svms methods
# than other classification tress me;thods
# 
# Should be done only on training set
#
# best approach through exploratory analysis
#
# new covariates should be added to data frames
#
#
library(ISLR)
data(Wage)
inTrain <- createDataPartition(Wage$wage,
                               p=0.7,
                               list=FALSE)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]

# BASIC IDEA

# turn factors to indicators

table(training$jobclass)
dummies <- dummyVars(wage~jobclass,
                     data=training)
head(predict(dummies, newdata=training))

# remove zero covariates

nsv <- nearZeroVar(training, saveMetrics=TRUE)
nsv

# apply splines: usually for regression 

library(splines)
bsBasis <- bs(training$age, df=3)
bsBasis








