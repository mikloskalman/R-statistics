library(h2o)
library(hflights)

#let's start H2O
h2o.init()

write.csv(hflights,'hflights.csv', row.names=FALSE)
hex <- h2o.importFile('hflights.csv', destination_frame = 'hflights')

str(hex)
head(hex)
summary(hex)
hex[, 'FlightNum'] <- as.factor(hex[, 'FlightNum'])

for (v in c('Month','DayOfMonth','DayOfWeek','DepTime','ArrTime')){
  hex[, v] <- as.factor(hex[, v])
}
summary(hex)
