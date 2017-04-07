#!/bin/bash

. ./init.sh $@

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

export AGENT=8
docker -H d8:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d8:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=9
docker -H d9:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}
docker -H d9:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent0${AGENT}

export AGENT=10
docker -H d10:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H d10:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
