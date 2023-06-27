import pytest, sys, logging, time
import numpy as np

from mnist_dnn.core.activation_function import activation_function


class TestActivationFunctionInit():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = 'activation_function'


    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)


    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def test_init_relu(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing activation_function collection with ReLu')
        f, df = activation_function['relu']

        f_input = np.array([1, 2, 3, 4])
        f_output = np.array([1, 2, 3, 4])
        
        assert np.array_equal(f(f_input), f_output)

        df_input = np.array([1, 2, 3, 4])
        df_output = np.array([[1, 0, 0, 0],
                              [0, 1, 0, 0],
                              [0, 0, 1, 0],
                              [0, 0, 0, 1]])
        
        assert np.array_equal(df(df_input), df_output)


    def test_init_softmax(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing activation_function collection with Softmax')
        f, df = activation_function['softmax']

        f_input = np.array([1, 2, 3, 4])
        f_output = np.array([0.0320586, 0.08714432, 0.23688282, 0.64391426])
        
        assert np.allclose(f(f_input), f_output)

        df_input = np.array([1, 2, 3, 4])
        df_output = np.array([[ 0.03103085, -0.00279373, -0.00759413, -0.02064299],
                              [-0.00279373,  0.07955019, -0.02064299, -0.05611347],
                              [-0.00759413, -0.02064299,  0.18076934, -0.15253222],
                              [-0.02064299, -0.05611347, -0.15253222,  0.22928869]])
        
        assert np.allclose(df(df_input), df_output)


    def test_init_exception(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing activation_function collection exception')
        
        with pytest.raises(KeyError):
            activation_function['invalid_activation']