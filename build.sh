#!/bin/bash

# set -x
set -e

if [ "$#" -eq 0 ]; then
  STACK_VERSIONS=(16 18 20)
else
  STACK_VERSIONS=( "$@" )
fi

for stack_version in "${STACK_VERSIONS[@]}"; do
  image_name=libvips-heroku-$stack_version:$VIPS_VERSION

  docker build \
    --build-arg VIPS_VERSION=${VIPS_VERSION} \
    --build-arg STACK_VERSION=${stack_version}\
    -t $image_name \
    container

  mkdir -p build

  docker run --rm -t -v $PWD/build:/build $image_name sh -c 'cp -f /usr/local/vips/build/*.tar.gz /build'
done
