from mnist_dnn.engine.loss_functions.categorical_crossentropy import Categorical_crossentropy

loss_function = {
    'categorical_crossentropy': (Categorical_crossentropy.function, Categorical_crossentropy.derivative)
}