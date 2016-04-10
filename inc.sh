#!/bin/bash

source $(dirname $0)/init.sh || exit $?


DATE=$(date +"%Y-%m-%d")
for s in $SOURCES; do 
    for f in $(find $s -type f -mtime -1); do
        destdir=$DEST/${DATE}$(dirname $f)
        mkdir -p $destdir
        cp -ra $f $destdir
    done
done
