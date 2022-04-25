# Adds the libraries from the copied maven dependencies into the basic sling launchpad fileinstall-docker directory
# Relies on a maven build to copy the sling starter into target/lib/
# See comments of base image!

ARG DOCKER_IMAGE_TAG
FROM composum/slingstarter:${DOCKER_IMAGE_TAG}

RUN set -eux; \
    mkdir -p /opt/sling/fileinstall-immediate; \
    chown -R sling:sling /opt/sling/fileinstall-immediate;

COPY --chown=sling:sling src/main/scripts /opt/sling/scripts/

RUN set -eux; \
    mkdir -p /opt/sling/fileinstall; \
    chmod a+x /opt/sling/scripts/*.sh

ENV COMMAND /opt/sling/scripts/start.sh $COMMAND

# from maven, currently nothing needed.
# COPY --chown=sling:sling target/lib /opt/sling/fileinstall-docker/
# COPY --chown=sling:sling target/immediatelib /opt/sling/fileinstall-immediate/
