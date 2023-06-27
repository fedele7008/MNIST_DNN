"""
mnist_dnn.core.optimizer package provides list of optimizers
"""

# Define __version__
__version__ = '0.1.1'

# Import submodules
from mnist_dnn.core.optimizer.gradient_descent import GradientDescent

optimizers = {
    'gradient_descent': GradientDescent
}