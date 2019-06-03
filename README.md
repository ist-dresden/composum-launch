# Contents

This module creates a couple of docker images with which it is easy to run the public parts of the [Composum](https://composum.com/) suite.

- **slingstarter**: starts a [Sling Starter](https://github.com/apache/sling-org-apache-sling-starter) and updates the contained composum parts (an earlier version) with the current [Composum Nodes](https://github.com/ist-dresden/composum).

- **platform**: based on slingstarter, it deploys both the newest version of the [Composum Nodes](https://github.com/ist-dresden/composum) and the [Composum Platform](https://github.com/ist-dresden/composum-platform).

- compatiblilty/**slingstarter-compat**: like slingstarter, but with the earliest Sling Launchpad version that is supported by the Composum Nodes (as of 4/2019: version 9 on JDK 7).

Do a mvn clean install on everything and start in the corresponding directory with:

docker-compose up --force-recreate -V --abort-on-container-exit

Destroy remnants with

docker-compose down --rmi local -v --remove-orphans
