
#Setting my directory to where my data files are located.
setwd("/Users/rubyvazquez/Desktop/SMU/Doing Data Science/Case Study 1")
getwd()

#Importing first data file Country.
Country<-read.csv("Country.csv", header = TRUE, sep=",",na.strings=c("", "NA"))
head(Country) #Checking the data.

#Importing second data file GDP.
#Setting column names, for a cleaner import.
names<- c("CountryCode","Ranking", "Delete", "Economy", "GDP","Delete","Delete","Delete","Delete","Delete")
#Importing the second data file with the set column names.
GDPdata<-read.csv("GDP.csv", header = FALSE, sep=",", skip=5, col.names = names,na.strings=c("", "NA"))
head(GDPdata)#Checking the data.

#Cleansing GDP data.
#Deleting columns filled of NAs or blank.
GDPdata$Delete<-NULL
GDPdata$Delete.1<-NULL
GDPdata$Delete.2<-NULL
GDPdata$Delete.3<-NULL
GDPdata$Delete.4<-NULL
GDPdata$Delete.5<-NULL
head(GDPdata)#Checking the data.

##Calculating the Number of missing value from deleting the above variables.
##Deleted 6 variables and each variable has 326 obs.
6*326

##I will subset GDP to only the confirmed GDP estimates, which are those with a ranking.
GDPdata<-GDPdata[1:190,]


#Question 1
#Merge the data based on the country shortcode.
Mergeddata<-merge(Country, GDPdata, by="CountryCode")
head(Mergeddata)

#Number of IDs that matched
dim(Mergeddata)[1]

#Question 2
##Converting GDP values to numeric values.
Mergeddata$GDP<-as.character(Mergeddata$GDP)
Mergeddata$GDP<-as.numeric(gsub(",", "", Mergeddata$GDP))
##Sorting data by GDP.
Sorteddata<-Mergeddata[order(Mergeddata$GDP),]
#The 13th country on the list
Sorteddata[13,1:2]

#Question 3
#Subsetting the data where Income group equal High income: OECD and taking the mean.
mean(as.numeric(as.character(Mergeddata[Mergeddata$Income.Group =="High income: OECD",]$Ranking)))
#Subsetting the data where Income group equal High income: nonOECD and taking the mean.
mean(as.numeric(as.character(Mergeddata[Mergeddata$Income.Group =="High income: nonOECD",]$Ranking)))

#Question 4
#Making sure I have ggplot2 installed.
library("ggplot2")
#Plotting GDP for all countries by Income.Group.
ggplot(Mergeddata, aes(Income.Group, GDP),labels)+geom_point(aes(colour= factor(Mergeddata$Income.Group)))+
 ggtitle("GDP for each Country")+ theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(legend.position="bottom")


#Question 5
##Making the 5 quartiles.
breaks <- quantile(as.numeric(as.character(Mergeddata$Ranking)), probs = seq(0, 1, 0.2), na.rm = TRUE)
##Making the quartiles a column in the data.
Mergeddata$quantileGDP <- cut(as.numeric(as.character(Mergeddata$Ranking)), breaks = breaks)
##Selecting the data that has Income.Group equal to Lower middle income.
x<-Mergeddata[Mergeddata$Income.Group=="Lower middle income",]
#Getting the number of countries in the Lower middle income group that are in each quartile.
by(x, x$quantileGDP, nrow)


