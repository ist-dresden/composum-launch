#!/usr/bin/env bash
echo copies some composum sites to the package installation directories for automatic installation
topdir=`dirname $0`
source $topdir/../.env
mkdir -p target/launcher/fileinstall

if test ! -f target/launcher/fileinstall/sitescopiedmarker; then

  echo "CAUTION: Installing workflow and tenant package, too, for some tests - do not checkin like that, as this doesn't belong to the public stuff."
  mvn -q -B dependency:copy -Dartifact=com.composum.platform:composum-platform-workflow-package:1.0.1-SNAPSHOT:zip -DoutputDirectory=target/launcher/fileinstall
  mvn -q -B dependency:copy -Dartifact=com.composum.platform:composum-platform-tenant-package:1.0.1-SNAPSHOT:zip -DoutputDirectory=target/launcher/fileinstall

  mvn -q -B dependency:copy -Dartifact=sites.ist.composum:composum-site-app-package:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall
  mvn -q -B dependency:copy -Dartifact=sites.ist.composum:composum-site-content:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall

  mvn -q -B dependency:copy -Dartifact=sites.ist.composum:IST-site-test-testpages-app-package:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall
  mvn -q -B dependency:copy -Dartifact=sites.ist.composum:IST-site-test-testpages-content:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall

  mvn -q -B dependency:copy -Dartifact=com.composum.prototype:composum-prototype-assets-pagesintegration-content:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall
  mvn -q -B dependency:copy -Dartifact=com.composum.prototype:composum-prototype-assets-pagesintegration-app-package:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall

  mvn -q -B dependency:copy -Dartifact=com.composum.prototype:composum-prototype-assets-demo-app-package:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall
  mvn -q -B dependency:copy -Dartifact=com.composum.prototype:composum-prototype-assets-demo-content:${COMPOSUM_SITES_VERSION}:zip -DoutputDirectory=target/launcher/fileinstall

  touch target/launcher/fileinstall/sitescopiedmarker

fi
