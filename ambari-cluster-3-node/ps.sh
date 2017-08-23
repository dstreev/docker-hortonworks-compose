#!/bin/bash

. ./init.sh $@

for i in 1 10 11 12; do
	echo "======================"
      	echo "Docker #${i}"
	echo "======================"
  	docker -H os${i}:2375 ps
done
