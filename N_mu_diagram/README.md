# Particle Number versus Chemical Potential

This directory contains simulations used to map each selected subunit's particle
number response across a range of chemical potentials.

## Purpose

The particle-number versus chemical-potential scans help diagnose convergent,
divergent, and critical behavior in the reservoir-coupled INO80 model. In the
study, these curves were used to understand why some subunits fail to converge
to their empirical abundance in a grand-canonical setting.

## Contents

- `N_mu_1/`: example scan configured for subunit type 1.

Only the subunit-1 example is included here. To run scans for other subunits,
copy or adapt the example and update:

- `run.sh`: change which line of `mu_coeff.txt` is overwritten by each sampled
  chemical potential.
- `in.xlms_toy.bak`: allow particle exchange only for the investigated subunit
  in the LAMMPS `fix` commands.
- The sampled chemical-potential values and trajectory counts in `run.sh`.

## Outputs

The example writes particle-number time series, trajectories, logs, and energy
files into subdirectories under `N_mu_1/`.

## Notes

- The included scripts assume an MPI-enabled LAMMPS executable and a SLURM/HPC
  environment.
- Update hard-coded LAMMPS paths before running on a new machine.
