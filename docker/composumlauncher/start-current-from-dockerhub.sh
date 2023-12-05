#!/usr/bin/env bash
source .env
#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
exec $DIR/start-version-from-dockerhub.sh $DOCKER_IMAGE_TAG
