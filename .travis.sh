#!/bin/bash
# Build script on travis.
echo "Building for travis branch $TRAVIS_BRANCH"
set -vx
mvn -v
MVN="mvn -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"

# Build as much as possible to find all errors at once, but
# do not start deployment until everything was right
$MVN -fae -P${TRAVIS_BRANCH} clean install &&
$MVN -P${TRAVIS_BRANCH},deployDocker clean deploy &&
echo "Build script done!"
