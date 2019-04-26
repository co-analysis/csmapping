library(tidyverse)
library(geojsonio)
library(sp)
library(leaflet)

cs18_lad <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_129_1.data.csv?geography=1820327937...1820328307&date=latest&department=0&national_identity=0&gender=0&full_part_time=0&ethnic_group=0&disability_status=0&wage_band=0&civil_service_grade=0&age_band=0&measures=20100")

spdf_lad <- geojson_read("https://opendata.arcgis.com/datasets/bbb0e58b0be64cc1a1460aa69e33678f_0.geojson", what = "sp")

lad_dt <- cs18_lad %>%
  select(geo_id = GEOGRAPHY_CODE, name = GEOGRAPHY_NAME, value = OBS_VALUE) %>%
  mutate(pc = formattable::percent(
    value/sum(cs18_lad$OBS_VALUE, na.rm = TRUE))) %>%
  drop_na(pc)

lad_leaf <- sp::merge(spdf_lad, lad_dt, by.x = "lad19cd", by.y = "geo_id")

quantcol <- colorQuantile("Purples", lad_dt$value, n = 7, na.color = NA)

bincol <- colorBin("Purples",
                   lad_dt$value,
                   bins = c(0, 500, 2500, 10000, 40000, 50000),
                   pretty = FALSE,
                   na.color = NA)


leaflet(lad_leaf) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(color = "#ffffff",
              weight = 2,
              fillColor = ~bincol(value),
              popup = ~paste(name, value, sep = ": "),
              fillOpacity = 0.8)
