#!/bin/bash

. ./init.sh $@

# Create the network
docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core


# Deploy on Swarm, but as individual containers
# Ambari Server
export AGENT=01
docker -H os1:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=02
docker -H os2:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=03
docker -H os3:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=04
docker -H os4:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=05
docker -H os5:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=06
docker -H os6:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=07
docker -H os7:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=10
docker -H os10:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=11
docker -H os11:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=12
docker -H os12:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
