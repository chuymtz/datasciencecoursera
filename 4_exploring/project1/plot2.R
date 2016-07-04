fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists('data')) dir.create('data')
download.file(fileUrl, destfile = './data/powerdata.zip')
unzip('./data/powerdata.zip', exdir = './data')

library(dplyr)
library(lubridate)

power <- tbl_df(read.table(
    './data/household_power_consumption.txt',
    header = TRUE,
    sep = ';',
    na.strings = '?',
    nrows = 2075260L))

power <- power %>%
    mutate(date = dmy(Date)) %>%
    mutate(time = hms(Time)) %>%
    filter(year(date) == 2007) %>%
    filter(month(date)==2) %>%
    filter(day(date) %in% c(1, 2)) %>%
    mutate(DateTime=paste(Date, Time, sep=" "))%>%
    select(DateTime, date, time, Global_active_power:Sub_metering_3) %>%
    print
power$DateTime <- strptime(power$DateTime,"%d/%m/%Y %H:%M:%S")


# Plot 2 ------------------------------

plot(power$DateTime, power$Global_active_power, 
     type='l', 
     col='black', 
     xlab='', 
     ylab='Global Active Power (kilowatts)')
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()



















