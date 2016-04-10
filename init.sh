#!/bin/bash

# remove old backup
function clean-old-backup() {
    older=$(date -d "-$KEEP day" +"%Y-%m-%d")
    rm -rf $DEST/inc/$older
}

# remove last slash 
function fix-dirname() {
    _S=$SOURCES
    SOURCES=
    for s in $_S; do
        SOURCES=$SOURCES" "$(echo $s | sed 's,/$,,') 
    done
}

# basic check for ingored files
function check-ignore() {
    [ -z "$EXCLUDE" ] && return 0
    while read ignore; do
        (echo $1 | grep $ignore) && return 1
    done < $EXCLUDE
    return 0
}

source $(dirname $0)/conf.sh

[ -z "$SOURCES" ] && echo "SOURCES is empty" >&2 && exit 1
[ -z "$DEST" ] && echo "DEST is empty" >&2 && exit 1
[ -z "$FREQ" ] && echo "FREQ is empty" >&2 && exit 1
[ -z "$KEEP" ] && echo "KEEP is empty" >&2 && exit 1

# allow to have exclude list file
__EXCLUDE_FROM=""
[ -z "$EXCLUDE" ] || __EXCLUDE_FROM="--exclude-from=$EXCLUDE"

mkdir -p $DEST
fix-dirname
clean-old-backup
