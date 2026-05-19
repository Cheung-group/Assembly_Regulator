# Graph Generation From LAMMPS Trajectories

This folder contains Python code for converting raw LAMMPS trajectories into
graph edgelist files for downstream network analysis.

## Purpose

Each sampled simulation frame is represented as an undirected graph:

- Particles are graph nodes.
- An edge is drawn between two particles when their separation is less than the
  distance cutoff.
- Edge weights are computed as `cutoff - distance`.

The resulting edgelists are consumed by the scripts in `graph_statistics/` to
measure changes in coordination number and its coefficient of variation.

## Key Files

- `basegraphing.py`: generates an edgelist for the baseline trajectory in which
  all subunits are at empirical abundance.
- `runperturbedgraphing.py`: runs graph generation in parallel across
  perturbed abundance conditions.
- `Helpers/perturbedgraphs.py`: helper function used by
  `runperturbedgraphing.py`.

## Inputs

The scripts expect LAMMPS trajectory files with particle identifiers, particle
types, and coordinates. The included paths use placeholders such as
`/home/[PATH_TO_FILE]/`; replace these with the actual trajectory and output
locations before running.

## Outputs

- Baseline graph file, for example `empirical_abundance.txt`.
- Perturbed graph files organized by subunit and abundance index, for example
  `subunit_<type>/abundance_<index>.txt`.

Each output file is split into `TIMESTEP` sections followed by NetworkX edgelist
entries.

## Important Notes

- Edgelist files only include nodes that have at least one edge. Isolated nodes
  are not written by NetworkX, so `graph_statistics/` reconstructs their zero
  coordination values from the corresponding trajectory frame.
- The distance cutoff is `1.05` reduced units in the included scripts.
- `runperturbedgraphing.py` must be configured before use. In this copy,
  `tvec` is commented out; define it or adapt the abundance-index loops before
  running.
