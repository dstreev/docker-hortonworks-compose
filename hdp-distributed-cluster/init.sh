#!/bin/bash

export MYSQL_ROOT_PASSWORD=hortonworks

export DOCKER_OPTS="-H d7:2375"

export CLUSTER_PREFIX=${1:-dk}
export AMBARI_INSTANCE=${2:-01}
export AMBARI_VERSION=${3:-2.4.2.0-136}
export HDF_VERSION=${4:-2.1.2.0-10}
export NIFI_VERSION=${5:-1.1.0}
export REPO_BASE_URL=${6:-http://repo.hdp.local}
#export OS_VERSION=${5:-centos7}

echo "CLUSTER_PREFIX: ${CLUSTER_PREFIX}"
echo "AMBARI_INSTANCE: ${AMBARI_INSTANCE}"
echo "AMBARI_VERSION: ${AMBARI_VERSION}"
echo "HDF_VERSION: ${HDF_VERSION}"
echo "NIFI_VERSION: ${NIFI_VERSION}"
echo "REPO_BASE_URL: ${REPO_BASE_URL}"
#echo "OS_VERSION: ${OS_VERSION}"
