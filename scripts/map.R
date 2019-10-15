#########################
# interactive maps with R

library("sf")

screenings <- read_sf("public/screenings.json")
library("mapview")

mapview::mapView(screenings)

# <- makeIcon(
#  iconUrl = "oaicon.png",
#  iconWidth = 25, iconHeight = 32,
#  #iconAnchorX = 22, iconAnchorY = 94
#)
#
#library("leaflet")
#m <- leaflet(data = screenings_latlon) %>%
#  addTiles() %>%
#  addMarkers(popup = ~as.character(description),
#             label = ~as.character(place),
#             icon = oaIcon)
#mapshot(m, 'map.html')
