#https://github.com/hadley/httr/blob/master/demo/oauth2-github.r

install.packages("httpuv")
install.packages("httr")
library(jsonlite)
library(httpuv)
library(httr)
oauth_endpoints("github")

myapp = oauth_app('githut',
                  key="63157c5462bd2257b128",
                  secret="3422f3e16fe3293ad899305b6d06ea4b88266104")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)

linkUrl <-"https://api.github.com/users/jtleek/repos"
req <- GET(linkUrl, gtoken)
stop_for_status(req)
content(req)

json1 <- content(req)
json2 <- jsonlite::fromJSON(toJSON(json1))
json2

index <- match('datasharing', json2$name)

json2$created_at[[index]]

#################################################################


install.packages("sqldf")
library(sqldf)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = 'acs.csv')
dateDownloaded <- date()

acs <- read.csv('acs.csv', nrows = 239L, header = TRUE)
v1 <- acs$pwgtp1[acs$AGEP < 50]

library(tcltk)
sql1 <- sqldf("select * from acs")
sql2 <- sqldf("select * from acs where AGEP < 50 and pwgtp1")
sql3 <- sqldf("select pwgtp1 from acs where AGEP < 50") #THIS ONE
sql4 <- sqldf("select pwgtp1 from acs")

#################################################################

v2 <- unique(acs$AGEP)

sql3_1 <- sqldf("select AGEP where unique from acs")
sql3_2 <- sqldf("select distinct pwgtp1 from acs")
sql3_3 <- sqldf("select distinct AGEP from acs") # THIS ONE
sql3_4 <- sqldf("select unique AGEP from acs")

head(sql3_3)

#################################################################

con <- url('http://biostat.jhsph.edu/~jleek/contact.html')
htmlCode = readLines(con)
close(con)

lines <- c(10, 20, 30, 100)
htmlCode[10]

for (i in lines) {
  x <- nchar(htmlCode[i])
  print(x)
}


#################################################################


fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
download.file(fileUrl, destfile = 'for_file.csv')
dateDownloaded <- date()

# From instrunctions, i need 9 columns
#
# " 03JAN1990     23.4-0.4     25.1-0.3     26.6 0.0     28.6 0.3"
#
# 1 empty -> -1
# 9 chars -> 9
# 5 empty -> -5
# 4 chars -> 4
# 4 chars -> 4
# 5 empty -> -5
# 4 chars -> 4
# 4 chars -> 4
# 5 empty -> -5
# 4 chars -> 4
# 4 chars -> 4
# 5 empty -> -5
# 4 chars -> 4
# 4 chars -> 4

col_width <- c(-5, 4, 4)
w <- c(-1, 9, col_width, col_width, col_width, col_width)
for_file <- read.fwf('for_file.csv', widths = w, skip=4)

sum(for_file$V4)


























