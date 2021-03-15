# Leer un raster de temperatura del mes de enero
# Convertir unidades multiplicando por factor 0.02 y luego convertir a Celsius
# Cargar datos vectoriales de España 
# Realizar estadísticas zonales por campo "ETIQUETA"


# Cargar librerías --------------------------------------------------------
library(raster)
library(tidyverse)
library(sf)



# Leer raster -------------------------------------------------------------

lst <- raster("data/raster/lst_01.tif")
lst <- (lst * 0.02) - 273.15
plot(lst)


# Cargar y seleccionar comunidad ------------------------------------------

comunidad <- read_sf("data/limites_espana.shp") %>% 
  filter(CCAA == "Castilla León") %>% 
  st_transform(crs = st_crs(lst)) # Transformar a crs de raster


# Hacer estadística zonal -------------------------------------------------

temp_ene <- comunidad %>%
  mutate(ene = as.vector(raster::extract(
    lst, comunidad["ETIQUETA"], fun = mean, na.rm = T
  )))


# Hacer gráfico -----------------------------------------------------------

ggplot(temp_ene)+
  geom_sf(aes(fill = ene))+
  geom_sf_text(aes(label = ETIQUETA))+
  scale_fill_distiller(palette = "Spectral")

