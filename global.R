library(leaflet)
library(raster)
library(dplyr)

datos<-readRDS('data/datos elektra,monte,first,prendamex.rds')

datos<-datos %>%
  filter(!is.na(latitude))%>%
  filter(!is.na(longitude))


