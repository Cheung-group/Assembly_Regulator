#!/usr/bin/env bash
rm -f mu_coeff.txt mu.txt 

mapfile -t Mu_array < newMu.txt

for k in "${!Mu_array[@]}"; do
    echo "${Mu_array[k]}" >> mu.txt
done

k=0
for i in {1..15}; do
	echo "variable mu$i index ${Mu_array[k]}" >> "mu_coeff.txt"
        k=$((k+1))
done
