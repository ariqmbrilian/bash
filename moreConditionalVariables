#!/bin/bash

read SCA
read EQU
read ISO

if [[ $SCA -eq $EQU && $SCA -eq $ISO  ]];then 
echo EQUILATERAL
elif [[ $SCA -eq $EQU || $SCA -eq $ISO || $ISO -eq $EQU ]];then 
echo ISOSCELES
else
echo SCALENE
fi
