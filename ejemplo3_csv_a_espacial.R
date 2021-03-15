# Cargar librerías --------------------------------------------------------

library(sf)
library(tidyverse)


# Cargar datos csv --------------------------------------------------------

paradas <- read_csv("data/stops.txt")


# Transformar a objeto espacial -------------------------------------------

paradas_sp <- st_as_sf(paradas, coords = c("stop_lon", "stop_lat"), crs = 4326)


# Visualización dinámica con mapview --------------------------------------

library(mapview)
mapview(paradas_sp)
