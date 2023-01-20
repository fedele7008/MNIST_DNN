from mnist_dnn.dataset import MNIST
from mnist_dnn.layer import *
from mnist_dnn.model import *
from mnist_dnn.util.tool import Display

(x_train_data, y_train_data), (x_test_data, y_test_data) = MNIST.load_data()
for i in range(10):
    print(f"value: {y_train_data[i]}")
    #Display.show_img(x_train_data[:, int(i)], is_normalized=True, display_mode='ascii')
    Display.show_img(x_train_data[:, int(i)], is_normalized=True, display_mode='simple-ascii')
    #Display.show_img(x_train_data[:, int(i)], is_normalized=True, display_mode='graphic')

