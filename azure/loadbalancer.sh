# /usr/bin/env bash

set -e

# variable
let "randomIdentifier=$RANDOM*$RANDOM"
location=southeastasia
resourceGroup="lb-rg-$randomIdentifier"
tag="create-vm-nlb"
vNet="vnet-lb-$randomIdentifier"
subnet="subnet-lb-$randomIdentifier"
loadBalancerPublicIp="public-ip-lb-$randomIdentifier"
loadBalancer="load-balancer-$randomIdentifier"
frontEndIp="front-end-ip-lb-$randomIdentifier"
backEndPool="back-end-pool-lb-$randomIdentifier"
probe80="port-80-health-probe-lb-$randomIdentifier"
loadBalancerRuleWeb="load-balancer-rule-port80-$randomIdentifier"
loadBalancerRuleSSH="load-balancer-rule-port22-$randomIdentifier"
networkSecurityGroup="network-security-group-lb-$randomIdentifier"
networkSecurityGroupRuleSSH="network-security-rule-port22-lb-$randomIdentifier"
networkSecurityGroupRuleWeb="network-security-rule-port80-lb-$randomIdentifier"
nic="nic-lb-$randomIdentifier"
availabilitySet="availability-set-lb-$randomIdentifier"
vm="vm-lb-$randomIdentifier"
image="UbuntuLTS"
ipSku="Standard"
login="azueruser"


# create resource group
echo "Creating $resourceGroup in "$location"..."
az group create --name $resourceGroup --location "$location" --tags $tags

# create a virtual network and a subnet
echo "Creating"
az network vnet create --resource-group $resourceGroup --location "$location" --name $vNet --subnet-name $subnet

# create a public IP address for load balancer
echo "Creating $loadBalancerPublicIp"
az network public-ip create --resource-group $resourceGroup --name $loadBalancerPublicIp

# create an Azure Load Balancer
echo "Creating $loadBalancer with $frontEndIp and $backendPool"
az network lb create --resource-group $resourceGroup --name $loadBalancer --public-ip-address $loadBalancerPublicIp --frontend-ip-name $frontEndIp --backend-pool-name $backEndPool

# create and LB probe on port 80
echo "Creating $probe80 in $loadBalancer"
az network lb probe create --resource-group $resourceGroup --lb-name $loadBalancer --name $probe80 --protocol tcp --port 80

# crea an LB rule for port 80
echo "Creating $loadBalancerRuleWeb for $loadBalancer"
az network lb rule create --resource-group $resourceGroup --lb-name $loadBalancer --name $loadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $frontEndIp --backend-pool-name $backEndPool --probe-name $probe80

# create three NAT rules for port 22
echo "Create three NAT fules named $loadBalancerRuleSSH"
for i in `seq 1 3`; do
    az network lb inbound-nat-rule create --resource-group $resourceGroup --lb-name $loadBalancer --name $loadBalancerRuleSSH$i --protocol tcp --frontend-port 422$i --backend-port 22 --frontend-ip-name $frontEndIp
done

# create a network security group
echo "Creating $networkSecurityGroup"
az network nsg create --resource-group $resourceGroup --name $networkSecurityGroup

# create a network security group rule for port 22
echo "Creating $networkSecurityGroupRuleSSH in $networkSecurityGroup for port 22"
az network nsg rule create --resource-group $resourceGroup --nsg-name $networkSecurityGroup --name $networkSecurityGroupRuleSSH --protocol tcp --direction inbound --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 22 --access allow --priority 1000

# create a network security group rule for port 80
echo "Creating $networkSecurityGroupRuleWeb in $networkSecurityGroup for port 80"
az network nsg rule create --resource-group $resourceGroup --nsg-name $networkSecurityGroup --name $networkSecurityGroupRuleWeb --protocol tcp --direction inbound --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 --access allow --priority 2000

# create three virtual network cards and associate with public IP address and NSG
echo "Creating three NICS named $nic for $vNet and $subnet"
for i in `seq 1 3`; do
    az network nic create --resource-group $resourceGroup --name $nic$i --vnet-name $vNet --subnet $subnet --network-security-group $networkSecurityGroup --lb-name $loadBalancer --lb-address-pools $backEndPool --lb-inbound-nat-rules $loadBalancerRuleSSH$i
done

# create a availability set
echo "Creating $availabilitySet"
az vm availability-set create --resource-group $resourceGroup --name $availabilitySet --platform-fault-domain-count 1 --platform-update-domain-count 1


# create three virtual machines, this creates SSH keys if not present
echo "Creating three VMs named $vm with $nic using $image"
for i in `seq 1 3`; do
    az vm create --resource-group $resourceGroup --name $vm$i --availability-set $availabilitySet --nics $nic$i --image $image --public-ip-sku $ipSku --admin-username $login --generate-ssh-keys --no-wait
done 

# list the virtual machines
az vm list --resource-group $resourceGroup
