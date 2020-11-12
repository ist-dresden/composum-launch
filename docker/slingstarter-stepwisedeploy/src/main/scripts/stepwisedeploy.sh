#!/bin/bash

# set -evx

function logdate {
    date -u '+%d.%m.%Y %H:%M:%S'
}

logfile=/opt/sling/sling/logs/error.log

# waits until there are no deployment activities on the server for 10 seconds
function waituntilquiet {
    `dirname $0`/WaitForServerUp.jsh $logfile
}

sleep 15 # give server some undisturbed startup time before any deployments
waituntilquiet

for file in /opt/sling/scripts/_preinstall*.sh; do
  echo `logdate` STEPDEPL executing pre installation script $file
  source $file
done

# First copy stuff together into intermediatedir to be able to
# override stuff from the docker image.
intermediatedir=/opt/sling/fileinstall-joined
targetdir=/opt/sling/fileinstall

/bin/rm -fr $intermediatedir $targetdir
mkdir $intermediatedir $targetdir

function cleanup {
  /bin/rm -fr $intermediatedir
}
trap cleanup EXIT

cd /opt/sling/fileinstall-docker
if [ "$(ls -A .)" ]; then
    for dir in */; do
        mkdir -p $intermediatedir/$dir
        for fil in $dir/*; do
            ln -s `pwd`/$fil $intermediatedir/$dir/
        done
    done
fi

cd /opt/sling/fileinstall-user
if [ "$(ls -A .)" ]; then
    for dir in */; do
        mkdir -p $intermediatedir/$dir
        for fil in $dir/*; do
            ln -fs `pwd`/$fil $intermediatedir/$dir/
        done
    done
fi

echo `logdate` STEPDEPL start stepwise deploying stuff

# Now stepwise move the links to the install directory
cd $intermediatedir
if [ "$(ls -A .)" ]; then
    for dir in */; do
        mkdir -p $targetdir/$dir
        echo `logdate` checking `pwd`/$dir
        for fil in $dir/*; do
            if test \! -e "$targetdir/$fil"; then
                echo `logdate` STEPDEPL deploying $fil
                mv -f `pwd`/$fil $targetdir/$dir/
            fi
        done
        waituntilquiet
    done
fi

echo `logdate` STEPDEPL FINISHED stepwise deploying stuff at `date` - server should now be usable

for file in /opt/sling/scripts/_postinstall*.sh; do
  echo `logdate` STEPDEPL executing post installation script $file
  source $file
done

/opt/sling/scripts/preload.sh &
