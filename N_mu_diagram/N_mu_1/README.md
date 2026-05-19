# N-mu Scan Example: Subunit 1

This directory runs particle-number versus chemical-potential scans for INO80
subunit type 1.

## Purpose

For each chemical potential in `run.sh`, the workflow launches a LAMMPS
simulation, records the particle-number trajectory, and archives the resulting
LAMMPS trajectory, log, and energy output. These outputs can be used to plot the
subunit's abundance response as a function of chemical potential.

## Key Files

- `run.sh`: launches one or more simulations for the configured chemical
  potentials and trajectory IDs.
- `run_muCalc.slurm`: SLURM wrapper that runs `run.sh`.
- `run_vacc.slurm`: SLURM wrapper reserved for accessible-volume jobs when used
  with downstream analysis.
- `mu_coeff.txt`: chemical-potential input in LAMMPS variable format.
- `pair_coeff_commands.txt`: pair interaction-energy commands in LAMMPS format.
- `in.xlms_toy.bak`: LAMMPS input template.

## Expected Output Directories

- `Snumber/`: particle-number time series, named by chemical potential and
  trajectory ID.
- `traj/`: LAMMPS trajectories.
- `lammps_log/`: LAMMPS logs and energy outputs.

Create these directories before running if they are absent.

## Running

```bash
sbatch run_muCalc.slurm
```

The default `run.sh` samples the chemical potentials listed in its `for mu in`
loop. It creates a temporary run directory for each condition, replaces random
seed placeholders in `in.xlms_toy.bak`, runs LAMMPS, copies outputs into the
collection directories, and removes the temporary run directory.

## Adapting the Scan

- Edit the `for mu in ...` loop in `run.sh` to change sampled chemical
  potentials.
- Edit the `traj_id` loop to run multiple independent trajectories per
  chemical potential.
- For a different subunit, update both the `sed` command that edits
  `mu_coeff.txt` and the LAMMPS exchange settings in `in.xlms_toy.bak`.
