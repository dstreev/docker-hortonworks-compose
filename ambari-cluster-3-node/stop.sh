#!/bin/bash

. ./init.sh $@

# Deploy on Swarm, but as individual containers
# Ambari Server
export AGENT=01
docker -H os10:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=02
docker -H os11:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=03
docker -H os12:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

