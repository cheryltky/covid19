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

#Transition between diff stages of the data
library(dplyr)
mean.temp <- airquality %>% 
  group_by(Month) %>% 
  summarise(Temp = mean(Temp))
mean.temp

#create a bar plot of mean temperature

p <- ggplot(mean.temp, aes(Month, Temp, fill = Temp)) +
geom_col()+
  scale_fill_distiller(palette = "Reds", direction = 1)+
  theme_minimal()+
  theme(
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "white"),
    panel.ontop = TRUE)
p

#transition states

p + transition_states(Month, wrap = FALSE)+
  shadow_mark()+
#enter grow and fdae
enter_grow()+
  enter_fade()
