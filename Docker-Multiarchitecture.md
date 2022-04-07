# Docker multi architecture building

## Why?

While docker is able to run docker images of other architectures (e.g. a 
Apple M1 Max with arm64 architecture can run amd64 for Intel processors),
that proved to be extremely slow. So it's necessary to provide images 
both for the Intel processors, as well as for the ARM processors.

## What

This documents how to build images for different platforms, but this is 
still rather cumbersome.

## Build

There are profiles amd64 and arm64. If you don't give the profile, 
amd64 is taken, as that still seems to be the most current one.

## Setting a default architecture

If you have an M1 Max, it's probably sensible to set the default to that 
architecture by introducing into the maven settings.xml:

        <profile>
            <id>dockerplatformdefault</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <dockerplatform>arm64</dockerplatform>
            </properties>
        </profile>

## Checking whether it's right

`docker image inspect` shows the architecture of an image.

## See
https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
https://medium.com/icetek/understanding-how-docker-multi-arch-images-work-9a7e035e2868

## Todo
When
https://github.com/fabric8io/docker-maven-plugin/issues/1541
is solved, we could remove the default profile and leave the 
architecture empty.
