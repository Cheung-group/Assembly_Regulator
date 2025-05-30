#!/bin/bash
export PATH="/gscratch/cheung/softwares/lammps_parallel/src:$PATH"

# CONFIG
THREADS_PER_JOB=4
MAX_TOTAL_THREADS=12
MAX_JOBS=$((MAX_TOTAL_THREADS / THREADS_PER_JOB))

running_jobs=0

for mu in -11.5 -12 -12.5; do
    for traj_id in 1; do
        # Wait if we've hit max allowed parallel jobs
        if (( running_jobs >= MAX_JOBS )); then
            wait
            running_jobs=0
        fi

        echo "Launching mu = $mu, trajectory $traj_id"

        (
            # Unique run directory
            sim_dir=run_mu${mu}_traj${traj_id}
            mkdir -p "$sim_dir"
            cp mu_coeff.txt "$sim_dir/"
            cp in.xlms_toy.bak "$sim_dir/"
            cp pair_coeff_commands.txt "$sim_dir/"
	     
            cd "$sim_dir"

            # Update mu1
            sed "1s/.*/variable mu1 index $mu/" mu_coeff.txt > mu_coeff_temp.txt

            # Generate random seeds
            sedCommand=""
            for i in {1..15}; do
                randomNumber=$(shuf -i 1-100000 -n1)
                sedCommand+="s/SEED$i/$randomNumber/g;"
            done

            sed "$sedCommand" in.xlms_toy.bak > in.xlms_toy_temp.in

            # Run LAMMPS
            mpirun -np $THREADS_PER_JOB lmp_mpi -in in.xlms_toy_temp.in

            # Post-process and save results
            sed '1,2d' Snumber.dat > temp && mv temp Snumber.dat

            cp Snumber.dat ../Snumber/N_mu${mu}_traj${traj_id}.txt
            cp xlms.lammpstrj ../traj/traj_mu${mu}_traj${traj_id}.txt
            cp log.lammps ../lammps_log/log_mu${mu}_traj${traj_id}.txt
            cp energy.txt ../lammps_log/energy_mu${mu}_traj${traj_id}.txt

            cd ..
            rm -rf "$sim_dir"
        ) &  # run in background

        ((running_jobs++))
    done
done

# Final wait to catch any remaining jobs
wait

echo "All simulations completed."

