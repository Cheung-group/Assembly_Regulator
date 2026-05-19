# INO80 Assembly Modeling Code

Author: Jiayi Wang  
Last updated: May 2026

This repository contains the core analysis and simulation code used for the study
**"Physical principles of building protein megacomplexes in a crowded milieu"**.
The project models the assembly of the yeast INO80 chromatin-remodeling complex in a
crowded, cell-like environments using coarse-grained statistical mechanics and
experimental data, such as protein abundance and cross-linking mass spectrometry.

## Study Overview

The workflow represents each protein in the INO80 complex as a coarse-grained bead and uses
Grand Canonical Monte Carlo (GCMC) simulations to infer the parameters and physical principles that govern
assembly:

1. Infer subunit-subunit interaction energies from cross-linking contact
   intensities.
2. Infer subunit chemical potentials from empirical relative abundances.
3. Classify subunits as convergent or divergent based on whether abundance
   converges in a grand-canonical reservoir setting.
4. Map particle number versus chemical potential for selected subunits.
5. Perturb particle numbers in canonical simulations to quantify changes in
   accessible volume, potential energy, and network structure.

## Repository Structure

- `Int_convergence/`: inverse determination of pair interaction energies from
  cross-linking-derived contact frequencies.
- `Mu_convergence/`: inverse determination of chemical potentials for individual
  subunits while other subunit counts are fixed.
- `N_mu_diagram/`: scans of particle number as a function of chemical potential.
- `N_perturbation_CMC/`: canonical particle-number perturbation analyses,
  including accessible volume and potential energy processing.
- `graphing/`: conversion of LAMMPS trajectories into graph edgelists.
- `graph_statistics/`: analysis of graph-derived coordination statistics.

## Main Requirements

The scripts are intended for an HPC environment and assume access to:

- LAMMPS with MPI support (`lmp_mpi`).
- MATLAB for iterative parameter updates and contact analysis.
- Python 3 with `numpy`, `pandas`, `scipy`, `networkx`, `ovito`, `matplotlib`,
  and `tqdm` as needed by the analysis scripts.
- A SLURM scheduler for the included `.slurm` submission scripts.

Several scripts contain absolute paths from the original compute environment
such as `/gscratch/...`, `/mmfs1/...`, or `/home/[PATH_TO_FILE]/`. Update these
paths before running the code in a new location.

## Suggested Workflow

1. Run `Int_convergence/` to infer pair interaction energies.
2. Use the inferred interactions in `Mu_convergence/` to determine chemical
   potentials for each subunit.
3. Use `N_mu_diagram/` to examine particle-number response over chemical
   potential scans.
4. Use canonical perturbation trajectories with `N_perturbation_CMC/` to quantify the systemic thermodynamic effects of subunit particle number perturbation. 
5. Use canonical perturbation trajectories with `graphing/`, and `graph_statistics/` to quantify the change in protein-protein interaction network induced by subunit abundance perturbation.

Each subdirectory contains a README with more specific inputs, outputs, and
execution notes.
