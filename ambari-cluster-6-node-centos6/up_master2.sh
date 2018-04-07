#!/bin/bash

. ./init.sh $@

# Create the network
#docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

echo "Clean up: "
#pdsh -g dk rm -rf /var/local/hdp/${CLUSTER_PREFIX}${AMBARI_INSTANCE}/data
ansible os_skull -b -a 'mkdir -p /var/local/hdp/${CLUSTER_PREFIX}${AMBARI_INSTANCE}/data'



# Deploy the stack
#docker ${DOCKER_OPTS} stack deploy ambari_${AMBARI_INSTANCE} --compose-file=./docker-compose.yml

# Deploy on Swarm, but as individual containers
# Ambari Server

export AGENT=02
docker -H os11:2375 run -h ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}.core --privileged --network-alias ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}.core -P --name ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT} -d --network core --dns-search=core --restart=unless-stopped -e "AMBARI_VERSION=${AMBARI_VERSION}" -e "CLUSTER_PREFIX=${CLUSTER_PREFIX}" -e "AMBARI_INSTANCE=${AMBARI_INSTANCE}" -e "AMBARI_AGENT=true" -e "AGENT=${AGENT}" -e "REPO_BASE_URL=${REPO_BASE_URL}" -v "/var/local/hdp/${CLUSTER_PREFIX}${AMBARI_INSTANCE}/data:/data" dstreev/centos7_ambari:2

#export AGENT=05
#docker -H os14:2375 run -h ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}.core --privileged --network-alias ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT}.core -P --name ${CLUSTER_PREFIX}${AMBARI_INSTANCE}agent${AGENT} -d --network core --dns-search=core --restart=unless-stopped -e "AMBARI_VERSION=${AMBARI_VERSION}" -e "CLUSTER_PREFIX=${CLUSTER_PREFIX}" -e "AMBARI_INSTANCE=${AMBARI_INSTANCE}" -e "AMBARI_AGENT=true" -e "AGENT=${AGENT}" -e "REPO_BASE_URL=${REPO_BASE_URL}" -v "/var/local/hdp/${CLUSTER_PREFIX}${AMBARI_INSTANCE}/data:/data" dstreev/centos7_ambari:2

. ./ps.sh
