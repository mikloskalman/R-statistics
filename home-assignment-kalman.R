library(nycflights13)
library(data.table)
library(ggplot2)

#head(flights)

flights <- data.table(flights)
flights$depart_date <- as.Date(paste(flights$year, flights$month, flights$day,sep='-'),format="%Y-%m-%d")

mindate <- min(flights$depart_date, na.rm = TRUE)
maxdate <- max(flights$depart_date, na.rm = TRUE)

flights$DayOfWeek <- weekdays(flights$depart_date)

flights$DistanceKMs <- flights$distance / 0.62137
flights$depart_time <- paste(flights$hour,flights$minute,sep=':')




flights <- merge(flights, airports, by.x = 'dest', by.y = 'faa')
names(flights)[21]<-"dest_airport_name"
names(flights)[22]<-"dest_lat"
names(flights)[23]<-"dest_lon"
names(flights)[24]<-"dest_alt"
names(flights)[25]<-"dest_tz"
names(flights)[26]<-"dest_dst"
flights <- merge(flights, airlines, by.x = 'carrier', by.y = 'carrier')
names(flights)[27]<-"carrier_name"

flights <- merge(flights, airports, by.x = 'origin', by.y = 'faa')
names(flights)[28]<-"origin_airport_name"
names(flights)[29]<-"origin_lat"
names(flights)[30]<-"origin_lon"
names(flights)[31]<-"origin_alt"
names(flights)[32]<-"origin_tz"
names(flights)[33]<-"origin_dst"


flights <- merge(flights, planes, by.x = 'tailnum', by.y = 'tailnum')


names(flights)[34]<-"plane_year"
names(flights)[35]<-"plane_type"
names(flights)[36]<-"plane_manufacturer"
names(flights)[37]<-"plane_model"
names(flights)[38]<-"plane_engines"
names(flights)[39]<-"plane_seats"
names(flights)[40]<-"plane_speed"
names(flights)[41]<-"plane_engine"

names(flights)[5]<-"year"

#factor origin/dest airport name
flights$origin_airport_name <- factor(flights$origin_airport_name)
flights$dest_airport_name <- factor(flights$dest_airport_name)


#factor DayOfWeek
flights$DayOfWeek <- factor(flights$DayOfWeek)

#factor plane_manufacturer
flights$plane_manufacturer <- factor(flights$plane_manufacturer)

#factor plane_engine
flights$plane_engine <- factor(flights$plane_engine)

min_dist <- floor(min(flights$DistanceKMs, na.rm = TRUE))
max_dist <- round(max(flights$DistanceKMs, na.rm = TRUE))

str(flights)

#min_dist
#max_dist
#128, 256,512,1024,2048,3172,4096,5120,6144,7168,8092


#1: list flights in range of distance on the given date range -> table

#2: show histogram by destination count for date range

#3: show average delays by distance -> scatter plot -> fit

#4: show average flights per weekday (Pie chart)

#5: show average delay per carrier
#table

#flights[, mean(arr_delay, na.rm = TRUE), by = dest]

#ggplot(flights[, mean(arr_delay, na.rm = TRUE), by = dest],
  #     aes(x = dest, y = V1)) + geom_bar(stat = 'identity') + coord_flip()
## TODO plot the average departure and arrival delays per destination
#ggplot(flights[, .(ArrDelay = mean(arr_delay, na.rm = TRUE),
 #                  DepDelay = mean(dep_delay, na.rm = TRUE)),
 #              by = dest], aes(x = DepDelay, y = ArrDelay, label = dest)) + geom_text()