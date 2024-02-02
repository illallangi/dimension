# Main image
FROM docker.io/library/debian:bookworm-20240130
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    ca-certificates=20230311 \
    curl=7.88.1-10+deb12u5 \
    gnupg=2.2.40-1.1 \
    gnupg1=1.4.23-1.1+b1 \
    gnupg2=2.2.40-1.1 \
    lighttpd=1.4.69-1 \
    musl=1.2.3-1 \
    xz-utils=5.4.1-0.2 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/*

# Install confd
RUN \
  if [ "$(uname -m)" = "x86_64" ]; then \
    curl https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 --location --output /usr/local/bin/confd \
  ; fi \
  && \
  if [ "$(uname -m)" = "aarch64" ]; then \
    curl https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-arm64 --location --output /usr/local/bin/confd \
  ; fi \
  && \
  chmod +x \
    /usr/local/bin/confd

# Install s6 overlay
RUN \
  if [ "$(uname -m)" = "x86_64" ]; then \
    curl https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer --location --output /tmp/s6-overlay-installer \
  ; fi \
  && \
  if [ "$(uname -m)" = "aarch64" ]; then \
    curl https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-aarch64-installer --location --output /tmp/s6-overlay-installer \
  ; fi \
  && \
  chmod +x \
    /tmp/s6-overlay-installer \
  && \
  /tmp/s6-overlay-installer / \
  && \
  rm /tmp/s6-overlay-installer

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Set command
CMD ["/init"]

# Copy rootfs
COPY rootfs /
