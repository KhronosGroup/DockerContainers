# DockerContainers

Docker container specifications which package dependencies for building
Khronos documentation and software.

Images built from this repo are pushed to https://hub.docker.com/r/khronosgroup/docker-images -
Each Dockerfile corresponds to a tag, where the extension of the Dockerfile (e.g., `openxr`, `openxr-sdk`)
matches the name of the tag.

## Scripts

In general, any additional arguments are forwarded on to `docker build`,
so this is how you can pass `--no-cache` to force a rebuild, etc.

- Single-image scripts: pass a Dockerfile name as the first argument, the tag is automatically computed.
  - `./build-one.sh` - Just builds and tags the image locally, does not push to Docker Hub.
    Use for testing modifications.
  - `./build-and-push-one.sh` - Builds and tags the image locally, then pushes it to Docker Hub.
    Only run this once you've committed (and ideally, pushed) the corresponding changes to this Git repo.
- `./build-and-push-all.sh` - Just calls `./build-and-push-one.sh` on the Dockerfiles listed in it.
  If you add a new Dockerfile to this repo, add it to this script too.
