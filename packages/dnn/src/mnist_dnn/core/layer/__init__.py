"""
mnist_dnn.core.layer package provides internal layers of neural networks.
"""

# Define __version__
__version__ = '0.1.1'


# Import submodules
from mnist_dnn.core.layer.base import _Layer
from mnist_dnn.core.layer.dendrite import _Dendrite as Dendrite
from mnist_dnn.core.layer.activation import _Activation as Activation