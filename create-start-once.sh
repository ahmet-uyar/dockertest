#!/bin/bash

# command line parameters 
image=$1
outFile=$2
contIdFile=$3
index=$4

echo "Initializing the container for: $image"
start=$(date +%s%3N)
contId=$(docker create $image)
end=$(date +%s%3N)
delay=$((end-start))
docker start $contId
end2=$(date +%s%3N)
delay2=$((end2-end))

echo "$index $image $delay $delay2" >> $outFile
echo $contId >> $contIdFile

echo "Done with the container: $contId"
