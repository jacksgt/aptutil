#!/bin/bash

MAX_CONNS="${MAX_CONNS:=10}"
LOG_LEVEL="${LOG_LEVEL:=info}"
LOG_FORMAT="${LOG_FORMAT:=plain}"

if [ "$1" = "go-apt-cacher" ]; then
    LISTEN_ADDRESS="${LISTEN_ADDRESS:=:3142}"
    CHECK_INTERVAL="${CHECK_INTERVAL:=600}"
    CACHE_CAPACITY="${CACHE_CAPACITY:=1}"
    CACHE_PERIOD="${CACHE_PERIOD:=3}"

    # should not be set manually
    META_DIR="${META_DIR:=/var/spool/go-apt-cacher/meta}"
    CACHE_DIR="${CACHE_DIR:=/var/spool/go-apt-cacher/cache}"
    CONFIG="${CONFIG:=go-apt-cacher.toml}"

    # write to config file
    echo "### $CONFIG ###" > "$CONFIG" # empty config file
    echo "listen_address = \"${LISTEN_ADDRESS}\"" >> "$CONFIG"
    echo "check_interval = $CHECK_INTERVAL" >> "$CONFIG"
    echo "cache_period = $CACHE_PERIOD" >> "$CONFIG"
    echo "meta_dir = \"$META_DIR\"" >> "$CONFIG"
    echo "cache_dir = \"$CACHE_DIR\"" >> "$CONFIG"
    echo "cache_capacity = $CACHE_CAPACITY" >> "$CONFIG"
    echo "max_conns = $MAX_CONNS" >> "$CONFIG"
    echo "[log]" >> "$CONFIG"
    echo "level = \"$LOG_LEVEL\"" >> "$CONFIG"
    echo "format = \"$LOG_FORMAT\"" >> "$CONFIG"

    # Example mapping
    # MAP=debian=http://httpredir.debian.org/debian,ubuntu=http://archive.ubuntu.com/ubuntu

    # replace commas with spaces and let Bash parse it into an arrau
    arr=$(echo $MAP | tr ',' ' ')

    # write mappings
    echo "[mapping]" >> "$CONFIG"
    for i in ${arr[@]}; do
        key="$(echo $i | cut -d '=' -f1)"
        value="$(echo $i | cut -d '=' -f2)"
        echo "$key = \"$value\"" >> "$CONFIG"
    done

    # print config
    cat "$CONFIG"

    exec 'go-apt-cacher' '-f' "$CONFIG"

elif [ "$1" = "go-apt-mirror" ]; then
    echo "Not implemented yet."
    return 1;
else
    exec $1
fi
