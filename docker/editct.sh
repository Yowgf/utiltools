#!/bin/sh
#
# Edit the last created image using specified shell.

shell=$1

if [ -z "$shell" ]; then
   shell=bash
fi

last_image=$(docker image ls -q | head -1)
docker run -it --entrypoint "$shell" "$last_image"
