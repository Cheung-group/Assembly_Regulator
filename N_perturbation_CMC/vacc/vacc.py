import numpy as np
from scipy.spatial import cKDTree
from tqdm import tqdm
import sys

# Function to parse dump file (skipping box bounds)
def parse_lammpstrj(filename):
    frames = []          # list of coordinate arrays (N_atoms x 3)
    type_lists = []      # list of type arrays (N_atoms,)

    with open(filename) as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        if lines[i].strip() == "ITEM: TIMESTEP":
            i += 3  # Skip TIMESTEP, value, and NUMBER OF ATOMS
            n_atoms = int(lines[i].strip())
            i += 6  # Skip BOX BOUNDS and ATOMS header

            coords = []
            types = []

            for _ in range(n_atoms):
                parts = lines[i].strip().split()
                atom_type = int(parts[1])        # second column is type
                x, y, z = map(float, parts[2:5])  # next three are x, y, z
                types.append(atom_type)
                coords.append([x, y, z])
                i += 1

            frames.append(np.array(coords))
            type_lists.append(np.array(types))
        else:
            i += 1

    return frames, type_lists




# Compute accessible volume for a single frame
def compute_accessible_volume(positions, box, voxel_size, exclusion_radius):
    #Wrap positions into the box to satisfy periodic boundary assumption
    positions %= box
    # Create grid points inside the fixed box
    x = np.arange(0, box[0], voxel_size)
    y = np.arange(0, box[1], voxel_size)
    z = np.arange(0, box[2], voxel_size)
    X, Y, Z = np.meshgrid(x, y, z, indexing='ij')
    grid_points = np.vstack((X.ravel(), Y.ravel(), Z.ravel())).T

    # Fast neighbor search with periodic boundaries
    tree = cKDTree(positions, boxsize=box)
    neighbors = tree.query_ball_point(grid_points, r=exclusion_radius)

    # Count grid points with no nearby particles
    accessible_mask = np.array([len(n) == 0 for n in neighbors])
    return np.sum(accessible_mask) * voxel_size**3




# Parameters
target_type = int(sys.argv[2])
particle_radius = 0.5
insertion_radius = 0.5
exclusion_radius = particle_radius + insertion_radius  # = 1.0
voxel_size = 0.2
sample_interval = 50
n_frames_to_check = 1000
traj_file = sys.argv[1]
# Fixed box size (since it's always 20 x 20 x 20)
BOX_SIZE = np.array([20.0, 20.0, 20.0])

# Main analysis
frames, types = parse_lammpstrj(traj_file)
n_total = len(frames)
start = n_total - n_frames_to_check
sampled_indices = range(start, n_total, sample_interval)

accessible_volumes = []
type_counts = []

for idx in tqdm(sampled_indices):
    positions = frames[idx]
    types_per_frame = types[idx]
    vol = compute_accessible_volume(positions, BOX_SIZE, voxel_size, exclusion_radius)
    accessible_volumes.append(vol)

    type_count = [np.sum(t == target_type) for t in types]
    type_counts.append(type_count)

#Final Output
avg_vol = round(np.mean(accessible_volumes),1)
std_vol = round(np.std(accessible_volumes),1)
vacc_ratio = round(avg_vol / 8000, 3)
avg_counts = round(np.mean(type_counts),0)
print(avg_vol, std_vol, vacc_ratio, avg_counts)
