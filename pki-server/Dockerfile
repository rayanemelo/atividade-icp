FROM nginx:alpine

COPY ./pki-server/index.html /usr/share/nginx/html/index.html
COPY ./raiz/certs/raiz.crt.pem /usr/share/nginx/html/raiz/raiz.crt
COPY ./intermediaria/certs/intermediaria.crt.pem /usr/share/nginx/html/intermediaria/intermediaria.crt
COPY ./intermediaria/crl/intermediaria.crl.pem /usr/share/nginx/html/crl/intermediaria.crl
COPY ./pki-server/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]