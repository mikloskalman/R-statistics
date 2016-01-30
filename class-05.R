#linear models
df <- read.csv('http://bit.ly/BudapestBI-R-csv')

plot(df$heightIn, df$weightLb)

str(df)
fit <- lm (weightLb ~ heightIn, data=df)
abline(fit, col='red')

predfit <- predict(fit)
points(df$heightIn, predfit,col='blue', pch=19)
#lm = Intercept + heightInModel* heightIn

segments(df$heightIn, df$weightLb, df$heightIn, predfit, col='green')

#http://psycho.unideb.hu/statisztika

predict(fit, newdata = data.frame(heightIn=195/2.5)) * 0.45

plot(df$heightIn, df$weightLb, xlim = c(45,75), ylim = c(60,170))
abline(fit, col='red')

#fit <- lm (weightLb ~ heightIn + heightIn^2 +  , data=df)
fit2 <- lm (weightLb ~ poly(heightIn, 2, raw=TRUE)  , data=df)
#plot(df$heightIn, df$weightLb, xlim = c(40,80), ylim = c(50,200))
predfit2 <- predict(fit2)
points(df$heightIn, predfit2, col='blue',pch=19)

library(ggplot2)
ggplot(df, aes(x=heightIn, y=weightLb)) + geom_point() + geom_smooth(method = 'lm', se=FALSE)

ggplot(df, aes(x=heightIn, y=weightLb)) + geom_point() + geom_smooth(method = 'lm', se=FALSE, formula=y~poly(x, 2))


