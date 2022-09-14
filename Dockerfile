# confd image
FROM ghcr.io/illallangi/toolbx:v0.0.8 as toolbx

# main image
FROM docker.io/library/debian:buster-20220912

# install confd
COPY --from=toolbx /usr/local/bin/confd /usr/local/bin/confd

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    lighttpd=1.4.53-4+deb10u2 \
    musl=1.1.21-2 \
    xz-utils=5.2.4-1+deb10u1 \
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

COPY rootfs /

CMD ["/init"]
