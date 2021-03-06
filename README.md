# paywallthemovie-map

A map of screenings of Jason Schmitt's documentary "Paywall: The Business of Scholarship"

**[Browse the map online at https://paywallthemovie.gitlab.io/map](https://paywallthemovie.gitlab.io/map)**

## Add your screening

Choose one of the following, preferred method first:

1. Clone the repo and add your screening to the file `data/paywallthemovie-screenings.csv`, then open a merge request
  - Feel free to add a link to the description, in the following form: `<a href='http://your_link.url'>🔗</a>`
1. [Create an issue](https://gitlab.com/nuest/paywallthemovie-map/issues)
1. Send Daniel an email

## Initial data load

The data was manually copied from the page and inserted into the file `data/paywallthemovie-screenings.csv` as the first column `raw`.
Manual changes:

1. removing headlines ("US screenings" etc.)
1. putting all "data" in one line, i.e. date (if given) and location
1. removing whitespace and trailing punctuation
1. put `"` around raw data (has many commas in it...)
1. split up information in columns `date,time,description,place,raw`
1. remove duplicate lines ("City, ..")
1. commit state
1. geocode information in column `place` into column `location` save to GeoJSON file `public/screenings.json` with the R script `scripts/geolocate.R`

## Update map data (local R)

The main data file is a CSV file in `data`, but the map is based on a structured document with geolocation coordinates for each screening.
The [OpenCage](https://opencagedata.com) API is used for forward geocoding the text place names.
Add an OpenCage API key to a file `.Renviron` in the base directory of the project, following the instructions of the R package [`opencage`](https://github.com/ropensci/opencage).

Required R packages: `here`, `readr`, `opencage`, `sf`

Run the following command:

```
Rscript scripts/geolocate.R
```

## Update map data (container)

Run

```
make geolocate_container
```

## Map

Full page [Leaflet](https://leafletjs.com/) map with CSS and JS from CDNs.
Map has a custom markers using the Open Access logo with the movie CI color.

### Develop

Use a local webserver to resolve the paths:

```
docker run --rm -v $(pwd)/public:/usr/share/nginx/html -p 80:80 nginx
```

or on Windows:

```
MSYS_NO_PATHCONV=1 docker run --rm -v `pwd`/public:/usr/share/nginx/html -p 80:80 nginx
```

Then go to http://localhost/

## Licenses

Screening data for the movie Paywall: The Business of Scholarship is made available under the Open Data Commons Attribution License: http://opendatacommons.org/licenses/by/1.0

Code published under Apache License, Version 2.0. Copyright 2018 Daniel Nüst.

Text and documentation published under a Creative Commons Attribution 4.0 International (CC BY 4.0) license: https://creativecommons.org/licenses/by/4.0/
