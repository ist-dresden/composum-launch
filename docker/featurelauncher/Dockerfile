# Creates a docker image on top of the releases sling launchpad
# Relies on a maven build to copy the sling starter into target/lib/
#
# We provide two watched directories for file installation - fileinstall-docker, which is meant to be filled
# in derived docker images, and fileinstall-user, which could be mounted by the user

FROM openjdk:17
# install some essential utilities for diagnosing trouble from a shell within the container
RUN installer=$(command -v yum && echo yum || echo microdnf); \
    for pkg in procps-ng less vim-minimal wget findutils; do \
      $installer install -y $pkg; \
    done

RUN set -eux; \
    groupadd -r sling --gid=1000; \
    useradd -r -g sling --uid=1000 --home-dir=/opt/sling --shell=/bin/bash sling; \
    mkdir -p /opt/sling/launcher /opt/sling/fileinstall-docker /opt/sling/fileinstall-user /opt/sling/features-docker/system /opt/sling/features-user /opt/sling/features-docker /opt/sling/launcher/repository /opt/sling/scripts; \
    chown -R sling:sling /opt/sling; \
    ln -s /opt/sling/launcher/logs /var/log/sling; \
    ln -s /opt/sling/launcher/logs /opt/sling/logs;

COPY --chown=sling:sling src/main/scripts /opt/sling/scripts/

RUN set -eux; \
    chmod a+x /opt/sling/scripts/*.sh

# the HTTP port
EXPOSE 8080
# attach for debugging
EXPOSE 18080
# JMX port for jconsole
EXPOSE 28080

VOLUME /opt/sling/launcher
VOLUME /opt/sling/fileinstall-user
VOLUME /opt/sling/features-user
VOLUME /opt/sling/scripts-user
VOLUME /opt/sling/launcher/repository
WORKDIR /opt/sling
USER sling:sling

# JVM options
ENV JVM_OPTS \
    -Djava.awt.headless=true -server \
    --add-opens java.base/java.lang=ALL-UNNAMED

ENV MEM_OPTS \
    -Xms32m -Xmx512m \
    -XX:MaxHeapFreeRatio=10 -XX:MinHeapFreeRatio=5 -XX:-ShrinkHeapInSteps

ENV DEBUG_OPTS \
    -agentlib:jdwp=transport=dt_socket,address=*:18080,server=y,suspend=n

# enables JMX : caution, these are development settings!
# The port has to be the same as the host port. For hostname we might also use environment variable HOST.
ENV JMX_OPTS \
    -Djava.rmi.server.hostname=0.0.0.0 \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=28080 \
    -Dcom.sun.management.jmxremote.rmi.port=28080 \
    -Dcom.sun.management.jmxremote.local.only=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false

# additional options that don't belong here
ENV ADD_OPTS ""

# not quite clear what applies here: https://felix.apache.org/documentation/subprojects/apache-felix-file-install.html
# and https://sling.apache.org/documentation/bundles/file-installer-provider.html
ENV FILEINSTALL_OPTS \
    -D sling.fileinstall.dir=fileinstall-docker,fileinstall-user \
    -D sling.fileinstall.dir.autocreate=true \
    -D felix.startlevel.bundle=30 \
    -D felix.log.level=2 \
    -D felix.fileinstall.start.level=30 \
    -D felix.fileinstall.active.level=30

# arguments for the feature launcher
ENV LAUNCHER_OPTS ""

# additional arguments for the feature launcher
ENV ADD_LAUNCHER_OPTS ""

ENV COMMAND java

CMD exec /opt/sling/scripts/start.sh $COMMAND $JVM_OPTS $MEM_OPTS $DEBUG_OPTS $JMX_OPTS $ADD_OPTS -jar /opt/sling/nodeslauncher.jar $FILEINSTALL_OPTS $LAUNCHER_OPTS $ADD_LAUNCHER_OPTS

# from maven dependency:copy
ARG LAUNCHERJAR
RUN echo LAUNCHERJAR : $LAUNCHERJAR
COPY --chown=sling:sling $LAUNCHERJAR /opt/sling/nodeslauncher.jar

ARG SYSTEM_FAR_DIRECTORY
COPY --chown=sling:sling $SYSTEM_FAR_DIRECTORY/* /opt/sling/features-docker/system/
