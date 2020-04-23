#gapminderanalysis.R
#load libraries
library(tidyverse)

#read in gapminder data
gapminder <- readr::read_csv('https://raw.githubusercontent.com/OHI-Science/data-science-training/master/data/gapminder.csv')


#create country variable
cntry <- "Afghanistan"

#create list of countries
country_list <- c("Albania", "Fiji", "Spain")

for (cntry in country_list) {
  
  ##filter country to plot
  gap_to_plot <- gapminder %>% 
    filter(country == cntry)
  
  ##plot
  my_plot <- ggplot(data = gap_to_plot, aes( x = year, y = gdpPercap))+
    geom_point()+
  #add title and save
  labs(title = paste(cntry, "GDP per capita", sep = " "))
  
  #save this figure
  ggsave(filename = paste(cntry, "_gdpPercap.png", sep = ""), plot = my_plot)
  
}


  