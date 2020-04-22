library(ggplot2)
library(gganimate)
theme_set(theme_bw())

library(gapminder)
head(gapminder)

#static plot
p <- ggplot(
  gapminder,
  aes(x = gdpPercap, y = lifeExp, size = pop, color = 
        country)) +
  geom_point(show.legend = FALSE, alpha = 0.7) +
  scale_color_viridis_d() +
  scale_size(range = c(2,12)) +
  scale_x_log10() +
  labs(x = "GDP per capita", y = "Life expectancy")
p

#time transition plot

p + transition_time(year) +
  labs(title = "Year:{frame_time}")

#create facets by continent
p + facet_wrap(~ continent) +
  transition_time(year)+
  labs(title = "Year:{frame_time}")

#staticplot in line graphs

p <- ggplot(
  airquality,
  aes(Day,Temp,group = Month, color = factor(Month))) +
  geom_line() +
  scale_color_viridis_d() +
  labs ( x = "Day of Month", y = "Temperature") +
  theme(legend.position = "top")

p

#Let data gradually appear
## Reveal by day ( x-axis)

p + transition_reveal(Day)

#show points

p +
  geom_point() +
  transition_reveal(Day)

#keeping points on a graph

p +
  geom_point(aes(group = seq_along(Day)))+
  transition_reveal(Day)
