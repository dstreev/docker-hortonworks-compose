#!/bin/bash

. ./init.sh $@

# Deploy on Swarm, but as individual containers

export AGENT=01
docker -H os10:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os10:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=02
docker -H os3:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os3:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=03
docker -H os4:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os4:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

# Increment instance
AMBARI_INSTANCE=$((AMBARI_INSTANCE+1))

export AGENT=01
docker -H os11:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os11:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=02
docker -H os5:2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os5:2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}

export AGENT=03
docker -H os6::2375 stop ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
docker -H os6::2375 rm ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}
