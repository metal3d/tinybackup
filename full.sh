#!/bin/bash

source $(dirname $0)/init.sh || exit $?

for s in $SOURCES; do
    destdir=$DEST/full$s
    mkdir -p $destdir
    rsync -ra --delete $__EXCLUDE_FROM $s/ $destdir/
done
