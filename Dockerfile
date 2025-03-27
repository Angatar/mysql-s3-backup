FROM alpine:latest
LABEL org.opencontainers.image.authors="d3fk"
LABEL org.opencontainers.image.source="https://github.com/Angatar/mysql-s3-backup.git"
LABEL org.opencontainers.image.url="https://github.com/Angatar/mysql-s3-backup"

RUN apk upgrade --no-cache \
  &&  echo  https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
  && apk add --no-cache mysql-client mariadb-connector-c gpg ca-certificates s3cmd
  
WORKDIR /s3
