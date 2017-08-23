#!/bin/bash

# Create the network
#docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core
export MYSQL_ROOT_PASSWORD=hortonworks

ssh os10 cp -R /data/mysql/data/ibm_orig /data/mysql/data/ibm_$1

docker -H os10:2375 run -h db.core --net-alias db.core -P --name mysql-ibm-bi -d --network core --restart=unless-stopped -v "/data/mysql/data/ibm_$1:/var/lib/mysql" -e "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" mysql:5.7

# Deploy on Swarm, but as individual containers
# Ambari Server
docker -H os10:2375 run -h ibm01.core --privileged --network-alias ibm01.core -P --name ibm01 -d --network core --dns-search=core --restart=unless-stopped ibm01_$1

docker -H os11:2375 run -h ibm02.core --privileged --network-alias ibm02.core -P --name ibm02 -d --network core --dns-search=core --restart=unless-stopped ibm02_$1

docker -H os12:2375 run -h ibm03.core --privileged --network-alias ibm03.core -P --name ibm03 -d --network core --dns-search=core --restart=unless-stopped ibm03_$1


. ./ps.sh
