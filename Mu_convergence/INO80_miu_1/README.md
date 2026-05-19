# Individual Chemical-Potential Example: Subunit 1

This directory is a working example for inversely determining the chemical
potential of one INO80 subunit while keeping all other subunit particle numbers
fixed. In this copy, the investigated subunit is type 1.

## Purpose

The workflow runs repeated grand-canonical Monte Carlo simulations in which only
the selected subunit exchanges particles with a reservoir. After each simulation,
MATLAB reads the sampled particle numbers, compares the mean count with the
empirical target, and writes an updated chemical potential for the next
iteration.

## Key Files

- `Int.txt`: fixed interaction energies from the interaction-convergence step.
- `coeff_Int.sh`: converts `Int.txt` into LAMMPS `pair_coeff` commands.
- `newMu.txt`: current chemical-potential vector.
- `coeff_mu.sh`: converts `newMu.txt` into `mu_coeff.txt` and `mu.txt`.
- `newMu.m`: MATLAB update script for the selected subunit.
- `in.xlms_toy.bak`: LAMMPS input template.
- `run_muCalc.sh`: main iterative driver script.
- `run_muCalc.slurm`: SLURM submission script.

## Generated Outputs

- `mu.txt` and `mu_coeff.txt`: chemical potentials used in the current
  iteration.
- `N.txt`: mean particle numbers from the current iteration.
- `error.txt`: relative error for the investigated subunit.
- `iterations/`: archived chemical potentials, particle numbers, and errors.
- `Snumber/`: archived particle-number time series.
- `lammps_traj/`: archived trajectories.
- `lammps_log/`: archived LAMMPS logs.

Create the output directories above before running if they are not already
present.

## Running

```bash
sbatch run_muCalc.slurm
```

or, on a configured compute node:

```bash
./run_muCalc.sh
```

The driver starts from the current `newMu.txt`, runs up to 50 iterations, and
stops early when the relative error is below the tolerance set in
`run_muCalc.sh` (`tol=0.01` in this copy).

## Adapting to Another Subunit

1. Change `module = [1]` in `newMu.m` to the desired subunit type.
2. Update `in.xlms_toy.bak` so that only the same subunit type exchanges with
   the reservoir.
3. Replace or reset `newMu.txt` as needed.
4. Confirm that `Int.txt` contains the interaction-energy set intended for the
   study condition.
