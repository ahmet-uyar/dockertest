#!/bin/bash

# start docker containers from hard drive for openwhisk and measure the latency
# this is cold start delay for warming up a container
# it includes container startup + container initialization for that language
# this is equivalent to warming up a container

# outFile="warmup-delay-ssd.txt"
outFile=$1
# chek whether output file is provided from command line
if [ "$outFile" = "" ]; then
  echo "You need to give the output file as the parameter"
  exit 0
else
  echo "output file: $outFile"
fi

# sleep time between consecutive container tests
sleepTime=10

images="openwhisk/action-php-v7.3:nightly openwhisk/java8action:nightly openwhisk/python3action:nightly openwhisk/action-dotnet-v2.2:nightly openwhisk/action-ruby-v2.5:nightly openwhisk/action-swift-v4.2:nightly openwhisk/actionloop-golang-v1.11:nightly"

for i in {0..4}
do
  for image in $images
  do
    echo "Starting the warmup for: $image"
    start=$(date +%s%3N)
    contId=$(docker run -d $image)
    end=$(date +%s%3N)
    delay=$((end-start))
    echo "$image $delay" >> $outFile

    echo "container started with id: $contId"
    echo "Stopping the container ..."
    docker stop $contId
    echo "Removing the container ..."
    docker rm $contId

    echo "Wait $sleepTime seconds before warming up the next container"
    sleep $sleepTime
  done

  echo "-----------------------------" >> $outFile
  echo "Completed iteration: $i ......................................."
done

