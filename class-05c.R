library(rpart)
iris <- data.table(iris)
library(data.table)
set.seed(42)
i<-sample(1:150,100)
train <-iris[i]
test <- iris[-i]

#Species ~ x + t...OR use . to exclude Species
ct <- rpart(Species ~ ., data=train)
plot(ct)
text(ct)
library(rpart.plot)
rpart.plot(ct)

library(partykit)
plot(as.party(ct))

predict(ct, type='class', newdata=test)

