#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -A cheung
#SBATCH -t 5:00:00

### SBATCH -J vacc
### SBATCH -o vacc.o%j
### SBATCH -e vacc.e%j


# Activate conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate N_mu_env  # Replace with your actual env name

# Set working directory
TRAJ_DIR="/gscratch/cheung/INO80_New_Canonical/Subtype_$Type/lammps_traj"
OUTPUT_FILE="vacc_results$Type.txt"

# Initialize the results file
echo "filename abd avg_vacc std_vacc vacc_ratio avg_counts" > "$OUTPUT_FILE"

# Loop through all files in the directory
for traj in "$TRAJ_DIR"/*; do
    filename=$(basename "$traj")
    number=$(echo "$filename" | grep -o '[0-9]\+')
    output=$(python vacc.py "$traj" "$Type")
    echo "$filename $number $output" >> "$OUTPUT_FILE"
done

