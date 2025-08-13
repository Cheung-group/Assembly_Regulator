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
import statistics
def basequantities(frame_number, cut_number):
    coefflist = np.zeros([2, 201])
    pipes = (r'/home/[PATH_TO_FILE]/INO80_phi0.1_CMC.lammpstrj')
    edges = (r'/home/[PATH_TO_FILE]/empirical_abundance.txt')
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
        for n in range(len(lines)): # this sectione exists to make the graph file parsable for networkx
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
            (centralitylist).append(hold)
        difference = system_size - b
        for i in range(difference):
            (centralitylist).append(0)
        a = statistics.mean(centralitylist)
        b = statistics.stdev(centralitylist)
        coefflist[0][c-2] = a
        coefflist[1][c-2] = b/a
    d = np.ones([1, 201])
    semifinalavg = np.dot(coefflist[0], d[0])
    finalavg = semifinalavg/201
    semifinalcoeff = np.dot(coefflist[1], d[0])
    finalcoeff = semifinalcoeff/201
    print("basemean is equal to " + str(finalavg))
    print("basecoeff is equal to " + str(finalcoeff))
# uncomment this to run the code
#basequantities(4010, 10)
