# Listing of TODOs wrt. composum-launcher

## Next

- Put release of starters out to maven central
- Update README.md and restructure it
- try to convince https://github.com/apache/sling-org-apache-sling-feature-launcher version 1.3.0 to work.
- integrate and activate dashboard!
- create release 1.5.1

## Bugs

- why does fileinstall not work on feature/composumstarter ??? probably wrong configuration, works in docker. 
  Compare https://sling.apache.org/documentation/bundles/file-installer-provider.html 

## Backlog

- integrate and activate dashboard!
- retry startup/featurelauncher to see whether new versions help with problems
- try to convince https://github.com/apache/sling-org-apache-sling-feature-launcher version 1.3.0 to work.

## Unclear

- dockerhub: composum/pages sounds like the real thing, but currently isn't. Deactivate? Repurpose?

# Done

- OK: Dockerhub deployment from Github Actions
- revisit all modules and evaluate whether there is an update necessary or whether they can be archived. -> Output:
  Modules.md, extend TODO.md
- move Sling 11 stuff to archive, if no longer necessary. (It might be necessary for deploying stuff with package
  manager instead of features, since feature upgrades might or might not work smoothly.)
