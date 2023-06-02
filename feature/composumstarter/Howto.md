# Various howtos about the feature/composumstarter

## How to add new libraries
Add dependency and perhaps version number property in /pom.xml , add version number property to configuration in 
slingfeature-maven-plugin , add feature ot src/main/features/composumpackages.json

## How to (temporarily!) add some site packages for testing

Add something like
{
  "content-packages:ARTIFACTS|required": [
    {
      "id": "sites.ist.composum:composum-site-app-package:zip:1.0.0-SNAPSHOT",
      "start-order": "50"
    },
    {
      "id": "sites.ist.composum:composum-site-content:zip:1.0.0-SNAPSHOT",
      "start-order": "50"
    }
  ]
}
as a feature file in src/main/features.

## How to test

(IST only) After mvn clean install call bin/examplesites-resourceshook.sh and then bin/start.sh.
