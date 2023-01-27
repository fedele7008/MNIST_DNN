"""
Layers module provides various layers within the DNN structure.
"""

from abc import ABCMeta, abstractmethod
import numpy as np

class Layer(metaclass=ABCMeta):
    """
    Layer class an abstract base class for all layers. It provides abstract 
    features to handle layers in general.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        * x: input data
        * y: output data
    """

    def __init__(self):
        self.x = None
        self.y = None

    @abstractmethod
    def forward(self, x):
        """
        Forward propagation.

        Args:
            * x: input data

        Return:
            * y: output data
        """
        raise NotImplementedError

    @abstractmethod
    def backward(self, dy):
        """
        Backward propagation.

        Args:
            * dy: gradient of loss function with respect to output data

        Return:
            * dx: gradient of loss function with respect to input data
        """
        raise NotImplementedError

class Dense(Layer):
    """
    Dense class provides features to handle dense layers.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        * w: weight
        * b: bias
        * dw: gradient of loss function with respect to weight
        * db: gradient of loss function with respect to bias
    """

    def __init__(self, x_size, y_size):
        """
        Initialize the layer.

        Args:
            * x_size: number of input data
            * y_size: number of output data

        Return:
            <No return>
        """
        super().__init__()
        self.w = np.random.randn(y_size, x_size) * 0.01
        self.b = np.zeros((y_size, 1))
        self.dw = None
        self.db = None