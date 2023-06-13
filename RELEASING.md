# How to create a new release, step by step

## What a release contains

The module creates Sling feature archives (FAR), launcher JAR with embedded feature archives and docker images for
running both Sling Starter 12 with updated Composum Nodes, and also Sling Starter 12 with all public Composum
Sling projects. Those are distributed through maven central and dockerhub.

## Update and check process

### Local check before releasing

The process of updating when new versions of the Composum Components are released is as follows.

Since normally the platform and pages version are in sync, we use this joined
version also as version for the various artifacts of composum-launch. If there are updates despite having the same
pages version, we might have to use versions like 1.5.2.1 .

There are integration tests for the feature starters and for the docker images that check whether all bundles start
and there is a minimum number of bundles, whether a number of URLs work and.
So you'll probably need to verify only that the docker images work, if there aren't big changes.

1. Update the version numbers in the develop branch to the latest Composum releases. In determining all the latest
   versions, composum-launch/startup/featurelauncher/bin/composumVersions.sh might be helpful. The version numbers
   are defined in the top level composum-launch/pom.xml ; composum-launch/startup/featurelauncher/pom.xml contains
   the corresponding snapshot versions for experiments.
2. Build locally
3. Optional: feature/nodesstarter
    - go to composum-launch/feature/nodesstarter/target
    - java -jar composum-launcher-feature-nodesstarter-*-oak_tar-launcher.jar
    - log in into http://localhost:8080/starter.html and check that the browser works and has the right version.
4. Optional: feature/nodesstarter
    - go to composum-launch/feature/nodesstarter/target
    - java -jar composum-launcher-feature-nodesstarter-*-oak_tar-launcher.jar
    - log in into http://localhost:8080/starter.html and check that the browser works and has the right version.
5. Less optional: composum-launch/feature/composumstarter
    - go to composum-launch/feature/composumstarter
    - start with `bin/start.sh`
    - run quickcheck (see below)
    - stop with Crtl-C
6. Optional: docker/featurelauncher 
    - start with `start.sh`
    - log in into http://localhost:8080/starter.html and check that the browser works and has the right version.
    - stop with Ctrl-C
7. docker/composumlauncher
   -  start with  `start.sh`
   - run quickcheck (see below)
   - install a site e.g. cpm-site-composum with package manager, 
     - mvn -P cpmLocalDefault,installPackage install
   - install a site e.g. by copying package to target/run/fileinstall 
 
### Release project

For releasing there are some Github actions https://github.com/ist-dresden/composum-launch/actions :

1. Create Release
   - check tag is set; wait >30min before checking on maven central.
2. Check state of git branches
3. Create docker images with "Build and deploy docker images" on branch master
4. Check that there are new releases on docker-hub
   - https://hub.docker.com/repository/docker/composum/featurelauncher-nodes
   - https://hub.docker.com/repository/docker/composum/featurelauncher-composum
5. Pull from dockerhub and try docker image and check it runs:
   - docker pull composum/featurelauncher-nodes:{version}
   - docker run --rm -p 8080:8080 composum/featurelauncher-nodes:{version}

   - docker pull composum/featurelauncher-composum:{version}
   - docker run --rm -p 8080:8080 composum/featurelauncher-composum:{version}
   
6. set "latest" tag: scripts bin/tagdockerhublatest_all.sh {version} 
   - Test possibly with scripts start-*-from-dockerhub.sh in the docker projects
   
## Quickcheck

Check http://localhost:8080/

- Sling console: all bundles active? Composum versions correct?
- quick look at browser, user manager, package manager
- create simple site in pages, publish, create release, in-place replication + check replicated result in browser

## Debugging Docker

The logfiles are at target/run/logs.

Start with pages/docker/start-from-dockerhub.sh :

- install less for logfile viewing with e.g.
  `docker exec -it -u root composum-pages-develop yum install -y less`
- attach to container with `docker exec -it composum-pages-develop bash`

## Preconditions, to check once in a while

- Starter derived from newest release of sling starter https://github.com/apache/sling-org-apache-sling-starter/releases

## Tricks

If you have xmlstarlet (e.g. package xmlstarlet from https://brew.sh/) installed, the following command prints the
versions of the pom.xml below a main directory:
for fil in */pom.xml ; do
xml sel -T -N pom=http://maven.apache.org/POM/4.0.0 -t -m pom:project -v pom:groupId -o : -v pom:artifactId -o : -v pom:
version -nl $fil
done

### Updating properties

Helper for that:
mvn -DallowDowngrade=true -DgenerateBackupPoms=false -DprocessParent=true versions:update-properties versions:
update-parent
If you want the latest snapshots:
mvn -DallowSnapshots=true -DgenerateBackupPoms=false -DprocessParent=true versions:update-properties versions:
update-parent

Possibly interesting other goals: https://www.mojohaus.org/versions-maven-plugin/
versions:use-latest-releases
versions:commit or -DgenerateBackupPoms=false

mvn versions:display-dependency-updates versions:display-parent-updates versions:display-property-updates
mvn versions:display-plugin-updates
