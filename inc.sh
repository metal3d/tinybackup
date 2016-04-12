#!/bin/bash

source $(dirname $0)/init.sh || exit $?
startup
mkdir -p $DEST/inc/$DATE
launch-incremental-before-action || exit 1
build-exclude-list

for s in $SOURCES; do 
    for f in $(find $s -type f -mtime -$FREQ); do
        check-ignore $f || continue

        destdir=$DEST/inc/${DATE}$(dirname $f)
        mkdir -p $destdir
        #rsync -av $__EXCLUDE_FROM $f $destdir
        cp -a $f $destdir
    done
done

launch-incremental-after-action || exit 1
