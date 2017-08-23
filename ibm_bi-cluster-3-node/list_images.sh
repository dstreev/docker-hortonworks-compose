#!/usr/bin/env bash

for h in 10 11 12; do
    echo "===== Host =====: os${h}.streever.local"
    docker -H os${h}:2375 images
done