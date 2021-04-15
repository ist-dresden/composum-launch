# How to update versions

## General process

The module creates an artifact that is officially available through the maven repositories
(namely the pages/starter) and artifacts that are distributed through dockerhub (slingstarter and pages/docker).
The pages/starter is deployed from a developer machine to avoid having to put the signing key under outside control.
The docker images, however, are created and deployed from the automated travis build. For testing purposes there is
a "develop" tag; the build from the master branch creates the "latest" tag.

## Update and check process

The process of updating when new versions of the Composum Components are released is as follows. Please be aware that
the develop branch is for local testing - it is so far not deployed on dockerhub, since for local testing you'll
probably build everything locally, anyway.

Since normally the platform and pages version are in sync, we use this joined
version also as version for the various artefacts of composum-launch.

1. Update the version numbers in the develop branch to the latest Composum releases. The version numbers are defined 
    - in the top level composum-launch/pom.xml
    - composum-launch/pages/starter/src/main/provisioning/composum-*.txt
    - set composum-launch/pages/**/pom.xml version to pages version (search for "sync with Pages")
2. Build locally
3. Try starter jar locally in pages/starter
    - start with `start.sh`
    - run quickcheck (see below)
    - stop with Crtl-C
4. Try that locally with the pages/docker image (compare README.md) 
    - start with `start.sh`
    - run quickcheck (see below)
    - stop with Ctrl-C
5. Update the project version to the joined pages / platform version
   - mvn -B -DpushChanges=false release:clean release:prepare release:clean
6. generate-resources verify this, generate .env files with generate-resources and checkin & tag, push master
7. Check travis build  
   and 
   release on docker-hub https://cloud.docker.com/repository/docker/composum/pages/tags
    - possibly check `docker pull -a composum/pages ; docker images composum/pages`
8. Run release from dockerhub
    - start in pages/starter with `start-from-dockerhub.sh`
    - run quickcheck (see below)
    - stop with Ctrl-C
9. Merge master to develop, set versions to snapshot versions, commit that
   - mvn -B release:update-versions -DdevelopmentVersion=1.1.1-SNAPSHOT

## Quickcheck

Check http://localhost:8080/
- Sling console: all bundles active? Composum versions correct? 
- quick look at browser, user manager, package manager
- create simple site in pages, publish, create release, in-place replication + check replicated result in browser

## Debugging Docker

Start with pages/docker/start.sh : the logfiles are at target/run/logs.

Start with pages/docker/start-from-dockerhub.sh : 
- install less for logfile viewing with e.g.
        `docker exec -it -u root composum-pages-develop yum install -y less`
- attach to container with `docker exec -it composum-pages-develop bash`     

## Preconditions, to check once in a while

- Starter derived from newest release of sling starter https://github.com/apache/sling-org-apache-sling-starter/releases 

## Tricks
If you have xmlstarlet (e.g. package xmlstarlet from https://brew.sh/) installed, the following command prints the versions of the pom.xml below a main directory:
for fil in */pom.xml ; do
   xml sel -T -N pom=http://maven.apache.org/POM/4.0.0 -t -m pom:project -v pom:groupId -o : -v pom:artifactId -o : -v pom:version -nl $fil 
done

### Updating properties
Helper for that:
mvn -DallowDowngrade=true -DgenerateBackupPoms=false -DprocessParent=true versions:update-properties versions:update-parent
If you want the latest snapshots:
mvn -DallowSnapshots=true -DgenerateBackupPoms=false -DprocessParent=true versions:update-properties versions:update-parent

Possibly interesting other goals: https://www.mojohaus.org/versions-maven-plugin/
versions:use-latest-releases
versions:commit or -DgenerateBackupPoms=false

mvn versions:display-dependency-updates versions:display-parent-updates versions:display-property-updates
mvn versions:display-plugin-updates
