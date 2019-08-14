# Contents

This repository contains the sources for building some starters that allow you to try out or use the public parts
of the [Composum](http://composum.com/) suite - both some Docker images and a Sling Starter JAR with preinstalled 
Composum Nodes, Platform and Pages.

# Available Docker images

This module creates a couple of docker images with which it is easy to run the public parts of the [Composum](http://composum.com/) suite.

- **slingstarter**: starts a [Sling Starter](https://github.com/apache/sling-org-apache-sling-starter) on JDK 11 with enabled debugging and JMX and some provisions to automatically install more packages when a derived docker image is started. On dockerhub this is available as [composum/slingstarter](https://cloud.docker.com/u/composum/repository/docker/composum/slingstarter).

- **pages/docker**: docker image based on slingstarter, it deploys both the newest version of the [Composum Nodes](https://github.com/ist-dresden/composum), [Composum Platform](https://github.com/ist-dresden/composum-platform) and [Composum Pages](https://github.com/ist-dresden/composum-pages). On dockerhub this is available as [composum/pages](https://cloud.docker.com/u/composum/repository/docker/composum/pages).

- compatibilty/**slingstarter-compat**: like slingstarter, but with the earliest Sling Launchpad version that is supported the Composum Nodes (as of 4/2019: version 9 on JDK 8).

- compatibilty/**nodes-compat**: like slingstarter, but with the earliest Sling Launchpad version that is supported the Composum Nodes (as of 4/2019: version 9 on JDK 8).

# Start Composum Pages using docker

## Pull from dockerhub

Run as a temporary installation (after stopping the container all data is deleted):

    docker pull composum/pages:1.0.0-SNAPSHOT
    docker run --rm -p 8080:8080 composum/pages:1.0.0-SNAPSHOT

Compare the [docker run](https://docs.docker.com/engine/reference/run/) documentation for other options. 
Composum Pages is accessible at http://localhost:8080/bin/pages.html one or two minutes after starting.

## Build and start locally

Do a `mvn clean install` on everything and start in the corresponding directory using [docker-compose](https://docs.docker.com/compose/):

    docker-compose up --force-recreate -V --abort-on-container-exit

Stop it and destroy created containers with:

    docker-compose down --rmi local -v --remove-orphans

# Start Composum Pages using Sling Starter

(**Caution**: pages isn't released yet, so this is just a not yet publicly accessible snapshot. Until pages is released, you have to build it yourself.)

**pages/starter**: contains a [Sling Starter](https://github.com/apache/sling-org-apache-sling-starter) 
    extended with the newest version of the [Composum Nodes](https://github.com/ist-dresden/composum), [Composum Platform](https://github.com/ist-dresden/composum-platform) and [Composum Pages](https://github.com/ist-dresden/composum-pages).

If you don't want to build it yourself, you can grab a copy with using maven with

    mvn dependency:copy -Dartifact=com.composum.pages:composum-pages-starter:1.0.0-SNAPSHOT -DoutputDirectory=.
    
or download it from https://build.ist-software.com/archiva/repository/mirror/com/composum/pages/composum-pages-starter/ . Composum Pages is accessible at http://localhost:8080/bin/pages.html after starting

    java -jar composum-pages-starter-1.0.0-SNAPSHOT.jar

(You need to wait one or two minutes for Sling to fully start up.)
