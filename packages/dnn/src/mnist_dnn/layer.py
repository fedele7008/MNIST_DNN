"""
Layer module provides Dense layer for user to setup.
"""

import numpy as np
from numba import jit

import mnist_dnn.core.layer as core_layer


class Dense(core_layer._Layer):
    """
    Dense class provides implemented features for both Dendrite and Activation layers combined.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        TODO
    """

    def __init__(self, nodes: int, activation: str, input_nodes: (int | None) = None):
        """
        Constructor for Dense class.

        Args:
            * 'nodes' is number of nodes in the dense layer.
            * 'activation' is the name of activation function.
            * 'input_nodes' is number of input nodes in the dense layer. (conditional use)
        
        Return:
            <N/A>

        Requires:
            * 'nodes' must be greater than 0
        """

        # Initialize base layer
        try:
            super().__init__(nodes)
        except Exception as e:
            raise e
        
        # Internal layer attributes
        self.dendrite_layer = core_layer.Dendrite(nodes)
        self.activation_layer = core_layer.Activation(nodes)
        self.input_size = input_nodes
        self.activation_function = activation

        # Additional Indicators
        self._is_compiled = False


    def compile(self, input_size: int, learning_rate: float, optimizer: str, *optimizer_param, **kw_optimizer_param):
        try:
            self.dendrite_layer.compile(input_size, optimizer, learning_rate, optimizer_param, kw_optimizer_param)
            self.activation_layer.compile(self.size, self.activation_function)
        except Exception as e:
            raise e


    def forward(self, X: np.ndarray) -> np.ndarray:
        Z = self.dendrite_layer.forward(X)
        Y = self.activation_layer.forward(Z)

        self.input = X
        self.output = Y

        return self.output


    def backward(self, dY: np.ndarray) -> np.ndarray:
        dZ = self.activation_layer.backward(dY)
        dX = self.dendrite_layer.backward(dZ)

        return dX


    def update(self) -> None:
        self.dendrite_layer.update()
        self.activation_layer.update()
