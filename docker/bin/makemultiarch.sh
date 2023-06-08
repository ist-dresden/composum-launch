#!/bin/bash
# e.g.
# docker/bin/makemultiarch.sh composum/slingstarter
# docker/bin/makemultiarch.sh composum/slingstarter-compat
# docker/bin/makemultiarch.sh composum/nodes-compat
# docker/bin/makemultiarch.sh composum/slingstarter-stepwisedeploy
# docker/bin/makemultiarch.sh composum/featurelauncher-composum
# docker/bin/makemultiarch.sh composum/featurelauncher-nodes
# docker/bin/makemultiarch.sh composum/nodes
# docker/bin/makemultiarch.sh composum/pages

# set -vx
# set -e

name=$1
if test -z "$name"; then
  echo no name given
  exit 1
fi

version=$2
if test -z "$version"; then
  version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
  if test -z "$version"; then
    echo Unable to determine version
    exit 1
  fi
fi

destversion=$3
if test -z "$destversion"; then
  destversion=$version
fi

architectures="aarch64 amd64"

for arch in $architectures; do
  docker pull $name:$version-$arch
done

CMD="docker manifest create $name:$destversion"
for arch in $architectures; do
  CMD="$CMD $name:$version-$arch"
done

docker manifest rm $name:$destversion

echo $CMD

set -vxe

$CMD

docker manifest push $name:$destversion
