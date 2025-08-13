This folder contains the code for analyzing the network structure of the graphs that are made with the code contained in the 'graphing' folder. 
basestatistics will give you the frame-averaged mean and coefficient of variation in degree centrality for the graph that corresponds to the simulation in which all 
subunits are kept at their empirical abundances. These two quantities correspond to "basemean" and "basecoeff" variables in the newanalysis function, respectively.
Once those values have been input to the newanalysis function (this has already been done here), running said function will do the following:
  1. First, it will calculate the frame-averaged mean and coefficient of variation in degree centrality for the graph that corresponds to a simulation
     in which subunit 1 has had its abundance reduced by 40 compared to the empirical level
  2. Then, it will subtract from these quantities the values of the basemean and basecoeff, respectively. 
  3. After that, it will write the values of these differences in their corresponding text files, along with appropriate labeling
  4. The function will then perform this procedure for all 15 subunits over all applicable perturbation values
