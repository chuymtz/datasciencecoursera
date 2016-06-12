# The American Community Survey distributes downloadable data about United  
# States communities. Download the 2006 microdata survey about housing for the 
# state of Idaho using download.file() from here:
    
urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

# and load the data into R. 

download.file(urlLink, destfile = './housing.csv')
dateDownloaded <- date()

housing <- read.csv('./housing.csv', header = TRUE, nrows = 6496L)

#The code book, describing the variable names is here:
    
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Create a logical vector that identifies the households on greater than 
# 10 acres who sold more than $10,000 worth of agriculture products. Assign 
# that logical vector to the variable agricultureLogical. Apply the which() 
# function like this to identify the rows of the data frame where the logical 
# vector is TRUE.

head(housing[, 1:14])

str(housing)
summary(housing)    

# households on greater than 10 acres means ACR == 3
# households that sold more than $10,000 worth of ag prods means AGS==6

agricultureLogical <- housing$ACR==3 & housing$AGS==6


which(agricultureLogical)
length(which(agricultureLogical))

# What are the first 3 values that result? 

# ANSWER: 125, 238, 262


## ----------------------------------------------------------------------------

# Using the jpeg package read in the following picture of your instructor 
# into R

#   https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
# resulting data? (some Linux systems may produce an answer 638 different for 
# the 30th quantile)


install.packages('jpeg')
library(jpeg)

urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(urlLink, destfile = './jeff.jpg')
dateDownloaded <- date()

# Must use the function readJPEG which has the 'native' option st result is a 
# native raster representatio

jeff <- readJPEG('./jeff.jpg', native = TRUE)

# Find the quantiles

quant <- quantile(jeff, c(.3, .8))
quant

# ANSWER: -15259150 -10575416 

## ----------------------------------------------------------------------------

# Load the Gross Domestic Product data for the 190 ranked countries in this 
# data set:
    
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:
    
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. 
# How many of the IDs match? Sort the data frame in descending order by GDP 
# rank (so United States is last). What is the 13th country in the resulting 
# data frame?

# Original data sources:
    
#   http://data.worldbank.org/data-catalog/GDP-ranking-table

#   http://data.worldbank.org/data-catalog/ed-stats

library(dplyr)

urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(urlLink, destfile = './gdp.csv')
dateDownloaded <- date()
gdp <- read.csv('./gdp.csv', stringsAsFactors = FALSE)

gdp_df <- tbl_df(data = gdp)

# I will practice pipe operator to clean gpd data frame.

gdp_df <- gdp_df %>%
    select(c(1, 2, 4, 5)) %>%
    rename(CountryCode=X, 
           GDP_12=Gross.domestic.product.2012, 
           Economy=X.2,
           millions_dollars=X.3) %>%
    slice(5:194) %>%
    filter(CountryCode != "") %>%
    mutate(GDP_12 = as.numeric(GDP_12)) %>%
    print

urlLink <- 
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(urlLink, destfile = './edu_Data.csv')
dateDownloaded <- date()
edu_Data <- read.csv('./edu_Data.csv', stringsAsFactors = FALSE)

edu_Data_df <- tbl_df(data = edu_Data)
edu_Data_df <- edu_Data_df %>%
    filter(CountryCode != "") %>%
    print

# Merge the two data frames and clean up. 

new_df <- tbl_df(merge(gdp_df, edu_Data_df, by = c("CountryCode")))
new_df <- new_df %>%
    select(CountryCode, GDP_12, Economy) %>%
    filter(GDP_12 != "") %>%
    mutate(CountryCode = unique(CountryCode)) %>%
    mutate(GDP_12 = as.numeric(GDP_12)) %>%
    arrange(desc(GDP_12)) %>%
    print

length(unique(new_df$CountryCode))
new_df[13,]

# Answer: 189 matches
# Answer: St. Kitts and Nevis


## ----------------------------------------------------------------------------

# What is the average GDP ranking for the "High income: OECD" and "High 
# income: nonOECD" group? 


urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(urlLink, destfile = './gdp.csv')
dateDownloaded <- date()
gdp <- read.csv('./gdp.csv', stringsAsFactors = FALSE)
gdp_df <- tbl_df(data = gdp)

urlLink <- 
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(urlLink, destfile = './edu_Data.csv')
dateDownloaded <- date()
edu_Data <- read.csv('./edu_Data.csv', stringsAsFactors = FALSE)
edu_Data_df <- tbl_df(data = edu_Data)

gdp_df <- gdp_df %>%
    select(c(1, 2, 4, 5)) %>%
    rename(CountryCode=X, 
           GDP_12=Gross.domestic.product.2012, 
           Economy=X.2,
           millions_dollars=X.3) %>%
    slice(5:194) %>%
    filter(CountryCode != "") %>%
    mutate(GDP_12 = as.numeric(GDP_12)) %>%
    print

edu_Data_df <- edu_Data_df %>%
    filter(CountryCode != "") %>%
    print

new_df <- tbl_df(merge(gdp_df, edu_Data_df, by = c("CountryCode")))
new_df <- new_df %>%
    select(CountryCode, GDP_12, Economy, Income.Group) %>%
    filter(GDP_12 != "") %>%
    mutate(CountryCode = unique(CountryCode)) %>%
    mutate(GDP_12 = as.numeric(GDP_12)) %>%
    arrange(desc(GDP_12)) %>%
    print

high <- filter(new_df, Income.Group == 'High income: OECD')
mean(high$GDP_12)

low <- filter(new_df, Income.Group == 'High income: nonOECD')
mean(low$GDP_12)

# Answer: 32.96667, 91.91304



# ----------------------------------------------------------------------------



# Cut the GDP ranking into 5 separate quantile groups. Make a table 
# versus Income.Group. How many countries are Lower middle income but among 
# the 38 nations with highest GDP?


urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(urlLink, destfile = './gdp.csv')
dateDownloaded <- date()
gdp <- read.csv('./gdp.csv', stringsAsFactors = FALSE)
gdp_df <- tbl_df(data = gdp)

urlLink <- 
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(urlLink, destfile = './edu_Data.csv')
dateDownloaded <- date()
edu_Data <- read.csv('./edu_Data.csv', stringsAsFactors = FALSE)
edu_Data_df <- tbl_df(data = edu_Data)

gdp_df <- gdp_df %>%
    select(c(1, 2, 4, 5)) %>%
    rename(CountryCode=X, 
           GDP_12=Gross.domestic.product.2012, 
           Economy=X.2,
           millions_dollars=X.3) %>%
    slice(5:194) %>%
    filter(CountryCode != "") %>%
    mutate(GDP_12 = as.numeric(GDP_12)) %>%
    print

edu_Data_df <- edu_Data_df %>%
    filter(CountryCode != "") %>%
    print

new_df <- tbl_df(merge(gdp_df, edu_Data_df, by = c("CountryCode")))
new_df <- new_df %>%
    select(CountryCode, GDP_12, Economy, Income.Group) %>%
    filter(GDP_12 != "") %>%
    mutate(CountryCode = unique(CountryCode)) %>%
    mutate(GDP_12 = as.numeric(GDP_12)) %>%
    arrange(GDP_12) %>%
    print

# There's no need to cut into quantiles since alrady ordered.

quantile(new_df$GDP_12)
new_df$GDP_12 <- cut(new_df$GDP_12, quantile(new_df$GDP_12))
new_df[GDP_12 == "Lower middle income", .N, by = c("Income.Group", "GDP_12")]

new_df %>%
    slice(1:38) %>%
    filter(Income.Group == 'Lower middle income') %>%
    print

# Answer: 5







