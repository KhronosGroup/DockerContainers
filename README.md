# DockerContainers

Docker container specifications which package dependencies for building
Khronos documentation and software.

Images built from this github repository are pushed to the Dockerhub
repository https://hub.docker.com/r/khronosgroup/docker-images.

## Structure

Each Dockerfile is named `<tag>.Dockerfile` where `<tag>` (e.g. `openxr`, `asciidoctor-spec`)
matches the tag for that image in the Dockerhub repository (e.g. `KhronosGroup/docker-images:rust`).
A second tag is suffixed with `.<date>` representing a timestamp when this image was last modified.

## Scripts

In general, any additional arguments are forwarded on to `docker build` except the first if it is
`"push"`, so this is how you can pass `--no-cache` to force a rebuild, etc.

- Single-image scripts: pass a tag name as the first argument and a version as the second.
  - `./build-one.sh <tag> <date>` - Just builds and tags the image locally, does not push to Dockerhub.
    Use for testing modifications.
  - `./build-one.sh <tag> <date> push` - Builds and tags the image locally, then pushes it to Dockerhub.
    Only run this once you've committed (and ideally, pushed) the corresponding changes to this Git repo.
- `./build-all.sh` - Just calls `./build-one.sh` on all the tags listed in it. Use as `./build-all.sh push`
  to push all images to Dockerhub.
  If you add a new Dockerfile to this repo, add it to this script too.
