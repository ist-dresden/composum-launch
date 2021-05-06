#!/usr/bin/env bash
echo "Starts the launcher in composumstarter/target(/launcher) and deploys some additional packages."
#set -xv
set -e

scriptdir=`dirname $0`
launcherpattern="target/composum-launcher-feature-composumstarter-*-oak_tar-launcher.jar"

if test ! -s $launcherpattern; then
  echo "Cannot find launcher at $launcherpattern"
  exit 1
fi

launcherjar=`ls -1 $launcherpattern`
launcherjar=`basename $launcherjar`

mkdir -p target/launcher/fileinstall
for hook in ${scriptdir}/*-resourceshook.sh; do
    if [[ -e $hook ]]; then
        $hook
    fi
done

$scriptdir/preload.sh &

cd target
cmdline="java -Djava.awt.headless=true -server -agentlib:jdwp=transport=dt_socket,address=*:18080,server=y,suspend=n -Djava.rmi.server.hostname=0.0.0.0 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=28080 -Dcom.sun.management.jmxremote.rmi.port=28080 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dsling.fileinstall.dir=launcher/fileinstall -Dfelix.startlevel.bundle=30 -Dfelix.log.level=2 -jar $launcherjar"
echo "Launching with $cmdline"
$cmdline
