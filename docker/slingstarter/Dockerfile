# Creates a docker image on top of the releases sling launchpad
# Relies on a maven build to copy the sling starter into target/lib/
#
# We provide two watched directories for file installation - fileinstall-docker, which is meant to be filled
# in derived docker images, and fileinstall-user, which could be mounted by the user

FROM openjdk:17
ARG FELIXVERSION
# install some essential utilities for diagnosing trouble from a shell within the container
RUN installer=$(command -v yum && echo yum || echo microdnf); \
    $installer install -y procps-ng; \
    $installer install -y less; \
    $installer install -y vim-minimal; \
    $installer install -y wget

RUN set -eux; groupadd -r sling --gid=1000; \
    useradd -r -g sling --uid=1000 --home-dir=/opt/sling/launcher --shell=/bin/bash sling; \
    mkdir -p /opt/sling/launcher /opt/sling/fileinstall-docker /opt/sling/fileinstall-user; \
    chown -R sling:sling /opt/sling; \
    ln -s /opt/sling/launcher/logs /var/log/sling;

# JVM options
ENV JVM_OPTS \
    -Djava.awt.headless=true -server \
    --add-opens=java.base/sun.net.www.protocol.jrt=ALL-UNNAMED
# --add-opens... is a workaround for https://issues.apache.org/jira/browse/FELIX-6035 with JDK 11/12, until a felix upgrade to >=6.0.2 is done

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

# additional options for sling
ENV SLING_OPTS ""

ENV FILEINSTALL_OPTS -D sling.fileinstall.dir=fileinstall-docker,fileinstall-user -D felix.startlevel.bundle=30

ENV COMMAND java

# the HTTP port
EXPOSE 8080
# attach for debugging
EXPOSE 18080
# JMX port for jconsole
EXPOSE 28080

VOLUME /opt/sling/launcher
VOLUME /opt/sling/fileinstall-user
WORKDIR /opt/sling
USER sling:sling
CMD exec $COMMAND $JVM_OPTS $MEM_OPTS $DEBUG_OPTS $JMX_OPTS $ADD_OPTS $STARTER_CMDLINE $SLING_OPTS $FILEINSTALL_OPTS

ENV STARTER_CMDLINE -jar featurelauncher.jar -f main.far -u jar:file:felixcontainer.zip! -u jar:file:main.far! -fv $FELIXVERSION -v

# from maven dependency:copy
COPY target/lib/composum-launcher-feature-felixcontainer-1.2.1-SNAPSHOT-zip.zip felixcontainer.zip
COPY target/lib/org.apache.sling.feature.launcher-1.1.26.jar featurelauncher.jar
COPY target/lib/org.apache.sling.starter-12-oak_tar_far.far main.far
