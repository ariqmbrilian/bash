#! /usr/bin/env bash

set -e

export RESOURCE_GROUP_NAME="development-rg"
export LOCATION=southeastasia
export VM_NAME=linux-dev-vm
export VM_IMAGE=debian
export ADMIN_USERNAME=azureuser

# create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# create linux vm
az vm create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $VM_NAME \
    --image $VM_IMAGE \
    --admin-username $ADMIN_USERNAME \
    --generate-ssh-keys \
    --public-ip-sku Standard

# install web server
az vm run-command invoke \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $VM_NAME \
    --command-id RunShellScript \
    --scripts "sudo apt update && sudo apt install nginx -y && sudo systemctl enable nginx && sudo systemctl restart nginx"

# open port 80
az vm open-port --port 80 --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME

# show ip address
export IP_ADDRESS=$(az vm show -d -g $RESOURCE_GROUP_NAME -n $VM_NAME --query publicIps -o tsv)

# check web server
curl $IP_ADDRESS

