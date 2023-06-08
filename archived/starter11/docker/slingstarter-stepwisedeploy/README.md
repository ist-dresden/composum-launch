# Content

This contains a docker image that sets up some basic scripts for the stepwise deployment of packages within sling starter from a docker image to avoid problems with dependencies between them.

# Configuration

Docker image deriving on this can add packages to /opt/sling/fileinstall-docker to subdirectories named with a number (e.g. /opt/sling/fileinstall-docker/45/somepackage.zip). They will be installed in the order given by these directory names, waiting until the server is quiet between those stages.

If an image wants to preload some urls on startup to have the image initialize some things on startup so that the user has quick access time, it can add a script matching the pattern _preloadurls-*.sh to /opt/sling/scripts/ and augment the variable urls with some URLs to load immediately after startup.
