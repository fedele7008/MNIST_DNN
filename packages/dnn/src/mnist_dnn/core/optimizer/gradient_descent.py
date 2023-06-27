import numpy as np
from numba import jit


class GradientDescent():

    def __init__(self, learning_rate: float, *args, **kwargs):
        self.learning_rate = learning_rate


    def update(self, param: np.ndarray, grad: np.ndarray) -> None:
        param -= self.learning_rate * grad
