library(ggplot2)
#ggplot(mtcars, aes(x = carb)) + geom_bar()
ggplot(mtcars, aes(x = hp)) + geom_histogram(binwidth = 50)

#grouped bar char
ggplot(mtcars, aes(x = carb)) + geom_bar() *



%ggplot(mtcars, aes(x = carb, y = hp)) + geom_boxplot()

ggplot(mtcars, aes(x = hp, y=wt, fill=carb)) + geom_area()

