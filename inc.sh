#!/bin/bash

source $(dirname $0)/init.sh || exit $?

launch-incremental-before-action || exit 1
build-exclude-list

DATE=$(date +"%Y-%m-%d")
for s in $SOURCES; do 
    for f in $(find $s -type f -mtime -$FREQ); do
        check-ignore $f || continue

        destdir=$DEST/${DATE}$(dirname $f)
        mkdir -p $destdir
        #rsync -av $__EXCLUDE_FROM $f $destdir
        cp -a $f $destdir
    done
done

launch-incremental-after-action || exit 1
