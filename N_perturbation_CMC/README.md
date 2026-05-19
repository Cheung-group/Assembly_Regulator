# Canonical Particle-Number Perturbation Analysis

This directory contains post-processing code for canonical Monte Carlo
trajectories in which one INO80 subunit count is perturbed away from its
empirical value.

## Purpose

Particle-number perturbation is used to quantify how each subunit contributes to
the assembled system. The analyses compare perturbed trajectories with a
reference canonical trajectory and report changes in:

- Accessible volume available to an inserted test particle.
- Potential energy from LAMMPS energy outputs.

These measurements support the thermodynamic analysis of divergent and
convergent subunits.

## Subdirectories

- `vacc/`: accessible-volume calculation and processing.
- `PE/`: potential-energy averaging and processing.

## General Workflow

1. Generate canonical trajectories for each perturbed subunit count.
2. Run the accessible-volume scripts in `vacc/` on the trajectory files.
3. Run the potential-energy scripts in `PE/` on LAMMPS energy output files.
4. Run each subdirectory's processing script to combine per-subunit results and
   express values relative to the reference trajectory.

## Notes

- Several scripts contain original HPC paths; update them before running.
- Perturbation values are encoded as particle counts in filenames and are later
  converted to particle-number differences using the empirical count dictionary
  in the processing scripts.
