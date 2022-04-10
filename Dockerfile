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
    xz-utils=5.2.4-1 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/* /var/www/html/*

# expose HTTP port
EXPOSE 80

# set version for s6 overlay
ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

COPY root /

CMD ["/init"]