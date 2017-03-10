#!/bin/bash

. ./init.sh $@

docker-compose -p ${DATA_GROUP} down
