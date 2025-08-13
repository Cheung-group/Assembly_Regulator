This folder contains the code necessary for generating graph files from the raw simulation trajectories. 
It is important to note that these files are edgelist files, and will therefore only contain those nodes that have been assigned edges. Nodes with no edges will not
be written to file. 
The basegraphing script takes as its input the trajectory file corresponding to the simulation in which all subunits are at their empirical abundances. 
For each sampled frame, basegraphing will do the following:
   1. First, it will initialize an empty graph for that frame
   2. Then, it will assign every subunit in the frame a corresponding node in that graph
   3. After that, it will calculate the pairwise distances between all subunits
   4. If any two subunits are separated by a distance equal to or less than 1.05 reduced units, then an edge will be drawn between their corresponding nodes
   5. At the end of this procedure, it writes the graph's edgelist to the corresponding text file, along with appropriate labeling

runperturbedgraphing will use pool to perform this same procedure in parallel for all applicable perturbation values of a given subunit, one subunit at a time

