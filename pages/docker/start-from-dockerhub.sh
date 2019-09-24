#!/usr/bin/env bash
echo Start script for quick check of docker image drawn from dockerhub
set -vx
docker pull -a composum/pages:latest
docker run --rm -p 8080:8080 composum/pages:latest

