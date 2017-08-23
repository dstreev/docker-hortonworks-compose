#!/bin/bash

. ./init.sh $@

# Create the network
#docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

docker -H os1:2375 start mysql-hdp

docker -H os1:2375 start repo-hdp

# Infra Host
echo "Infra Host"
docker -H os1:2375 ps

