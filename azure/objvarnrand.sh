#!/bin/bash

let "randomIdentifier=$RANDOM*$RANDOM"

resourceGroup='bash-$randomIdentifier' # ignored
resourceGroup="bash-$randomIdentifier" # evaluated

location="East US"
echo location $location # evaluated
echo "location $location" # evaluated
echo 'location $location' # ignored
echo "location \$location" # ignored

az group create --name $resourceGroup -l $location # failed because detect white space
az group create --name $resourceGroup -l "location" # success because whitespace ignored and accept entire string as value