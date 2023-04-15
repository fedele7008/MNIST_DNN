from mnist_dnn.engine.base_layer import Layer

class Dense(Layer):
    def __init__(self, nodes, activation, input_nodes = None):
        super().__init__(nodes)
        self.activation = activation
        self.input_nodes = input_nodes
        self.W = None
        self.B = None
        self.dW = None
        self.dB = None
        self.X = None
        self.Y = None

        if self.input_nodes is not None:
            pass

    def forward(self, x):
        pass

    def backward(self, y):
        pass

    def update(self):
        pass
    