#!/bin/bash
#
# Commit last created docker container, tag it with specified tag, then push it.

tag=$1
[ -z "$tag" ] && echo "Unable to run script without 'tag' argument" && exit 1

last_container=$(docker ps -a -q | head -1)
docker commit $last_container
commited_image=$(docker image ls -q | head -1)
docker tag $commited_image $tag
docker push $tag
