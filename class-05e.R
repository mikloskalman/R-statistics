eurodist
library(data.table)

#mds multi dimensional scaling
m<-cmdscale(eurodist)
plot(cmdscale(eurodist), type='n')
text(m[,1],-m[,2],labels(eurodist))
