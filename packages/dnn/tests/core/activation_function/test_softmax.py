import pytest, sys, logging, time
import numpy as np

from mnist_dnn.core.activation_function.softmax import SoftMax


class TestSoftmax():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = 'SoftMax'


    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)


    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def test_softmax_positive_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax with positive input values')
        input = np.array([1, 2, 3, 4])
        output = np.array([0.0320586, 0.08714432, 0.23688282, 0.64391426])
        
        assert np.allclose(SoftMax.function(input), output)


    def test_softmax_negative_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax with negative input values')
        input = np.array([-1, -2, -3, -4])
        output = np.array([0.64391426, 0.23688282, 0.08714432, 0.0320586])
        
        assert np.allclose(SoftMax.function(input), output)


    def test_softmax_positive_and_negative(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax with positive and negative input values')
        input = np.array([1, -2, 3, -4])
        output = np.array([0.11840511, 0.00589504, 0.87490203, 7.9780739e-4])
        
        assert np.allclose(SoftMax.function(input), output)

    
    def test_softmax_zero_input(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax with zero input values')
        input = np.array([0, 0, 0, 0])
        output = np.array([0.25, 0.25, 0.25, 0.25])
        
        assert np.allclose(SoftMax.function(input), output)


    def test_softmax_derivative_positive_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax derivative with positive input values')
        input = np.array([1, 2, 3, 4])
        output = np.array([[ 0.03103085, -0.00279373, -0.00759413, -0.02064299],
                           [-0.00279373,  0.07955019, -0.02064299, -0.05611347],
                           [-0.00759413, -0.02064299,  0.18076934, -0.15253222],
                           [-0.02064299, -0.05611347, -0.15253222,  0.22928869]])
        
        assert np.allclose(SoftMax.derivative(input), output)


    def test_softmax_derivative_negative_only(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax derivative with negative input values')
        input = np.array([-1, -2, -3, -4])
        output = np.array([[ 0.22928869, -0.15253223, -0.05611347, -0.02064299],
                           [-0.15253223,  0.18076935, -0.02064299, -0.00759413],
                           [-0.05611347, -0.02064299,  0.07955019, -0.00279372],
                           [-0.02064299, -0.00759413, -0.00279372,  0.03103084]])
        
        assert np.allclose(SoftMax.derivative(input), output)


    def test_softmax_derivative_positive_and_negative(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax derivative with positive and negative input values')
        input = np.array([1, -2, 3, -4])
        output = np.array([[ 0.10438534   , -6.98002860e-4, -0.10359287   , -9.44644718e-5],
                           [-6.98002860e-4,  0.00586029   , -0.00515758   , -4.70310648e-6],
                           [-0.10359287   , -0.00515758   ,  0.10944847   , -6.98003305e-4],
                           [-9.44644718e-5, -4.70310648e-6, -6.98003305e-4,  0.00079717   ]])
        
        assert np.allclose(SoftMax.derivative(input), output)


    def test_softmax_derivative_zero(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing SoftMax derivative with zero input values')
        input = np.array([0, 0, 0, 0])
        output = np.array([[ 0.1875, -0.0625, -0.0625, -0.0625],
                           [-0.0625,  0.1875, -0.0625, -0.0625],
                           [-0.0625, -0.0625,  0.1875, -0.0625],
                           [-0.0625, -0.0625, -0.0625,  0.1875]])
        
        assert np.allclose(SoftMax.derivative(input), output)
