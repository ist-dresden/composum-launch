# Sling Feature Starter for Composum

This generates a JAR with a Sling Starter containing Sling and Composum Nodes using the feature model and the [Sling feature launcher](https://github.com/apache/sling-org-apache-sling-feature-launcher).
It contains a feature archive containing all stuff needed to start a basic system.

## Starting

After building the project (mvn clean install) it can be started testwise for http://localhost:8080 with the command:

    java -jar target/dependency/org.apache.sling.feature.launcher.jar -f target/slingfeature-tmp/feature-oak_tar.json

## Updating the feature starter

From time to time it's sensible to synchronize the feature files from the Sling Starter (especially when version 12 is released). For this, copy src/main/features from the Sling Starter, and possibly check for changes in the pom: likely the properties changed, possibly plugins.

## TODO
Check whether it's necessary to integrate more bundles for using MongoDB. Perhaps reenable classifier oak_mongo .

## Debugging

