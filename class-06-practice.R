#1 Load the content of the https://bit.ly/mtcars-csv CSV file and save as df (check the variable names in the manual of mtcars)
df <- read.csv('https://bit.ly/mtcars-csv ')
str(df)

#2 Transform df to a data.table object
df <- data.table(df)
str(df)

#3 Count the number of cars with 4 gears
df[gear==4,.N]

#4 Count the number of cars with 4 gears and less than 100 horsepower
df[gear==4 & hp<100,.N]


#5 What's the overall weight of cars with 4 cylinders?
df[gear==4, mean(wt)]

#6 Which car is the heaviest?
df[wt==max(wt)][1]

#7 Plot the distribution of weights
df[,.N,by=wt]

#8 Plot the distribution of gears
library(ggplot2)
ggplot(df, aes(x = gear)) + geom_histogram()

#9 Plot the distribution of weights per gears
ggplot(df, aes(x = factor(gear), y = wt)) + geom_boxplot()


#10 Plot the average weight per gears
r1<-df[,.(mean=mean(wt)),by=gear]
ggplot(r1, aes(x=factor(gear), y=mean))+ geom_bar()

#11 Which car has the best fuel consumption?
df[mpg==max(mpg)][1]

#12 Plot the weight and horsepower of cars


#13 Add a linear trend line to the above plot
#14 Add a 3rd degree polynomial model to the above plot
#15 Fit a linear model on hp to predict weight
#16 Estimate the weight based on the above model for Lotus Europa
#17 Compute a new variable in the dataset for the ratio of wt and hp
#18 Plot the distribution of this new variable on a boxplot
#19 Create an aggregated dataset on mtcars including the average hp and wt grouped by the number of gears
#20 Merge the average hp and wt per gears from the above dataset to the original df object based on the number of gears
#21 Compute a new variable for fuel consumption using the "liters per 100 kilometers" unit based on mpg
#22 Which car has the best fuel consumption?
#23 Compute wt2 to store the weight in kilograms based on wt
#24 Apply k-means clustering on the dataset to split the observations into 3 groups
#25 Perform hierarchical clustering on the dataset and plot the dendogram
#26 Build a decision tree to tell if a car has automatic or manual transmission
#27 Visualize the above decision tree
#28 Create a confusion matrix for the above model
#29 Use the k-NN algorithm to fit a similar model and decide on the best number of neighbors to use