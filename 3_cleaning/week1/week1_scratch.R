## Problem 1 The American Community Survey distributes downloadable data 
## about United States communities. Download the 2006 microdata survey 
## about housing for the state of Idaho using download.file() from here:

## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

## and load the data into R. The code book, describing the variable names is here:
  
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

## How many properties are worth $1,000,000 or more?

if (!file.exists('data')) {
  dir.create('data')
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = './data/cameras.csv')
dateDownloaded <- date()

cameraData <- read.csv('./data/cameras.csv')


head(cameraData)
str(cameraData)
prop_value <- cameraData$VAL
str(prop_value)
length(prop_value)
complete_prop_value <- prop_value[complete.cases(prop_value)]
length(complete_prop_value)
sum(complete_prop_value >= 24)

## Below vector has more than one variable.... family type and employment status

fam_type <- cameraData$FES
head(fam_type)

##### PROBLEM 3 #############################################################

if(!file.exists('data')){
  dir.create('data')
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = './data/cameras.xlsx', mode = 'wb')
dataDownloaded <- data()
## If needed install package xlsx
install.packages('xlsx')
library(xlsx)

cameraData <- read.xlsx('./data/cameras.xlsx', sheetIndex = 1,  header = TRUE)
head(cameraData)

dat <- read.xlsx('./data/cameras.xlsx', 
                              sheetIndex = 1, 
                              header = TRUE, 
                              colIndex = 7:15, 
                              rowIndex = 18:23)

sum(dat$Zip*dat$Ext,na.rm=T)

head(dat$Zip*dat$Ext)


##### PROBLEM 4 #############################################################

install.packages('XML')
library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode[[1]][[1]][[2]])

zips <- xpathSApply(rootNode, "//zipcode", xmlValue)
head(zips)
sum(zips == 21231)


##### PROBLEM 5 #############################################################

install.packages('data.table')
library(data.table)

if (!file.exists('data')) {
  dir.create('data')
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = './data/file.csv')
dateDownloaded <- date()

DT <- fread('./data/file.csv', sep = ",")
class(DT)

#wrong
sapply(split(DT$pwgtp15,DT$SEX),mean)
system.time({
  sapply(split(DT$pwgtp15,DT$SEX),mean)
})

mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
system.time({
  mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
})

rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
system.time({
  rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
})

#wrong
mean(DT$pwgtp15,by=DT$SEX)
system.time({
  mean(DT$pwgtp15,by=DT$SEX)
})

# CORRECT!
DT[,mean(pwgtp15),by=SEX]
system.time({
  DT[,mean(pwgtp15),by=SEX]
})

#wrong
tapply(DT$pwgtp15,DT$SEX,mean)
system.time({
  tapply(DT$pwgtp15,DT$SEX,mean)
})
















