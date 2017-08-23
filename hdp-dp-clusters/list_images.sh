#!/usr/bin/env bash

for h in 1 10 11; do
	echo "======================"
      	echo "Docker #${i}"
	echo "======================"
    docker -H os${h}:2375 images
done