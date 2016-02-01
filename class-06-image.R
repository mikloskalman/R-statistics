library(jpeg)

img <- readJPEG('C:/Users/mkalm/Documents/BudapestBI-R-img.jpg')

h<-dim(img)[1]
w<-dim(img)[2]
img1d <- matrix(img, h*w)
pca <- prcomp(img1d)
image(matrix(pca$x[,2],h ), col=gray.colors(100) )
