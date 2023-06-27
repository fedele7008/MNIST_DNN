import pytest, sys, logging, time
import numpy as np

from mnist_dnn.core.layer.dendrite import _Dendrite as Dendrite


class TestDendrite():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = '_Dendrite'


    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)


    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    @pytest.fixture
    def dendrite_4(self):
        yield Dendrite(4)
    

    def test_dendrite_init_attributes(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer initialization attributes')

        assert dendrite_4.size == 4
        assert dendrite_4.input is None
        assert dendrite_4.output is None
        assert dendrite_4.weights is None
        assert dendrite_4.bias is None
        assert dendrite_4.delta_weights is None
        assert dendrite_4.delta_bias is None
        assert dendrite_4.learning_rate is None
        assert dendrite_4.optimizer is None
        assert dendrite_4._is_compiled == False


    def test_dendrite_init_exception(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer initialization exception')

        with pytest.raises(ValueError):
            obj = Dendrite(-1)

    
    def test_dendrite_compile(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer compilation')
        
        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        assert dendrite_4.size == 4
        assert dendrite_4.input is None
        assert dendrite_4.output is None
        assert dendrite_4.weights is not None
        assert dendrite_4.bias is not None
        assert dendrite_4.delta_weights == []
        assert dendrite_4.delta_bias == []
        assert dendrite_4.learning_rate == 0.001
        assert dendrite_4.optimizer is not None
        assert dendrite_4._is_compiled == True

    
    def test_dendrite_compile_exception_invalid_input_size(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer compilation exception - invalid input size')

        with pytest.raises(ValueError):
            obj = dendrite_4.compile(input_size = 0, optimizer = 'gradient_descent', learning_rate = 0.001)

    
    def test_dendrite_compile_exception_invalid_learning_rate(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer compilation exception - invalid learning rate')

        with pytest.raises(ValueError):
            obj = dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = -0.001)

    
    def test_dendrite_compile_exception_invalid_optimizer(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer compilation exception - invalid optimizer')

        with pytest.raises(ValueError):
            obj = dendrite_4.compile(input_size = 3, optimizer = 'invalid_optimizer', learning_rate = 0.001)

    
    def test_dendrite_forward(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer forward pass')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        # Override Weights and Bias
        dendrite_4.weights = np.array([[0.1, 0.2, 0.3, 0.4],
                                       [0.5, 0.6, 0.7, 0.8],
                                       [0.9, 0.1, 0.2, 0.3]])
        
        dendrite_4.bias = np.array([0.1, 0.2, 0.3, 0.4])

        input = np.array([0.1, 0.2, 0.3])
        output = np.array([0.48, 0.37, 0.53, 0.69])
        
        assert np.allclose(dendrite_4.forward(input), output)


    def test_dendrite_forward_exception_not_compiled(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer forward pass exception - not compiled')

        with pytest.raises(RuntimeError):
            dendrite_4.forward(np.array([0.1, 0.2, 0.3]))

    
    def test_dendrite_forward_exception_invalid_input_size(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer forward pass exception - invalid input size')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        with pytest.raises(ValueError):
            dendrite_4.forward(np.array([0.1, 0.2, 0.3, 0.4]))

    
    def test_dendrite_backward(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer backward pass')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        # Override Weights and Bias
        dendrite_4.weights = np.array([[0.1, 0.2, 0.3, 0.4],
                                       [0.5, 0.6, 0.7, 0.8],
                                       [0.9, 0.1, 0.2, 0.3]])
        
        dendrite_4.bias = np.array([0.1, 0.2, 0.3, 0.4])

        forward_input = np.array([0.1, 0.2, 0.3])

        backward_input = np.array([0.1, 0.2, 0.3, 0.4])
        backward_output = np.array([0.3, 0.7, 0.29])

        backward_delta_weights = [np.array([[0.01, 0.02, 0.03, 0.04],
                                            [0.02, 0.04, 0.06, 0.08],
                                            [0.03, 0.06, 0.09, 0.12]])]
        
        backward_delta_bias = [np.array([0.1, 0.2, 0.3, 0.4])]

        # Forward pass
        dendrite_4.forward(forward_input)

        # Backward pass
        result = dendrite_4.backward(backward_input)
        
        assert np.allclose(result, backward_output)
        assert np.allclose(dendrite_4.delta_weights, backward_delta_weights)
        assert np.allclose(dendrite_4.delta_bias, backward_delta_bias)


    def test_dendrite_backward_exception_not_compiled(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer backward pass exception - not compiled')

        with pytest.raises(RuntimeError):
            dendrite_4.backward(np.array([0.1, 0.2, 0.3, 0.4]))
        
    
    def test_dendrite_backward_exception_invalid_input_size(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer backward pass exception - invalid input size')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        forward_input = np.array([0.1, 0.2, 0.3])
        dendrite_4.forward(forward_input)

        with pytest.raises(ValueError):
            dendrite_4.backward(np.array([0.1, 0.2, 0.3, 0.4, 0.5]))


    def test_dendrite_backward_exception_forward_not_initialized(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer backward pass exception - forward not initialized')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        with pytest.raises(RuntimeError):
            dendrite_4.backward(np.array([0.1, 0.2, 0.3, 0.4]))


    def test_update_single_pass(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer update - after 1 pass cycle')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        # Override Weights and Bias
        dendrite_4.weights = np.array([[0.1, 0.2, 0.3, 0.4],
                                       [0.5, 0.6, 0.7, 0.8],
                                       [0.9, 0.1, 0.2, 0.3]])
        
        dendrite_4.bias = np.array([0.1, 0.2, 0.3, 0.4])

        forward_input = np.array([0.1, 0.2, 0.3])
        backward_input = np.array([0.1, 0.2, 0.3, 0.4])

        # Forward pass
        dendrite_4.forward(forward_input)

        # Backward pass
        dendrite_4.backward(backward_input)
        
        # Update weights and bias
        dendrite_4.update()

        output_weights = np.array([[0.09999, 0.19998, 0.29997, 0.39996],
                                   [0.49998, 0.59996, 0.69994, 0.79992],
                                   [0.89997, 0.09994, 0.19991, 0.29988]])

        output_bias = np.array([0.0999, 0.1998, 0.2997, 0.3996])

        assert np.allclose(dendrite_4.weights, output_weights)
        assert np.allclose(dendrite_4.bias, output_bias)


    def test_update_2_pass(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer update - after 2 pass cycles')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        # Override Weights and Bias
        dendrite_4.weights = np.array([[0.1, 0.2, 0.3, 0.4],
                                       [0.5, 0.6, 0.7, 0.8],
                                       [0.9, 0.1, 0.2, 0.3]])
        
        dendrite_4.bias = np.array([0.1, 0.2, 0.3, 0.4])

        # pass cycle 1
        forward_input = np.array([0.1, 0.2, 0.3])
        backward_input = np.array([0.1, 0.2, 0.3, 0.4])

        dendrite_4.forward(forward_input)
        dendrite_4.backward(backward_input)

        # pass cycle 2
        forward_input = np.array([0.4, 0.5, 0.6])
        backward_input = np.array([0.7, 0.8, 0.9, 0.1])

        dendrite_4.forward(forward_input)
        dendrite_4.backward(backward_input)

        # Update weights and bias
        dendrite_4.update()

        output_weights = np.array([[0.099855, 0.19983, 0.299805, 0.39996],
                                   [0.499815, 0.59978, 0.699745, 0.799935],
                                   [0.899775, 0.09973, 0.199685, 0.29991]])

        output_bias = np.array([0.0996, 0.1995, 0.2994, 0.39975])

        assert np.allclose(dendrite_4.weights, output_weights)
        assert np.allclose(dendrite_4.bias, output_bias)


    def test_update_exception_backward_not_initialized(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer update exception - backward not initialized')

        dendrite_4.compile(input_size = 3, optimizer = 'gradient_descent', learning_rate = 0.001)

        forward_input = np.array([0.1, 0.2, 0.3])
        dendrite_4.forward(forward_input)

        with pytest.raises(RuntimeError):
            dendrite_4.update()


    def test_update_exception_not_compiled(self, dendrite_4):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Dendrite layer update exception - not compiled')
        
        with pytest.raises(RuntimeError):
            dendrite_4.update()
    