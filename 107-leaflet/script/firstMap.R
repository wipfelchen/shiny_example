# sandra's 1. app

setwd("107-leaflet")

### Pakete installieren und einbinden
# install.packages("xlsx")
# install.packages("data.table")
# install.packages("devtools")
# install_github("rstudio/leaflet")
# install.packages("htmltools")
library(xlsx)
library(data.table)
library(devtools)
library(leaflet)
library(htmltools)

### Daten einlesen
dbgarra1 <- read.xlsx2("data/Garra_DBAll_Koordinaten_20151005.xlsx", sheetName="Garra_DB")
dbgarra <- data.table(dbgarra1)
str(dbgarra)

### Daten vorbereiten
# verändern der Klasse
dbgarra$longitude <- as.numeric(as.character(dbgarra$longitude))
dbgarra$latitude <- as.numeric(as.character(dbgarra$latitude))
dbgarra$altitude <- as.numeric(as.character(dbgarra$altitude))
dbgarra$genCode <- as.character(dbgarra$genCode)
str(dbgarra)

# hat er leere Zellen als NA erkannt?
dbgarra$longitude

# Subset mit Datensatz ohne NA (dg)
dg = dbgarra[!with(dbgarra, is.na(longitude) & is.na(latitude)),]

### Karte erstellen
# Basiskarte + pipe(%>%)
m <- leaflet(data=dg) %>%
  # addTiles() %>% # Standardkarte von Openstreetmap, weitere Karten unter http://leaflet-extras.github.io/leaflet-providers/preview/index.html
  addProviderTiles("Esri.WorldImagery") %>%
  addMarkers()
m

# individualisierte Icons
fishIcon <- makeIcon(
  iconUrl = "http://icons.iconarchive.com/icons/martin-berube/flat-animal/256/gold-fish-icon.png",
  iconWidth = 42, iconHeight = 42,
  iconAnchorX = 00, iconAnchorY = 00
  #shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
  #shadowWidth = 50, shadowHeight = 64,
  #shadowAnchorX = 4, shadowAnchorY = 62
)
leaflet(data=dg) %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addMarkers(~longitude, ~latitude, icon=fishIcon)


# unterschiedliche Icons
fishIcons <- icons(
  iconUrl = ifelse(dg$phenotype=="surface",
                   "http://icons.iconarchive.com/icons/martin-berube/flat-animal/128/fish-icon.png",
                   "http://icons.iconarchive.com/icons/martin-berube/flat-animal/256/gold-fish-icon.png"
  ),
  iconWidth = 45, iconHeight = 45,
  iconAnchorX = 00, iconAnchorY = 00
#   shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
#   shadowWidth = 50, shadowHeight = 64,
#   shadowAnchorX = 4, shadowAnchorY = 62
)
leaflet(data=dg) %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addMarkers(~longitude, ~latitude, icon=fishIcons)


# Popup
leaflet(data=dg) %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addMarkers(~longitude, ~latitude, icon=fishIcons, popup=~htmlEscape(locality))





