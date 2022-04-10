# caddy image
FROM ghcr.io/illallangi/caddy-builder:v0.0.3 as caddy

# confd image
FROM ghcr.io/illallangi/confd-builder:v0.0.1 AS confd

# main image
FROM docker.io/library/debian:buster-20220328

# install caddy
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy

# install confd
COPY --from=confd /go/bin/confd /usr/local/bin/confd

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    musl=1.1.21-2 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/*

# expose HTTP and HTTPS ports
EXPOSE 80 443

# set default variables
ENV DIMENSION_TITLE="Default Title" \
    DIMENSION_QUOTE="Mess with the best, Die like the rest" \
    DIMENSION_ATTRIBUTION="Dade Murphy"

# set entrypoint
ENTRYPOINT ["custom-entrypoint"]

# set command
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile", "--watch"]
