from ovito.io import *
from ovito.modifiers import *
from ovito.data import *
from ovito.pipeline import *
import numpy as np
from multiprocessing import Pool
from Helpers.perturbedgraphs import perturbedgraphing
svec = [4, 5, 6, 7, 8]
evec = [2, 3, 4, 5, 6, 7, 8]
#tvec = [1, 2, 3, 6]
badvec = [6, 11]
numvec = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
for i in numvec:
    if i not in badvec:
        if __name__=='__main__':
            args_list = [(i, 4010, 10, j) for j in tvec]
            with Pool() as pool:
                pool.starmap(perturbedgraphing, args_list)
    elif i in badvec:
        if __name__== '__main__':
            if i == 6:
                args_list = [(i, 4010, 10, j) for j in svec]
                with Pool() as pool:
                    pool.starmap(perturbedgraphing, args_list)
            elif i == 11:
                args_list = [(i, 4010, 10, j) for j in evec]
                with Pool() as pool:
                    pool.starmap(perturbedgraphing, args_list)

