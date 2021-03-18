#!/usr/bin/env bash
echo Start script for quick check
set -vxe
cd target
/bin/rm -fr sling
exec java -jar composum-launcher-pages-starter-*.jar
