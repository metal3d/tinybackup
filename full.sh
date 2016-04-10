#!/bin/bash

source $(dirname $0)/init.sh || exit $?

for s in $SOURCES; do
    destdir=$DEST/full$s
    echo mkdir -p $destdir
    echo rsync -ra --delete $s/ $destdir/
done
