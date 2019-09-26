#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub
echo Debug / view logfiles with docker exec -it composum-pages-latest bash
echo "install less e.g. with docker exec -it -u root composum-pages-develop yum install -y less"
set -x
docker pull composum/pages:develop
docker run --name composum-pages-develop --rm -p 8080:8080 composum/pages:develop
