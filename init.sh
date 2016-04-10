#!/bin/bash

function clean-old-backup() {
    older=$(date -d "-$KEEP day" +"%Y-%m-%d")
    rm -rf $DEST/inc/$older
}


source $(dirname $0)/conf.sh

[ -z "$SOURCES" ] && echo "SOURCES is empty" >&2 && exit 1
[ -z "$DEST" ] && echo "DEST is empty" >&2 && exit 1
[ -z "$FREQ" ] && echo "FREQ is empty" >&2 && exit 1
[ -z "$KEEP" ] && echo "KEEP is empty" >&2 && exit 1

mkdir -p $DEST
clean-old-backup
