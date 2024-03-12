#/!bin/bash

resourceGroup="999SMGO"
location="East US"

var=$(az group list --query "[? contains(name, "$resourceGroup")].name" -o tsv)
case "$resourceGroup" in
$var)
echo The "$resourceGroup" resource group already exists.;;
*)
az group create -n "$resourceGroup" -l "$location";;
esac