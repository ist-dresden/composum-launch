#! /bin/bash
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
