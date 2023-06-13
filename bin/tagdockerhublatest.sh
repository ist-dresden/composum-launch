#!/usr/bin/env bash

function usage() {
echo Description: tags a version on dockerhub as 'latest' or given tag
echo Usage: $0 {dockerimage} {version} [tag]
echo Example: $0 composum/featurelauncher-nodes 1.5.0
echo Example: $0 composum/featurelauncher-composum 1.5.1-SNAPSHOT develop
exit 1
}

image="$1"
version="$2"
tag="$3"

if test -z "$image"; then
  echo No image given - abort
  usage
fi

if test -z "$version"; then
  echo No version given - abort
  usage
fi

if test -z "$tag"; then
  tag=latest
fi

# pull image, set latest tag and push that tag
docker pull $image:$version
docker tag $image:$version $image:$tag
docker images $image
docker push $image:$tag

echo DONE tagging $image:$version to $image:$tag
