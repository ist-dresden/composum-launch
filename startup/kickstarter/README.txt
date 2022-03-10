# Test to run composum with the kickstarter

This directory contains some scripts to run Composum on Sling 12 with the kickstarter.
https://mvnrepository.com/artifact/org.apache.sling/org.apache.sling.kickstart
https://github.com/apache/sling-org-apache-sling-kickstart

The directory fileinstall is set up as a directory that is scanned for new bundles or
packages. If we copy the composum packages there, it starts up nicely.

One problem with the current version (0.0.12) of the kickstarter is that it is not possible to configure it
to initialize sling only from the content of a FAR - it always accesses $HOME/.m2/repo and / or the network
to retrieve the dependencies. This is OK for development, but not for production, as it creates ways to introduce
unwanted code into the system (in $HOME/.m2, DNS spoofing and whatnot). Also, the development of kickstarter
doesn't seem very active, and the major advantage over the plain feature launcher is the start / stop commands,
which can also be done other ways. So, as of 22/03 we do not recommend production usage of kickstarter.

## Tip: Running without network for testing

To check the behaviour of the kickstarter without network access and access to $HOME/.m2: with docker it's
possible to execute a bash in the current directory while just mounting it into the docker image:

docker run -ti --rm --network none -v `pwd`:`pwd` -w `pwd` -p 8080:8080 openjdk:11 /bin/bash

## Links

https://issues.apache.org/jira/browse/SLING-11184?jql=project%20%3D%20SLING%20AND%20component%20%3D%20Starter
