install.packages("data.table")
library(data.table)
library(nycflights13)
#use data set flights, 
flights=data.table(flights)
#creats a copy in the global namespace
str(flights)
#reference the original df in package:
str(nycflights13::flights)
ls(nycflights13) # doesnt work!!!

#Excercises:
flights[dest=='LAX',.N,]
flights[dest=='LAX' & origin=='JFK',.N,]
# not good as it contains NA-s
flights[dest=='LAX' & origin=='JFK',mean(arr_delay),]
# ignore NA-s
flights[dest=='LAX' & origin=='JFK',mean(arr_delay, na.rm=TRUE),]
#one trick - override function
mean = function(x,...) base::mean(x, na.rm=TRUE,...)
flights[origin=='JFK',mean(arr_delay, na.rm=TRUE),by=dest][order(V1)]
#OR
flightsa=flights[origin=='JFK',mean(arr_delay, na.rm=TRUE),by=dest]
setorder(flightsa, V1)
flightsa[1] #OR head(flightsa, 1)

#name it for convenience
flights[dest=='LAX' & origin=='JFK',.(avg_delay=mean(arr_delay, na.rm=TRUE)),]
str(flightsa)

library(ggplot2)
#why we need the stat=identity? check ggplot/geom_bar help
ggplot(flightsa, aes(x=dest, y=V1))+geom_bar(stat='identity')

str(flightsa)
#order by average delay
setorder(flightsa, V1)
#update dest to factor from string, otherwise it will display based in abc order
flightsa[,dest:=factor(dest, levels=flightsa$dest)]
str(flightsa)
ggplot(flightsa, aes(x=dest, y=V1))+geom_bar(stat='identity')

#coord flip, add a bunch of titles
ggplot(flightsa, aes(x=dest, y=V1))+geom_bar(stat='identity')+coord_flip()+ggtitle('Avg delay to airports')+xlab('airports')+ylab('minutes')

#plotting stuff:
ggplot(flights, aes(x=dest, y=arr_delay))+geom_boxplot()
ggplot(flights, aes(x=arr_delay))+geom_histogram()

#############################################
# linear models
#############################################

df=read.csv("http://bit.ly/BudapestBI-R-csv")
str(df)
# create lienar model, usually named as fit
#dependent ~ independet
fit = lm(weightLb~heightIn, data=df)
fit
#linear model explained
plot(df$heightIn, df$weightLb)
abline(fit, col="red")
#print prediction, for heights, pch=19 -> type of point to use.
points(df$heightIn, predict(fit), col='blue', pch=19)

fit
#what does it calc ? -132.99+3.818*[height] = weight
predict(fit) # this is the line points

#draw distnaces btw original value and predicted value (the trend line)
segments(df$heightIn, df$weightLb, df$heightIn, predict(fit), col='green')

#now a business case!
#prediction for a new data, predict the weight of kid, man in metric system
predict(fit, newdata = data.frame(heightIn=104/2.5))*0.45
predict(fit, newdata = data.frame(heightIn=171/2.5))*0.45
#doesnt give us good values. why? original data set only covers limited heights, work for dose but on outliers, on either side. to demonstrate:
plot(df$heightIn, df$weightLb, xlim = c(0,300))
abline(fit, col="red")

#new model : polynomial. check out ?poly
fit = lm(weightLb ~ poly(heightIn, 2, raw=TRUE), data=df)
fit
#cant use abline for this model, this is not a straight line!
#use prediciton to plot
predict(fit)
points(df$heightIn, predict(fit), col='blue', pch=19)

#draw with ggplot also - linear model:
ggplot(df, aes(x=heightIn, y=weightLb))+geom_point()+geom_smooth(method='lm', se=FALSE)
#draw with ggplot also - poly model:
ggplot(df, aes(x=heightIn, y=weightLb))+geom_point()+geom_smooth(method='lm', se=FALSE, formula=y~poly(x,5))

#shoe size and math excercise
df=read.csv("http://bit.ly/math_and_shoes")
plot(df$size, df$math)
abline(fit, col="red")
#correlation matrix
cor(df) # the close to 1, the higher the correlation
#based on this - shoe size highly correlated to math skills :)
#how to lie with statistics - "spurious correlations"

#partial correlations, check out math - size correlation based on correlation x.
lm(math~x,df)
lm(size~x,df)
residuals(lm(math~x,df)) #residual vectors
residuals(lm(size~x,df))
cor(residuals(lm(math~x,df)),residuals(lm(size~x,df))) # this is high cor

#package to calc partial correlation
install.packages("psych")
library("psych")
partial.r(df, 2:3, 4)

