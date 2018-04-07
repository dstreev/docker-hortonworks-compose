#!/usr/bin/env bash

ansible os_skull -b -a "docker -H localhost:2375 pull dstreev/centos7_ambari:2"
ansible os_skull -b -a "docker -H localhost:2375 pull dstreev/centos6_ambari:2"