# Example of Machine Learning algorithm using "Bootstrap aggregating"
#  or "Bagging" with R's carot package.

# MAIN IDEA
#
#   1. Resample cases and recalculate predictions
#   2. Average or majority vote
#
# Similar bias, reduced variance, good for nonlinear

# Use the ozone data

install.packages('ElemStatLearn')
install.packages('caret', dependencies = TRUE)
library(ElemStatLearn)
library(caret)

data(ozone, package="ElemStatLearn")
ozone <- ozone[order(ozone$ozone), ]
head(ozone)

# We want to predict temperature as function of ozone

#  BAGGED LOESS

# init matrix of 10 rows and 155 cols 
ll <- matrix(NA, nrow = 10, ncol = 155)

# 
for (i in 1:10){
    # resample with replacement
    ss <- sample(1:dim(ozone)[1], replace=TRUE)
    # resampled data sample at i
    ozone0 <- ozone[ss,]
    # reorder by ozone
    ozone0 <- ozone0[order(ozone0$ozone), ] 
    # fit loess curve (like splines)
    loess0 <- loess(temperature~ozone,
                    data = ozone0,
                    span = 0.2)
    # make preduction for this resampled data on 
    ll[i,] <- predict(loess0,
                      newdata = data.frame(ozone=1:155))
}

# make a plot of fitted curve

# plot the points
plot(ozone$ozone, ozone$temperature,
     pch=19,
     cex=0.5)

# put each curve
for (i in 1:10) {
    lines(1:155,
          ll[i,],
          col='grey',
          lwd=2)
}

# now include the loess curve
lines(1:155, apply(ll,2,mean), 
      col='red',
      lwd=2)

mean_pred <- apply(ll,2,mean)


