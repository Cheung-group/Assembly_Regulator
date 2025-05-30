#!/bin/bash
#SBATCH -n 12
#SBATCH -N 1
#SBATCH -A cheung
#SBATCH -J 1_0.1
#SBATCH -o test.o%j
#SBATCH -e test.e%j
#SBATCH -t 2-00:00:00
###SBATCH -p gpu

module load ompi/4.1.4
./run.sh
