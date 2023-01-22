from mnist_dnn.dataset import MNIST
from mnist_dnn.layer import *
from mnist_dnn.model import *
from mnist_dnn.util.tool import Display

(train_image, train_label), (test_image, test_label) = MNIST.load_data()

print(f"train data size: {train_image.shape[1]}")
print(f"test data size: {test_image.shape[1]}")

data = []
for i in range(60):
    title = f'number: {train_label[i]}'
    image = train_image[:, int(i)]
    data.append((title, image))

Display.show_img(data)