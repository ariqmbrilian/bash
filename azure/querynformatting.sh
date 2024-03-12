#!/bin/bash

az account show --query [user.name,user.type] -o tsv
az account show --query name