#!/usr/bin/env bash
mapfile -t Int_array < Int.txt

k=0
for i in {1..15}; do
  for ((j=i; j<=15; j++)); do
    type1=$i
    type2=$j
    echo "pair_coeff $type1 $type2 \${E_rep} ${Int_array[k]}" >> "pair_coeff_commands.txt"
    k=$((k+1))
  done
done

