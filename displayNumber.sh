#!/bin/bash

## Print number 1-100
for i in {1..100}; do echo "This is number $i"; done

## Print number 1-100 with odd pattern
for i in {1..100..1}; do echo "This is number $i"; done

## Print number 1-100 with even pattern
for i in {1..100..2}; do echo "This is number $i"; done

## Invinite loop
while true; do echo "Unable to stop"; done  