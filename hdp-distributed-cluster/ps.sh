#!/bin/bash

. ./init.sh $@

for i in 1 2 3 4 5 6 7 10 11 12; do
	echo "======================"
      	echo "Docker #${i}"
	echo "======================"
  	docker -H os${i}:2375 ps
done
