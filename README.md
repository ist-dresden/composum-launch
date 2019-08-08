# Contents

This module creates a couple of docker images with which it is easy to run the public parts of the [Composum](http://composum.com/) suite.

- **slingstarter**: starts a [Sling Starter](https://github.com/apache/sling-org-apache-sling-starter) on JDK 11 with enabled debugging and JMX and some provisions to automatically install more packages when a derived docker image is started. On dockerhub this is available as [composum/slingstarter](https://cloud.docker.com/u/composum/repository/docker/composum/slingstarter).

- **pages/docker**: docker image based on slingstarter, it deploys both the newest version of the [Composum Nodes](https://github.com/ist-dresden/composum), [Composum Platform](https://github.com/ist-dresden/composum-platform) and [Composum Pages](https://github.com/ist-dresden/composum-pages). On dockerhub this is available as [composum/pages](https://cloud.docker.com/u/composum/repository/docker/composum/pages).

- compatiblilty/**slingstarter-compat**: like slingstarter, but with the earliest Sling Launchpad version that is supported the Composum Nodes (as of 4/2019: version 9 on JDK 8).

- compatiblilty/**nodes-compat**: like slingstarter, but with the earliest Sling Launchpad version that is supported the Composum Nodes (as of 4/2019: version 9 on JDK 8).

Do a mvn clean install on everything and start in the corresponding directory with:

docker-compose up --force-recreate -V --abort-on-container-exit

Destroy remnants with

docker-compose down --rmi local -v --remove-orphans