#new data set
str(iris)
fit = lm(Sepal.Width~Sepal.Length, data=iris)
fit
plot(iris$Sepal.Length, iris$Sepal.Width)
abline(fit, col="red")
#print all details of model:
summary(fit)
#based on this - this linear model is not very good.
#why? check out data, 3 different types of iris
plot(iris$Sepal.Length, iris$Sepal.Width, col=iris$Species)
# add Species to model
fit = lm(Sepal.Width~Sepal.Length+Species, data=iris)
# much better result, r-squared is higher etc, variance is explained by model
summary(fit)

#draw it - very nice!
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species))+geom_smooth(method='lm')+geom_point()

#what if there is no speaices column? do clustering!
?hclust
#distance matrix
str(dist(iris))
#only include the first 4 column, get rid of factor column
dm=dist(iris[,1:4])
#visualize the distances
hc =hclust(dm)
str(hc)
#plot will know this is a h cluster
plot(hc) #check out the clusters, based on eucledian distance
#visulaize and cut the tree into 3 clusters
rect.hclust(hc, k=3, border ='red')
cn=cutree(hc, k=3)
str(cn)
#combine iris with clusters, based on Species
table(cn, iris$Species)
#not very good for some reason. not classifying becuase distance btw length is higer then in width

#other clustering method
kc = kmeans(iris[,1:4], 3) #check out hwo kmeans works
str(kc)
table(kc$cluster, iris$Species)
#check out the plot, its visible why

############################################
#supervised methods!
############################################
#trinaing data set. develop model, train on this dataset.
#then use model on different data set.
plot(iris$Sepal.Length, iris$Sepal.Width, col=iris$Species)

#use data tebale
iris=data.table(iris)
#take random 100 from isis, use that as training data, remaining 50 is test data.
#random selection - method 1.
i =sample(1:150, 100)
iris[i, .N, by =Species]
iris[-1i, .N, by =Species]
#random selection - method 2.
#assign new col with random values, order, take first 100...

#standardizing for everyon in class
iris=data.table(datasets::iris)
set.seed(42)
i =sample(1:150, 100)
#create train & test dataset
train = iris[i]
test = iris[-i]
library(class)
# k-Nearest Neighbour Classification
?knn
#dont pass the last facor column, disable expression syntax crap, othervise 1:4 Wwould return 1..4 vector only.
res=knn(train[,1:4, with=FALSE], test[,1:4, with=FALSE], train$Species)
str(res)
table(res, test$Species) #good result!

########################################################
#find optimal number of clusters
########################################################
install.packages("NbClust")
library(NbClust)
?NbClust
#check out output, runs a lot of analitical method and they will suggest the number of clusters
NbClust(iris[,1:4, with=FALSE], method="complete")

########################################################
# machine learning - reg trees
library(rpart)
#. :use all columns apart from the one in the left hand side
ct=rpart(Species~.,data=train)
#visualize nicely
plot(ct)
text(ct)
#other visualization method
install.packages(partykit)
library(partykit)
#shows how thje decision is made
plot(as.party(ct))

#fit model to test data
predict(ct, type='class')
predict(ct, type='class',newdata=test)

########################################################
#develop model on gender
df=read.csv("http://bit.ly/BudapestBI-R-csv")
str(df)
df
train = df[1:100,]
test = df[101:nrow(df),]
ct = rpart(sex ~heightIn+weightLb, data=train, minsplit=1)
#error, all females, cant build tree, need to randomize
set.seed(7)
df = df[order(runif(nrow(df))),]
train = df[1:100,]
test = df[101:nrow(df),]
train
#works after randomoziation. very overfitting so mathcing almost perfectly.
ct = rpart(sex ~heightIn+weightLb, data=train, minsplit=1)
table(train$sex, predict(ct,type='class'))

#try test data - not good...model doesnt work on test data. too specialized for train data
table(test$sex, predict(ct,type='class', newdata = test))

ct = rpart(sex ~weightLb+heightIn, data=train, minsplit=50)
plot(ct);text(ct)
table(train$sex, predict(ct,type='class'))

#TODO - try to use body mass index!

#######################################################
#Book - An introduction to statistical learning!!!


#######################################################
#PCA
#######################################################
setDF(iris)#flip back to Data frame
prcomp(iris[,1:4])
#produces 4 new variables to describe data (same as original data)
#original data is liner combination of new vars
#first variable is most significant, stddev >1, describes the variance.

#need to scale, and trnasform all varables to mean 0, stddve 1
pc=prcomp(iris[,1:4], scale=TRUE)

str(pc)
#just first 2 significant variable
pc$x[,1:2]
#plot them, after scaling data is centered around (0,0)
plot(pc$x[,1:2], col=iris$Species)

#new dataset
eurodist

#MDS - multi dimensional scaling
#reduce dimension to 21 -> 2
m=cmdscale(eurodist)
plot(cmdscale(eurodist), type='n') #dont put up points, instead use labels
#cool map of cities!!
#paris in center...
text(m[,1],-m[,2],labels(eurodist))




