# Docker multi architecture building

## Why?

While docker is able to run docker images of other architectures (e.g. a 
Apple M1 Max with arm64 architecture can run amd64 for Intel processors),
that proved to be extremely slow. So it's necessary to provide images 
both for the Intel processors, as well as for the ARM processors.

## General idea

Unfortunately the used docker maven plugin does not yet support building
for several architectures properly. Also, it turns out that running
a x86_64 architecture image is theoretically possible on arm64, but only
theoretically - it seems Java doesn't work properly and waaaaay too slow.
So we opt for building the image only on the native architecture,
and possibly creating multi architecture images per script. The architecture
is added as an suffix to the version.

## Creating multiarchitecture images

In docker/bin/ there is a makemultiarch.sh that combines the images
for both supported architectures into one multiarchitecture manifest.
makeallmultiarch.sh combines all published images.

If it's a snapshot, repeat this with develop as additional argument (= tag);
if it's a release, repeat this with latest as additional argument.

## Checking whether it's right

`docker image inspect` shows the architecture of an image.

## See
https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
https://medium.com/icetek/understanding-how-docker-multi-arch-images-work-9a7e035e2868

## Related bugs
https://github.com/fabric8io/docker-maven-plugin/issues/1541
