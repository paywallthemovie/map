library("here")
library("readr")

# load data
dataFile <- here("data/paywallthemovie-screenings.csv")
screenings <- read_csv(dataFile)
head(screenings)

# http://www.storybench.org/geocode-csv-addresses-r/
#library("ggmap")
# single geocoding
#geocodeQueryCheck()
#ggmap::geocode(screenings$place[[1]])
#ggmap::geocode(screenings$place[1:3])

# devtools::install_github("hrbrmstr/nominatim")
#library("nominatim")
#nominatim::osm_geocode(query = screenings$place[[1]], email = "daniel.nuest@uni-muenster.de")
# need API key..


# https://github.com/ropensci/opencage
#opencage_key <- Sys.getenv("OPENCAGE_KEY")
library("opencage")
# single test
#opencage_forward(placename = screenings$place[[1]], limit = 1)$results[1,]
coords <- lapply(screenings$place, function(place) {
  result <- opencage_forward(placename = place, limit = 1)$results[1,]
  tibble::data_frame(x = as.numeric(levels(result$annotations.Mercator.x)),
                     y = as.numeric(levels(result$annotations.Mercator.y)))
})

coords <- do.call(rbind, coords)
screenings$x <- coords$x
screenings$y <- coords$y
head(screenings)

library("sf")
screenings_geo <- st_as_sf(screenings, coords = c("x", "y"), crs = 3395)
screenings_latlon <- st_transform(screenings_geo, crs = 4326)

# devtools::install_github("r-spatial/mapview", ref = "develop") because of https://github.com/r-spatial/mapview/issues/177
library("mapview")
mapview::mapView(screenings_latlon)

# save to GeoJSON:
sf::st_write(screenings_latlon, "public/screenings.json", driver = "GeoJSON")
# adds ""crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } }," which GeoJSON linter complains about



# create interactive map with R
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
