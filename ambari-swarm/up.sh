#!/bin/bash

. ./init.sh $@

# Create the network
docker network create --driver=overlay --attachable core

# Deploy the stack
docker stack deploy ambari-1 --compose-file=./docker-compose.yml
