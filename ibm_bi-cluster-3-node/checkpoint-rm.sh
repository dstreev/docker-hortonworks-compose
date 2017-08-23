#!/bin/bash

# Deploy on Swarm, but as individual containers
# Ambari Server
docker -H os10:2375 checkpoint rm mysql-ibm-bi $1

docker -H os10:2375 checkpoint rm ibm01 $1

docker -H os11:2375 checkpoint rm ibm02 $1

docker -H os12:2375 checkpoint rm ibm03 $1

