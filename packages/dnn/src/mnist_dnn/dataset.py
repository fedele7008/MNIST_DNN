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
        
        Requires:
            * 'train.csv' must be in same directory as this module

        Note: 
            train.csv contains dataset has 42000 rows and 785 columns. First column
            is label, and the rest are pixel data (28px * 28px) in greyscale 
            (value from 0 to 255) value. We shuffle the rows and separate first
            1000 rows to be our test data, and the rest of 41000 are training
            data; and we normalize the greyscale values.

        Args: 
            <No argument>
            
        Return:
            ((x_train_data, y_train_data), (x_test_data, y_test_data))
            x_train_data(2D) has dimension of 784 x 41000, each column is an image,
            y_train_data(1D) has dimension of 41000, each row is a label,
            x_test_data(2D) has dimension of 784 x 1000, each column is an image,
            y_test_data(1D) has dimension of 1000, each row is a label.
        """

        # Read MNIST Dataset 
        data = pd.read_csv(files('mnist_dnn.data').joinpath('train.csv'))

        # Convert the data to numpy array
        data = np.array(data)

        # Shuffle the data
        np.random.shuffle(data)

        # Separate test/train data
        test_data = data[:1000]
        train_data = data[1000:]

        # Separate the label and pixel data from testing dataset
        test_data = test_data.T
        y_test_data = test_data[0]
        x_test_data = test_data[1:]

        # Separate the label and pixel data from training dataset
        train_data = train_data.T
        y_train_data = train_data[0]
        x_train_data = train_data[1:]

        # Normalize greyscale pixels
        x_test_data = x_test_data.astype(np.float64) / 255
        x_train_data = x_train_data.astype(np.float64) / 255

        return ((x_train_data, y_train_data), (x_test_data, y_test_data))
