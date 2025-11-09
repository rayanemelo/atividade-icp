FROM alpine:latest

RUN apk add --no-cache curl ca-certificates

COPY ./raiz/certs/raiz.crt.pem /usr/local/share/ca-certificates/raiz.crt.pem
RUN update-ca-certificates

COPY ./client/test.sh /test.sh
RUN chmod +x /test.sh

CMD ["/test.sh"]
