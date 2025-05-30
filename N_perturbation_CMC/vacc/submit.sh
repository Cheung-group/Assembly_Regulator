#!/bin/bash

# Submit jobs for Type = 1 to 15
for Type in {1..15}; do
    sbatch --export=Type=$Type \
           --job-name=vacc_$Type \
           --output=vacc_$Type.o \
           --error=vacc_$Type.e \
           vacc.slurm
done

