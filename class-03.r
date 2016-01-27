library(ggplot2)
#ggplot(mtcars, aes(x = carb)) + geom_bar()
ggplot(mtcars, aes(x = hp)) + geom_histogram(binwidth = 50)

#grouped bar char
#ggplot(mtcars, aes(x = carb)) + geom_bar() +facet_grid(~am)

mtcars$am <- factor(mtcars$am)
ggplot(mtcars, aes(x = carb,fill=am)) + geom_bar(position = 'dodge',bin)

#boxplot for hp and carb
ggplot(mtcars, aes(x = factor(carb), y=hp)) + geom_boxplot()

#hp and weight by carb (factor carb as it is continuous)
ggplot(mtcars, aes(x = hp, y=wt, color=factor(carb))) + geom_point()

#trendline
ggplot(mtcars, aes(x = hp, y=wt, color=factor(carb))) + geom_point()+ geom_smooth(method='lm',se=FALSE)

