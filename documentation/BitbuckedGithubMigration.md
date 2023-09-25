# Migration of code from bitbucket to github
## Todos:
- Identify all repositories to be migrated
- copy over branches and tags
- add README.md and Licence
- make public release
- add to Docker images / new docker image composum-suite

## Clarify with Ralf
- Change repository names? Change artifact names?
- "Composum Pages Suite"? "Composum Suite"?

## Repositories

Prompt: Make a summary of the module what it does and how it fits within the Composum Platform.

### Todo

cpm-site-test https://bitbucket.org/ist-software/cpm-site-test
private https://bitbucket.org/ist-software/composum

### Do not migrate

cpm-site-ist https://bitbucket.org/ist-software/cpm-site-ist
(private content)

### Done

cpm-platform-auth https://bitbucket.org/ist-software/cpm-platform-auth
-> https://github.com/ist-dresden/composum-platform-auth

cpm-platform-replication https://bitbucket.org/ist-software/cpm-platform-replication
-> https://github.com/stoerr/composum-platform-replication

cpm-platform-tenant https://bitbucket.org/ist-software/cpm-platform-tenant
-> https://github.com/ist-dresden/composum-platform-tenant

cpm-platform-workflow https://bitbucket.org/ist-software/cpm-platform-workflow
-> https://github.com/ist-dresden/composum-platform-workflow

### Unclear
cpm-pages-import https://bitbucket.org/ist-software/cpm-pages-import
-> Ralf's Projekt, vermutlich unvollständig. Unklar.

cpm-platform-content https://bitbucket.org/ist-software/cpm-platform-content

cpm-platform-config https://bitbucket.org/ist-software/cpm-platform-config
Secret? Example?

### Later

cpm-launch https://bitbucket.org/ist-software/cpm-launch
-> ??? migrate into composum-launch?

## Script migrate_github_to_bitbucket.sh

#!/bin/bash
# We will migrate from bitbucket to github
# The current origin (on bitbucket) will be renamed to bitbucket and the new origin (on github) will be added as remote
# Then we will copy over all tags and branches from bitbucket to github, but will copy only the branches that are not merged to bitbucket develop.
echo 'Usage: ./migrate_github_to_bitbucket.sh <newremote>'
newremote=$1
# Check if newremote is passed as argument
if [ -z "$newremote" ]; then
  echo "Please pass the new remote as argument"
  exit 1
fi

# Check whether we have already changed the remotes, if not do the renaming.
# If the new remote was already added, we will skip this step
if [ -z "$(git remote | grep $newremote)" ]; then
  # Rename existing origin to bitbucket
  git remote rename origin bitbucket

  # Add a new origin pointing to GitHub
  git remote add origin $newremote
fi

# 1. Fetch all tags from bitbucket
git fetch bitbucket --tags

# 2. Push all these tags to GitHub origin
git push origin --tags

# 3. Fetch all branches from bitbucket
git fetch bitbucket

# 4. Push branches not merged into develop to GitHub origin, excluding the HEAD
for branch in $(git branch -r --no-merged bitbucket/develop | grep "bitbucket/" | sed "s/bitbucket\///" | grep -v '^HEAD$'); do
  # Push the branch directly from bitbucket to origin
  echo git push origin refs/remotes/bitbucket/$branch:refs/heads/$branch
done
