#!/usr/bin/env bash
echo "This summarizes the directories with ChatGPT from the README.md, pom.xml etc. files"

prompt=$(
  cat <<EOF
Please summarize what the directory containing the following files is about. Especially:
- Repeat the path to the directory (as subheading "Module", see example below)
- What is the purpose of the module in that directory?
- What other composum-launcher* and com.composum.platform.features:* artifacts does it need?
- What other docker images does it need and which does it build? The docker image name built is specified in the pom.xml docker-maven-plugin configuration. If there is a Dockerfile or a docker-maven-plugin in the pom.xml then it certainly produces a docker image.
Do not discuss the files I give you - these are only there for you to extract information.
An example is as follows; please omit sections if they would be empty:
## Module pages/docker
Purpose: Create a docker image from sling starter with updated Composum Core (incl. Package manager and User mgmt) and Composum Platform and Pages.
Description: The module builds a docker image with the name composum/pages. It also copies the maven dependencies of the sling starter into target/lib directory of the docker image.
Artifact: composum-launcher-pages-docker
Dependencies: composum-launcher-composumnodes, composum-launcher-feature-integrationtest
Docker: builds composum/pages from composum/nodes
EOF
)

# check that there is exactly one argument that is a directory, otherwise complain and exit. It should be assigned to variable dir
#if [ $# -ne 1 ] || [ ! -d "$1" ]; then
#  echo "ERROR: Exactly one argument expected, the directory to summarize. Exiting."
#  exit 1
#fi
#dir=$1
#dir=${dir%/}

for dir in $(find . -name pom.xml | fgrep -v target | fgrep -v archived | xargs -n 1 dirname); do

  echo "Summarizing $dir"
  # if $dir/.cgpt.description.md does not exist or is empty
  if [ ! -s "$dir/.cgpt.description.md" ]; then

    filearray=()
    for fil in $dir/README.md $dir/pom.xml $dir/Dockerfile $dir/.env; do
      if [ -f "$fil" ]; then
        filearray+=("-f" "$fil")
      fi
    done

    chatgpt "${filearray[@]}" "$prompt" | tee $dir/.cgpt.description.md

    # exit 0
  fi

done

echo "# ChatGPT generated summary of all modules" > .cgpt.description.all.md
echo >> .cgpt.description.all.md
for fil in $(find . -name .cgpt.description.md); do
  cat $fil >> .cgpt.description.all.md
  echo >> .cgpt.description.all.md
  echo >> .cgpt.description.all.md
done
