#!/bin/bash

. ./init.sh $@

for i in 1 2 3 4 5 6 7 8 9 10; do
	echo "======================"
      	echo "Docker #${i}"
	echo "======================"
  	docker -H d${i}:2375 ps
done
