"""
Model module holds multiple layers in one place and form a DNN structure.
"""

class Sequential():
    """
    Sequential class provides features to handle layers in one place to form a
        sequential form of DNN structure.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        * layers: list of layers
    """

    def __init__(self):
        self.layers = []

    def add(self, layer):
        """
        Add a layer to the list of layers.

        Args:
            * layer: layer to be added

        Return:
            <No return>
        """
        self.layers.append(layer)

    def setup(self, loss, optimizer):
        """
        Setup the layers in the list of layers.

        Args:
            * loss: loss function
            * optimizer: optimizer

        Return:
            <No return>
        """

    def train(self, x_train, y_train, epochs, batch_size):
        """
        Train the layers in the list of layers.

        Args:
            * x_train: training data
            * y_train: training label
            * epochs: number of epochs
            * batch_size: batch size

        Return:
            <No return>
        """