"""
mnist_dnn.core.loss_function package provides list of loss functions
"""

# Define __version__
__version__ = '0.1.1'

# Import submodules
from mnist_dnn.core.loss_function.categorical_crossentropy import Categorical_crossentropy

loss_function = {
    'categorical_crossentropy': (Categorical_crossentropy.function, Categorical_crossentropy.derivative)
}