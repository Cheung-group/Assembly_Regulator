#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -A cheung
#SBATCH -J 14_vacc
#SBATCH -o test.o%j
#SBATCH -e test.e%j
#SBATCH -t 01:00:00

# Activate conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate N_mu_env  # Replace with your actual env name

# Set working directory
target_type=1
TRAJ_DIR="/gscratch/cheung/Smart_Jiayi/Integrative_modeling/N_mu/phi0.1/N_mu_1/traj"  # <-- Change to your actual path
OUTPUT_FILE="vacc_results.txt"

# Initialize the results file
echo "filename vacc_ratio avg_counts" > "$OUTPUT_FILE"

# Loop through all files in the directory
for traj in "$TRAJ_DIR"/*; do
    # Get filename only (strip path)
    filename=$(basename "$traj")

    # Run your Python script on the file and capture the printed output
    output=$(python vacc.py "$traj" "$target_type")

    # Append result to output file
    echo "$filename $output" >> "$OUTPUT_FILE"
done
