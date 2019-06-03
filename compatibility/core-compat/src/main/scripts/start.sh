#!/bin/sh
echo cmd line $@
/opt/sling/scripts/stepwisedeploy.sh &
exec $@

