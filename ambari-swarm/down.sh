#!/bin/bash

. ./init.sh $@

docker ${DOCKER_OPTS} stack rm ambari_${AMBARI_INSTANCE}