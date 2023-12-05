#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub with the given version tag $1
echo Debug / view logfiles with docker exec -it composum bash

VERSION=$1
if [ -z "$VERSION" ]
then
  echo "No version tag given, aborting"
  exit 1
fi

set -x
docker pull composum/featurelauncher-composum:$VERSION
docker run --name composum --rm -p 8080:8080 -e OPENAI_API_KEY=$OPENAI_API_KEY composum/featurelauncher-composum:$VERSION
