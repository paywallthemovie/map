# Geolocating Paywall movie screenings, Copyright 2018 Daniel Nüst

library("here")
library("readr")
library("pbapply")
pbapply::pboptions(type = "timer")

cat("Loading data\n")
dataFile <- here::here("data/paywallthemovie-screenings.csv")
screenings <- read_csv(dataFile, col_types = "Dtccc")
summary(screenings)

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

cat("Geocoding addresses\n")
# https://github.com/ropensci/opencage
#opencage_key <- Sys.getenv("OPENCAGE_KEY")
library("opencage")
# single test
#opencage_forward(placename = screenings$place[[1]], limit = 1)$results[1,]
coords <- pbapply::pblapply(screenings$place, function(place) {
  result <- opencage_forward(placename = place, limit = 1)$results[1,]
  if(is.null(result)) {
    cat("Error geocoding place: ", place, "\n")
    stop()
  }
  #browser()
  found <- toString(result$formatted)
  tibble::tibble(place = place,
                 found = found,
                 x = as.numeric(levels(result$annotations.Mercator.x)),
                 y = as.numeric(levels(result$annotations.Mercator.y)))
  #cat("Geocoded: ", place, " >>> ", toString(result$formatted), "\n")
})
coords <- do.call(rbind, coords)

# find out about non-geocoded entries:
#dplyr::anti_join(screenings, coords, by = "place")

screenings$x <- coords$x
screenings$y <- coords$y
head(screenings)
dim(screenings)

cat("Converting to geocoordinates\n")
library("sf")
screenings_geo <- sf::st_as_sf(screenings, coords = c("x", "y"), crs = 3395)
screenings_latlon <- sf::st_transform(screenings_geo, crs = 4326)
screenings_latlon$time <- as.character(screenings_latlon$time)

cat("Save data as GeoJSON (removing the old file beforehand)\n")
unlink("public/screenings.json")
sf::st_write(screenings_latlon, "public/screenings.json", driver = "GeoJSON")

cat("Save stats to file\n")
library("jsonlite")
write(toJSON(list(screenings = nrow(screenings), lastUpdate = Sys.time()),
             auto_unbox = TRUE,
             pretty = TRUE),
      "public/statistics.json")

cat("Done\n")

#########################
# interactive maps with R

# devtools::install_github("r-spatial/mapview", ref = "develop") because of https://github.com/r-spatial/mapview/issues/177
#library("mapview")
#mapview::mapView(screenings_latlon)

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
