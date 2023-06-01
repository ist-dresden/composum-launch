# Overview over the modules, their classification and dependencies

## Abbreviations for group ids etc.
cpm: = com.composum.platform: 
cpmf: = com.composum.platform.features:
:: is :: or whatever version is current
:CL- is :composum-launcher-

## Modules

- docker/slingstarter cpm:CL-docker-slingstarter::docker
- docker cpm:CL-docker::pom
- docker/slingstarter-stepwisedeploy cpm:CL-slingstarter-stepwisedeploy:1.5.
  0-SNAPSHOT:docker-build
- docker/composumlauncher cpm:CL-docker-composumlauncher::docker
- docker/featurelauncher cpm:CL-docker-featurelauncher::docker
- docker/composumnodes cpm:CL-composumnodes::docker
- feature/sling-starter-copy cpmf:sling.starter.copy:1.3.1-SNAPSHOT:
- feature/nodesstarter cpmf:CL-feature-nodesstarter::
- feature cpmf:CL-feature::pom
- feature/composumstarter cpmf:CL-feature-composumstarter::
- feature/felixframeworkcontainer cpmf:CL-feature-felixcontainer::pom
- feature/integrationtest cpmf:CL-feature-integrationtest::

## Obsolete
- pages/starter com.composum.pages:CL-pages-starter:1.3.1-SNAPSHOT:slingstart
  old Sling Starter directly integrating packages via provisioning, < Sling Starter 11
- pages/docker com.composum.pages:CL-pages-docker::docker
  uses pages/starter 


## Independent experiments, no docker image or deliverables
- startup/featurelauncher cpm:composum-startup-featurelauncher::pom

## Intermediate poms
(No interesting content but for submodules)
. cpm:composum-launcher::pom
- pages cpm:CL-pages::pom

## Obsolete (don't look at it, don't touch, not necessarily compileable)

- archived/compatibilityV1/slingstarter-compat cpm:CL-compatibility-docker-slingstarter::docker
- archived/compatibilityV1 cpm:CL-compatibility::pom
- archived/compatibilityV1/nodes-compat cpm:CL-compatibility-docker-nodes:1.3.1-SNAPSHOT:docker
