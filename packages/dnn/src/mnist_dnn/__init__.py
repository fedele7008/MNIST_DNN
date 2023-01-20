"""
mnist_dnn package provides essential tools to build custom dnn based on MNIST dataset
"""

# Import all modules
from mnist_dnn import dataset
from mnist_dnn import layer
from mnist_dnn import model

# Import all subpackages
from mnist_dnn import util

# Define __all__
__all__ = ['dataset', 'layer', 'model', 'util']

# Define __version__
__version__ = '0.1.1'