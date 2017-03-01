#!/bin/bash

. ./init.sh $@

# Create the network
docker network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy the infrastructure stack
docker stack deploy infra-hdp --compose-file=./infra-docker-compose.yaml
