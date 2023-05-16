#! /usr/bin/env bash

set -e

# variables
resourcegroup="development-rg"
location="southeastasia"
vmname="windows-dev-vm"
username="azureuser"

# create resource group
az group create --name $resourcegroup --location $location

# create windows vm
az vm create \
    --resource-group $resourcegroup \
    --name $vmname \
    --image Win2022AzureEditionCore \
    --public-ip-sku Standard \
    --admin-username $username

# install web server
az vm run-command invoke -g $resourcegroup \
    -n $vmname \
    --command-id RunPowerShellScript \
    --scripts "Install-WindowsFeature -name Web-Server -IncludeManagementTools"

# open port 80
az vm open-port --port 80 --resource-group $resourcegroup --name $vmname

# show ip address
export IP_ADDRESS=$(az vm show -d -g $resourcegroup -n $vmname --query publicIps -o tsv)

# check web server
curl $IP_ADDRESS