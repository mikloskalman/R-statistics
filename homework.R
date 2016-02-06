df=read.csv("https://bit.ly/mtcars-csv") 
dt=data.table(df)
dt[gear==4,.N] # 11
dt[gear==4 & hp < 100,.N] # 7
dt[gear==4,sum(wt)] # 28.62
dt[order(wt,decreasing=TRUE)][1]#Lincoln Continental

#Plot the distribution of weights - histogram for continous var
ggplot(dt, aes(x=wt))+geom_histogram()

#Plot the distribution of gears - barchart for discrete var
ggplot(dt, aes(x=factor(gear)))+geom_bar()

#Plot the distribution of weights per gears - 2 solutions
ggplot(dt, aes(x=wt/gear))+geom_histogram()
ggplot(dt, aes(x=wt))+geom_histogram()+ facet_grid(. ~ gear) # alternatively

#Plot the average weight per gears - doing it in 2 steps, can it be done in one?
agg = aggregate(wt ~ gear, FUN = mean, data = dt)
ggplot(agg, aes(x=factor(gear), y=wt))+geom_boxplot()

#Which car has the best fuel consumption?
dt[order(mpg, decreasing = TRUE)][1] #Toyota Corolla
p=ggplot(dt, aes(x=wt, y=hp))+geom_point()+geom_smooth(method = 'lm', se = FALSE, col = 'red')
p+stat_smooth(method="lm", se=FALSE,formula=y ~ poly(x, 3, raw=TRUE),colour="green")

## plot this model
fit = lm(wt~hp, data=dt) # need to specify it this way vs lm(dt$wt... for the below to work
plot(dt$hp, dt$wt)
abline(fit, col = 'red')
summary(fit)
fit$coefficients[[2]]*dt[car=="Lotus Europa",hp]+fit$coefficients[[1]] # ugly
predict(fit, newdata = data.frame(hp = dt[car=="Lotus Europa",hp])) # nice

dt[,ratio:=wt/hp]
ggplot(dt, aes(x=wt, y=ratio))+geom_boxplot() #x coord doesnt matter?

#Create an aggregated dataset on mtcars including the average hp and wt grouped by the number of gears
agg=aggregate(cbind(hp,wt)~gear, FUN=mean, data = dt)

#Merge the average hp and wt per gears from the above dataset to the original df object based on the number of gears
df=merge(df,agg,by='gear')
names(df)[names(df)=="hp.y"] <- "hpmean" #more sensible names
names(df)[names(df)=="wt.y"] <- "wtmean"
df
#Compute a new variable for fuel consumption using the "liters per 100 kilometers" unit based on mpg
dt[,lpkm:=235/mpg]
#Which car has the best fuel consumption?
dt[order(lpkm, decreasing = FALSE)][1] #Toyota Corolla
#Compute wt2 to store the weight in kilograms based on wt
dt[,wt2:=wt*0.45*1000]
str(dt)
head(dt)
#Apply k-means clustering on the dataset to split the observations into 3 groups
kc <- kmeans(dt[,2:15], 3)
str(kc$cluster)

#  Perform hierarchical clustering on the dataset and plot the dendogram
df<- read.csv('https://bit.ly/mtcars-csv ')
df<- df[,2:12]
ab<-dist(df)
hc<- hclust(ab)
plot(hc)

#color the divisions red
rect.hclust(hc, k = 3, border = 'red')
cn <- cutree(hc, k = 3)

#  Build a decision tree to tell if a car has automatic or manual transmission
str(df)
library(rpart)
ct<- rpart(am ~ .,data =df)
str(df)
summary(ct)


 

#  Visualize the above decision tree

plot(ct);text(ct)
