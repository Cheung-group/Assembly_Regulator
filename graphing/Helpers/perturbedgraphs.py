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
def perturbedgraphing (sub_type, frame_number, cut_number, abd):
    abd_matrix = [[19, 29, 39, 49, 69, 79, 89, 99],
            [26, 36, 46, 56, 76, 86, 96, 106],
            [214, 224, 234, 244, 264, 274, 284, 294],
            [273, 283, 293, 303, 323, 333, 343, 353],
            [67, 77, 87, 97, 117, 127, 137, 147],
            [0, 0, 0, 7, 27, 37, 47, 57],
            [83, 93, 103, 113, 133, 143, 153, 163],
            [0, 10, 20, 30, 50, 60, 70, 80],
            [17, 27, 37, 47, 67, 77, 87, 97],
            [71, 81, 91, 101, 121, 131, 141, 151],
            [0, 1, 11, 21, 41, 51, 61, 71],
            [48, 58, 68, 78, 98, 108, 118, 128],
            [93, 103, 113, 123, 143, 153, 163, 173],
            [10, 20, 30, 40, 60, 70, 80, 90],
            [36, 46, 56, 66, 86, 96, 106, 116]
            ]
    ind = sub_type - 1
    abdind = abd - 1
    abundance = abd_matrix[ind][abdind]
    discut = 1.05
    input_file = (r'/home/jfhase/Graphs/01_default/traj' + str(sub_type) + r'/xlms_cmc_' + str(abundance) + r'.lammpstrj')
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
        with open(r'/home/jfhase/Graphs/graphs/subunit_' + str(sub_type) + r'/abundance_' + str(abd) + '.txt', 'a') as file:
            file.write("TIMESTEP: " + str(frame))
            file.write('\n')
        with open(r'/home/jfhase/Graphs/graphs/subunit_' + str(sub_type) + r'/abundance_' + str(abd) + '.txt', 'ab') as file:
            nx.write_edgelist(G, file, data=True)