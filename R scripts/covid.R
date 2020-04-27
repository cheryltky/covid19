#load library 
library(tidyverse)
library(ggplot2)
library(gganimate)
theme_set(theme_bw())

#load the data
covid <- readr::read_csv("~/Github/covid19/Data/Australian coronavirus tracking - latest totals.csv")
head(covid)
str(covid)
summary(covid)

#globaldata
global <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

head(global)
str(global)
summary(global)


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
  
  
ggplot(data = global) +
  aes(x = Country/Region, y = )