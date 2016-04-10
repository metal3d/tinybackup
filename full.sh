#!/bin/bash

source $(dirname $0)/init.sh || exit $?

if [ "$TAR" == "true" ]; then
    create-empty-tar $DEST/full.tar
else
    mkdir -p $DEST/full
fi

for s in $SOURCES; do
    destdir=$DEST/full$s/
    if [ "$TAR" == "true" ]; then
        tar $__TAR_EXCLUDE_FROM --exclude-backups -rf $DEST/full.tar $s
    else
        mkdir -p $destdir
        rsync -ra $__EXCLUDE_FROM $s/ $destdir
    fi
done

# compress if wanted
[ "$TAR" == "true" ] && [ "$GZ" == "true" ] && gzip $DEST/full.tar

# remove ignorelist generated for tar
rm $__IGNORE
