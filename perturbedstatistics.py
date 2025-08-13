import os
import pandas as pd
import matplotlib.pyplot as plt
from ovito.io import *
from ovito.modifiers import *
from ovito.data import *
from ovito.pipeline import *
import numpy as np
import networkx as nx
import ast
from scipy.spatial.distance import pdist, squareform
from scipy.stats import variation
import statistics
def newanalysis(sub_type, frame_number, cut_number, abd):
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
    coefflist = np.zeros([2, 201])
    basemean = 0.9591778810863715 # you get this and basecoeff from running the basestatistics script
    basecoeff = 1.8069102818895462
    ind = sub_type - 1
    abdind = abd - 1
    abundance = abd_matrix[ind][abdind]
    global_tally = np.zeros([1, 15])
    pipes = (r'/home/jfhase/Graphs/01_default/traj' + str(sub_type) + r'/xlms_cmc_' + str(abundance) + r'.lammpstrj')
    edges = (r'/home/jfhase/Graphs/graphs/subunit_' + str(sub_type) + r'/abundance_' + str(abd) + r'.txt')
    header_line = "TIMESTEP"
    pipeline = import_file(pipes, multiple_frames=True)
    with open(edges) as file:
        a = file.read()
        edgevec = a.split(header_line)
    c = 1
    for frame in range(2000, frame_number, cut_number):
        centralitylist = []
        section = str(edgevec[c])
        c += 1
        data = (pipeline).compute(frame)
        system_size = len(data.particles['Particle Identifier'])
        lines = section.splitlines()
        del(lines[0])
        G = nx.Graph()
        for n in range(len(lines)): # this loop exists to make the graph file parsable for networkx
            a = lines[n]
            parts = a.split(maxsplit=2)
            u, v = int(parts[0]), int(parts[1])
            attr_str_fixed = parts[2].replace("np.float64(", "").replace(")", "")
            attr_dict = ast.literal_eval(attr_str_fixed)
            G.add_edge(u, v, **attr_dict)
        nodes = list(G.nodes())
        b = len(nodes)
        centralities = (nx.degree_centrality(G))
        for i in range(b):
            a = data.particles['Particle Type'][nodes[i] - 1]
            hold = (centralities.get(nodes[i]))*(b-1)
            centralitylist.append(hold)
        difference = system_size - b
        for i in range(difference):
            (centralitylist).append(0)
        m = statistics.mean(centralitylist)
        y = statistics.stdev(centralitylist)
        z = y/m
        coefflist[0][c-2] = m
        coefflist[1][c-2] = z
    d = np.ones([1, 201])
    semifinalavg = np.dot(coefflist[0], d[0])
    finalavg = semifinalavg/201
    diffmean = finalavg - basemean
    semifinalcoeff = np.dot(coefflist[1], d[0])
    finalcoeff = semifinalcoeff/201
    diffcoeff = finalcoeff - basecoeff
    with open (r'/home/jfhase/Graphs/data/mean2/subunit_' + str(sub_type) + r'.txt', 'a') as file:
        file.write("Difference in mean coordination number between baseline simulation and simulation with subunit " + str(sub_type))
        file.write(" abundance of " + (str(abd_matrix[ind][abdind])))
        file.write('\n')
        file.write(str(diffmean))
        file.write('\n')    
    with open (r'/home/jfhase/Graphs/data/variation3/subunit_' + str(sub_type) + r'.txt', 'a') as file:
        file.write("Difference coefficient of variation in the coordination number between baseline simulation and simulation with subunit " + str(sub_type))
        file.write(" abundance of " + (str(abd_matrix[ind][abdind])))
        file.write('\n')
        file.write(str(diffcoeff))
        file.write('\n') 

# uncomment the following section if you wish to run the function
  
# badvec = [6, 11]
# vec = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
# for i in vec:
#     if i in badvec:
#         if i == 6:
#             for n in range(4, 9):
#                 newanalysis(i, 4010, 10, n)
#         elif i == 11:
#             for n in range(2, 9):
#                 newanalysis(i, 4010, 10, n)
#     elif i not in badvec:
#         for n in range(1, 9):
#             newanalysis(i, 4010, 10, n)