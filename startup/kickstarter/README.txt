java -jar ...kickstart.. start
java -jar ...kickstart.. status
java -jar ...kickstart.. stop

java -jar <kickstart jar file>.jar -Dsling.run.modes=mode1,mode2


https://mvnrepository.com/artifact/org.apache.sling/org.apache.sling.kickstart/0.0.12
https://mvnrepository.com/artifact/org.apache.sling/org.apache.sling.starter/ ??? nix 12!!!

https://hub.docker.com/r/apache/sling 12!

see composumpackages.json

run without network:
docker run -ti --rm --network none -v `pwd`:`pwd` -w `pwd` -p 8080:8080 openjdk:12-jdk /bin/bash
