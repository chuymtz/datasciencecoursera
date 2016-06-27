# Example of Machine Learning algorithm using "Random Forest" method
# with R's carot package.

# MAIN IDEA
#
#   * Bootstrap samples
#   * At each split, bootstrap variables
#   * grow multiple tress and vote
#   
# Very accurate, slow, hard to interpret, leads to 
# overfitting

# load iris data and copare to decision_trees.R

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

# Do a model fit
modFit <- train(Species~.,
                method="rf",
                data=training,
                prox=TRUE)
modFit

# Look at specific tree
getTree(modFit$finalModel, k=2)

# Look at center of class' prediction
irisP <- classCenter(training[,c(3,4)],
                     training$Species,
                     modFit$finalModel$prox)
irisP <- as.data.frame(irisP)
irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, 
           col=Species,
           data=training)
p+geom_point(aes(x=Petal.Width, y=Petal.Length,
                 col=Species),
             size=5,
             shape=4,
             data=irisP)


# Ready for predictions

pred <- predict(modFit, testing)
testing$predRight <- pred==testing$Species
table(pred, testing$Species)

# Plot where are the wrong predictions

qplot(Petal.Width, Petal.Length,
      colour=predRight,
      data=testing,
      main="new data preds")

























