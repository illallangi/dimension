# confd image
FROM ghcr.io/illallangi/confd-builder:v0.0.2 AS confd

# main image
FROM docker.io/library/debian:buster-20220328

# install confd
COPY --from=confd /go/bin/confd /usr/local/bin/confd

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    lighttpd=1.4.53-4+deb10u2 \
    musl=1.1.21-2 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/* /var/www/html/*

# expose HTTP port
EXPOSE 80

# set default variables
ENV DIMENSION_TITLE="Default Title" \
    DIMENSION_QUOTE="Mess with the best, Die like the rest" \
    DIMENSION_ATTRIBUTION="Dade Murphy"

COPY root /

# set entrypoint
ENTRYPOINT ["custom-entrypoint"]

# set command
CMD ["/usr/sbin/lighttpd","-D","-f","/etc/lighttpd/lighttpd.conf"]
