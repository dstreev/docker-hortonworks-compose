#!/bin/bash

. ./init.sh $@

# Create the network
docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy on Swarm, but as individual containers
# Ambari Server
export AGENT=01
docker -H os10:2375 start ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=02
docker -H os11:2375 start ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=03
docker -H os12:2375 start ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}


. ./ps.sh

