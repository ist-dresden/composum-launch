# Test to run composum with the feature starter

This directory contains some scripts to run Composum on Sling 12 with the feature starter.
https://github.com/apache/sling-org-apache-sling-starter

The directory fileinstall is set up as a directory that is scanned for new bundles or
packages. If we copy the composum packages there, it starts up nicely.

## Usage

The bin/ directory contains various scripts; call bin/help to get an overview.
If you want to preinstall various composum packages, there are bin/fileinstall* scripts to do that.

E.g.:
bin/setup ; bin/fileinstall.individual.latest ; bin/fileinstall.sites ; bin/start ; sleep 30; bin/log

## Tip: Running without network for testing

To check the behaviour of the kickstarter without network access and access to $HOME/.m2: with docker it's
possible to execute a bash in the current directory while just mounting it into the docker image:

docker run -ti --rm --network none -v `pwd`:`pwd` -w `pwd` -p 8080:8080 openjdk:17 /bin/bash

## Links
https://github.com/apache/sling-org-apache-sling-starter
https://github.com/apache/sling-org-apache-sling-feature-launcher
https://mvnrepository.com/artifact/org.apache.sling/org.apache.sling.feature.launcher
https://issues.apache.org/jira/browse/SLING-11184?jql=project%20%3D%20SLING%20AND%20component%20%3D%20Starter
