#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub
echo Debug / view logfiles with docker exec -it composum-nodes-latest bash
echo "install less e.g. with docker exec -it -u root composum-pages-latest yum install -y less"
set -x
docker pull composum/featurelauncher-nodes:latest
docker run --name composum-nodes-latest --rm -p 8080:8080 composum/featurelauncher-nodes:latest
