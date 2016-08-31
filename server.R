library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate

# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see

shinyServer(function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.metronhomo.com.mx/">Metronhomo</a>'
      ) %>%
      setView(lng = -95.9, lat = 24, zoom = 5)
  })
  
  # Me quedo sólo con lo que se ve en el mapa
  datosEnRango <- reactive({
    if (is.null(input$map_bounds))
      return(datos[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(datos,
           latitude >= latRng[1] & latitude <= latRng[2] &
             longitude >= lngRng[1] & longitude <= lngRng[2])
  })
  
 
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
      # Color and palette are treated specially in the "superzip" case, because
      # the values are categorical instead of continuous.
      colorData <- datos$marca
      pal <- colorFactor(c('orange','darkred','green','black'), colorData)
    leafletProxy("map", data = datos) %>%
      clearShapes() %>%
      addCircleMarkers(~longitude, ~latitude, clusterOptions=markerClusterOptions(disableClusteringAtZoom=10),radius=8, layerId=~ID,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData),popup=paste(
                   datos$marca, "<br>",
                   "Nombre: ", datos$nombre, "<br>",
                   "Dirección: ", datos$direccion, "<br>",
                   "CP: ",datos$cp, "<br>",
                   "Tipos de empeño: ",datos$categoria, "<br>"
                 )) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title='Marcas',
                layerId="colorLegend")
  })
  

  
  
})
