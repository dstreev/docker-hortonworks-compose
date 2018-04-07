#!/bin/bash

. ./init.sh $@

# Deploy on Swarm, but as individual containers
# Ambari Server

export AGENT=02
docker -H os11:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os11:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=05
docker -H os14:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os14:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

