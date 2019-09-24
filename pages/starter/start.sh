#!/usr/bin/env bash
echo Start script for quick check
set -vx
cd target
exec java -jar composum-pages-starter-*.jar
