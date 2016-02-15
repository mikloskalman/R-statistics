library(nycflights13)
library(data.table)
library(ggplot2)

#head(flights)

flights <- data.table(flights)

library(stringr)


flights$depart_date <- as.Date(paste(flights$year, flights$month, flights$day,sep='-'),format="%Y-%m-%d")

mindate <- min(flights$depart_date, na.rm = TRUE)
maxdate <- max(flights$depart_date, na.rm = TRUE)

flights$DayOfWeek <- weekdays(flights$depart_date)

flights$DistanceKMs <- flights$distance / 0.62137
flights$depart_time <- paste(str_pad(flights$hour, 2, pad = "0"),str_pad(flights$minute, 2, pad = "0"),sep=':')



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

min_dist <- 300#floor(min(flights$DistanceKMs, na.rm = TRUE))
max_dist <- 1000#round(max(flights$DistanceKMs, na.rm = TRUE))


from<-as.Date('2013-01-01')
to<-as.Date('2013-12-31')

#min_dist
#max_dist
#128, 256,512,1024,2048,3172,4096,5120,6144,7168,8092


#1: list flights in range of distance on the given date range -> table
str(flights)
res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
str(res)
output<-res[,c("depart_date","depart_time","origin_airport_name","dest_airport_name","DistanceKMs","carrier_name","dep_delay","arr_delay"),with=FALSE]
setorder(output,depart_date,depart_time)
output

#1.1 show count by carrier
res[,.N, by=carrier_name]


#2: show histogram by destination count for date range
res[,.N, by=dest_airport_name]

#3: show average delay by destination
plot_data<-res[, .('average_delay'=mean(arr_delay, na.rm = TRUE)), by = dest_airport_name]
ggplot(plot_data , aes(x = dest_airport_name, y = average_delay,fill=dest_airport_name)) + geom_bar(width = 1, stat = "identity") +coord_flip() + xlab("Aiport") + ylab("Average Delay") + ggtitle("Average Delay per Airport")

#3.1 Average delay by carrier
plot_data<-res[, .('average_delay'=mean(arr_delay, na.rm = TRUE)), by = carrier_name]
ggplot(plot_data , aes(x = carrier_name, y = average_delay,fill=carrier_name)) + geom_bar(width = 1, stat = "identity") +coord_flip() + xlab("Aiport") + ylab("Average Delay") + ggtitle("Average Delay by Carrier")

#3.2 On Time ratio by carrier
on_time <- res[arr_delay<=0,.('on_time_count'=.N),by = carrier_name]
total_flight <- res[,.('total_flights'=.N),by = carrier_name]

flight_stat <- merge(total_flight, on_time, by.x = 'carrier_name', by.y = 'carrier_name')

flight_stat$on_time_ratio=flight_stat$on_time_count*100 / flight_stat$total_flights
flight_stat

#4: show average flights per weekday (Pie chart)
data<-flights[,.('total_flights'=.N),by=DayOfWeek]

bp<- ggplot(data, aes(x=DayOfWeek, y=total_flights,fill=DayOfWeek)) +  geom_bar(width = 1, stat = "identity")

bp

#5: show average delay per carrier
#table
output[,.('average_delay'=mean(arr_delay, na.rm = TRUE)),by=carrier_name]

