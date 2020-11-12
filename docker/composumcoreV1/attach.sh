#!/usr/bin/env bash
echo For debugging: start an interactive shell in the docker container started with ./start.sh

set -x
exec docker-compose exec sling bash
