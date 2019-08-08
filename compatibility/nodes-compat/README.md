# Contents

Installs the newest Composum Nodes (formerly also known as Core) version into slingstarter-compat, mainly for tests of backwards compatibility with the minimal supported sling launchpad and JDK version.

## Compose-files

For testing, there are some docker-compose files. You need to do a mvn install before calling them:

- docker-compose.yml : for a quick check of the created docker image: start with a file system based CR.

Launchpad is at http://localhost:8080/index.html , 
composum browser at http://localhost:8080/bin/browser.html .
