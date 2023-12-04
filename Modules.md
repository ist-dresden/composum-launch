# Overview over the modules, their classification and dependencies

## Docker image to folder map
 
- composum/featurelauncher-nodes - Module: docker/featurelauncher
- composum/featurelauncher-composum - Module: docker/composumlauncher, Dependencies: docker/featurelauncher, composum-launcher-feature-composumstarter, composum-launcher-feature-integrationtest

### Archived:

- archived/starter11/composum/slingstarter - Module: docker/slingstarter
- archived/starter11/composum/slingstarter-stepwisedeploy - Module: docker/slingstarter-stepwisedeploy
- archived/starter11/composum/nodes - Module: docker/composumnodes, Dependencies: docker/slingstarter-stepwisedeploy
- archived/starter11/composum/pages - Module: pages/docker, Dependencies: composum-launcher-composumnodes, composum-launcher-feature-integrationtest

## Docker image dependencies

```mermaid
graph LR
    F[composum/featurelauncher-composum] --> E[composum/featurelauncher-nodes]
```

## Dependency diagram

The following maps out most of the dependencies of the folders / docker images. The node labels contain in the first 
line the groupid, second the artifactid, fourth folder and fourth line the docker image name on dockerhub.

```mermaid
graph LR
  D["com.composum.platform.features\ncomposum-launcher-feature-composumstarter\n./feature/composumstarter"]
  D --> E["com.composum.platform.features\ncomposum-launcher-feature-nodesstarter\n./feature/nodesstarter"]
  I["com.composum.platform\ncomposum-launcher-docker-composumlauncher\n./docker/composumlauncher\ncomposum/featurelauncher-composum"] --> D
  I --> J["com.composum.platform\ncomposum-launcher-docker-featurelauncher\n./docker/featurelauncher\ncomposum/featurelauncher-nodes"]
  J --> E
  M["com.composum.platform\ncomposum-startup-featurelauncher\n./startup/featurelauncher"]
```

## Abbreviations for group ids etc.
- cpm: = com.composum.platform:              (default group) 
- cpmf: = com.composum.platform.features:    (always and only in directory features/)
- :: is :: or whatever version is current
- :CL- is :composum-launcher-

## Modules

- docker cpm:CL-docker::pom
- docker/composumlauncher cpm:CL-docker-composumlauncher::docker
- docker/featurelauncher cpm:CL-docker-featurelauncher::docker
- feature/nodesstarter cpmf:CL-feature-nodesstarter::
- feature cpmf:CL-feature::pom
- feature/composumstarter cpmf:CL-feature-composumstarter::
- feature/felixframeworkcontainer cpmf:CL-feature-felixcontainer::pom
- feature/integrationtest cpmf:CL-feature-integrationtest::

## Independent experiments, no docker image or deliverables
- startup/featurelauncher cpm:composum-startup-featurelauncher::pom

## Intermediate poms
(No interesting content but for submodules)
. cpm:composum-launcher::pom
- pages cpm:CL-pages::pom

## Obsolete (don't look at it, don't touch, not necessarily compileable)

- archive/feature/sling-starter-copy cpmf:sling.starter.copy:1.3.1-SNAPSHOT:

- archived/sling11/docker/slingstarter cpm:CL-docker-slingstarter::docker
- archived/sling11/docker/slingstarter-stepwisedeploy cpm:CL-slingstarter-stepwisedeploy::docker-build
- archived/sling11/docker/composumnodes cpm:CL-composumnodes::docker
- archived/sling11/pages/starter com.composum.pages:CL-pages-starter:1.3.1-SNAPSHOT:slingstart
  old Sling Starter directly integrating packages via provisioning, < Sling Starter 11
- archived/sling11/pages/docker com.composum.pages:CL-pages-docker::docker uses pages/starter

- archived/compatibilityV1/slingstarter-compat cpm:CL-compatibility-docker-slingstarter::docker
- archived/compatibilityV1 cpm:CL-compatibility::pom
- archived/compatibilityV1/nodes-compat cpm:CL-compatibility-docker-nodes:1.3.1-SNAPSHOT:docker

## Problem with composum-site

maven release build complains with:

    Error:  Failed to execute goal org.apache.maven.plugins:maven-release-plugin:2.5.3:prepare (default-cli) on project 
        composum-launcher: Can't release project due to non released dependencies :
    Error:      sites.ist.composum:composum-site-app-package:zip:1.0.0-SNAPSHOT:provided
    Error:      sites.ist.composum:composum-site-content:zip:1.0.0-SNAPSHOT:provided
    Error:  in project 'Composum Launcher Feature Composum Starter (With Composum Public)' 
        (com.composum.platform.features:composum-launcher-feature-composumstarter:jar:1.5.2.2-SNAPSHOT)

These are included from examplesites.json .
