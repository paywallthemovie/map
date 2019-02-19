FROM rocker/geospatial:3.5.1

RUN install2.r --error \
    opencage \
    here \
    pbapply

WORKDIR /map

CMD ["Rscript", "scripts/geolocate.R"]
