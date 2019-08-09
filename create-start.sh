#!/bin/bash

# create and start docker containers in separate phases and measure the latency
# https://stackoverflow.com/questions/37744961/docker-run-vs-create/37745900
# Technically, docker run = docker create + docker start

outFile="init-delay.txt"
# sleep time between consecutive container tests
sleepTime=10

images="openwhisk/action-php-v7.3:nightly openwhisk/java8action:nightly openwhisk/python3action:nightly openwhisk/action-dotnet-v2.2:nightly openwhisk/action-ruby-v2.5:nightly openwhisk/action-swift-v4.2:nightly openwhisk/actionloop-golang-v1.11:nightly"

for i in {0..4}
do
  for image in $images
  do
    echo "Initializing the container for: $image"
    start=$(date +%s%3N)
    contId=$(docker create $image)
    end=$(date +%s%3N)
    delay=$((end-start))
    docker start $contId
    end2=$(date +%s%3N)
    delay2=$((end2-end))

    echo "$image $delay $delay2" >> $outFile

    echo "container initialized with id: $contId"
    echo "Stopping the container ..."
    docker stop $contId
    echo "Removing the container ..."
    docker rm $contId

    echo "Wait $sleepTime seconds before initializing the next container"
    sleep $sleepTime
  done

  echo "-----------------------------" >> $outFile
  echo "Completed iteration: $i ......................................."
done

