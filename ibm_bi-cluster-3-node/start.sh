#!/bin/bash

# Create the network
#docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy on Swarm, but as individual containers
# Ambari Server
#docker -H os10:2375 start mysql-ibm-bi

#docker -H os10:2375 start --checkpoint $1 ibm01

#docker -H os11:2375 start --checkpoint $1 ibm02
docker -H os12:2375 start --checkpoint $1 ibm03
#docker -H os10:2375 start ibm01

#docker -H os11:2375 start ibm02

#docker -H os12:2375 start ibm03


. ./ps.sh

