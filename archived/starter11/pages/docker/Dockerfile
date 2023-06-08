# Adds the libraries from the copied maven dependencies into the basic sling launchpad fileinstall-docker directory
# Relies on a maven build to copy the sling starter into target/lib/
# See comments of base image!

ARG DOCKER_IMAGE_TAG
FROM composum/nodes:${DOCKER_IMAGE_TAG}

COPY --chown=sling:sling src/main/scripts /opt/sling/scripts/

RUN set -eux; \
    chmod a+x /opt/sling/scripts/*.sh

# from maven
COPY --chown=sling:sling target/lib /opt/sling/fileinstall-docker/
