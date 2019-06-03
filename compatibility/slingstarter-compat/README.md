# Contents

This creates a docker image that starts the plain sling launchpad with the earliest version of JDK and Sling Launchpad supported for the Composum Core, mainly for tests of backwards compatibility.

## Compose-files

For testing, there are some docker-compose files. You need to do a mvn install before calling them:

- docker-compose-local-filesystem.yml : for a quick check of the created docker image: start with a file system based CR.

Launchpad is at http://localhost:8080/index.html .

