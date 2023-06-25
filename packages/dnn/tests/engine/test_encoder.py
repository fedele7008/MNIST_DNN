import pytest, sys, logging, time
import numpy as np

import mnist_dnn.core.encoder as encoder

class TestEncoder():

    @classmethod
    def setup_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)
        cls.name = 'One_hot'

    @classmethod
    def teardown_class(cls):
        logging.debug(sys._getframe(0).f_code.co_name)

    def setup_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)

    def teardown_method(self, method):
        logging.debug(sys._getframe(0).f_code.co_name)
    
    @pytest.fixture
    def result(self):
        return 

    def test_onehot_encoding(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('starting test_onehot_encoding')
        input = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
        output = np.array([[1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0, 1]])
        
        assert(np.array_equal(encoder.One_hot.encode(input, 10), output))
