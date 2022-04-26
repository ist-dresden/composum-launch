#!/bin/bash
echo build multi architecture images for all docker images
echo Call this from composum-launch
#set -vx
set -e

version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
if test -z "$version"; then
  echo Unable to determine version
  exit 1
fi

destversion=$1
if test -z "$destversion"; then
  destversion=$version
fi

echo using version $version and destination version $destversion
echo

# feature launcher section
docker/bin/makemultiarch.sh composum/featurelauncher-nodes $version $destversion
docker/bin/makemultiarch.sh composum/featurelauncher-composum $version $destversion

# stepwise package deployment section
docker/bin/makemultiarch.sh composum/slingstarter $version $destversion
docker/bin/makemultiarch.sh composum/slingstarter-stepwisedeploy $version $destversion
docker/bin/makemultiarch.sh composum/nodes $version $destversion
docker/bin/makemultiarch.sh composum/pages $version $destversion

# ignored composum/slingstarter-compat (not public)
# ignored composum/nodes-compat (not public)
