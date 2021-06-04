#!/bin/bash
# Build script on travis.
echo "Building for travis branch $TRAVIS_BRANCH"
set -vx
mvn -v
MVN="mvn -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"

# Try to determine docker pull limit, see https://docs.docker.com/docker-hub/download-rate-limit/
(
  TOKEN=TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
  curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest
)

# Build as much as possible to find all errors at once, but
# do not start deployment until everything was right
$MVN -fae -P${TRAVIS_BRANCH} clean install &&
  $MVN -P${TRAVIS_BRANCH},deployDocker clean deploy &&
  echo "Build script done!"
