## Plot 3 creates the required line graph with multiple lines on same graph

## Packages Required (Packages need to be just installed as the code will load them automatically) :-
## 1. Dplyr
## 2. lubridate

library(dplyr)
library(lubridate)

## Check if dataset has already been downloaded; if not then create the required file

filename <- "plotdata.zip"

if (!file.exists(filename)){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, filename, method="curl")
}

if (!file.exists("household_power_consumption")) { 
        unzip(filename) 
}



## Extract the data into a data frame and subset the relevant rows

df <- read.table("household_power_consumption.txt",
                 col.names = c("Date", "Time", "Global_active_power",
                               "Global_reactive_power", "Voltage", "Global_intensity",
                               "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                 colClasses = c(rep("character", 9)),
                 stringsAsFactors = FALSE, na.strings = "?", sep = ";", skip = 1, header = TRUE)

df <- subset(df, df$Date == "1/2/2007" | df$Date == "2/2/2007")



## Merge date and time columns into one and convert the class from string to date
## Convert class of the remaining columns into integer

df <- df %>%
        mutate(Date = paste(Date, Time)) %>%
        select(-Time)

names(df)[1] <- "datetime"

df$datetime <- parse_date_time(df$datetime, "%d/%m/%y %H:%M:%S")

for (col in 2:8){
        df[,col] <- as.numeric(df[,col])
}





## Open png device and add plots from the 3 sub meters

png(filename = "plot3.png", width = 480, height = 480, units = "px")

## Add the first plot using plot() function

plot(df$datetime, df$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")

## Add second and third lines using lines() function

lines(df$datetime, df$Sub_metering_2, type = "l", col = "red")

lines(df$datetime, df$Sub_metering_3, type = "l", col = "blue")

## Add a legend to the graph

legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty = rep(1,3))
dev.off()