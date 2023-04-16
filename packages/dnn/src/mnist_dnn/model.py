from mnist_dnn.engine.base_layer import Layer
from mnist_dnn.engine.encoder import One_hot
from mnist_dnn.engine.loss_function import loss_function

class Sequential():
    def __init__(self, layers = []):
        for layer in layers:
            if not isinstance(layer, Layer):
                raise TypeError("Layer must be an instance of Layer")

        self.layers = layers
        self.loss = None
        self.loss_prime = None
        self.optimizer = None

    def add(self, layer):
        if not isinstance(layer, Layer):
            raise TypeError("Layer must be an instance of Layer")

        self.layers.append(layer)

    def compile(self, loss, optimizer):
        # TODO: raise exception if layer is empty
        # TODO: depending on the input str of loss, set self.loss and self.loss_prime to appropriate loss function from engine
        # TODO: depending on the input str of optimizer, set self.optimizer to appropriate optimizer function
        # TODO: if they are not valid loss or optimizer, raise exception
        # TODO: initialize every layers
        if loss not in loss_function:
            raise ValueError("Invalid loss function")
        
        self.loss, self.loss_prime = loss_function[loss]
        self.optimizer = optimizer

    def train(self, train_data, epochs, batch_size, learning_rate = 0.01, one_hot = True):
        # TODO: assert train_data to be approporiate form (compare with input layer)
        # TODO: raise exception if layer is empty or loss is None or optimizer is None
        train_data_x, train_data_y = train_data
        for _ in range(epochs):
            for batch in range(0, len(train_data_x), batch_size):
                batch_x = train_data_x[batch:batch+batch_size]
                batch_y = train_data_y[batch:batch+batch_size]

                if one_hot:
                    batch_y = One_hot.encode(batch_y, self.layers[-1].nodes)
                
                output = batch_x
                for layer in self.layers:
                    output = layer.forward(output)
                
                # TODO: implement rest of loss eval and backprop
                