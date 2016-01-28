df <- read.csv('http://bit.ly/BudapestBI-R-csv')
str(df)
t.test(heightIn ~ sex, data=df)
table(df$sex)

summary(aov(heightIn~sex, data=df))
?aov

library(ggplot2)
ggplot(df, aes(y=heightIn, x=sex)) + geom_violin(fill='pink')

library(data.table)
df <- data.table(df)
setDT(df)

df[, high := as.character(heightIn>mean(heightIn))]
df
df[,.N,by=.(sex,high)]

library(reshape2)
ft<- dcast(df,sex~high)
ft

ft[2:3]
ft[,-1]
ft$sex <- NULL
chisq.test(ft)