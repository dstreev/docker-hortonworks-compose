#!/bin/bash

. ./init.sh $@

for i in 1 3 4 5 6 10 11; do
	echo "======================"
      	echo "Docker #${i}"
	echo "======================"
  	docker -H os${i}:2375 ps
done
