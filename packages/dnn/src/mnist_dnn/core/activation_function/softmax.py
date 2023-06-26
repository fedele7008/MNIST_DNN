import numpy as np


class SoftMax():

    @staticmethod
    def function(x: np.ndarray) -> np.ndarray:
        e_x = np.exp(x - np.max(x))
        return e_x / np.sum(e_x)
    

    @staticmethod
    def derivative(x: np.ndarray) -> np.ndarray:
        softmax_output = SoftMax.function(x)
        n = len(x)
        jacobian = np.zeros((n, n))

        for i in range(n):
            for j in range(n):
                if i == j:
                    jacobian[i, j] = softmax_output[i] * (1 - softmax_output[i])
                else:
                    jacobian[i, j] = -softmax_output[i] * softmax_output[j]

        return jacobian