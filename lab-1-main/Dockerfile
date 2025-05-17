FROM alpine:latest

RUN apk add --no-cache nginx 

COPY nginx.conf /etc/nginx/nginx.conf

RUN adduser -D -g 'www' www \
	&& mkdir -p /var/lib/nginx/tmp /var/lib/nginx/logs /var/run/nginx \
	&& chown -R www:www /var/run/nginx \
	&& chown -R www:www /var/lib/nginx \
	&& chmod -R 755 /var/lib/nginx \
    && mkdir -p /var/www/html \
    && chown -R www:www /var/www/html

USER www

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]