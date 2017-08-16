# docker-firefox-send

This is a Docker image for [Mozilla's Firefox Send](https://send.firefox.com) designed to be built locally.

## Motivation

While Mozilla offer a [Send Docker image](https://hub.docker.com/r/mozilla/send/), this is not a repostiory with automated build from source. [The Send GitHub repository](https://github.com/mozilla/send) contains a Dockerfile, but the build process is [not designed to be completed fully inside Docker](https://github.com/mozilla/send/issues/498), which partially removes the benefit of not cluttering the host with depencies by running applications in Docker.

The Dockerfile is this repository is a modified version of the original one that does not need any work to be done on the host. Building a fresh copy of Send is as easy as cloning the repository and running a build. The resulting image is negligibly larger than the original Mozilla one.

## Building an image

The easiest way to build is by using [Docker Compose](https://docs.docker.com/compose/overview/). Open the `docker-compose.yml` file and adjust the paramters to suit your needs. Of particular interest should be:

* the `version` build arg. This is a git _treeish_ indicating the version of Send to build. It is recommended to use the latest release tag, but you can also try `master` for the most up-to-date code.
* the forwarded port. This should be set to your desired port on which Send can be reached. Ideally, you should make the port accesible from localhost only with the `127.0.0.1:<host-port>:<container-port>` syntax, and set up a reverse proxy (with https!) in front of that. Note that if you change the container port, then you also need to update this in `Dockerfile`.

When the parametrs are in place, build the image and start Send:

```
$ docker-compose build
$ docker-compose up -d
```

### Without `docker-compose`

If you only want to build the Send Docker image and avoid using Compose, you can use a plain Docker build:

```
$ docker build -t firefox-send --build-arg version=<treeish> .
```

You would then need to link the Send container to a Redis server manually. See the [instructions on the Send GitHub page](https://github.com/mozilla/send/blob/73ccce627cb6bbb910137505ccba97451143c7b8/docs/docker.md) for more details.

## Running without building

The main purpose of this image is to use a transparent build that is easily adjustable to your personal needs. It is strongly encouraged that you build your own image, for a variety of reasons, including the peace of mind that you know what code you are running, and especially since the build process takes only a couple of minutes.

If you insist on using a pre-built image, perhaps it is better to trust [Mozilla's image](https://hub.docker.com/r/mozilla/send/) than that of a random stranger on the Internet.

If you _still_ want to obtain a pre-built version of this particular image, you can download it from [DockerHub](https://hub.docker.com/r/andreipoe/firefox-send/). At this point, you need to run it by either using a modified `docker-compose.yml` (with the `build` section removed), or by following the instructions for running [without Compose](#without-docker-compose). Note that the image you obtain from DockerHub may or may not be up-to-date with the latest Send version.

