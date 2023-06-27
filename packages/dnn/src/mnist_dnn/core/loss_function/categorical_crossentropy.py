import numpy as np
from numba import jit 


class Categorical_crossentropy():

    @staticmethod
    @jit(nopython=True)
    def function(y_actual, y_predict):
        # Avoid division by zero
        epsilon = 1e-12
        y_predict = np.clip(y_predict, epsilon, 1.0 - epsilon)
        
        # Compute cross entropy loss
        loss = -np.sum(y_actual * np.log(y_predict))
        
        return loss


    @staticmethod
    @jit(nopython=True)
    def derivative(y_actual, y_predict):
        # Avoid division by zero
        epsilon = 1e-12
        y_predict = np.clip(y_predict, epsilon, 1.0 - epsilon)
        
        # Compute derivative
        derivative = -(y_actual / y_predict)
        
        return derivative
