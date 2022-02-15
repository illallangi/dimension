# main image
FROM docker.io/library/debian:buster-20220125

# install caddy
COPY --from=ghcr.io/illallangi/caddy-builder:v0.0.1 /usr/bin/caddy /usr/local/bin/caddy

# install confd
COPY --from=ghcr.io/illallangi/confd-builder:v0.0.1 /go/bin/confd /usr/local/bin/confd

# add local files
COPY root/ /

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
