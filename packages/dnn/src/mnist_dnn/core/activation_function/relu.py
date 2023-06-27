import numpy as np
from numba import jit


class ReLu():

    @staticmethod
    @jit(nopython=True)
    def function(x: np.ndarray) -> np.ndarray:
        return np.maximum(0, x)
    

    @staticmethod
    @jit(nopython=True)
    def derivative(x: np.ndarray) -> np.ndarray:
        return np.diag(np.where(x > 0, 1, 0))
