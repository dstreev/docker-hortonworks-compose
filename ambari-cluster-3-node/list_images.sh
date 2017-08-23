#!/usr/bin/env bash

for h in 1 2 3 4 5 6 7 8 9 10; do
    echo "===== Host =====: d${h}.docker.local"
    docker -H d${h}:2375 images
done