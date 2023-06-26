"""
activation module defines _activation layer class.
"""

import numpy as np

from mnist_dnn.core.layer.base import _Layer


class _Activation(_Layer):
    """
    Activation class is partial dense layer of DNN where it computes activation function.
    _Activation class is internal layer of Dense Layer that encapsulates _Dendrite and _Activation layer

    Static Attributes:
        <No static attributes>

    Class Attributes:
        * 'size' is number of neurons in the layer
        * 'input' is the input of the layer
        * 'output' is the output of the layer
        * 'activation_function' is the activation function
        * 'activation_derivative' is the derivative of the activation function
        * 'is_compiled' denotes whether the layer is compiled or not
    """

    def __init__(self, size: int):
        """
        Constructor of _Activation internal layer object.

        Args:
            * 'size' is number of neurons in the layer, the value must be integer.

        Return:
            <N/A>

        Requires:
            * 'size' must be greater than 0
        """

        # Initialize base layer
        try:
            super().__init__(size)
        except Exception as e:
            raise e
        
        # Internal layer attributes
        self.activation_function = None
        self.activation_derivative = None

        # Additional Indicators
        self._is_compiled = False


    def compile(self, input_size: int, output_size: int, activation_function: str) -> None:
        pass


    def forward(self, X: np.ndarray) -> np.ndarray:
        pass


    def backward(self, dY: np.ndarray) -> np.ndarray:
        pass


    def update(self) -> None:
        pass

