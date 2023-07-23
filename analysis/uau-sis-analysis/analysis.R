library(tidyverse)

my_data <- read_csv("../../test.csv")

my_data %>% ggplot() +
  aes(x = step, y = sum_health) +
  geom_point() +
  facet_wrap(~susceptibility)
