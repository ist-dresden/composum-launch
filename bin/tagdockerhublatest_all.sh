#!/usr/bin/env bash

function usage() {
  echo Tags our docker images on dockerhub with the given version as 'latest' or given tag
  echo Usage: $0 {version} [tag]
  exit 1
}

version="$1"
tag="$2"

if test -z "$version"; then
  echo No version given
  usage
fi

if test -z "$tag"; then
  tag=latest
fi

$(dirname $0)/tagdockerhublatest.sh composum/featurelauncher-nodes "$version" "$tag"
$(dirname $0)/tagdockerhublatest.sh composum/featurelauncher-composum "$version" "$tag"
