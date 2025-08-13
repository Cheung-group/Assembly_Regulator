import os
import pandas as pd
import matplotlib.pyplot as plt
from ovito.io import *
from ovito.modifiers import *
from ovito.data import *
from ovito.pipeline import *
import numpy as np
import networkx as nx
from scipy.spatial.distance import pdist, squareform
def basegraphing(frame_number, cut_number):
    discut = 1.05
    input_file = (r'/home/[PATH_TO_FILE]/INO80_phi0.1_CMC.lammpstrj')
    pipeline = import_file(input_file, multiple_frames = True)
    for frame in range(2000, frame_number, cut_number):
        data = pipeline.compute(frame)
        G = nx.Graph()
        number = len(data.particles['Particle Identifier'])
        coordinates = np.zeros([number, (3*number)])
        codevec = ['Position.X', 'Position.Y', 'Position.Z']
        type_count = np.zeros([1, 15])
        for n in range(number):
                type_count[0][(data.particles['Particle Type'][n]) - 1] += 1
                G.add_node(data.particles['Particle Identifier'][n])
                for r in range(3):
                    coordinates[n][r] = data.particles[codevec[r]][n]
        distances = squareform(pdist(coordinates))
        for n in range(number):
            for j in range(n+1, number):
                if distances[n, j] < discut:
                    G.add_edge(
                        data.particles['Particle Identifier'][n],
                        data.particles['Particle Identifier'][j],
                        weight = (discut - distances[n, j]))
        with open(r'/home/[PATH_TO_FILE]/empirical_abundance.txt', 'a') as file:
            file.write("TIMESTEP: " + str(frame))
            file.write('\n')
        with open(r'/home/[PATH_TO_FILE]/empirical_abundance.txt', 'ab') as file:
            nx.write_edgelist(G, file, data=True)
#uncomment this to run the script
#basegraphing(4010, 10)
