"""
activation module defines _activation layer class.
"""

import numpy as np
from numba import jit

from mnist_dnn.core.layer.base import _Layer
from mnist_dnn.core.activation_function import activation_function as activation_function_collection


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


    def compile(self, input_size: int, activation_function: str, *args, **kwargs) -> None:
        if input_size < 1:
            raise ValueError('input size must be greater than 0')

        if activation_function not in activation_function_collection:
            raise ValueError('activation function named, {} is not found'.format(activation_function))
        
        self.activation_function, self.activation_derivative = activation_function_collection[activation_function]
        
        self._is_compiled = True


    def forward(self, X: np.ndarray) -> np.ndarray:
        if self._is_compiled is False:
            raise RuntimeError('layer is not compiled yet')
        
        self.input = X
        self.output = self.activation_function(X)

        return self.output


    def backward(self, dY: np.ndarray) -> np.ndarray:
        if self._is_compiled is False:
            raise RuntimeError('layer is not compiled yet')
        
        return dY @ self.activation_derivative(self.input)


    def update(self) -> None:
        pass # Nothing to update in this layer

