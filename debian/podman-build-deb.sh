#!/bin/sh

# run from project root directory as debian/podman-build-deb.sh

podman build --logfile=/dev/stderr --output type=local,dest=. -f - . <<END
FROM docker.io/debian:stable AS build
RUN apt-get update
RUN apt-get install -yy build-essential

RUN mkdir /tmp/workspace
WORKDIR /tmp/workspace
COPY debian debian
RUN apt-get build-dep -yy .

COPY . .
RUN dpkg-buildpackage -uc -us

FROM scratch
COPY --from=build /tmp/*.deb /tmp/*.tar.* /tmp/*.dsc /
END

