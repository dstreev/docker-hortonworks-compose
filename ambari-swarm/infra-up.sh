#!/bin/bash

. ./init.sh $@

# Create the network
docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy the infrastructure stack
docker ${DOCKER_OPTS} stack deploy infra-hdp --compose-file=./infra-docker-compose.yml
