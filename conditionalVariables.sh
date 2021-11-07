#!/bin/bash

read fVariable
read sVariable

if [[ "$fVariable" == 'n' || "$fVariable" == 'N' ]]; then
    echo "NO"
else
    echo "YES"
fi
