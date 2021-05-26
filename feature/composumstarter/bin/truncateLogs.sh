#!/usr/bin/env bash
echo "Truncates the logfiles of the launcher"
if test -d target/launcher/logs; then
  truncate --size=0 target/launcher/logs/*
else
  echo "ERROR: I'm confused: there is no target/launcher/logs here in $(pwd)"
fi
