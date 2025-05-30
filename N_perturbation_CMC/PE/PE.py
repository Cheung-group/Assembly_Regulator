import glob
import numpy as np
import re
import os
import sys

type = int(sys.argv[1])
# Directory containing the energy files (relative or absolute)
data_dir = f"/mmfs1/home/jiayiw98/cheung/INO80_New_Canonical/Subtype_{type}/Energy"
pattern = os.path.join(data_dir, "energy_cmc_*.txt")

files = sorted(glob.glob(pattern))

with open(f"avgPE{type}.txt", "w") as out:
    for fname in files:
        number = int(re.search(r"energy_cmc_(\d+)\.txt", fname).group(1))
        with open(fname) as f:
            lines = f.readlines()[-300:]
        energies = [float(line.split()[2]) for line in lines]
        avg_energy = round(np.mean(energies), 2)
        std_energy = round(np.std(energies),2)
        out.write(f"{number} {avg_energy} {std_energy}\n")

