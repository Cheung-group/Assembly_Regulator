#!/bin/bash
input="xlms.lammpstrj"
output="equil"

# Use a loop for the consistent 1 to 15 set.
for n in {1..15}
do
    outFileName="${output}${n}.txt"
    awk -v n="$n" 'BEGIN{b=0; t=0}{a+=1; if($2=="TIMESTEP") b = a; if((a==(b+1)) && ($1>=5000)) t=$1; if(a==(b+3)&&(t>=5000)) print "0""\t"$1"\t"0"\t"0"\t"0; if((a>=(b+9))&&(t!=0)&&($2==n)) print t"\t"$2"\t"$3"\t"$4"\t"$5 }'  $input > $outFileName
    wait 
done
