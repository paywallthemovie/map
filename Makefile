default:
	Rscript scripts/geolocate.R

develop:
	docker run --rm -v $(pwd)/public:/usr/share/nginx/html -p 80:80 nginx
