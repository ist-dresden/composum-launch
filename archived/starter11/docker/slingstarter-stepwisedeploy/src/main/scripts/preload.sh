#!/bin/bash

function logdate {
    date -u '+%d.%m.%Y %H:%M:%S'
}

urlbase="http://localhost:8080"
urls=""

# fill the variable urls
for urlscript in /opt/sling/scripts/_preloadurls*.sh; do
    if [[ -e $urlscript ]]; then
        echo "loading urls from $urlscript"
        source $urlscript
    fi
done

`dirname $0`/WaitForServerUp.jsh $logfile
until curl -f -u admin:admin -s -S $urlbase/system/console/status-osgi-installer.txt | egrep 'com.composum.nodes.console.*(INSTALLED|IGNORED)' > /dev/null; do
  echo `logdate` preload waiting until server up
  sleep 10
done
`dirname $0`/WaitForServerUp.jsh $logfile

echo `logdate` Preloading: access some URL whose initial generation takes time to improve user experience after startup

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
