import pytest, sys, logging, time

import mnist_dnn_api.app as app

def setup_function(function):
    logging.debug(sys._getframe(0).f_code.co_name)

def teardown_function(function):
    logging.debug(sys._getframe(0).f_code.co_name)

def test_sample_function():
    logging.debug(sys._getframe(0).f_code.co_name)
    logging.info('starting test_sample_function')
    assert(True)