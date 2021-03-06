---
"TidyRtutorial"
date: "21 April 2020"

#Data wrangling with 'tidyr'


library(tidyverse)

#wide format
gap_wide <- readr::read_csv('https://raw.githubusercontent.com/OHI-Science/data-science-training/master/data/gapminder_wide.csv')

#yesterday's format
gapminder <- readr::read_csv('https://raw.githubusercontent.com/OHI-Science/data-science-training/master/data/gapminder.csv')

head(gap_wide)
str(gap_wide)

# To transform the data into a long format
?gather

gap_long <- gap_wide %>% 
  gather(key = obstype_year,
         value = obs_values)

str(gap_long)
head(gap_long)
tail(gap_long)

#give the program more information on which columns we want reshaped

gap_long <- gap_wide %>% 
  gather(key = obstype_year, 
         value = obs_values,
         dplyr::starts_with('pop'),
         dplyr::starts_with('lifeExp'),
         dplyr::starts_with('gdpPercap'))# name all the old columns to be included into this single new column

str(gap_long)
head(gap_long)
tail(gap_long)

?separate

gap_long <- gap_wide %>% 
  gather(key = obstype_year,
         value = obs_values,
         -continent, -country) %>% 
  separate(obstype_year,
           into = c('obs_type', 'year'),
           sep = "_",
           convert = TRUE) #this ensures that the year column is an integer rather than a character

str(gap_long)
head(gap_long)
tail(gap_long)

#plotting long format data with ggplot2, just Canada's data
canada_df <- gap_long %>% 
  filter(obs_type == "lifeExp",
         country == "Canada")
ggplot(canada_df, aes( x= year, y = obs_values))+
  geom_line()

#look at all countries in the Americas

life_df <- gap_long %>% 
  filter(obs_type == "lifeExp",
         continent == "Americas")
ggplot(life_df, aes( x = year, y = obs_values, color = country)) +
  geom_line()


#Using gap_long, calcuate the mean life expectancy for each continet from 1982 to 2007 over time.


continents <- gap_long %>% 
  filter(obs_type == "lifeExp",
         year > 1981) %>% 
  group_by(continent, year) %>% 
  summarize(mean_le = mean(obs_values)) %>% 
  ungroup()
continents #check

ggplot(data = continents, aes(x = year, y = mean_le, color = continent)) +
  geom_line()+
  labs(title = "Mean Life Expectancy",
       x = "Year",
       y = "Age (years)",
       color = "Continent")+
  theme_classic()+
  scale_fill_brewer(palette = "Blues")


#Using spread() to put our data back into wide format

gap_normal <- gap_long %>% 
  spread(obs_type, obs_values)
#check

dim(gap_normal)
dim(gapminder)
names(gap_normal)
names(gapminder)

#now my df for gap_normal is the same as gapminder

#Next, convert gap_long all the way back to gap_wide

head(gap_long)#remember the columns

gap_wide_new <- gap_long %>% 
  
#first unite obs_type and year into a new column called var_names, separate by _
unite(col = var_names,obs_type, year, sep = "_") %>% 
#then spread var_names out by key-value pair
spread(key = var_names, value = obs_values)

str(gap_wide_new)


