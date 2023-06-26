"""
encoder module provides multiple encoding methods.
"""

import numpy as np


class One_hot():
    """
    One_hot class provides features related with one-hot encoding.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        <No class attributes>
    """
    
    @staticmethod
    def encode(y: list[int] | np.ndarray, size: int = 10) -> np.ndarray:
        """
        Encodes a list of integers into list of one-hot vectors.

        Args:
            * 'y' must be list of integers or numpy.ndarray of integers
            * 'size' is integer that denotes the size of each one-hot vector.
        
        Returns:
            numpy.ndarray of one-hot vectors. (This is 2D array)

        Requires:
            * each elemenets of 'y' must not exceed the size of the one-hot vector.
        
        Note:
            * 'size' is defaulted to 10.
        """

        # Verify if 'all' elements of 'y' are less than the size
        if np.max(y) >= size:
            raise ValueError('All elements of y must not exceed the size of the one-hot vector.')

        return np.array([np.eye(size)[i] for i in y])
    