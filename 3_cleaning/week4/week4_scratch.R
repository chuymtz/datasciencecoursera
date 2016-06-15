# The American Community Survey distributes downloadable data about United 
# States communities. Download the 2006 microdata survey about housing for  
# the state of Idaho using download.file() from here:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names 
# is here:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Apply strsplit() to split all the names of the data frame on the characters 
# "wgtp". What is the value of the 123 element of the resulting list?

if (!file.exists('data')) {
    dir.create('data')
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = './data/housing.csv')
dateDownloaded <- date()

housing <- read.csv('./data/housing.csv')

splitnames <- strsplit(names(housing), "wgtp")
splitnames[123]

# ASNWER: "" "15"

#------------------------------------------------------------------------------
# Load the Gross Domestic Product data for the 190 ranked countries in this 
# data set:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Remove the commas from the GDP numbers in millions of dollars and average 
# them. What is the average?

# Original data sources:
    
#    http://data.worldbank.org/data-catalog/GDP-ranking-table 

library(dplyr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = './data/gdp.csv')
dateDownloaded <- date()

gdp <- read.csv('./data/gdp.csv')

gdp <- tbl_df(gdp)
gdp <- gdp %>%
    select(X, Gross.domestic.product.2012, X.2, X.3) %>%
    rename(
        country=X, 
        ranking = Gross.domestic.product.2012, 
        Economy = X.2,
        millions = X.3
        ) %>%
    slice(-(1:4)) %>%
    slice(1:190) %>%
    mutate(millions = as.numeric(gsub(",", "", millions))) %>%
    print

mean(gdp$millions)

# Answer: 377652.4

#------------------------------------------------------------------------------
# In the data set from Question 2 what is a regular expression that would allow 
# you to count the number of countries whose name begins with "United"? Assume 
# that the variable with the country names in it is named countryNames. How 
# many countries begin with United? 

begin_w_United <- grepl("^United", gdp$Economy)
table(begin_w_United)

# ANSWER: 3

# 4 ---------------------------------------------------------------------------
# Load the Gross Domestic Product data for the 190 ranked countries in this 
# data set:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. Of the countries for which 
# the end of the fiscal year is available, how many end in June?

# Original data sources:
    
#    http://data.worldbank.org/data-catalog/GDP-ranking-table

#    http://data.worldbank.org/data-catalog/ed-stats

library(dplyr)

urlLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(urlLink, destfile = './gdp.csv')
dateDownloaded <- date()
gdp <- read.csv('./gdp.csv', stringsAsFactors = FALSE)
urlLink <- 
    "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(urlLink, destfile = './edu_Data.csv')
dateDownloaded <- date()
edu_Data <- read.csv('./edu_Data.csv', stringsAsFactors = FALSE)

gdp_df <- tbl_df(data = gdp)
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



edu_Data_df <- tbl_df(data = edu_Data)
edu_Data_df <- edu_Data_df %>%
  filter(CountryCode != "", Special.Notes != "") %>%
  select(CountryCode, Long.Name, Special.Notes)
  print

# Merge the two data frames and clean up. 

new_df <- tbl_df(merge(gdp_df, edu_Data_df, by = c("CountryCode")))
new_df <- new_df %>%
  select(CountryCode, GDP_12, Economy, Special.Notes) %>%
  mutate(GDP_12 = as.numeric(GDP_12)) %>%
  arrange(desc(GDP_12)) %>%
  print

grep("Fiscal year end: June", new_df$Special.Notes, value = TRUE)

# ANSWER: 13

# 5 ---------------------------------------------------------------------------
# You can use the quantmod (http://www.quantmod.com/) package to get historical 
# stock prices for publicly traded companies on the NASDAQ and NYSE. Use the 
# following code to download data on Amazon's stock price and get the times 
# the data was sampled.

install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
dim(amzn)

# How many values were collected in 2012? How many values were collected on 
# Mondays in 2012?

library(lubridate)
library(dplyr)

sum(year(sampleTimes) == 2012)

w_days <- wday(sampleTimes[years == 2012], label=TRUE)
sum(w_days == "Mon")


# ANSWER: 250, 47