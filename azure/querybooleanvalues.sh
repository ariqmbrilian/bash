#!/bin/bash

az account list --query "[?isDefault].{SubscriptionName:name, SubscriptionId:id}"
az account list --query "[?isDefault]" -o tsv
az account list --query "[?isDefault].id" -o yaml

az account list --query "[?isDefault == \`false\`].name"

az account list --query "[? contains(name, 'Test')].id" -o tsv