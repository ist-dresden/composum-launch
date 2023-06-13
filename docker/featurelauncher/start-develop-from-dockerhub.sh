#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub
echo Debug / view logfiles with docker exec -it featurelauncher-nodes bash
set -x
docker pull composum/featurelauncher-nodes:develop
docker run --name featurelauncher-nodes --rm -p 8080:8080 composum/featurelauncher-nodes:develop
