# -*- coding: utf-8 -*-
#
# Utility functions and classes.
#
# Author:Just van den Broecke

import logging

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(name)s %(levelname)s %(message)s')

# Static utility methods
class Util:

    @staticmethod
    def get_log(name):
        log = logging.getLogger(name)
        log.setLevel(logging.DEBUG)
        return log


    # Convert a string to a dict
    @staticmethod
    def string_to_dict(s, separator='=', space='~'):
        # Convert string to dict: http://stackoverflow.com/a/1248990
        dict_arr = [x.split(separator) for x in s.split()]
        for x in dict_arr:
            x[1] = x[1].replace(space, ' ')

        return dict(dict_arr)

    # Convert a dict to a string
    @staticmethod
    def dict_to_string(dict_v):
        # Convert/flatten dict to string http://codereview.stackexchange.com/questions/7953/how-do-i-flatten-a-dictionary-into-a-string
        return ' '.join("%s=%r" % (key, val) for (key, val) in dict_v.iteritems())
