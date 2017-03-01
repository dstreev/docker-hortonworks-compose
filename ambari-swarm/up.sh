#!/bin/bash

. ./init.sh $@

# Create the network
docker network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy the stack
docker stack deploy ambari_${AMBARI_INSTANCE} --compose-file=./docker-compose.yaml

#docker service update --publish-add 8080 ambari-1_nifi_1

#docker service update --publish-add 80 ambari-1_repo
