#!/usr/bin/env bash
echo For debugging: start an interactive shell in the docker container started with ./start.sh

set -x
# exec docker-compose exec composum /bin/bash
exec docker exec -it composum /bin/bash
