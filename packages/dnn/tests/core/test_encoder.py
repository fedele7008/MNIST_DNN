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


    def test_onehot_encoding_1(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing general numbers from 0 to 9 with size 10')
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
        
        assert np.array_equal(encoder.One_hot.encode(input, 10), output)


    def test_onehot_encoding_2(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing general numbers from 0 to 9 with size 10 in random values')
        input = np.array([3, 9, 0, 4, 0, 7, 5, 5, 0, 0])
        output = np.array([[0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                           [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
                           [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
                           [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
                           [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]])
        
        assert np.array_equal(encoder.One_hot.encode(input, 10), output)


    def test_onehot_encoding_3(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing single number array with size 5')
        input = np.array([3])
        output = np.array([[0, 0, 0, 1, 0]])
        
        assert np.array_equal(encoder.One_hot.encode(input, 5), output)


    def test_onehot_encoding_exception_1(self):
        logging.debug(sys._getframe(0).f_code.co_name)
        logging.info('Testing exception when input exceeds the given size')
        input = np.array([2, 5, 8])

        with pytest.raises(ValueError):
            encoder.One_hot.encode(input, 8)
