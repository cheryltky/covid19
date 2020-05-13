#load library 
install.packages("readr")
install.packages("tidyverse")
install.packages("gganimate")


library(tidyverse)
library(ggplot2)
library(gganimate)
library(readr)
theme_set(theme_bw())

<<<<<<< HEAD
##only for troubleshooting.
#setwd("~/Documents/cheryl/covid19")
=======
setwd("~/Documents/cheryl/covid19")

#load the data
#australia's data only
covid <- readr::read_csv("~/Github/covid19/Data/Australian coronavirus tracking - latest totals.csv")
head(covid)
str(covid)
summary(covid)
>>>>>>> 8bd476c00cbec062e6707f747e0ba728ce8bb74b

#globaldatafromjhu
global <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", stringsAsFactors=F)

head(global)
str(global)
summary(global)
names(global)
dim(global)
ncol(global)
nrow(global)
glimpse(global)

<<<<<<< HEAD
countries <- unique(global$CountryRegion)
=======
countries <- unique(global$Country.Region)
>>>>>>> 8bd476c00cbec062e6707f747e0ba728ce8bb74b

nglob <- matrix(NA, nrow=dim(global)[2]-4, ncol=length(countries))
date <- names(global)[5:length(names(global))]
date <- gsub("X", "", date)
colnames(nglob) = countries
row.names(nglob) = date

# algorithm to aggregate values per country so we have only one value per country
for(i in 1:length(countries)){
	x <- global[which(global$Country.Region == countries[i]), 5:dim(global)[2]]
	xx <- as.vector(colSums(x))
	nglob[,i] <- xx
}

# transpose
tnglob <- t(nglob)

glob <- as.data.frame(tnglob)
# add variable
glob$Country <- row.names(tnglob)


# wide to long
library(reshape2)
globl <- melt(glob, id.vars=c("Country"))


ggplot(data=globl, aes(x=variable, y=value, color=Country)) + geom_point() + theme(legend.position='none')

selc <- c("US", "United Kingdom", "Italy", "Spain")

# select a few countries
pdf("covid19_few_counts.pdf", 16,7)
par(mar=c(6, 4, 2, 2) + 0.1, bty='n')
plot(1:length(date), seq(0,max(globl$value), length.out=length(date)), type='n', las=2, xlab="", ylab="Counts", xaxt='n')
lines(globl$variable[which(globl==selc[1])], globl$value[which(globl==selc[1])], col="red")
lines(globl$variable[which(globl==selc[2])], globl$value[which(globl==selc[2])], col="blue")
lines(globl$variable[which(globl==selc[3])], globl$value[which(globl==selc[3])], col="green")
lines(globl$variable[which(globl==selc[4])], globl$value[which(globl==selc[4])], col="orange")
axis(1, at=seq(1,97), labels=date, las=2, cex=.4)
legend("topleft", legend=selc, col=c("red", "blue", "green", "orange"), lty=1, bty='n')
dev.off()








global$`1/22/20`
summary(global$`1/22/20`)

global$X1.22.20
summary(global$X1.22.20)

select(global, "Country/Region", "4/26/20")

select(global, "Country.Region", "X4.26.20")

ggplot(data = global, aes( x= "~4/26/20", y = "Country/Region"))+
  geom_point()

ggplot(data = global, aes( x="X4.26.20", y = "Country.Region"))+
  geom_point()

ggplot(data = covid) +
  geom_point(aes(x = State, y = Confirmed_cumulative, color = State)) +
  labs(x = "State",
       y = "COnfirmed Cases",
       title = "Australia Nationwide COVID-19 Count") +
  theme_bw()+
  theme(legend.title = element_blank())

ggplot(data = covid) +
aes(x = State, y = Confirmed_cumulative, size = Current_hospitalisation, color = State)+
  geom_point(show.legend = FALSE, alpha = 0.7) +
  scale_color_viridis_d()+
  scale_size(range = c(2,12))+
  labs(x = "State", y = "Confirmed Cases", title = "Australia COVID-19 Cases")

pdf("covid19_counts.pdf", 16, 8)
par(cex=.4, mar=c(15, 4, 2, 2) + 0.1, bty='n')
plot(global$Country.Region, global$X4.26.20, type='n', las=2)
points(global$Country.Region, global$X4.26.20, pch=20)
points(global$Country.Region[which(global$X4.26.20>200000)], global$X4.26.20[which(global$X4.26.20>200000)], pch=20, col='red')
abline(h=200000, lty=2, col='red')
dev.off()



dates <- names(global)[5:length(names(global))]
dates <- gsub("X", "", dates)
rates <- as.vector(global[is.element(global$Country.Region, c("United Kingdom", "Italy", "Spain", "US")), c(2,5:length(names(global)))])

# wide to long
library(reshape2)
rates_long <- melt(rates, id.vars=c("Country.Region"))
rates_long$Country.Region <- as.vector(rates_long$Country.Region)
#rates_long$variable <- as.vector(rates_long$variable)


# library(tidyr)
# rates_long <- gather(rates, dates, counts, X1.22.20:X4.26.20)
rates_long


ggplot(data=rates_long, aes(x=variable, y=value, color = Country.Region))+geom_point()

pdf("covid19_few_counts.pdf", 10, 10)
par(cex=.4, mar=c(15, 4, 2, 2) + 0.1, bty='n')
plot(rates_long$variable[which(rates_long=="US")], rates_long$value[which(rates_long=="US")], type='n', las=2)
lines(rates_long$variable[which(rates_long=="US")], rates_long$value[which(rates_long=="US")], col="red")
lines(rates_long$variable[which(rates_long=="United Kingdom")], rates_long$value[which(rates_long=="United Kingdom")], col="blue")
lines(rates_long$variable[which(rates_long=="Italy")], rates_long$value[which(rates_long=="Italy")], col="green")
lines(rates_long$variable[which(rates_long=="Spain")], rates_long$value[which(rates_long=="Spain")], col="orange")
dev.off()


