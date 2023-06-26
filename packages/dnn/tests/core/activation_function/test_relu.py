import pytest, sys, logging, time
import numpy as np

from mnist_dnn.core.activation_function.relu import ReLu


class TestReLu():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = 'ReLu'


    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)


    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)

    
    def test_relu_positive_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu with positive input values')
        input = np.array([1, 2, 3, 4])
        output = np.array([1, 2, 3, 4])
        
        assert np.array_equal(ReLu.function(input), output)

    
    def test_relu_negative_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu with negative input values')
        input = np.array([-1, -2, -3, -4])
        output = np.array([0, 0, 0, 0])
        
        assert np.array_equal(ReLu.function(input), output)


    def test_relu_positive_and_negative(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu with positive and negative input values')
        input = np.array([1, -2, 3, -4])
        output = np.array([1, 0, 3, 0])
        
        assert np.array_equal(ReLu.function(input), output)


    def test_relu_zero(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu with zero input values')
        input = np.array([0, 0, 0, 0])
        output = np.array([0, 0, 0, 0])
        
        assert np.array_equal(ReLu.function(input), output)


    def test_relu_derivative_positive_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu derivative with positive input values')
        input = np.array([1, 2, 3, 4])
        output = np.array([[1, 0, 0, 0],
                           [0, 1, 0, 0],
                           [0, 0, 1, 0],
                           [0, 0, 0, 1]])
        
        assert np.array_equal(ReLu.derivative(input), output)


    def test_relu_derivative_negative_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu derivative with negative input values')
        input = np.array([-1, -2, -3, -4])
        output = np.array([[0, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 0, 0]])
        
        assert np.array_equal(ReLu.derivative(input), output)


    def test_relu_derivative_positive_and_negative(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu derivative with positive and negative input values')
        input = np.array([1, -2, 3, -4])
        output = np.array([[1, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 1, 0],
                           [0, 0, 0, 0]])
        
        assert np.array_equal(ReLu.derivative(input), output)


    def test_relu_derivative_zero(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing ReLu derivative with zero input values')
        input = np.array([0, 0, 0, 0])
        output = np.array([[0, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 0, 0]])
        
        assert np.array_equal(ReLu.derivative(input), output)
