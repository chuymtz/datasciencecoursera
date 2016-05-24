head(airquality)
str(airquality)

s <- split(airquality, airquality$Month)
sapply(s, function(x) colMeans(x[, c('Ozone', 'Wind')], na.rm = TRUE))

#------------------#------------------#------------------
library(datasets)
data('iris')

index <- iris$Species == 'virginica'
mean(iris$Sepal.Length[index] )

str(iris)

rowMeans(iris[, 1:4]) #no

apply(iris[, 1:4], 2, mean) # yes

apply(iris[, 1:4], 1, mean) #no

colMeans(iris) #no

apply(iris, 2, mean)#no

apply(iris, 1, mean) #no

rm(list=ls(all=TRUE)) 

------------------#------------------#------------------
library(datasets)
data(mtcars)

?mtcars

##############################
sapply(mtcars, cyl, mean) #no

apply(mtcars, 2, mean) #no

sapply(split(mtcars$mpg, mtcars$cyl), mean) #yes

split(mtcars, mtcars$cyl) #no

with(mtcars, tapply(mpg, cyl, mean)) #yes

lapply(mtcars, mean) #no

tapply(mtcars$cyl, mtcars$mpg, mean) #no

tapply(mtcars$mpg, mtcars$cyl, mean) #yes

mean(mtcars$mpg, mtcars$cyl) #no

rm(list=ls(all=TRUE)) 

#------------------#------------------#------------------

library(datasets)
data(mtcars)

v <- tapply(mtcars$hp, mtcars$cyl, mean)
    
v[[3]] - v[[1]]    
    
class(v)
    
    
    
    
    
    
    




