library(data.table)
df <- read.csv('http://bit.ly/BudapestBI-R-csv')

df <- data.table(df)
df


i <- sample(1:237,170)
train <- df[i]
test <- df[-i]
str(t)
ct <- rpart(sex ~ heightIn + weightLb, data=train)
cm<-predict(ct, type='class', newdata=test)

table(test$sex,cm)

library(partykit)
plot(as.party(ct))

resknn1 <- knn(train[,2:5,with=FALSE], test[,2:5,with=FALSE], train$sex, k=6)
table(resknn1, test$sex)

resknn2 <- knn(train[,4:5,with=FALSE], test[,4:5,with=FALSE], train$sex, k=6)
table(resknn2, test$sex)

###############
ctr<-rpart(sex~heightIn+weightLb,data=df, minsplit=1)
table(predict(ctr,type='class'),df$sex)

set.seed(7)
df <- df[order(runif(nrow(df))),]

train <- df[1:180,]
test <- df[181:nrow(df),]

ct<-rpart(sex~heightIn*weightLb,data=train, minsplit=10)
table(train$sex, predict(ct,type='class'))
table(test$sex, predict(ct,type='class',newdata=test))
plot(ct)
text(ct)
library(partykit)
plot(as.party(ct))

#PCA - principal component analysis
setDF(iris)
pc<-prcomp(iris[,1:4],scale=TRUE)
str(pc)
pc2<-pc$x[,1:2]
plot(pc2, col=iris$Species)
