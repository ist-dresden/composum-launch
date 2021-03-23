#!/bin/bash

function logdate {
    date -u '+%d.%m.%Y %H:%M:%S'
}

sleep 5

echo `logdate` Preloading: access some URL whose initial generation takes time to improve user experience after startup
# (mostly client libraries)

urlbase="http://localhost:8080"
urls=""

# fill the variable urls
for urlscript in /opt/sling/scripts/preloadurls*.sh; do
    if [[ -e $urlscript ]]; then
        echo "loading urls from $urlscript"
        source $urlscript
    fi
done

# load everything in parallel to speed things up
for url in $urls; do
  curl -s -S -L -o /dev/null -u admin:admin $url &
done

wait

# load everything again in case something went wrong
sleep 1
for url in $urls; do
  curl -s -S -L -o /dev/null -u admin:admin $url
done

TMPFIL=`mktemp -d /tmp/deleteme.preload.XXXXXXXX`
trap "{ /bin/rm -fr $TMPFIL; }" EXIT

# preload everything with it's required stuff
wget -P $TMPFIL -q -nc -p --user=admin --password=admin --delete-after $urls
# loading the browser with links depth 1 touches all the major composum applications
wget -P $TMPFIL -q -nc -p -r -l 1 --user=admin --password=admin --delete-after ${urlbase}/bin/browser.html

sleep 1
for url in $urls; do
  curl -f -s -S -L -o /dev/null -u admin:admin $url || echo FAIL : $url
done

echo `logdate` Preloading done, have a nice day using Composum!
