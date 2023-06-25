"""
model module defines Sequential neural network framework that can store layers
"""

from mnist_dnn.layer import Dense
from mnist_dnn.core.encoder import One_hot
from mnist_dnn.core.loss_function import loss_function
from mnist_dnn.core.optimizer import optimizer_function


class Sequential():
    """
    Sequential class is container for dense layers in DNN model.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        TODO
    """

    def __init__(self, layers: list[Dense] = []):
        """
        Constructor for Sequential class.

        Args:
            * 'layers' is list of Dense layer (optional)

        Return:
            <N/A>
        """

        # Verify each layers is an instance of Dense
        for layer in layers:
            if not isinstance(layer, Dense):
                raise TypeError("Layer must be an instance of Layer")

        # Initialize class attributes
        self.layers = layers
        self.loss_function = None
        self.loss_function_derivative = None
        self.optimizer = None


    def add(self, layer: Dense) -> None:
        # Verify each layers is an instance of Dense
        if not isinstance(layer, Dense):
            raise TypeError("Layer must be an instance of Layer")

        # Append Dense layer to layer
        self.layers.append(layer)


    def compile(self, loss: str, optimizer: str, learning_rate: float = 0.01) -> None:
        # Verify if layer is not empty
        if len(self.layers) == 0:
            raise Exception("Layer is empty")
        
        # Verify if loss function is valid
        if loss not in loss_function:
            raise ValueError("Invalid loss function")
        
        # Verify if optimizer is valid
        if optimizer not in optimizer_function:
            raise ValueError("Invalid optimizer")
        
        # Verify if first layer has input size set
        input_size = self.layers[0].input_size
        if input_size is None:
            raise Exception("First layer must have input size set")
        
        # Set loss function and optimizer
        self.loss_function, self.loss_function_derivative = loss_function[loss]
        self.optimizer = optimizer_function[optimizer]
        
        # Compile all layers
        for layer in self.layers:
            output_size = layer.size
            layer.compile(input_size, output_size, learning_rate)
            input_size = output_size


    def train(self, train_data, epochs, batch_size, one_hot = True):
        # TODO: assert train_data to be approporiate form (compare with input layer)
        # TODO: raise exception if layer is empty or loss is None or optimizer is None
        train_data_x, train_data_y = train_data
        for _ in range(epochs):
            for batch in range(0, len(train_data_x), batch_size):
                batch_x = train_data_x[batch:batch+batch_size]
                batch_y = train_data_y[batch:batch+batch_size]

                if one_hot:
                    batch_y = One_hot.encode(batch_y, self.layers[-1].size)

                output = batch_x
                for layer in self.layers:
                    output = layer.forward(output)
                
                # TODO: implement rest of loss eval and backprop
                