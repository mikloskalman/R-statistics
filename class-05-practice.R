library(nycflights13)
library(data.table)
#count the number of flights to LAX
str(flights)
flightsDT <- flights
setDT(flightsDT)

flightsDT[,.N,by='dest'][dest=='LAX']
flightsDT[,.N,dest=='LAX']

#solution
flights <- data.table(nycflights13::flights)
flights[dest=='LAX',.N]

#count the number of flights to LAX from JFK
flights[dest=='LAX' & origin=='JFK',.N]


library(sqldf)
v<-sqldf("select  count(*) as cnt from flights where dest='LAX' and origin='JFK'")
str(v)


#compute the average delay (in minutes) for flights from JFK to LAX
flights[dest=='LAX' & origin=='JFK', mean(arr_delay, na.rm = TRUE)]
#mean <- function(x,...) base::mean(x,na.rm=TRUE,...)


#which destination has the lowest average delay from JFK?
flights[origin=='JFK', .(avg_delay=mean(arr_delay, na.rm=TRUE)),by=dest][order(avg_delay)]
flightsa <- flights[origin=='JFK', .(avg_delay=mean(arr_delay, na.rm=TRUE)),by=dest]
setorder(flightsa,avg_delay)
flightsa[1]
head(flightsa,1)
#head (-1) all but last
##?which.min

#plot the average delay to all destinations from JFK
str(flightsa)
library(ggplot2)
ggplot(flightsa, aes(x=dest, y=avg_delay)) + geom_bar(stat="identity")
#show bars by average delay
setorder(flightsa, avg_delay)
flightsa$dest
flightsa[, dest := factor(dest, levels=flightsa$dest)]
ggplot(flightsa, aes(x=dest, y=avg_delay)) + geom_bar(stat="identity") + coord_flip() + ggtitle("Average Delay to airports") + xlab("destination") + ylab('minutes') + theme_bw()

#plot the distribution of all flight delays to all destinations from JFK
ggplot(flights, aes(x=dest, y=arr_delay)) + geom_boxplot()

#compute a new variable in flights showing the week of day
#plot the number of flights per weekday
#create a heatmap on the number of flights per weekday and hour of the day (see geom_tile)
#merge the airports dataset to flights on the FAA airport code
#order the weather dataset by year, month, day and hour
#plot the average temperature at noon in EWR for each month based on the weather dataset
#aggregate the weather dataset and store as daily_temperatures to show the daily average temperatures based on the EWR records
#merge the daily_temperatures dataset to flights on the date
#do the above two steps on daily + hourly temperature averages
