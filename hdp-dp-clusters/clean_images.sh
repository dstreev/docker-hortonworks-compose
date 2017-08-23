#!/usr/bin/env bash

for h in 1 2 3 4 5 6 7 8 9 10; do
    for image in `docker -H d${h}:2375 images | cut -c44-57`; do
        echo ${image}
        docker -H d${h}:2375 rmi ${image}
    done
done