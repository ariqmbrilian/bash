#!/bin/bash

az account list --query "[].{subscriptionId:id, name:name, isDefault:isDefault}"