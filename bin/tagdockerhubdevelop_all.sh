#!/usr/bin/env bash
echo Tags our docker images on dockerhub that have the same version as this project with 'develop'
cd $(dirname $0)/..

version=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec)
tag=develop
if test -z "$version"; then
  echo No version given
  usage
fi

echo Tagging dockerhub images with version $version and tag $tag

$(dirname $0)/tagdockerhub.sh composum/featurelauncher-nodes "$version" "$tag"
$(dirname $0)/tagdockerhub.sh composum/featurelauncher-composum "$version" "$tag"
