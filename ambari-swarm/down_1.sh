#!/bin/bash

. ./init.sh $@

# Create the network
docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

echo "Clean up: "
#pdsh -g dk rm -rf /var/local/hdp/${CLUSTER_PREFIX}${AMBARI_INSTANCE}/data
pdsh -g dk mkdir -p /var/local/hdp/${CLUSTER_PREFIX}${AMBARI_INSTANCE}/data



# Deploy the stack
#docker ${DOCKER_OPTS} stack deploy ambari_${AMBARI_INSTANCE} --compose-file=./docker-compose.yml

# Deploy on Swarm, but as individual containers
# Ambari Server
export AGENT=1
docker -H d6:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d6:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=2
docker -H d7:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d7:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

# Nifi
export AGENT=3
docker -H d3:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d3:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=4
docker -H d4:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d4:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=5
docker -H d5:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d5:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=6
docker -H d1:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d1:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=7
docker -H d2:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d2:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

