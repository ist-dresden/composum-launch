# Script to uninstall Composum Core V1 and install Composum Nodes instead.

# make sure the server is somewhat up and running.
until curl -f -u admin:admin -s -S http://localhost:8080/system/console/bundles.json | egrep 'Bundle information:' > /dev/null; do
  echo `logdate` REMCOMPV1 waiting until server up
  sleep 10
done
curl -s -S -L -o /dev/null -u admin:admin http://localhost:8080/

echo `logdate` REMCOMPV1 removing Composum Core v1 if present

# possibly also remove com.composum.core.pckginstall
for bundle in com.composum.core.pckgmgr com.composum.core.usermgnt com.composum.core.console com.composum.core.jslibs com.composum.core.commons com.composum.core.config; do
  if curl -s -f -o /dev/null -u admin:admin -daction=uninstall http://localhost:8080/system/console/bundles/$bundle; then
    removed="$removed $bundle"
  else
    failed="$failed $bundle"
  fi
done

if test -n "$removed"; then
  echo `logdate` REMCOMPV1 SUCCESS removing Composum V1 parts $removed
fi

if test -n "$failed"; then
  echo `logdate` REMCOMPV1 FAILURE removing Composum V1 parts: could not remove $failed - maybe already uninstalled?
fi

if test -n "$removed"; then
  sleep 10
fi
