# How to run a permanently running system via docker

https://github.com/ist-dresden/composum-launch/issues/7

If you want to run a system permanently using docker, that needs some special considerations. Since we want to
update the system by sometimes exchanging the docker container with a new one that has the new versions, nothing
permanent must be stored in the docker container itself

It has the advantage
that you have - code wise - a permanently clean system since it is always recreated from scratch, but you need to
keep various parts of the system permanent, specifically:

- OSGI configurations
- logfiles
- JCR content

JCR content in Apache Sling is particularily interesting since it contains content coming from various sources:

- Sling starter
- Composum application packages
- application packages of other tenants
- OSGI configuration
- general system specific configuration
- job / audit logs / workflow data, clientlib caches etc.
- user content
- version storage
- /public , /preview : replicated content

### Sidenote: Composum installation filters

The package filters in Composum have the following roots that are overwritten by some packages:
/apps/composum, /apps/fonts/(some subdirs), /apps/jslibs/(various), /conf/composum/(various), /etc/map.*,
/libs/composum/(various), /libs/jslibs/(various), /oak:index/lucene/aggregates/(various), /robots.txt, /favicon.ico

## JCR handling

There are three principal ways: keeping the JCR outside of the docker container completely, or mounting several
NodeStores.

### Mounting several NodeStore in JCR

With OAK it is possible to combine several NodeStores into one, as it is done with AEMaaCS for the immutable /libs
and /apps stores there, which . https://jackrabbit.apache.org/oak/docs/nodestore/compositens.html
This allows however only one read/write store with several readonly stores, which doesn't allow the installation of
packages via the package manager and would break other things. So we cannot use that.

### Copying content into the new docker container.

We could use the same process as when migrating to a new OAK version : copy the user managed content from the old
OAK repository to the new one.
Advantage: this makes sure that any old configuration is purged when redeploying / restarting the server. This,
however, is also the disadvantage and makes it brittle: it relies on collecting all content paths that have to be
copied - compare the script [copycontent](../startup/featurelauncher/bin/copycontent). So that is likely too
complicated.

### Keeping the JCR repository outside of the container

That amounts to mounting /opt/sling/launcher/repository as a volume from outside the store, which is easily done, or
keeping the JCR repository in a MongoDB or other database outside of the docker container. 

## Necessary adaptions

- introduced volume /opt/sling/launcher/repository/ into docker-image -> repository outside of docker container (DONE) 

## Test results:

- permanency of JCR works.
- Package updated in docker container -> is updated on restart in the system
- configuration: changed configurations are saved in the JCR and are updated in felix when the new container is started.
- Added packages are saved in JCR, incl. bundles -> permanent, too.

## Open points

1. The test system is used for daily deployments through the "Develop - Build and Deploy Snapshot" jobs. That is so 
   far done using the package manager. Replacing this through building a (850MB) new docker image each time is probably 
   not a good idea -> can, however be combined by continuing with package manager here and replacing the docker 
   image once in a while.
2. Where to store the (due to the non public projects) internal docker images? Possible solutions:
   - https://repo.ist-software.com/ can be configured for docker images
   - solve licensing topic and make them public
3. Where / how are /opt/sling/launcher/repository and /opt/sling/launcher/logs stored? -> depends on the provider 
   hosting the server.
