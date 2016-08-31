library(leaflet)
library(raster)
library(dplyr)

datos<-readRDS('data/datos elektra,monte,first,prendamex.rds')

datos<-datos %>%
  dplyr::filter(!is.na(latitude))%>%
  dplyr::filter(!is.na(longitude))


