import numpy as np


class Categorical_crossentropy():

    @staticmethod
    def function(y_actual, y_predict):
        delta = 1e-7
        return np.sum(y_predict * np.log(y_actual + delta))


    @staticmethod
    def derivative(y_actual, y_predict):
        return np.multiply(-1 * np.reciprocal(y_actual), y_predict)
