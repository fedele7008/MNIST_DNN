""" 
Primary purpose for this module is to load MNIST dataset ready to be used for 
    DNN training and testing.
"""

from importlib.resources import files
import numpy as np
import pandas as pd

class MNIST():
    """
    MNIST class provides features to handle mnist data in specific.

    Static Attributes:
        <No static attributes>

    Class Attributes:
        <No class attributes>
    """
    
    @staticmethod
    def load_data():
        """
        Load MNIST training and testing datasets

        Args: 
            <None>
            
        Return:
            ((x_train_data, y_train_data), (x_test_data, y_test_data))
            * x_train_data(2D) has dimension of 60000 x 784, each row is an image.
            * y_train_data(1D) has dimension of 60000, each row is a label.
            * x_test_data(2D) has dimension of 10000 x 784, each row is an image.
            * y_test_data(1D) has dimension of 10000, each row is a label.
        
        Requires:
            * 'mnist_train.csv' must be in 'mnist_dnn/data'
            * 'mnist_test.csv' must be in 'mnist_dnn/data'
        
        Note: 
            * 'mnist_train.csv' contains 60000 image data consists of 60000 rows
                and 785 columns. First column is label, and the rest are pixel 
                data (28px * 28px) in greyscale (value from 0 to 255) values.
            * 'mnist_test.csv' contains 10000 image data consists of 10000 rows 
                and 785 columns. First column is label, and the rest are pixel 
                data (28px * 28px) in greyscale (value from 0 to 255) values.
        """

        # Read MNIST Datasets
        train_data = pd.read_csv(files('mnist_dnn.data').joinpath('mnist_train.csv'))
        test_data = pd.read_csv(files('mnist_dnn.data').joinpath('mnist_test.csv'))

        # Convert the data into numpy array
        train_data = np.array(train_data)
        test_data = np.array(test_data)

        # Shuffle the data
        np.random.shuffle(train_data)
        np.random.shuffle(test_data)

        # Separate the label and pixel data from training dataset
        train_data = train_data.T
        y_train_data = train_data[0]
        x_train_data = train_data[1:].T

        # Separate the label and pixel data from testing dataset
        test_data = test_data.T
        y_test_data = test_data[0]
        x_test_data = test_data[1:].T

        # Normalize greyscale pixels
        x_train_data = x_train_data.astype(np.float64) / 255
        x_test_data = x_test_data.astype(np.float64) / 255

        return ((x_train_data, y_train_data), (x_test_data, y_test_data))