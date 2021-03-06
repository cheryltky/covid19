# Import JHU Github covid-19 data
confirmedglobal <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

str(confirmedglobal) # check most recent date

deathsglobal <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")

recoveredglobal <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")

#note differences in number of rows/columns


#DATA CLEANING : Create country level and global combined data
#Convert each data set from wide to long AND aggregate at country level

library(tidyr)
library(dplyr)

confirmed <- confirmedglobal %>% gather(key = "date",value = "confirmed", -c(Country.Region, Province.State, Lat, Long))%>% 
  group_by(Country.Region, date) %>% 
  summarize(confirmed = sum(confirmed))

deaths <- deathsglobal %>% gather(key = "date", value = "deaths",
                                  -c(Country.Region,Province.State, Lat, Long)) %>% 
  group_by(Country.Region, date) %>% 
  summarize(deaths=sum(deaths))

recovered <- recoveredglobal %>% gather(key = "date", value = "recovered",
                                        -c(Country.Region,Province.State,Lat,Long)) %>% 
  group_by(Country.Region, date) %>% 
  summarize(recovered = sum(recovered))
summary(confirmed)

#Final data : Combine all three
country <- full_join(confirmed,deaths) %>% full_join(recovered)


# Date variable
# Fix date variable and convert from character to date
str(country) # check date character
country$date <- country$date %>% sub("X", "", .) %>% as.Date("%m.%d.%y")
str(country) # check date Date

#Create new variable : number of days
country <- country %>% group_by(Country.Region) %>% 
  mutate(cumconfirmed = cumsum(confirmed), days = date - first(date) + 1)

#Aggregate at world level
world <- country %>% group_by(date) %>% 
  summarize(confirmed= sum(confirmed),
            cumconfirmed=sum(cumconfirmed),
            deaths=sum(deaths),
            recovered=sum(recovered))%>% 
  mutate(days = date-first(date)+1)

#Extract specific country : Italy
italy <- country %>% filter(Country.Region == "Italy")
italy

#SUMMARY STATISTICS
summary(country)
by(country$confirmed,country$Country.Region, summary)
by(country$cumconfirmed, country$Country.Region, summary)
by(country$deaths, country$Country.Region, summary)
by(country$recovered, country$Country.Region, summary)
summary(world)

#GRAPHS
#Barchart of cases over time
library(ggplot2)

#World confirmed
ggplot(world, aes(x = date, y= confirmed)) +
  geom_bar(stat="identity",
           width = 0.1)+
  theme_classic()+
  labs(title = "Covid-19 Global Confirmed Cases", x = "Date", y= "Daily confirmed cases")+
  theme(plot.title = element_text(hjust = 0.5))

# Italy confirmed
ggplot(italy, aes(x = date, y = confirmed)) + geom_bar(stat = "identity", width = 0.1)+
  theme_classic()+
  labs(title = "Covid-19 Confirmed Cases in Italy", x= "Date", y= "Daily confrmed cases")+
  theme(plot.title = element_text(hjust = 0.5))

# World confirmed, deaths, recovered
str(world)
world %>% gather("Type","Cases",-c(date,days)) %>% 
  ggplot(aes(x = date, y = Cases, colour = Type))+
           geom_bar(stat = "identity", width = 0.2, fill ="white")+
           theme_classic()+
           labs(title = "Covid-19 Global Cases", x = "Date", y = "Daily cases")+
           theme(plot.title = element_text(hjust = 0.5))

#Line graph of cases over time
#World confirmed
ggplot(world, aes( x = days, y = confirmed)) +
  geom_line()+
  theme_classic()+
  labs( title = "Covid-19 Global Confirmed Cases", x = "Days", y = "Daily confirmed cases")+
  theme(plot.title = element_text(hjust = 0.5))
# Ignore warning

#World confirmed with counts in log10 scale
ggplot(world, aes(x = days, y = confirmed))+
         geom_line()+
         theme_classic()+
         labs( title = "Covid-19 Global Confirmed Cases", x = "Days", y = "Daily confirmed cases(log scale)")+
         theme(plot.title = element_text(hjust = 0.5))+
         scale_y_continuous(trans = "log10")


#World confirmed, deaths and recovered
str(world)
world %>% gather("Type", "Cases", -c(date,days)) %>% 
  ggplot(aes(x=days, y = Cases, colour = Type))+
geom_line()+
  theme_classic()+
  labs(title = "Covid-19 Global Cases", x="Days", y = "Daily cases")+
theme(plot.title = element_text(hjust = 0.5))

#Confirmed by country for select countries with counts in log10 scale
countryselection <- country %>% filter(Country.Region == c("US","Italy","China","France","United Kingdom","Germany"))
ggplot(countryselection, aes(x = days, y = confirmed,
                             colour = Country.Region))+ geom_line(size=1)+
         theme_classic()+
         labs(title = "Covid-19 Confirmed Cases by Country", x = "Days", y = "Daily confirmed cases(log scale)")+
         theme(plot.title = element_text(hjust = 0.5))+
         scale_y_continuous(trans = "log10")

#Matrix of line grahs of confirmed, deaths and recovered for select countries in log10 scale
str(countryselection)
countryselection %>% gather("Type", "Cases", -c(date, days,Country.Region)) %>% 
  ggplot(aes(x = days, y = Cases, colour = Country.Region))+
  geom_line(size = 1)+
  theme_classic()+
  labs(title = "Covid-19 Cases by Country", x = "Days", y = "Daily cases(log scale)")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_y_continuous(trans="log10")+
  facet_grid(rows = vars(Type))

#--------------------------------------------------------------------------------------------------------------------------

##Map
countrytotal <- country %>% group_by(Country.Region) %>% 
  summarize(cumconfirmed=sum(confirmed),
            cumdeaths=sum(deaths), cumrecovered=sum(recovered))

#Basemap from package map
install.packages("tmaptools")
library(tmaptools)
library(tmap)
data(World)
class(world)

#Combine basemap data to covid data
countrytotal$Country.Region[!countrytotal$Country.Region%in%World$name]
