# Interaction-Energy Convergence

This directory contains the inverse-statistical workflow for determining INO80
subunit-subunit interaction energies from cross-linking-derived contact
frequencies in a canonical ensemble.

## Purpose

The scripts iteratively adjust Lennard-Jones attractive interaction energies so
that simulated contact intensities reproduce empirical contact intensities
inferred from cross-linking mass spectrometry. The resulting interaction
energies are used by the downstream chemical-potential and assembly simulations.

## Key Files

- `contact_exp.txt`: empirical contact intensities used as the target values.
- `newInt.txt`: current interaction-energy vector. This is usually initialized
  to zeros and updated after each iteration.
- `coeff.sh`: converts `newInt.txt` into `Int.txt` and
  `pair_coeff_commands.txt` in LAMMPS input format.
- `in.xlms_toy.bak`: LAMMPS input template. Random seed placeholders are
  replaced at each iteration to produce `in.xlms_toy`.
- `run_muCalc_Int.sh`: main iterative driver script.
- `run_muCalc.slurm`: SLURM submission script for the workflow.
- `create_input_for_ContactN.sh`: prepares per-subunit trajectory files for
  MATLAB contact analysis.
- `ContactN.m`: computes simulated contact intensities from the trajectory.
- `new_Int.m`: updates interaction energies using the covariance-based inverse
  statistical update.

## Generated Outputs

- `Int.txt`: interaction energies used in the current iteration.
- `pair_coeff_commands.txt`: LAMMPS `pair_coeff` commands.
- `avg_contactN.txt`: simulated average contact intensities.
- `error.txt`: current aggregate contact error.
- `error_max.txt`: maximum relative contact error.
- `iterations/`: archived interaction vectors, contact values, and errors.
- `lammps_traj/`: archived LAMMPS trajectory files.
- `lammps_log/`: archived LAMMPS log files.

Create the output directories above before running if they are not already
present in the working copy.

## Running

Submit the SLURM script or run the driver directly on a configured HPC node:

```bash
sbatch run_muCalc.slurm
```

or

```bash
./run_muCalc_Int.sh
```

The driver runs up to 30 iterations and stops early when the aggregate error is
below the tolerance set in `run_muCalc_Int.sh` (`tol=0.05` in this copy).

## Notes

- The script expects `lmp_mpi`, `mpirun`, `matlab`, `bc`, and standard Unix
  tools to be available.
- `run_muCalc_Int.sh` prepends the original LAMMPS build path to `PATH`; update
  that path for a new machine.
- `new_Int.m` updates only the cross-linked pairs listed in
  `cross_linked_pairs`; non-cross-linked attractive interactions remain fixed.
