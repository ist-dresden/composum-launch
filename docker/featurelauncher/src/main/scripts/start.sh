#!/bin/bash

function logdate {
    date -u '+%d.%m.%Y %H:%M:%S'
}

echo `logdate` "original starter cmd line $*"

farargs=""

for file in `find features-* -type f`; do
   echo `logdate` including feature $file;
   farargs="$farargs -f $file"
done

echo `logdate` "final launcher cmd line " "$@" $farargs

/opt/sling/scripts/preload.sh &

exec "$@" $farargs
