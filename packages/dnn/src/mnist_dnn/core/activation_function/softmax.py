import numpy as np


class SoftMax():

    @staticmethod
    def function(x: np.ndarray) -> np.ndarray:
        e_x = np.exp(x - np.max(x))
        return e_x / np.sum(e_x)
    

    @staticmethod
    def derivative(x: np.ndarray) -> np.ndarray:
        softmax_output = SoftMax.function(x)
        return softmax_output * (1 - softmax_output)
    