#!/usr/bin/env bash
echo Start script for quick check of docker image
set -vx
function removeimage {
  docker-compose down --rmi local -v --remove-orphans
}
trap removeimage EXIT
docker-compose up --force-recreate -V --abort-on-container-exit

