# Adds the libraries from the copied maven dependencies into the basic sling launchpad fileinstall-docker directory
# Relies on a maven build to copy the sling starter into target/lib/
# See comments of base image!

ARG DOCKER_IMAGE_TAG
FROM composum/featurelauncher-nodes:${DOCKER_IMAGE_TAG}

# from maven
COPY --chown=sling:sling target/dependencies/* /opt/sling/features-docker/
COPY --chown=sling:sling target/examplesites/* /opt/sling/fileinstall-docker/
