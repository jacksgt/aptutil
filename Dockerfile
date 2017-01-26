FROM debian:stretch
MAINTAINER Jack Henschel <jh@openmailbox.org>

EXPOSE 3142

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    golang-go \
    git \
    ca-certificates \
    bash

RUN useradd --home-dir "/home/aptutil" --create-home "aptutil" \
    && mkdir -p "/var/spool/go-apt-mirror/" \
    && chown -R aptutil "/var/spool/go-apt-mirror/" \
    && mkdir -p "/var/spool/go-apt-cacher/" \
    && mkdir -p "/var/spool/go-apt-cacher/cache/" \
    && mkdir -p "/var/spool/go-apt-cacher/meta/" \
    && chown -R aptutil "/var/spool/go-apt-cacher/"

#COPY cmd/go-apt-mirror/mirror.toml /etc/go-apt-mirror.toml
#COPY cmd/go-apt-cacher/go-apt-cacher.toml /etc/go-apt-cacher.toml
COPY entrypoint.sh /entrypoint.sh

WORKDIR "/home/aptutil"
USER "aptutil"
ENV GOPATH="/home/aptutil" \
    PATH="$PATH:/home/aptutil/bin"

RUN go get -u "github.com/cybozu-go/aptutil/..."

ENTRYPOINT [ "/entrypoint.sh" ]
