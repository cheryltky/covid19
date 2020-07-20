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
