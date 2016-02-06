library(nycflights13)
library(data.table)
head(flights)
max(flights$day, na.rm = TRUE)
flights <- data.table(flights)
flights$depart_date <- as.Date(paste(flights$year, flights$month, flights$day,sep='-'),format="%Y-%m-%d")

mindate <- min(flights$depart_date, na.rm = TRUE)
maxdate <- max(flights$depart_date, na.rm = TRUE)

flights$DayOfWeek <- weekdays(flights$depart_date)

flights$DistanceKMs <- flights$distance / 0.62137
flights$depart_time <- paste(flights$hour,flights$minute,sep=':')


#enrich origin airport

#enrich dest airport

#enrich airlines / carrier

#enrich planes by tailnum

#enrich weather by origin+ date


#1: list flights in range of distance on the given date range -> table

#2: show histogram by destination count for date range

#3: show average delays by distance -> scatter plot -> fit
head(weather)

head(flights)

