#!/bin/bash

# create and start docker containers in parallel
# https://stackoverflow.com/questions/37744961/docker-run-vs-create/37745900
# Technically, docker run = docker create + docker start

# outFile="init-delay-ssd.txt"
outFile=$1
contIdFile="container-ids.txt"

# remove container id file
rm $contIdFile
echo "Removed container id file: $contIdFile "

# chek whether output file is provided from command line
if [ "$outFile" = "" ]; then
  echo "You need to give the output file as the parameter"
  exit 0
else
  echo "output file: $outFile"
fi

# sleep after initializing all containers
sleepTime=100

images="openwhisk/action-php-v7.3:nightly openwhisk/java8action:nightly openwhisk/python3action:nightly openwhisk/action-dotnet-v2.2:nightly openwhisk/action-ruby-v2.5:nightly openwhisk/action-swift-v4.2:nightly openwhisk/actionloop-golang-v1.11:nightly"

count=0

for i in {0..9}
do
  for image in $images
  do
    ./create-start-once.sh $image $outFile $contIdFile $count &
    count=$((count+1))
  done
done

echo "Finished starting shell processes. Waiting for $sleepTime seconds ......"
sleep $sleepTime

ids=`cat container-ids.txt`
echo "Stopping the containers ..."
docker stop $ids
echo "Removing the containers ..."
docker rm $ids
