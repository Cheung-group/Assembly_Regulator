# Accessible-Volume Processing

This directory calculates and processes accessible volume for canonical
particle-number perturbation trajectories.

## Purpose

Accessible volume estimates the space available for insertion of a test
particle. The script samples LAMMPS trajectory frames, voxelizes the simulation
box, and uses periodic-boundary neighbor searches to identify grid points that
are not excluded by existing particles.

## Key Files

- `vacc.py`: parses a LAMMPS trajectory, computes accessible volume for sampled
  frames, and prints average volume, standard deviation, volume ratio, and
  average count for the target type.
- `vacc.slurm`: SLURM job script for running `vacc.py` over all trajectories of
  a given subunit type.
- `submit.sh`: submits one accessible-volume job for each subunit type 1-15.
- `process_data.py`: combines `vacc_results*.txt` files into
  `all_processed_vacc.txt`.

## Inputs

`vacc.slurm` expects trajectories in:

```text
/gscratch/cheung/INO80_New_Canonical/Subtype_$Type/lammps_traj
```

Update `TRAJ_DIR` before running on a new filesystem.

## Outputs

- `vacc_results<Type>.txt`: per-trajectory accessible-volume results for a
  given subunit type.
- `all_processed_vacc.txt`: combined table with columns `type`, `dN`,
  `dV_acc`, and `dV_acc_std`.

## Important Parameters

- Box size: `20.0 x 20.0 x 20.0`.
- Particle radius: `0.5`.
- Test-particle insertion radius: `0.5`.
- Voxel size: `0.2`.
- Sample interval: every 50 frames from the final 1000 frames.

## Notes

- The change in accessible volume is relative to that of a reference trajectory without particle number perturbation. The average and standard deviation of the reference accessible volumn used by `process_data.py` are `Vacc_ref = 3515.1` and
  `V_std_ref = 19.5`; update these if a different reference trajectory is used.
- The empirical particle counts are hard-coded in `N_exp_dict`.
