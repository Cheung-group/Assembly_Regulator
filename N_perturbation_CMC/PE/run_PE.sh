#!/bin/bash

for type in 6
do
    echo "Running PE.py with type $type"
    python PE.py $type
done

