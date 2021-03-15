# Leer un conjunto de rásters de temperatura superficial en Kelvin
# Convertir unidades multiplicando por factor 0.02 y luego convertir a Celsius
# Cargar datos vectoriales de España y filtrar por Comunidad
# Cortar conjunto de rásters por comunidad
# Visualizar rásters de temperaturas por mes


# Cargar librerías --------------------------------------------------------
library(raster)
library(tidyverse)
library(sf)


# Hacer ráster stack y cálculos -------------------------------------------

l <- list.files("data/raster/", full.names = T)
lst <- stack(l)
lst <- (lst * 0.02) - 273.15


# Leer y filtrar comunidad ------------------------------------------------

comunidad <- st_read("data/limites_espana.shp") %>% 
  filter(CCAA == "Andalucía") %>% 
  st_transform(crs = crs(lst))


lst_mask <- crop(mask(lst, comunidad), comunidad)


# Gráfico Rápido ----------------------------------------------------------

plot(lst_mask)


# Gráfico con ggplot2 -----------------------------------------------------

lst_mask_tb <- data.frame(rasterToPoints(lst_mask))
lst_mask_tbl <- lst_mask_tb %>%
  pivot_longer(
    cols = -c(1, 2),
    names_to = "mes",
    values_to = "temp",
    names_prefix = "lst_"
  ) %>% 
  mutate(mes = factor(as.numeric(mes), levels = 1:12, labels = locale("es")$date_names$mon))

p <- ggplot() +
  geom_raster(data = lst_mask_tbl, mapping = aes(x = x, y = y, fill = temp)) +
  geom_sf(data = comunidad, fill="transparent")+
  facet_wrap( ~ mes) +
  scale_fill_distiller(palette = "RdYlBu")
p +  theme_dark()
