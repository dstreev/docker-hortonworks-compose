#!/bin/bash

. ./init.sh $@

# Create the network
docker network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy the stack
docker stack deploy ambari-1 --publish 8080:8080 --compose-file=./docker-compose.yaml
