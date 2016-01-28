library(data.table)
set.seed(42)
tx <- data.table(
  item   = sample(letters[1:3], 10, replace = TRUE),
  time   = as.POSIXct(as.Date('2016-01-01')) - runif(10) * 36*60^2,
  amount = rpois(10, 25))
prices <- data.table(
  item  = letters[1:3],
  date  = as.Date('2016-01-01') - 1:2,
  price = as.vector(outer(c(100, 200, 300), c(1, 1.2))))
items <- data.table(
  item   = letters[1:3],
  color  = c('red', 'white', 'red'),
  weight = c(2, 4, 2.5))

#filter for transactions with "b" items
tx[item=='b']

#filter for transactions with less than 25 items
tx[amount<25]


#filter for transactions with less then 25 "b" items
tx[amount<25 & item=='b']


#count the number of transactions for each items
tx[,.N,by=item]


#count the number of transactions for each day
tx[,.N,by=as.Date(time)]
tx[,date:=as.Date(time)]

#count the overall number of items sold on each day
tx[,sum(amount),by=as.Date(time)]
tx[,.(sum = sum(amount)),by=date]


#merge items to tx
tx2<-merge(tx, items, by='item')
tx2

setkey(tx, item)
setkey(items, item)
str(tx)
items[tx]

setkey(tx, item, date)
setkey(prices, item, date)
prices[tx]

#rename
names(prices)[1] <- 'foobar'
str(prices)
setkey(prices, foobar, date)
tx<-tx[prices]
str(tx)
#sum
tx[,.(sum=sum(weight)),by=date]

#number of sold items per color
tx[,sum(amount),by=color]

#number of tx per color and date
tx[,.N,by=.(color,date)]

table(tx$color,tx$date)
