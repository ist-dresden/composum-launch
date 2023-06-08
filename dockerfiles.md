# An overview over the relationships of the docker images contained here (and some additions)

- composum/featurelauncher-nodes : composum-launch/docker/featurelauncher/Dockerfile FROM openjdk:17
- composum/featurelauncher-composum : composum-launch/docker/composumlauncher/Dockerfile FROM composum/featurelauncher-nodes
- composum-enterprise/featurelauncher-allprojects : cpm-launch/docker/allprojectslauncher/Dockerfile FROM composum/featurelauncher-nodes

- composum/slingstarter : composum-launch/docker/slingstarter/Dockerfile FROM openjdk:17
  - composum/slingstarter-stepwisedeploy : composum-launch/docker/slingstarter-stepwisedeploy/Dockerfile FROM composum/slingstarter
    - composum/core-v1 : composum-launch/docker/composumcoreV1/Dockerfile FROM composum/slingstarter-stepwisedeploy
    - composum/nodes : composum-launch/docker/composumnodes/Dockerfile FROM composum/slingstarter-stepwisedeploy
        - composum/pages : composum-launch/pages/docker/Dockerfile FROM composum/nodes
    
perhaps use as basis:
- apache/sling : sling/sling-starter/Dockerfile FROM docker.io/openjdk:17-slim




Archived:
- composum/slingstarter-compat : composum-launch/compatibility/slingstarter-compat/Dockerfile FROM openjdk:8-jdk
    - composum/core-compat : composum-launch/compatibility/core-compat/Dockerfile FROM composum/slingstarter-compat
    - composum/nodes-compat : composum-launch/compatibility/nodes-compat/Dockerfile FROM composum/slingstarter-compat
