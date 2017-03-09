#!/bin/bash

export DATA_GROUP=${1:-DK_01}
export OS_VERSION=${2:-centos7}
export AMBARI_VERSION=${3:-latest}
export NIFI_VERSION=${4:-latest}

echo "DATA_GROUP: ${DATA_GROUP}"
echo "OS_VERSION: ${OS_VERSION}"
echo "AMBARI_VERSION: ${AMBARI_VERSION}"
echo "NIFI_VERSION: ${NIFI_VERSION}"
