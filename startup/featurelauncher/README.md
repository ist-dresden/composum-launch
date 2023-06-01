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

## Results of some experiments

### Starting with various packages

(15.2.22 with Sling Starter 12)
Starting it up using either the packages directly with bin/fileinstall.individual.latest and bin/fileinstall.sites does
start up everything correctly. However, trying to update a package by stopping the server, replacing the package and
starting the server again does not work, as the packages cannot be uninstalled.
(Error message "PackageException: Unable to uninstall package. No snapshot present.")

It is possible to install the individual packages, or the uber-packages that combine the platform / pages packages, if their
dependencies are set right. The uber-packages have to depend on the other uber-packages.

### Upgrade from Sling 11

A possible path for upgrading from (for example) a Sling 11 launcher based Composum installation to a Sling 12 launcher
based installation is:
- set up and run the Sling 12 launcher; check that it works and stop it.
- use oak-upgrade-*.jar (https://jackrabbit.apache.org/oak/docs/migration.html) to copy the content from the old installation
into the new installation (should also be stopped). For example:

    java -jar starter/oak-upgrade-*.jar /somewhere/sling11launcher/sling/repository /somewhereelse/sling12launcher/launcher/repository --include-paths=/content/sites,/content/ist,/public,/preview,/var/composum --copy-binaries

- start the Sling 12 launcher with the copied content.

This replaces the JCR folders mentioned in --include-paths in the new launcher with the content from the old launcher, including the content versions.
Thus, the versions of the pages and the releases are kept.

## Tip: Running without network for testing

To check the behaviour of the kickstarter without network access and access to $HOME/.m2: with docker it's
possible to execute a bash in the current directory while just mounting it into the docker image:

docker run -ti --rm --network none -v `pwd`:`pwd` -w `pwd` -p 8080:8080 openjdk:17 /bin/bash

## Links
https://github.com/apache/sling-org-apache-sling-starter
https://github.com/apache/sling-org-apache-sling-feature-launcher
https://mvnrepository.com/artifact/org.apache.sling/org.apache.sling.feature.launcher
https://issues.apache.org/jira/browse/SLING-11184?jql=project%20%3D%20SLING%20AND%20component%20%3D%20Starter
