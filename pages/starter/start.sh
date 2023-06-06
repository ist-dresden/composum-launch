#!/usr/bin/env bash
echo Start script for quick check
set -vxe
cd target
/bin/rm -fr target
mkdir -p sling/fileinstall
exec java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=9970 -jar composum-launcher-pages-starter-*.jar -Dsling.fileinstall.dir=fileinstall
