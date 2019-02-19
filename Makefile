default: geolocate_container map

geolocate:
	Rscript scripts/geolocate.R

image:
	docker build --tag paywallthemoview-map .

geolocate_container: image
	docker run -v $(shell pwd)/data:/map/data:ro -v $(shell pwd)/scripts/:/map/scripts:ro -v $(shell pwd)/public/:/map/public:rw -v $(shell pwd)/.Renviron:/map/.Renviron:ro --name paywallmap paywallthemoview-map
	docker cp paywallmap:/map/public/screenings.json public/screenings.json
	docker cp paywallmap:/map/public/statistics.json public/statistics.json
	docker rm -f paywallmap

map:
	docker run --rm -v $(shell pwd)/public:/usr/share/nginx/html:ro -p 80:80 nginx
