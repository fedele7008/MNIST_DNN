import numpy as np

class One_hot():
    def encode(y, size):
        return np.array([np.eye(10)[i] for i in y])