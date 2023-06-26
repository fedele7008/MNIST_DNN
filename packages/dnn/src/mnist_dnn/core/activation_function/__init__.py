"""
mnist_dnn.core.activation_function package provides list of activation functions
"""

# Define __version__
__version__ = '0.1.1'

# Import submodules
from mnist_dnn.core.activation_function.relu import ReLu
from mnist_dnn.core.activation_function.softmax import SoftMax

activation_function = {
    'relu': (ReLu.function, ReLu.derivative),
    'softmax': (SoftMax.function, SoftMax.derivative)
}