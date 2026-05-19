# Chemical-Potential Convergence

This directory contains examples for determining chemical potentials of INO80
subunits from empirical abundance targets.

## Purpose

After interaction energies have been inferred, each subunit can be connected to
a particle reservoir one at a time while the other subunit counts remain fixed.
The chemical potential of the investigated subunit is iteratively updated until
its simulated particle number matches the empirical abundance target, or until
it is classified as divergent because convergence cannot be reached.

## Contents

- `INO80_miu_1/`: complete example for subunit type 1.

To run the same workflow for subunits 2 through 15, copy or adapt the example
directory and update the investigated subunit type in:

- `newMu.m`: set `module` to the target subunit type.
- `in.xlms_toy.bak`: ensure only the investigated subunit is allowed to
  exchange particles with the reservoir in the relevant LAMMPS `fix` command.

## Inputs From Upstream Steps

- Inferred pair interaction energies from `Int_convergence/`.

## Notes

- The included example is configured for volume fraction `phi=0.05` in
  `newMu.m`; update this value when analyzing other crowding conditions.
- The workflow uses MATLAB for chemical-potential updates and LAMMPS for
  simulation.
