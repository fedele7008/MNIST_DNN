"""
base module defines primary class for base layer namely, Layer.
"""

from abc import ABC, abstractmethod
import numpy as np


class _Layer(ABC):
    """
    Layer class is base object for all layer objects which includes: _Dendrite, _Activation, and Dense
    
    Static Attributes:
        <No static attributes>

    Class Attributes:
        * 'size' is number of neurons in the layer
        * 'input' is the input of the layer
        * 'output' is the output of the layer
    """

    def __init__(self, size: int):
        """
        Constructor for abstract base layer.

        Args:
            * 'size' is number of neurons in the layer, the value must be integer.

        Return:
            <N/A>

        Requires:
            * 'size' must be greater than 0 
        """

        # Validate layer size
        if size < 1:
            raise ValueError("Layer size must be greater than 0")
        
        # Size of layer (number of neuron nodes in the layer)
        self.size = size

        # input and output of the Layer
        self.input = None
        self.output = None

    
    @abstractmethod
    def compile(self, *args, **kwargs) -> None:
        """
        Compile the layer before running forward and backward passes.

        Args:
            Abstract arguments are accepted: args, kwargs (child class doesn't have to follow this)

        Return:
            <None>
        """
        pass


    @abstractmethod
    def forward(self, X: np.ndarray) -> np.ndarray:
        """
        Fordward pass of the layer

        Args:
            * 'X' is the input of the layer
        
        Return:
            numpy.ndarray of the output of the layer

        Note:
            This is an abstract method, it must be implemented in the child class.
        """
        pass

    
    @abstractmethod
    def backward(self, dY: np.ndarray) -> np.ndarray:
        """
        Backward pass of the layer

        Args:
            * 'dY' denote dE/dY of some Y in general
        
        Return:
            numpy.ndarray of dE/dX of the layer

        Note:
            This is an abstract method, it must be implemented in the child class.
        """
        pass


    @abstractmethod
    def update(self) -> None:
        """
        Update the layer accordingly

        Args:
            <None>

        Return:
            <None>
        """
        pass

