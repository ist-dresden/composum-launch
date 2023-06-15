#! /bin/bash
# helper script that prints the versions of the checked out composum projects at $COMPOSUM in a format usable for pom properties
cd $COMPOSUM

function printVersion () {
  echo "        <$2>$(xmlstarlet sel -N pom=http://maven.apache.org/POM/4.0.0 -T -t -i pom:project/pom:version -v pom:project/pom:version --else -v pom:project/pom:parent/pom:version $1/pom.xml)</$2>"
}

printVersion nodes composum.nodes.version
printVersion platform composum.platform.version
printVersion pages composum.pages.version
printVersion pages/options composum.pages.options.version
printVersion assets composum.assets.version
printVersion cpm-site-composum composum.sites.version
printVersion cpm-platform-htl cpm.platform.htl.version
printVersion composum-dashboard composum.dashboard.version

printVersion composum-launch composum.launch.version
echo
echo "<!-- closed source parts -->"
printVersion cpm-platform-replication cpm.platform.replication.version
printVersion cpm-platform-workflow cpm.platform.workflow.version
printVersion cpm-platform-tenant cpm.platform.tenant.version
printVersion cpm-platform-auth cpm.platform.auth.version
printVersion cpm-platform-config cpm.platform.config.version

echo
echo "<!-- AEM only -->"
printVersion composum-aem-microsite composum.aem.microsite.version
