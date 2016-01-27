library(data.table)
library(hflights)

str(hflights)


#convert to data table
dt <- data.table(hflights)

str(dt)

subset(dt, Dest == 'LAX')

#filter for rows where Dest is LAX
dt[Dest=='LAX', list(Dest, DepTime, ArrTime)]

#number of flights that were cancelled
dt[,sum(Cancelled)]

#number of rows
dt[,.N]

#return number by destination
dt[,.N, by=Dest]

#number by destination
dt[,sum(Cancelled), by=Dest]

#name column as cancelledHeader
dt[,list(cancelledHeader = sum(Cancelled)), by=Dest]

#na.rm=TRUE drop NA values
dt[,.(cancelled = sum(Cancelled),.N,totalDelay=sum(ArrDelay, na.rm = TRUE)), by=Dest]

dt[ArrDelay>0,.(cancelled = sum(Cancelled),.N,totalDelay=sum(ArrDelay, na.rm = TRUE)), by=Dest]

#dt[i,j,by]: i: filter rows, j: column names or expression

#chain brackets
dta<-dt[ArrDelay>0][,.(cancelled = sum(Cancelled),.N,totalDelay=sum(ArrDelay, na.rm = TRUE)), by=Dest]

#order by N
dta[order(N)]

setorder(dta,N)
dta

setorder(dta,-N, cancelled)
dta


dta<-dt[ArrDelay>0][,.(cancelled = sum(Cancelled),.N,totalDelay=sum(ArrDelay, na.rm = TRUE)), by=.(Dest,DayOfWeek)]
setorder(dta, Dest, DayOfWeek)
dta

#return first and last line
dta[c(1,.N)]
