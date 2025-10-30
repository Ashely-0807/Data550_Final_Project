here::i_am(
  "code/01_make_output.R"
)
library(tidyverse)
library(ggplot2)
absolute_path_to_data <- here::here("data","netflix_titles.csv")
data <- read.csv(absolute_path_to_data, header = TRUE, encoding = "UTF-8")

# Table 1. Number of Movies vs TV Shows )
table_type <-data  %>%
  filter(!is.na(type)) %>%
  group_by(type) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

saveRDS(
  table_type,
  file = here::here("output", "table_type.rds")
)

# Table 2.Top 10 Countries by Number of Movies (excluding missing values)
top_movies <- data %>%
  filter(type == "Movie" & !is.na(country) & country != "") %>%
  count(country, sort = TRUE) %>%
  slice_max(n, n = 10)

saveRDS(
  top_movies,
  file = here::here("output", "top_movies.rds")
)

#Table 3.Top 10 Countries by Number of TV Shows (excluding missing values)
top_tv <- data %>%
  filter(type == "TV Show" & !is.na(country) & country != "") %>%
  count(country, sort = TRUE) %>%
  slice_max(n, n = 10)

saveRDS(
  top_tv,
  file = here::here("output", "top_tv.rds")
)
## Figure 1. Growth of Netflix Movies and TV Shows Over Time (Excluding Missing Values)
figure1 <- data %>%
  filter(!is.na(release_year), !is.na(type), type != "", release_year != "") %>%
  group_by(release_year, type) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = release_year, y = count, color = type)) +
  geom_line(linewidth = 1.2) +
  labs(
    title = "Netflix Catalog Growth Over Time by Type (Based on Release Year)",
    x = "Release Year",
    y = "Number of Titles",
    color = "Content Type"
  ) +
  theme_minimal()

saveRDS(
  figure1,
  file = here::here ("output", "figure1.rds")
)
# Figure 2. Distribution of Netflix Titles by Rating and Content Type (Excluding Missing Values)
figure2 <- data %>%
  filter(!is.na(rating), rating != "", !is.na(type), type != "") %>%
  group_by(rating, type) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(x = reorder(rating, -count), y = count, fill = type)) +
  geom_col(position = "dodge") +
  labs(
    title = "Distribution of Netflix Titles by Rating and Content Type",
    x = "Rating",
    y = "Number of Titles",
    fill = "Content Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveRDS(
  figure2,
  file = here::here ("output", "figure2.rds")
)

quit(save="no")