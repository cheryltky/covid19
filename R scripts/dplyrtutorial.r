---
title: "dplyr tutorial"
author: "Cheryl"
date: "15 April 2020"
output: html_document
---


library(tidyverse)
gapminder <- readr::read_csv("https://raw.githubusercontent.com/OHI-Science/data-science-training/master/data/gapminder.csv")

head(gapminder)
tail(gapminder)
head(gapminder,10)#shows first time I indicate
str(gapminder)
names(gapminder)
summary(gapminder)

# to specify a single variable from a data frame
```{r}
head(gapminder$lifeExp)
str(gapminder$lifeExp)
summary(gapminder$lifeExp)
dim(gapminder)
```
#dplyr functions
#filter for rows/observations
#select for columns/variables
#mutate for creating new variables
#summarise for collapsing values into a single summary
#arrange for reordering rows
#groupby 

```{r}
#to subset observations, filter gapminder data for life expetancy less than 29
filter(gapminder, lifeExp < 29)

#filter the gapminder data for the country mexico
filter(gapminder, country == "Mexico")
```

```{r}
# use the %in% (shift ctrl m) to filter for more than one country
filter(gapminder, country %in% c("Mexico", "Peru"))
# mexico in 2002
filter(gapminder, country == "Mexico", year ==2002)
```

```{r}
#Average life expectancy in Brazil b/w 1987 and 2007
x <- filter(gapminder, country == "Brazil", year > 1986)
mean(x$lifeExp)
```

```{r}
#select multiple columns with a comma after specifying the data frame ( gapminder)

select(gapminder, year, country, lifeExp)

# or use select to DEselect columns too
select(gapminder, -continent, -lifeExp)
```

```{r}
# filter for Cambodia, remove continent and lifeExp by using filter and select
gap_cambodia <- filter(gapminder, country =="Cambodia")
gap_cambodia2 <- select(gap_cambodia, -continent, -lifeExp)

gap_cambodia2

#or I can use the %>% function
gap_cambodia <- gapminder %>% 
  filter(country == "Cambodia") %>% 
  select(-continent, -lifeExp)

```

```{r}
#Use piping function instead of subsetting manually
# To see the first 3 rows of Gapminder, we can say
head(gapminder, 3)
#0R
gapminder %>% head(3)

```

```{r}

#mutate adds new variables or adds a new column to your data frame

#to calculate the country's gdp
head(gapminder)

gapminder %>%
  mutate(gdp = pop*gdpPercap) %>% 
select(country, gdp) # this cleans up the dataframe

#Calculate the population in thousands for all Asian countries in the year 2007 and add it as a new column.

gapminder %>% 
  filter(continent == "Asia",
         year == 2007) %>% 
  mutate(pop_thousands = pop/1000) %>% 
  select(country, year, pop_thousands) # this cleans up the dataframe but isn't necessary

```

```{r}
# grouping variable
#What if we wanted to know the total population on each continent in 2002? 

gapminder %>% 
  filter(year == 2002) %>%
  group_by(continent) %>% # add up all country populations by their associated continents
  mutate(cont_pop = sum(pop))#creates a new column called cont_pop

# now we want only columns showing continent and their population in 2002
# use summarize or group_by function
gapminder %>% 
  group_by(continent) %>% 
  summarize(cont_pop = sum(pop)) %>% #summarize groups only columns we want
  ungroup()

#to use more than 1 grouping variable

gapminder %>% 
  group_by(continent, year) %>% 
  summarize(cont_pop = sum(pop)) %>% 
  arrange(year)#arrange function orders columns

#What is the maximum GDP per continent across all years?
gapminder %>% 
  mutate(gdp = pop*gdpPercap ) %>% 
  group_by(continent) %>% 
  mutate(max_gdp = max(gdp)) %>% 
  filter(gdp == max_gdp) %>% 
  select(continent, gdp)

#arrange the df in descending order
?arrange
gapminder %>% 
  group_by(continent,year) %>% 
  summarize(cont_pop = sum(pop)) %>% 
  arrange(desc(year)) %>% 
 ungroup()

#Find the maximum life capacity for countries in Asia

asia_life_exp <- gapminder %>% 
  filter(continent == 'Asia') %>% 
  group_by(country) %>% 
  filter(lifeExp == max(lifeExp)) %>% 
  arrange(year)
asia_life_exp
```





