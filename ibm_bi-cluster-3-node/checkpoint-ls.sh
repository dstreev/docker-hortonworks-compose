#!/bin/bash

# Deploy on Swarm, but as individual containers
# Ambari Server
docker -H os10:2375 checkpoint ls mysql-ibm-bi

docker -H os10:2375 checkpoint ls ibm01

docker -H os11:2375 checkpoint ls ibm02

docker -H os12:2375 checkpoint ls ibm03

