#!/bin/bash
#SBATCH -n 6
#SBATCH -N 1
#SBATCH -A cheung
#SBATCH -J phi0.1
#SBATCH -o output.o%j
#SBATCH -e error.e%j
#SBATCH -t 7-00:00:00
###SBATCH -p gpu

module load ompi/4.1.4
module load matlab/r2023a
./run_muCalc_Int.sh
