#load library 
library(tidyverse)
library(ggplot2)
library(gganimate)
theme_set(theme_bw())

#load the data
covid <- read_csv("~/Github/covid19/Data/Australian coronavirus tracking - latest totals.csv")
head(covid)
str(covid)
summary(covid)
#dataframe is already in a long format where all rows are observations and columns are variables

#static plot
p <- ggplot(
  covid,
  aes( x = State or territory , y = Confirmed cases ( cumulative), size = confirmed cases (cumulative), colour = State or territory))+
  geom_point(show.legend =  FALSE, alpha = 0.7)+
  scale_color_viridis_d()+
  sacle_size(range = c(2,12))
)

rlang::last_error()

