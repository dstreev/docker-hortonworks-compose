#!/bin/bash

#. ./init.sh $@

#for i in 1 10 11 12 13 14 15; do
#	echo "======================"
#      	echo "Docker #${i}"
#	echo "======================"
#  	docker -H os${i}:2375 ps
#done

ansible os_skull -b -a "docker -H localhost:2375 ps"