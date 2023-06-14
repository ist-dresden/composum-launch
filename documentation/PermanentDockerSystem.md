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

Things to check before using this in production:
