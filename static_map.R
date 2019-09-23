library(sf)


sf_nuts3 <- st_as_sf(leaf_dt) %>%
  mutate(bin = case_when(
    value < 500 ~ "0 - 500",
    value < 1000 ~ "500 - 1,000",
    value < 2500 ~ "1,000 - 2,500",
    value < 5000 ~ "2,500 - 5,000",
    value < 7000 ~ "5,000 - 7,000",
    value < 40000 ~ "7,000 - 40,000",
    value < 50000 ~ "40,000 - 50,000",
    TRUE ~ NA_character_
  ),
  bin = factor(bin, levels = c("0 - 500", "500 - 1,000", "1,000 - 2,500",
                                "2,500 - 5,000", "5,000 - 7,000",
                                "7,000 - 40,000", "40,000 - 50,000")))

sf_lond <- st_as_sf(london_spdf)
sf_manc <- st_as_sf(manchester_spdf)
sf_core <- st_as_sf(cities_spdf)


pal <- scales::col_bin("")

ggplot(sf_nuts3) +
  geom_sf(aes(fill = bin),
          size = 0.25,
          show.legend = FALSE,
          colour = "#aaaaaa") +
  geom_sf(data = sf_lond,
          size = 1,
          show.legend = FALSE,
          fill = NA,
          colour = "#F47738") +
  geom_sf(data = sf_manc,
          size = 1,
          show.legend = FALSE,
          fill = NA,
          colour = "#F47738") +
  geom_sf(data = sf_core,
          size = 1,
          show.legend = FALSE,
          fill = NA,
          colour = "#F47738") +
  scale_fill_brewer(palette = "YlGnBu", direction = 1) +
  theme_void() +
  coord_sf(datum = NA)
