#!/bin/bash

let "randomIdentifier=$RANDOM*$RANDOM"

for i in `seq 1 3`; do
    echo $randomIdentifier > container_size_sample_file_$i.txt
done

az storage blob upload batch \
    --pattern "container*.txt" \
    --source . \
    --destination $container \
    --account-key $accountKey \
    --account-name $storageAccount

az storage blob list \
    --container-name $container \
    --account-key $accountKey \
    --account-name $storageAccount \
    --query "[].name"

bytes=`az storage blob list \
    --container-name $container \
    --account-key $accountKey \
    --account-name $storageAccount \
    --query "[*].[properties.contentLength]" \
    --output tsv | paste -s -d+ | bc`

echo "Total bytes in container: $bytes"
echo $bytes