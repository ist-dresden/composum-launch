# Feature starters

This directory contains various projects related to starting composum with
the [Sling feature launcher](https://github.com/apache/sling-org-apache-sling-feature-launcher).

## Modules

- nodesstarter : produces a JAR containing a feature archive produced from a Sling Starter 12 snapshot, that has
  everything embedded and does not need any network access to start. It also updates Composum Nodes.
- composumstarter : like nodesstarter, but contains all public composum modules

- sling-starter-copy: a renamed copy of [Sling Starter](https://github.com/apache/sling-org-apache-sling-starter)
  version 12 since there was no release of that for a long long time and we need something to base the nodesstarter on.
  When Sling Starter 12 is released, this can be replaced and removed.

## Deprecated modules

- starter : alternative approach to creating a starter: copies the feature files from Sling Starter 12. Not quite ready and will probably be removed, but that's not 100% sure, so it's still there.
