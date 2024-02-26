FROM alpine:latest
LABEL org.opencontainers.image.authors="d3fk"
LABEL org.opencontainers.image.source="https://github.com/Angatar/mysql-s3-backup.git"
LABEL org.opencontainers.image.url="https://github.com/Angatar/mysql-s3-backup"

RUN apk upgrade --no-cache \
  && apk add --no-cache mysql-client libmagic git ca-certificates python3 py3-six py3-pip py3-setuptools py3-dateutil py3-magic \
  && git clone https://github.com/s3tools/s3cmd.git /tmp/s3cmd \
  && cd /tmp/s3cmd \
  && python3 /tmp/s3cmd/setup.py install \
  && cd / \
  && apk del git \
  && rm -rf /tmp/s3cmd 

WORKDIR /s3
