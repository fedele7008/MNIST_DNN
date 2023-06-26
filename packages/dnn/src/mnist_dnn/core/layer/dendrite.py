"""
dendrite module defines _dendrite layer class.
"""

import numpy as np

from mnist_dnn.core.layer.base import _Layer


class _Dendrite(_Layer):
    """
    Dendrite class is partial dense layer of DNN where it computes weights and bias (activation not included).
    _Dendrite class is internal layer of Dense Layer that encapsulates both _Dendrite and _Activation layer

    Static Attributes:
        <No static attributes>

    Class Attributes:
        * 'size' is number of neurons in the layer (base layer)
        * 'input' is the input of the layer (base layer)
        * 'output' is the output of the layer (base layer)
        * 'weights' is the weights of the layer
        * 'bias' is the bias of the layer
        * 'delta_weights' denote change of weights when update
        * 'delta_bias' denote change of bias when update
        * 'learning_rate' denote the Learning rate of deltas when update
        * 'optimizer' denotes the optimizer of the layer
        * 'is_compiled' denotes whether the layer is compiled or not
    """

    def __init__(self, size: int):
        """
        Constructor for _Dendrite internal layer object.

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
        self.weights = None
        self.bias = None
        self.delta_weights = None
        self.delta_bias = None
        self.learning_rate = None
        self.optimizer = None

        # Additional Indicators
        self._is_compiled = False

    
    def compile(self, input_size: int, optimizer: str, learning_rate: float) -> None:
        pass


    def forward(self, X: np.ndarray) -> np.ndarray:
        pass


    def backward(self, dY: np.ndarray) -> np.ndarray:
        pass

    
    def update(self) -> None:
        pass