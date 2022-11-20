#!/bin/sh

# This script is intended to be used inside of ec2 VM instances to iteractively
# change one of the docker containers used by the deployment. It is assumed that
# docker-compose is used as well.
#
# This was the result of a really painful process where I would create a new
# docker build, but after running `docker-compose up` the old configuration was
# used. This is because volumes are preserved by `docker-compose down`. To
# remove the volumes, you can do:
#
# docker system prune --volumes -f
#
# * Notice the --volumes flag
#

cd repair && \
    sudo docker build --no-cache . -t repair:1 && \
    cd .. && sudo docker-compose -f compose.yaml down && \
    sudo docker system prune --volumes -f && \
    sudo docker-compose -f compose.yaml up -d
