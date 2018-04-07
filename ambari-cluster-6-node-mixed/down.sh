#!/bin/bash

. ./init.sh $@

# Deploy on Swarm, but as individual containers
# Ambari Server
export AGENT=01
docker -H os10:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os10:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=02
docker -H os11:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os11:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=03
docker -H os12:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os12:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=04
docker -H os13:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os13:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=05
docker -H os14:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os14:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=06
docker -H os15:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os15:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
