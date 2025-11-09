FROM nginx:alpine

COPY ./fullchain.pem /etc/ssl/certs/fullchain.pem
COPY ./web-server/private/web.local.key.pem /etc/ssl/private/web.local.key.pem
COPY ./web-server/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
