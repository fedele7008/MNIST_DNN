import pytest, sys, logging, time
import numpy as np

from mnist_dnn.core.optimizer.gradient_descent import GradientDescent


class TestGradientDescent():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = 'GradientDescent'


    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)


    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def test_gradient_descent_1D(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Gradient Descent for 1D data')

        gd = GradientDescent(learning_rate=0.1)

        x = np.array([10, 20, 30, 40], dtype=np.float64)
        dx = np.array([40, 30, 20, 10], dtype=np.float64)

        gd.update(x, dx)

        output = np.array([6, 17, 28, 39], dtype=np.float64)

        assert np.array_equal(x, output)


    def test_gradient_descent_2D(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Gradient Descent for 2D data')

        gd = GradientDescent(learning_rate=0.1)

        x = np.array([[1, 2, 3], 
                      [4, 5, 6], 
                      [7, 8, 9]], dtype=np.float64)
        
        dx = np.array([[2, 2, 2],
                       [2, 2, 2],
                       [2, 2, 2]], dtype=np.float64)

        gd.update(x, dx)

        output = np.array([[0.8, 1.8, 2.8],
                           [3.8, 4.8, 5.8],
                           [6.8, 7.8, 8.8]], dtype=np.float64)

        assert np.array_equal(x, output)


    def test_gradient_descent_exception(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing Gradient Descent rasing exception for invalid input')

        gd = GradientDescent(learning_rate=0.1)

        x = np.array([[1, 2, 3], 
                      [4, 5, 6], 
                      [7, 8, 9]], dtype=np.float64)
        
        dx = np.array([[2, 2, 2],
                       [2, 2, 2]], dtype=np.float64)

        with pytest.raises(ValueError):
            gd.update(x, dx)

        output = np.array([[1, 2, 3], 
                           [4, 5, 6], 
                           [7, 8, 9]], dtype=np.float64)

        assert np.array_equal(x, output)