"""
model module defines Sequential neural network framework that can store layers
"""
import math

import numpy as np
from numba import jit

from mnist_dnn.layer import Dense
from mnist_dnn.core.encoder import One_hot, ImageModifications
from mnist_dnn.core.loss_function import loss_function


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
        self.loss_derivative = None


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
        
        # Verify if first layer has input size set
        input_size = self.layers[0].input_size
        if input_size is None:
            raise Exception("First layer must have input size set")
        
        self.loss_function, self.loss_derivative = loss_function[loss]

        # Compile all layers
        for layer in self.layers:
            layer.compile(input_size, learning_rate, optimizer)
            input_size = layer.size


    def train(self, train_data, epochs, batch_size, one_hot = True):
        # TODO: assert train_data to be approporiate form (compare with input layer)
        # TODO: raise exception if layer is empty or loss is None or optimizer is None
        train_data_x, train_data_y = train_data
        train_data_x = ImageModifications.apply_random_transformations(train_data_x)
        for ep in range(epochs):
            nbatch = 0
            for batch in range(0, len(train_data_x), batch_size):
                nbatch += 1
                batch_x = train_data_x[batch:batch+batch_size]
                batch_y = train_data_y[batch:batch+batch_size]

                if one_hot:
                    batch_y = One_hot.encode(batch_y, self.layers[-1].size)

                error_total = 0

                for x, y in zip(batch_x, batch_y):
                    output = x
                    for layer in self.layers:
                        output = layer.forward(output)

                    # print(output)
                    error_total += self.loss_function(y, output)
                    # print(error)
                    dy = self.loss_derivative(y, output)

                    for layer in reversed(self.layers):
                        dy = layer.backward(dy)
                
                print('Epoch: {}/{}, Batch: {}/{}, Error: {:0.2f}'.format(
                    ep + 1,
                    epochs,
                    nbatch,
                    math.floor(len(train_data_x)/batch_size),
                    error_total / batch_size
                ))

                for layer in self.layers:
                    layer.update()


    def test(self, test_data):
        test_data_x, test_data_y = test_data
        total = 0
        correct = 0
        for x, y in zip(test_data_x, test_data_y):
            total += 1
            output = x
            for layer in self.layers:
                output = layer.forward(output)

                result = np.argmax(output)
                if result == y:
                    correct += 1

        print(f"Accuracy: {correct/total}")

    def predict(self, image):
        output = np.array(1/255 * image, dtype=np.float64)
        for layer in self.layers:
            output = layer.forward(output)

        for i in range(len(output)):
            print(f'{i}: {round(output[i] * 100)} %')

        prediction = np.argmax(output)
        print(f'Prediction: {prediction}')