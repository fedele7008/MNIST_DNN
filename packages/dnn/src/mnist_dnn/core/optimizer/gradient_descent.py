import numpy as np


class GradientDescent():

    @staticmethod
    def function(param: np.ndarray, gradient: np.ndarray, learning_rate: float) -> np.ndarray:
        return param - learning_rate * gradient
    