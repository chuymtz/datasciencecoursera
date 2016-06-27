# Example of Machine Learning algorithm using "Decision trees"
# with R's carot package.

# MAIN IDEAS
#
#   *Iteratively split variables into groups
#   *Eval homogeneity with each group
#   *Split again if necessary

# BASIC ALGORITHM
#
#   1.- Start with all variables in one group
#   2.- Find variable that best separates outcomes
#   3.- Divide data into two leaves on that node.
#   4.- Within each node, find best variables that separates outcomes
#   5.- Continue until the groups are too small or suff pure

# MEASURE OF IMPURITY
#
#   \hat{p}_{mk}=\frac{1}{N_m}\sum_{xi in Leaf m}Xi_{y_i=k}
#
#   Misclassification error:
#       1- \hat{p}_{mk}
#
# 0 is perfect purity and 0.5 if no purity.

# Use the iris data

data(iris)
install.packages('ggplot2')
install.packages('caret', dependencies = TRUE)
library(ggplot2)
library(caret)

# Variable names
names(iris)

# Find how many obs of each species
table(iris$Species)

# We try to predict species

# Split the data into training and testing
inTrain <- createDataPartition(iris$Species,
                               p=0.7,
                               list=FALSE)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

# Next plot training data by sepal&petal width
# color by species
qplot(Petal.Width, Sepal.Width,
      colour=Species,
      data=training)

# Do a model fit
modFit <- train(Species~.,
                method="rpart",
                data=training)
print(modFit$finalModel)

# Take a look at classification tree
plot(modFit$finalModel,
     uniform=TRUE,
     main="Classification Tree")
text(modFit$finalModel,
     use.n = TRUE,
     all = TRUE,
     cex = 0.8)

# Now make prediction on testing data
preds <- predict(modFit, newdata = testing)

# check how many wrong predictions and where they appear
sum(preds != testing$Species)
which(preds != testing$Species)




















