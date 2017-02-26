#!/bin/bash

export DATA_GROUP=${1:-DK_01}
export AMBARI_VERSION=${2:-latest}
export NIFI_VERSION=${2:-latest}

echo "DATA_GROUP: ${DATA_GROUP}"
echo "AMBARI_VERSION: ${AMBARI_VERSION}"
echo "NIFI_VERSION: ${NIFI_VERSION}"
