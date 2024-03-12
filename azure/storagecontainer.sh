#!/bin/bash

storageAccount=$(az storage account list --query "[? contains(name, 'bash')].name" -o tsv)
resourceGroup=$(az storage account show -n $storageAccount --query "resourceGroup" -o tsv)
container="bash"

az storage container create --account-name "$storageAccount" --account-key "$accountKey" --name $container
az storage container list --account-name "$storageAccount" --account-key "$accountKey" --query [].name