#!/bin/bash

# Create the network
#docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

export MYSQL_ROOT_PASSWORD=hortonworks

docker -H os10:2375 run -h db.core --net-alias db.core -P --name mysql-ibm-bi -d --network core --restart=unless-stopped -v "/data/mysql/data/ibm_orig:/var/lib/mysql" -e "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" mysql:5.7

# Deploy on Swarm, but as individual containers
# Ambari Server
docker -H os10:2375 run -h ibm01.core --privileged --network-alias ibm01.core -P --name ibm01 -d --network core --dns-search=core --restart=unless-stopped dstreev/centos7_ibm_bi_base

docker -H os11:2375 run -h ibm02.core --privileged --network-alias ibm02.core -P --name ibm02 -d --network core --dns-search=core --restart=unless-stopped dstreev/centos7_ibm_bi_base

docker -H os12:2375 run -h ibm03.core --privileged --network-alias ibm03.core -P --name ibm03 -d --network core --dns-search=core --restart=unless-stopped dstreev/centos7_ibm_bi_base


. ./ps.sh
