# Adds the libraries from the copied maven dependencies into the basic sling launchpad fileinstall-docker directory
# Relies on a maven build to copy the sling starter into target/lib/
# See comments of base image!

ARG PROJECT_VERSION
FROM composum/nodes:${PROJECT_VERSION}

ENV FILEINSTALL_OPTS \
    -Dsling.fileinstall.dir=fileinstall

COPY --chown=sling:sling src/main/scripts /opt/sling/scripts/

RUN set -eux; \
    mkdir -p /opt/sling/fileinstall; \
    chmod a+x /opt/sling/scripts/*.sh

# from maven
COPY --chown=sling:sling target/lib /opt/sling/fileinstall-docker/
