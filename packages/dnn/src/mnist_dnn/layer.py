"""
Layer module provides Dense layer for user to setup.
"""

import numpy as np

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


    def compile(self, input_size: int, output_size: int, learning_rate: float):
        try:
            self.dendrite_layer.compile(input_size, output_size, learning_rate)
            self.activation_layer.compile(input_size, output_size, self.activation_function)
        except Exception as e:
            raise e


    def forward(self, X: np.ndarray) -> np.ndarray:
        pass


    def backward(self, dY: np.ndarray) -> np.ndarray:
        pass


    def update(self) -> None:
        pass
    