#!/bin/bash

export MYSQL_ROOT_PASSWORD=hortonworks

export DOCKER_OPTS="-H d7:2375"

export CLUSTER_PREFIX=${1:-dp}
export AMBARI_INSTANCE=${2:-1}
export AMBARI_VERSION=${3:-2.5.2.0-257}
#export HDF_VERSION=${4:-2.1.2.0-10}
#export NIFI_VERSION=${5:-1.1.0}
export REPO_BASE_URL=${6:-http://repo.hdp.local/repo}
#export BASE_OS_DATA_DIR=/data/str${AMBARI_INSTANCE}
#export OS_VERSION=${5:-centos7}

echo "CLUSTER_PREFIX: ${CLUSTER_PREFIX}"
echo "AMBARI_INSTANCE: ${AMBARI_INSTANCE}"
echo "AMBARI_VERSION: ${AMBARI_VERSION}"
#echo "HDF_VERSION: ${HDF_VERSION}"
#echo "NIFI_VERSION: ${NIFI_VERSION}"
#echo "BASE_OS_DATA_DIR: ${BASE_OS_DATA_DIR}"
#echo "OS_VERSION: ${OS_VERSION}"
