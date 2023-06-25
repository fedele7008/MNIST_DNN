import numpy as np


class ReLu():

    @staticmethod
    def function(x: np.ndarray) -> np.ndarray:
        return np.maximum(0, x)
    

    @staticmethod
    def derivative(x: np.ndarray) -> np.ndarray:
        return np.where(x > 0, 1, 0)
