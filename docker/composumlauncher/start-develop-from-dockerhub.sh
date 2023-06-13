#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub
echo Debug / view logfiles with docker exec -it composum bash
set -x
docker pull composum/featurelauncher-composum:develop
docker run --name composum --rm -p 8080:8080 composum/featurelauncher-composum:develop
