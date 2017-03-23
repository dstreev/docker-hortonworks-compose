#!/bin/bash

. ./init.sh $@

# Ambari Host
echo "Ambari Host"
docker -H d6:2375 ps
# Nifi Host
echo "Nifi Host"
docker -H d3:2375 ps
