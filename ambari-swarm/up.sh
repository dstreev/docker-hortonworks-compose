#!/bin/bash

. ./init.sh $@

# Create the network
docker ${DOCKER_OPTS} network create --driver=overlay --subnet 10.0.10.0/24 --attachable core

pdsh -g dk mkdir -p /var/local/hdp/DK01
for i in 01 02 03 04 05 06 07 09; do
    pdsh -g dk mkdir -p /var/local/hdp/DK01/${i}/data
    for j in "hadoop" "hadoop-yarn" "hadoop-mapreduce" "hive" "hbase" "oozie" "falcon" "atlas" "zookeeper" "ambari-infra-solr" "kafka"; do
        pdsh -g dk mkdir -p /var/local/hdp/DK01/${i}/log/${{j}
    done
done

# Deploy the stack
docker ${DOCKER_OPTS} stack deploy ambari_${AMBARI_INSTANCE} --compose-file=./docker-compose.yml

#docker service update --publish-add 8080 ambari-1_nifi_1

#docker service update --publish-add 80 ambari-1_repo
