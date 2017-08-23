#!/bin/bash

. ./init.sh $@

# Create the network
#docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

# Deploy the infrastructure stack
#docker ${DOCKER_OPTS} stack deploy infra-hdp --compose-file=./infra-docker-compose.yml


docker -H os1:2375 run -h db.hdp.local --net-alias db.hdp.local -P --name mysql-hdp -d --network core --restart=unless-stopped -e "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" -v "/data/mysql/data:/var/lib/mysql" -v "/data/mysql/conf.d:/etc/mysql/conf.d" mysql:5.7

docker -H os1:2375 run -h repo.hdp.local --net-alias repo.hdp.local -P --name repo-hdp -d --network core --restart=unless-stopped -v "/var/www/html:/www" dstreev/hdp-repo
