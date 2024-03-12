#!/bin/bash

resourceGroup="999SMGO"
listVM=($(az vm list -g "$resourceGroup" --query "[].name" -o tsv))

TIMEFORMAT='It took %R seconds.'
time {
list() {
    echo "List of VMs in resource group '$resourceGroup':"
    for list in "${listVM[@]}"; do
        echo "$list"
    done
}

start() {
    echo Starting all VMs in resource group "$resourceGroup"
    for list in "${listVM[@]}"; do
        az vm start -g "$resourceGroup" -n "$list" &
    done
    wait
}

stop() {
    echo Stopping all VMs in resource group "$resourceGroup"
    for list in "${listVM[@]}"; do 
        az vm stop -g "$resourceGroup" -n "$list" &
    done
    wait
}

case $1 in
        "list")
                list
                ;;
        "start")
                start
                ;;
        "stop")
                stop
                ;;
        *)
                echo "Usage: $0 [start|stop|list]"
                exit 1
esac
}