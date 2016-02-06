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

for (v in c('Month','DayofMonth','DayOfWeek','DepTime','ArrTime')){
  hex[, v] <- as.factor(hex[, v])
}
summary(hex)


hsplit <- h2o.splitFrame(hex, ratios=0.75)
htrain <- hsplit[1]
htest <- hsplit[2]

str(hsplit)
rf <- h2o.randomForest(
  training_frame = htrain,
  validation_frame = htest,
  x=c('Month','DayofMonth','DayOfWeek','FlightNum','Origin','Dest'),
  y='Cancelled'
)

h2o.shutdown(prompt=FALSE)

