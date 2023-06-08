#!/usr/bin/env bash
echo Start script for quick check of docker image, with complete cleanup on stop

set -x
function removeimage {
  echo Removing docker image, please wait a second
  docker-compose down --rmi local -v --remove-orphans
  echo Done
}
trap removeimage EXIT
docker-compose down --rmi local -v --remove-orphans
docker-compose up --force-recreate -V --abort-on-container-exit
