#!/bin/bash
#SBATCH -n 6
#SBATCH -N 1
#SBATCH -A cheung
#SBATCH -J test
#SBATCH -o test.o%j
#SBATCH -e test.e%j
#SBATCH -t 5-00:00:00
###SBATCH -p gpu

module load ompi/4.1.4
module load matlab/r2023a
./run_muCalc.sh
