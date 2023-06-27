import pytest, sys, logging, time
import numpy as np

from mnist_dnn.core.optimizer import optimizers


class TestOptimizerInit():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = 'optimizer'


    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)


    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)


    def test_optimizer_init_gradient_descent(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing optimizers collection with gradient descent')

        gd = optimizers['gradient_descent'](learning_rate=0.1)

        x = np.array([10, 20, 30, 40], dtype=np.float64)
        dx = np.array([40, 30, 20, 10], dtype=np.float64)

        gd.update(x, dx)

        output = np.array([6, 17, 28, 39], dtype=np.float64)

        assert np.array_equal(x, output)


    def test_optimizer_init_exception(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing optimizers collection exception')

        with pytest.raises(KeyError):
            optimizers['invalid_optimizer'](learning_rate=0.1)