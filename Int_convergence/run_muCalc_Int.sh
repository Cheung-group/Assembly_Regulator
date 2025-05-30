#!/bin/bash

export PATH="/gscratch/cheung/softwares/lammps_parallel/src:$PATH"

n="0"
tol="0.05"

#initialize the cond value
cond="1"

while [ $cond -eq 1 ] && [ $n -lt 30 ]
do
	n=$[$n+1]

#read interaction strength from the previous iteration's newInt.m output (newInt.txt) or a prepared newInt.txt file. Outputs include Int.txt and pair_coeff_commands.txt for lammps input file
	./coeff.sh
	cp Int.txt ./iterations/Int$n.txt


	#generate random SEED number and repplace SEED in lammps input file
	sedCommand=""
	for i in {1..15}; do
    		randomNumber=$(shuf -i 1-10000 -n1)
   	        sedCommand+="s/SEED$i/$randomNumber/g;"
	done
	sed "$sedCommand" "in.xlms_toy.bak" > "in.xlms_toy"

	echo "****************************************************"
	echo "				running iteration $n"
	echo "****************************************************"

	mpirun -np 6 lmp_mpi -in in.xlms_toy
	wait

	sed "1d"  Snumber.dat > temp
	sed "1d" temp > Snumber.dat
	rm temp

	./create_input_for_ContactN.sh
        matlab -nodesktop < ContactN.m 
	matlab -nodesktop < new_Int.m
	wait 
        
	mv xlms.lammpstrj lammps_traj/xlms_$n.lammpstrj
        mv log.lammps lammps_log/log_$n.lammps
        mv avg_contactN.txt iterations/contactN_$n.txt

	e=$(<error.txt)
	#e_max=$(<error_max.txt)
	if (( $(bc <<<"$e > $tol") )); then
        	cond="1"
        	echo "error = $e is greater than tolerance"
	else
        	cond="0"
        	echo "tolerance met"
	fi
	
#	echo "$e" > ./iterations/error_max$n.txt
        mv error.txt ./iterations/error_$n.txt
	
done
