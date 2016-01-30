library(nycflights13)

#count the number of flights to LAX
str(flights)
flightsDT <- flights
setDT(flightsDT)
DT[,sum(v),by=colA][V1<300][tail(order(V1))]
flightsDT[,.N,by='dest'][dest=='LAX']
flightsDT[,.N,dest=='LAX']


#count the number of flights to LAX from JFK
length(flightsDT[dest=='LAX' & origin=='JFK'])
flightsDT[,.N,by='dest'][dest=='LAX' & origin=='JFK']



library(sqldf)
sqldf("Select dest, count(*) as cnt from flights where dest='LAX' and origin='JFK' Group by dest")



#compute the average delay (in minutes) for flights from JFK to LAX
flightsDT[,total_delay:=dep_delay+arr_delay]
filtered = flightsDT[ dest=='LAX' & origin=='JFK']
flightsDT[is.na(dep_delay)] <- 0

mean(filtered$total_delay)

#which destination has the lowest average delay from JFK?
#plot the average delay to all destinations from JFK
#plot the distribution of all flight delays to all destinations from JFK
#compute a new variable in flights showing the week of day
#plot the number of flights per weekday
#create a heatmap on the number of flights per weekday and hour of the day (see geom_tile)
#merge the airports dataset to flights on the FAA airport code
#order the weather dataset by year, month, day and hour
#plot the average temperature at noon in EWR for each month based on the weather dataset
#aggregate the weather dataset and store as daily_temperatures to show the daily average temperatures based on the EWR records
#merge the daily_temperatures dataset to flights on the date
#do the above two steps on daily + hourly temperature averages
