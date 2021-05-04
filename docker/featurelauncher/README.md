# Composum Launcher Docker Feature Launcher

Creates a docker image with a sling feature launcher that launches a FAR from a Sling Starter 12 snapshot, but is
prepared to deploy more / different features as well as packages / bundles from the filesystem.

Caution: for production use you'll want to create your own docker-image - this is rather meant as and example and a
means of easily exploring what Composum can do for you.

## Usage information

The application defined in the Dockerfile is accessible at port 8080, for debugging port 18080 is opened and JMX is accessible at port 28080. It declares the following volumes:

- /opt/sling/launcher contains the launcher directory, /opt/sling/launcher/logs the log files
- /opt/sling/features-user can contain additional feature archives or features.
- /opt/sling/fileinstall-user can contain bundles or packages for use by the Sling [file installer](https://sling.apache.org/documentation/bundles/file-installer-provider.html).
The features have to be present at startup time, the fileinstall-user directory is repeatedly scanned. If the features are not embedded in a feature archive, it's necessary to specify a repository with in the environment variable LAUNCHER_OPTS for the docker image.

An example docker-compose file is present at [docker-compose.yml](docker-compose.yml).

There are some scripts:
- [start.sh](start.sh) starts a temporary instance in attached mode - all data is deleted when the script is stopped.
- [attach.sh](attach.sh) starts a bash in this instance, for debugging.

## Internal structure of the Docker-Image

The application relevant directories are below /opt/sling, and the starter uses a user sling (group sling) to start the
launcher. These directories are created:

- fileinstall-docker is contained in the docker image and can contain bundles or packages to be installed by
  the [file installer provider](https://sling.apache.org/documentation/bundles/file-installer-provider.html).
- fileinstall-user can be used as a volume so that additional bundles / packages can be processed by the file installer
  provider.
- features-docker is contained in the docker image and can contain various features or feature archives that are
  installed on startup.
- features-user can be used as a volume to provide additional features or feature archives.
- scripts contains various scripts used during start.

For production use, we suggest to use feature archives (FAR) instead of features to avoid that the launcher has to
access the network, and to take care that everything can be loaded without accessing the network. In fact, the feature
launcher is configured per default to avoid using an external repository, but it's possible to add an external
repository to be able to use features.

## Compose-files

For testing, there are some docker-compose files. You need to do a mvn install before calling them:

- docker-compose.yml : for a quick check of the created docker image: start with a file system based CR.

## Testing

Start e.g. with docker-compose up --force-recreate -V --abort-on-container-exit Remove everything e.g. with
docker-compose down --rmi local -v --remove-orphans

## Open points
What properties of the [Felix fileinstaller](https://sling.apache.org/documentation/bundles/file-installer-provider.html) work for the Sling [File Installer Provider](https://sling.apache.org/documentation/bundles/file-installer-provider.html)?
