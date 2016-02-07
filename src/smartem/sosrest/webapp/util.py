# -*- coding: utf-8 -*-
#
# Utility functions and classes.
#
# Author:Just van den Broecke

import logging

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(name)s %(levelname)s %(message)s')

# Static utility methods
def get_log(name):
    log = logging.getLogger(name)
    log.setLevel(logging.DEBUG)
    return log
