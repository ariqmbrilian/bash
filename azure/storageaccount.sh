#!/bin/bash

let "randomIdentifier=$RANDOM*$RANDOM"
resourceGroup="999SMGO"
location="East US"
storageAccount="bash$randomIdentifier"

az storage account create -n "$storageAccount" -l "$location" -g "$resourceGroup" --sku Standard_LRS --encryption-services blob
