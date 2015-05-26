#!/usr/bin/env python

"""
Synopsis:
    Sample math functions for use with Erlang and Erlport.
Details:
    test_01 -- Solve the continuous algebraic Riccati equation, or
        CARE, defined as (A'X + XA - XBR^-1B'X+Q=0) directly using a
        Schur decomposition method.
"""

import numpy as np
from scipy import linalg
from erlport.erlterms import Atom
#import json


def test_01(m, n):
    a = np.random.random((m, m))
    b = np.random.random((m, n))
    q = np.random.random((m, m))
    r = np.random.random((n, n))
    print '(test_01) m: {}  n: {}'.format(m, n, )
    result = linalg.solve_continuous_are(a, b, q, r)
    return result


def run(m=4, n=3):
    result = test_01(m, n)
    #print result
    #json_result = json.dumps(result.tolist())
    return (Atom('ok'), result.tolist())


def main():
    run()

if __name__ == '__main__':
    main()
