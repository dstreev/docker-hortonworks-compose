#!/bin/bash

export DOCKER_OPTS="-H d7:2375"

export CLUSTER_PREFIX=${1:-dk}
export AMBARI_INSTANCE=${2:-01}
export AMBARI_VERSION=${3:-2.4.2.0-136}
export NIFI_VERSION=${4:-2.1.1.0}
export REPO_BASE_URL=${5:-http://repo.hdp.local}
#export OS_VERSION=${5:-centos7}

echo "CLUSTER_PREFIX: ${CLUSTER_PREFIX}"
echo "AMBARI_INSTANCE: ${AMBARI_INSTANCE}"
echo "AMBARI_VERSION: ${AMBARI_VERSION}"
echo "NIFI_VERSION: ${NIFI_VERSION}"
echo "REPO_BASE_URL: ${REPO_BASE_URL}"
#echo "OS_VERSION: ${OS_VERSION}"
