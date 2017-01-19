FROM debian:stretch
MAINTAINER Jack Henschel <jh@openmailbox.org>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    golang-go git ca-certificates;

RUN useradd --home-dir "/home/aptutil" --create-home "aptutil" && \
    mkdir -p "/var/spool/go-apt-mirror" && chown -R aptutil "/var/spool/go-apt-mirror" && \
    mkdir -p "/var/spool/go-apt-cacher/" && chown -R aptutil "/var/spool/go-apt-cacher/"

WORKDIR "/home/aptutil"
USER "aptutil"
ENV GOPATH="/home/aptutil" \
    PATH="$PATH:/home/aptutil/bin"

RUN go get -u "github.com/cybozu-go/aptutil/..."
