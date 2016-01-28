library(openxlsx)
df<-read.xlsx('C:/Users/kalman_miklos/Downloads/bickel.xlsx')
setDT(df)
str(df)
df
df[, rejected := applicants - admissions]
df
df2<-df[, .(rejsum=sum(rejected),total=sum(applicants)), by=.(gender,department)]
df2[,ratio:= rejsum / total]
df2
df3<-df[, .(rejsum=sum(rejected),total=sum(applicants)), by=.(gender,department)]
df3[,ratio:=rejsum/total]
df3

ft<- df[, sum(rejected)/sum(applicants) * 100, by=.(gender,department)]
setorder(ft, department, gender)
ft
#names(ft)[2] <- 'department'
df[,sum(applicants),by=.(department,gender)]


