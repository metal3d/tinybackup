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
    DEST=$(echo $DEST | sed 's,/$,,') 
}

# basic check for ingored files
function check-ignore() {
    [ -z "$EXCLUDE" ] && return 0
    while read ignore; do
        (echo $1 | grep $ignore) && return 1
    done < $EXCLUDE
    return 0
}

# create an empty tar file, usefull to be able
# to "append" files.
function create-empty-tar() {
    [ -f $1 ] && return 0
    tar cf $1 /dev/null
    tar --delete -f $1 dev/null
}

# Launch before actions
function launch-action() {
    if [ ! -z "$1" ]; then
        $1
        return $?
    fi
    return 0
}

function launch-before-action(){
    launch-action $BEFORE_FULL
    return $?
}

function launch-after-action(){
    launch-action $AFTER_FULL
    return $?
}

function launch-incremental-before-action(){
    launch-action $BEFORE_INCREMENTAL
    return $?
}

function launch-incremental-after-action(){
    launch-action $AFTER_INCREMENTAL
    return $?
}

[ -f $(dirname $0)/conf.sh ] || (echo "You must provide a conf.sh in $(dirname $0) directory" >&2 && exit 1)
source $(dirname $0)/conf.sh

[ -z "$SOURCES" ] && echo "SOURCES is empty" >&2 && exit 1
[ -z "$DEST" ] && echo "DEST is empty" >&2 && exit 1
[ -z "$FREQ" ] && echo "FREQ is empty" >&2 && exit 1
[ -z "$KEEP" ] && echo "KEEP is empty" >&2 && exit 1

# allow to have exclude list file
__EXCLUDE_FROM=""
__TAR_EXCLUDE_FROM=""
__IGNORE=$(mktemp)

# tar cannot use rsync exclude format, so we 
# create another list that contains full path
# from ignore list
if [ ! -z "$EXCLUDE" ]; then
    __EXCLUDE_FROM="--exclude-from=$EXCLUDE"
    while read ignore; do
        isdir=0
        echo "$ignore" | grep -P "/$" 2>&1 >/dev/null && isdir=1
        ignore=$(echo $ignore | sed 's,/$,,') 
        [ $isdir -eq 1 ] && t=d || t=f
        for s in $SOURCES; do
            find $s -type $t -name "*$ignore" >> $__IGNORE
        done
    done <$EXCLUDE
    __TAR_EXCLUDE_FROM="--exclude-from=$__IGNORE"
fi

mkdir -p $DEST
fix-dirname
clean-old-backup
