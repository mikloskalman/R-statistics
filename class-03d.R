#nycflights13
library(nycflights13)
flights<-nycflights13::flights
str(flights)
str(airports)

#concatenate string 'paste'

flights <- data.table(flights)

#assigning a new column
flights[, date:= paste(year,month, day,sep='-')]

#convert to date
flights[, date:= as.Date(paste(year,month, day,sep='-'))]

#convert date to weekday this version won't copy
flights[, weekday := weekdays(date)]

str(flights)



#merge data based on origin and destination
flights2<-merge(flights, airports, by.x = 'dest', by.y='faa', all.x=TRUE)
nrow(flights2)
