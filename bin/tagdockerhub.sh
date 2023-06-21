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

docker manifest rm "$image:$version"
docker manifest rm "$image:$tag"

# This should work, but doesn't, probably due to docker bug - it uses the images from an old version
#
#docker manifest inspect "$image:$version"
#
## Create and push manifest
#docker manifest create "$image:$tag" --amend "$image:$version"
#docker manifest inspect "$image:$tag"
#docker manifest push --purge "$image:$tag"

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "jq could not be found. Please install jq."
  exit
fi

set -e

# Inspect the image and get manifest list
manifest_list=$(docker manifest inspect "${image}:${version}")

# Extract the number of manifest entries using jq
manifest_count=$(echo $manifest_list | jq '.manifests | length')

# Create new manifest for each platform
for i in $(seq 0 $(($manifest_count - 1))); do
  manifest=$(echo $manifest_list | jq ".manifests[$i]")
  digest=$(echo $manifest | jq -r '.digest')
  architecture=$(echo $manifest | jq -r '.platform.architecture')
  os=$(echo $manifest | jq -r '.platform.os')
  # if arch isn't "unknown" then add it
  if [ "$architecture" != "unknown" ]; then
    docker manifest create "${image}:${tag}" --amend "${image}@${digest}"
    docker manifest annotate "${image}:${tag}" "${image}@${digest}" --os "${os}" --arch "${architecture}"
  fi
done

docker manifest inspect "$image:$tag"

# Push the new tag
docker manifest push "${image}:${tag}"

echo "DONE tagging $image:$version to $image:$tag"
