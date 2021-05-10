#!/usr/bin/env bash
echo copies some composum sites to the package installation directories for automatic installation
topdir=$(dirname $0)
destdir=target/launcher/fileinstall/99
haveerror=""

source $topdir/../.env
mkdir -p $destdir

function copyArtifact() {
  mvn -q -B dependency:copy -Dartifact=$1 -DoutputDirectory=$destdir || haveerror=1
}

if test ! -f $destdir/sitescopiedmarker; then

  copyArtifact com.composum.prototype:composum-prototype-assets-pagesintegration-content:${COMPOSUM_SITES_VERSION}:zip
  copyArtifact com.composum.prototype:composum-prototype-assets-pagesintegration-app-package:${COMPOSUM_SITES_VERSION}:zip

  copyArtifact com.composum.prototype:composum-prototype-assets-demo-app-package:${COMPOSUM_SITES_VERSION}:zip
  copyArtifact com.composum.prototype:composum-prototype-assets-demo-content:${COMPOSUM_SITES_VERSION}:zip

  copyArtifact sites.ist.composum:composum-site-app-package:${COMPOSUM_SITES_VERSION}:zip
  copyArtifact sites.ist.composum:composum-site-content:${COMPOSUM_SITES_VERSION}:zip

  copyArtifact sites.ist.composum:IST-site-test-testpages-app-package:${COMPOSUM_SITES_VERSION}:zip
  copyArtifact sites.ist.composum:IST-site-test-testpages-content:${COMPOSUM_SITES_VERSION}:zip

  # echo "CAUTION: Installing workflow and tenant package, too, for some tests - do not checkin like that, as this doesn't belong to the public stuff."
  # copyArtifact com.composum.platform:composum-platform-workflow-package:1.0.1-SNAPSHOT:zip
  # copyArtifact com.composum.platform:composum-platform-tenant-package:1.0.1-SNAPSHOT:zip

  if test -z "$haveerror"; then
    touch $destdir/sitescopiedmarker
  fi

fi
