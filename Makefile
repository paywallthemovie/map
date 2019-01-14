default:
	Rscript scripts/geolocate.R

develop:
	docker run --rm -v $(shell pwd)/public:/usr/share/nginx/html:ro -p 80:80 nginx
