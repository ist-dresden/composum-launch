# How to update versions

## Update and check process

The process of updating when new versions of the Composum Components are released is as follows. Please be aware that
the develop branch is for local testing - it is so far not deployed on dockerhub, since for local testing you'll
probably build everything locally, anyway.

1. Update the version numbers in the develop branch to the latest Composum releases. The version numbers are defined 
    - in the top level composum-launch/pom.xml
    - composum-launch/pages/starter/src/main/provisioning/composum-*.txt
    - set composum-launch/pages/starter/pom.xml version to pages version
2. Build locally
3. Try that locally with the pages/docker image (compare README.md) 
    - start with start.sh
    - run quickcheck (see below)
    - stop with Ctrl-C
4. Try starter jar locally in pages/starter
    - start with start.sh  
    - run quickcheck (see below)
    - stop with Crtl-C
5. Checkin and merge develop to master, push
6. Check travis build and release on docker-hub https://cloud.docker.com/repository/docker/composum/pages/tags
    - possibly check docker pull -a composum/pages ; docker images composum/pages
8. Run release from dockerhub
    - start in pages/starter with start-from-dockerhub.sh
    - run quickcheck (see below)
    - stop with Ctrl-C
9. Set versions to snapshot versions (see step 1), commit that

## Quickcheck

Check http://localhost:8080/
- Sling console: all bundles active? Composum versions correct? 
- quick look at browser, user manager, package manager
- create simple site in pages

## Debugging Docker

In pages/docker you find the logfiles at target/run/logs , if started with start.sh .

## Preconditions, to check once in a while

- Starter derived from newest release of sling starter https://github.com/apache/sling-org-apache-sling-starter/releases 
