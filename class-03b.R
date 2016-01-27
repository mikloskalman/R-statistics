#XML library install
library(XML) 

#need stringsAsFactors to ensure they are characters
df <- readHTMLTable(readLines('https://en.wikipedia.org/wiki/FTSE_100_Index'),which = 2, header = TRUE, stringsAsFactors=FALSE)


names(df)[4] <- 'Cap'
str(df)
df$Cap <- as.numeric(df$Cap)
str(df)

#gsub => substitute and convert to int
df$Employees <- as.numeric(gsub(',', '', df$Employees))
str(df)

#statistics
min(df$Employees)

summary(df$Employees)

#mean of employees per sector
aggregate(Employees ~ Sector, FUN = mean, data=df)

#show range of values
aggregate(Employees ~ Sector, FUN = range, data=df)

#number of company per sector
aggregate(Employees ~ Sector, FUN = length, data=df)

#subset where  employees is under 1000
subset(df, Employees < 1000 & Cap < 5)


library(data.table)
