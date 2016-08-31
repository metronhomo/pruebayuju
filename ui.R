library(shiny)
library(leaflet)
library(raster)

vars=c("Top estados"="pagoEstadoNombre",
       "Top municipios"="pagoCiudadNombre")

vars2=c("monto total (en millones de pesos)"="monto",
        "envíos totales"="dummy",
        "monto promedio de los envíos"="montoP")


shinyUI(navbarPage("Metronhomo", id="nav",
                   
                   tabPanel("Mapa Interactivo",
                            div(class="outer",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("styles.css")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                
                                # Shiny versions prior to 0.11 should use class="modal" instead.
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto"
                                           

                                              
                                ),
                                
                                tags$div(id="cite",
                                         '', tags$em('Metronhomo 2016')
                                )
                            )
                   ),      
 
                   conditionalPanel("false", icon("crosshair"))
))
