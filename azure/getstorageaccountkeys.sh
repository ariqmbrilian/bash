storageAccount=$(az storage account list --query "[? contains(name, 'bash')].name" -o tsv)
resourceGroup=$(az storage account show -n $storageAccount --query "resourceGroup" -o tsv)
accountKey=$(az storage account keys list -g $resourceGroup --account-name $storageAccount --query "[0].value" -o tsv)