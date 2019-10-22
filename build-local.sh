#!/usr/bin/env bash

docker build --no-cache -t snellocms/snello-all-in-one -f Dockerfile .
ID="$(docker images | grep 'snello-cms/snello-all-in-one' | head -n 1 | awk '{print $3}')"
echo $ID
docker tag snellocms/snello-all-in-one snellocms/snello-all-in-one:latest
docker tag snellocms/snello-all-in-one snellocms/snello-all-in-one:1.0.0.RC1
docker push snellocms/snello-all-in-one:latest
docker push snellocms/snello-all-in-one:1.0.0.RC1
