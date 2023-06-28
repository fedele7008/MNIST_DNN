from mnist_dnn.dataset import MNIST
from mnist_dnn.layer import Dense
from mnist_dnn.model import Sequential
from mnist_dnn.util.tool import Display
from timeit import default_timer as timer

# Load MNIST dataset
start = timer()
train_data, test_data = MNIST.load_data()
print("Loaded time: ", timer() - start)

# print data size
print(f"train data size: {train_data[0].shape[0]}")
print(f"test data size: {test_data[0].shape[0]}")
'''
# print 50 sample images
image, label = train_data
sample = []
for i in range(50):
    sample.append((f'Number: {label[i]}', image[i]))
Display.show_img(sample)
'''
# run
model = Sequential()
model.add(Dense(nodes = 32, input_nodes = 28 * 28, activation = 'relu'))
model.add(Dense(nodes = 10, activation = 'softmax'))

start = timer()
model.compile(loss = 'categorical_crossentropy', optimizer = 'gradient_descent')
print("Compile time: ", timer() - start)

start = timer()
model.train(train_data, epochs = 1, batch_size = 2)
print("train time: ", timer() - start)

start = timer()
model.test(test_data)
print("test time: ", timer() - start)
