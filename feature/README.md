# Feature starters

This directory contains various projects related to starting composum with
the [Sling feature launcher](https://github.com/apache/sling-org-apache-sling-feature-launcher).

## Modules

All feature modules create feature archives with classifiers oak_tar and oak_mongo.

- nodesstarter : produces a JAR containing a feature archive produced from a Sling Starter 12, that has
  everything embedded and does not need any network access to start. It also updates Composum Nodes.
- composumstarter : like nodesstarter, but contains all public composum modules
 
- integrationtest : helper for other modules that checks whether they start up correctly in the mvn verify phase 

## Open points

It would be nice to have a runmode controlled version of the feature jars that decides based on the runmode which database backstore it uses. It is possible to declare run-mode on the bundles in a feature, but for that we'd have to copy and modify the oak_persistence_mongods.json und oak_persistence_sns.json, and that has the risk of diverging from the version numbers of the sling starter when the latter changes. So we just go for now with the classifiers oak_tar and oak_mongo, as the Sling Starter 12 beta does.
