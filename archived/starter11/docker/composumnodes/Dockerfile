# Adds the libraries from the copied maven dependencies into the basic sling launchpad fileinstall-docker directory
# Relies on a maven build to copy the sling starter into target/lib/
# See comments of base image!

ARG DOCKER_IMAGE_TAG
FROM composum/slingstarter-stepwisedeploy:${DOCKER_IMAGE_TAG}

RUN rm -f /opt/sling/fileinstall-docker/*/composum-sling-osgi-package-installer*

# from maven
COPY --chown=sling:sling target/lib /opt/sling/fileinstall-docker/

RUN set -eux; \
    chmod a+x /opt/sling/scripts/*.sh
