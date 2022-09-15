# main image
FROM ghcr.io/illallangi/debian:v0.0.1

# install lighttpd
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    lighttpd=1.4.53-4+deb10u2 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/*

# add local files
COPY rootfs /
