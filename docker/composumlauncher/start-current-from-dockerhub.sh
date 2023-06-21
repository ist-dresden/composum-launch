#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub
echo Debug / view logfiles with docker exec -it composum bash
set -x
source .env
docker pull composum/featurelauncher-composum:$DOCKER_IMAGE_TAG
docker run --name composum --rm -p 8080:8080 -e OPENAI_API_KEY=$OPENAI_API_KEY composum/featurelauncher-composum:$DOCKER_IMAGE_TAG
