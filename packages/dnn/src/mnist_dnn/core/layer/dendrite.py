"""
dendrite module defines _dendrite layer class.
"""

import numpy as np
from numba import jit

from mnist_dnn.core.layer.base import _Layer
from mnist_dnn.core.optimizer import optimizers


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


    def compile(self, input_size: int, optimizer: str, learning_rate: float, *optimizer_param, **kw_optimizer_param) -> None:
        if input_size < 1:
            raise ValueError('input size must be greater than 0')
        
        if learning_rate < 0:
            raise ValueError('learning rate must be non-negative')
        
        if optimizer not in optimizers:
            raise ValueError('optimizer named, {} is not found'.format(optimizer))
        
        self.weights = np.random.randn(input_size, self.size)
        self.bias = np.random.randn(self.size)

        self.learning_rate = learning_rate
        self.optimizer = optimizers[optimizer](learning_rate, optimizer_param, kw_optimizer_param)

        self.delta_weights = []
        self.delta_bias = []

        self._is_compiled = True


    def forward(self, X: np.ndarray) -> np.ndarray:
        if self._is_compiled is False:
            raise RuntimeError('layer is not compiled yet')
        
        self.input = X
        self.output = (X @ self.weights) + self.bias

        return self.output


    def backward(self, dY: np.ndarray) -> np.ndarray:
        if self._is_compiled is False:
            raise RuntimeError('layer is not compiled yet')
        
        if self.input is None:
            raise RuntimeError('Forward method must be called before backward')

        dW = np.array([self.input]).T @ np.array([dY])
        dB = dY

        self.delta_weights.append(dW)
        self.delta_bias.append(dB)

        return dY @ self.weights.T


    def update(self) -> None:
        if self._is_compiled is False:
            raise RuntimeError('layer is not compiled yet')
        
        if self.delta_weights == [] or self.delta_bias == []:
            raise RuntimeError('Backward method must be called before update')
        
        weights_avg = np.mean(np.array(self.delta_weights), axis = 0)
        bias_avg = np.mean(np.array(self.delta_bias), axis = 0)

        self.optimizer.update(param = self.weights, grad = weights_avg)
        self.optimizer.update(param = self.bias, grad = bias_avg)

        self.delta_weights = []
        self.delta_bias = []