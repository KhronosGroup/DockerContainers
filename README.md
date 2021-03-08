# DockerContainers

Docker container specifications which package dependencies for building
Khronos documentation and software.

Images built from this github repository are pushed to the Dockerhub
repository

https://hub.docker.com/r/khronosgroup/docker-images

Each Dockerfile is named in the form 'Dockerfile.<tag>' or
'<tag>.dockerfile', where <tag> (e.g. `openxr`, `asciidoctor-spec`) matches
the tag for that image in the Dockerhub repository.

## Scripts

In general, any additional arguments are forwarded on to `docker build`,
so this is how you can pass `--no-cache` to force a rebuild, etc.

- Single-image scripts: pass a Dockerfile name as the first argument, the tag is automatically computed.
  - `./build-one.sh` - Just builds and tags the image locally, does not push to Dockerhub.
    Use for testing modifications.
  - `./build-and-push-one.sh` - Builds and tags the image locally, then pushes it to Dockerhub.
    Only run this once you've committed (and ideally, pushed) the corresponding changes to this Git repo.
- `./build-and-push-all.sh` - Just calls `./build-and-push-one.sh` on the Dockerfiles listed in it.
  If you add a new Dockerfile to this repo, add it to this script too.
