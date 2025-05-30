#!/bin/bash

export PATH="/gscratch/cheung/softwares/lammps_parallel/src:$PATH"

rm -f Snumber.dat log.lammps in.xlms_toy mu.txt error.txt

n="5"
tol="0.01"
cond="1"

while [ $cond -eq 1 ] && [ $n -lt 50 ]
do
	n=$[$n+1]
        ./coeff_mu.sh
	cp mu.txt ./iterations/mu$n.txt

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

	matlab -nodesktop < newMu.m
	wait 

	e=$(<error.txt)
	if (( $(bc <<<"$e > $tol") )); then
        	cond="1"
        	echo "error = $e is greater than tolerance"
	else
        	cond="0"
        	echo "tolerance met"
	fi
	
	echo "$e" > ./iterations/error$n.txt
	
	cp xlms.lammpstrj lammps_traj/xlms_$n.lammpstrj
        cp log.lammps lammps_log/log_$n.lammps
        cp N.txt iterations/N_$n.txt
	cp Snumber.dat Snumber/Snumber_$n.dat
done
