# Potential-Energy Processing

This directory processes LAMMPS energy output files from canonical
particle-number perturbation simulations.

## Purpose

For each subunit type, `PE.py` reads energy files for a set of perturbed
particle counts, averages the final portion of each trajectory, and writes a
per-subunit summary. `process_PE.py` then combines all available summaries and
reports changes in potential energy relative to the reference trajectory.

## Key Files

- `PE.py`: reads `energy_cmc_*.txt` files for one subunit type and writes
  `avgPE<Type>.txt`.
- `process_PE.py`: combines `avgPE*.txt` files into
  `all_processed_PE.txt`.
- `run_PE.sh`: small shell wrapper for running `PE.py` for selected subunit
  types.

## Inputs

`PE.py` expects energy files named `energy_cmc_<abundance>.txt` in the directory
configured by `data_dir`. In this copy, that path points to the original HPC
location:

```text
/mmfs1/home/jiayiw98/cheung/INO80_New_Canonical/Subtype_<type>/Energy
```

Update `data_dir` before running elsewhere.

## Outputs

- `avgPE<Type>.txt`: columns are perturbed abundance, average energy, and energy
  standard deviation.
- `all_processed_PE.txt`: combined table with columns `type`, `dN`, `dE`, and
  `dE_std`.

## Notes

- The reference values used by `process_PE.py` are `E_ref = -1.460` and
  `E_ref_std = 0.044`; update these if a different reference trajectory is used.
- The empirical particle counts are hard-coded in `N_exp_dict`.
