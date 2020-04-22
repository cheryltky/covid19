#gapminderanalysis.R
#load libraries
library(tidyverse)

#read in gapminder data
gapminder <- readr::read_csv('https://raw.githubusercontent.com/OHI-Science/data-science-training/master/data/gapminder.csv')

##filter country to plot
gap_to_plot <- gapminder %>% 
  filter(country == "Afghanistan")
##plot
my_plot <- ggplot(data = gap_to_plot, aes( x = year, y = gdpPercap))+
  geom_point()+
  #add title and save
  labs(title = paste("Afghanistan", "GDP per capita", sep = " "))
my_plot

#save this figure

ggsave(filename = "Afghanistan_gdpPercap.png", plot = my_plot)


#now instead of writing "Afghanistan" 3 times, we create an object that we assign this to

## create country variable
cntry <- "Afghanistan"

#now repeat all the steps above but replace "Afghanistan" with "cntry"


#what if I want to do these same commands for each of the countries?
#use for loop function

## create country variable
cntry <- "Afghanistan"

for (each cntry in a list of countries) {
  
}