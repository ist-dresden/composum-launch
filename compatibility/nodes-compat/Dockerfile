# Adds the libraries from the copied maven dependencies into the basic sling launchpad fileinstall-docker directory
# Relies on a maven build to copy the sling starter into target/lib/
# See comments of base image!

ARG DOCKER_IMAGE_TAG
FROM composum/slingstarter-compat:${DOCKER_IMAGE_TAG}

ENV FILEINSTALL_OPTS \
    -Dsling.fileinstall.dir=fileinstall

COPY src/main/scripts/ /opt/sling/scripts/

RUN set -eux; \
    mkdir -p /opt/sling/fileinstall; \
    chmod a+x /opt/sling/scripts/*.sh

ENV COMMAND /opt/sling/scripts/start.sh $COMMAND

# from maven
COPY target/lib/ /opt/sling/fileinstall-docker/
