df <- read.csv('http://bit.ly/math_and_shoes')
cor(df)
fit <- lm (size ~ math, data=df)
predfit <- predict(fit)

cor(df)

residuals(lm(size~x, data=df))

cor(residuals(lm(math~x, data=df)),residuals(lm(size~x, data=df)))

library(psych)
partial.r(df, 1:3,4)

str(iris)
fit <- lm(Sepal.Width ~ Sepal.Length, data=iris)
summary(fit)

plot(iris$Petal.Length, iris$Sepal.Width)
abline(fit, col='red')

#fitting model for species
plot(iris$Petal.Length, iris$Sepal.Width, col= iris$Species)

fit <- lm(Sepal.Width ~ Sepal.Length + Species, data=iris)
fit
summary(fit)

library(ggplot2)
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) +geom_smooth(method='lm',se=FALSE) + geom_point()

#without species
dm <- dist(iris[,1:4])
hc <- hclust(dm)
str(hc)
plot(hc)
rect.hclust(hc, k=3, border='red')
cn<-cutree(hc, k=3)
nd <- iris
str(iris)
table(cn, iris$Species)

#scale matrix
scale(iris[,1:4])

kc <- kmeans(iris[,1:4],3)
str(kc)
table(kc$cluster, iris$Species)
library(data.table)
iris <- data.table(iris)
str(iris)
i<- sample(1:150,100)
iris[i,]
iris[i, .N, by=Species]

iris[, rnd:= runif(150)]
setorder(iris,rnd)
iris[1:100]
iris <- data.table(datasets::iris)
#standard seed
set.seed(42)

i<- sample(1:150, 100)
train <- iris[i]
test <- iris[-i]

library(class)
#k-nearest neighbor
#with=FALSE to disable expressions in second param of data.table
res <- knn(train[,1:4,with=FALSE], test[,1:4,with=FALSE], train$Species, k=6)
str(res)
table(res, test$Species)
#nbclust

#calculate optimal cluster count
library(NbClust)
NbClust(iris[,1:4,with=FALSE],method='complete')
