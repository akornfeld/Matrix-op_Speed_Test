# -*- coding: utf-8 -*-
"""
Created on Mon Jan 19 08:38:04 2015

@author: Ari
"""

# RESULTS:
#"Dedicated python shell"  Python 2.7.6 (is 10-25% faster than IPything, below)
#Small array, many iterations:
#   58.64,  58.84 s
#10x cols, 10x fewer iterations:
#   8.18, 8.26 s
#10x rows, 10x fewer iterations:
#   9.13, 9.21 s
#10x rows, 10x fewer iterations, row means:
#   8.30, 8.40 s
#100x cols, 100x fewer iterations:
#   3.12, 3.14 s
#500x cols, 500x fewer iterations:
#   2.60, 2.56 s
#   
#IPython 2.7.6:
#       Small array, many iterations:
#   65.02, 63.81 s
#10x cols, 10x fewer iterations:
#   9.45, 9.44 s
#10x rows, 10x fewer iterations:
#   9.59, 9.61 s
#10x rows, 10x fewer iterations, row means:
#   9.05, 9.05 s
#100x cols, 100x fewer iterations:
#   3.99, 3.98 s
#500x cols, 500x fewer iterations:
#   3.29, 3.32 s

#from __future__ import division
from numpy import mean, power, exp, log, sum, abs
import numpy as np
from scipy import rand, full, asmatrix
import time
import os

# the fast version, in which x is passed by reference
#
def cols_array(my_m, n_iter):
    for i in xrange(n_iter):
        m1 = mean(my_m, 0) # column means
    m1[0] = 0 # just to avoid complaints
   
def cols_array2(my_m, n_iter):
    my_m = asmatrix(my_m) # not strictly needed, but should be noop
    # the following is valid as long as we assume a fixed matrix size (and not in a general function)
    #v1 = asmatrix(full( (1, my_m.shape[0]), 1.0/my_m.shape[0]))
    v1 = full( (1, my_m.shape[0]), 1.0/my_m.shape[0])
    for i in xrange(n_iter):
        #v1 = asmatrix(full( (1, my_m.shape[0]), 1.0/my_m.shape[0]))        
        #m1 = v1 * my_m
        m1 = np.dot(v1,  my_m)
    m1[0] = 0 # just to avoid complaints
   
def rows_array(my_m, n_iter):
    for i in xrange(n_iter):
        m1 = mean(my_m, 1)  # row means
    m1[0] = 0 # just to avoid complaints
   
def rows_array2(my_m, n_iter):
    my_m = asmatrix(my_m) # not strictly needed, but should be noop
    # the following is valid as long as we assume a fixed matrix size (and not in a general function)
    v1 = asmatrix(full( (my_m.shape[1], 1), 1.0/my_m.shape[1]))
    for i in xrange(n_iter):
        #v1 = asmatrix(full( (my_m.shape[1], 1), 1.0/my_m.shape[1]))
        m1 = my_m * v1  # row means
    m1[0] = 0 # just to avoid complaints

def tic():
    return time.time()
    
def toc(t0):
    print '   {0:.2f} s'.format( time.time() - t0 )


## raising to powers, i.e. 2.1^x
#@profile  #- for:  kernprof -v -l RT_SpeedTest.py
def powers(my_mat, n_iter):
    def __pow__(a, b):
        return( np.exp(np.log(a,b))) 
    
    log21 = log(2.1)
    a1 = a2 = a3 = my_mat
    
    t1 = tic();
    #my_mat = asmatrix(my_mat) - declaring as matrix makes it worse!  (Also, ** doesn't work on matrix)
    for i in xrange(n_iter):  # with 100,000 iterations (and not "asmatrix")
#        a1 = a1 + 2.1 ** my_mat         # 3.7 s  ( error if "asmatrix")
        a1 = a1 + my_mat ** 0.25
    toc(t1)
    t1 = tic()
    for i in xrange(n_iter):  # with 100,000 iterations (and not "asmatrix")
#        a2 = a2 + power(2.1, my_mat)    # 3.7 s  ( 3.9 s if "asmatrix")
        #a2 = a2 + mypow(2.1, my_mat)    # 0.8 s  (essentially no overhead for the function call)
        a2 = a2 + exp(log(my_mat)*0.25)
    toc(t1)
    t1 = tic()

    for i in xrange(n_iter):  # with 100,000 iterations (and not "asmatrix")
#        a3 = a3 + exp(log21 * my_mat)   # 0.7 s  ( 5x faster! )  if asmatrix, its 1.2 s = 3x faster plus everything is slower
        #a3 = a3 + exp(log(2.1) * my_mat)   # 0.8 s  ( still 4.5x faster! )
        a3 = a3 + np.sqrt(np.sqrt(my_mat))
    toc(t1)
#        a4 = my_mat ** 2; # square is fast  (0.16 s)
#        a5 = my_mat ** 3; # cube is slow    (3.46 s)
#        a6 = my_mat * my_mat * my_mat # fast(0.195 s)
#    print sum(abs(a4+a5)) # just to use them
#    print 'a**3 - a*a*a: ', sum(abs(a5-a6))  # 4.64344193574e-15
    print 'a1 - a2: ', sum(abs(a1-a2))  # identical
    print 'a3 - a2: ', sum(abs(a3-a2))  # tiny round-off error (1e-11; or 1e-14 if not co-adding matrices)
    return(sum(abs(a3-a2)))
    
def mypow(a, b):
    return(exp(log(a)* b))
    
def innertest(a, b, n_iter):
    for i in xrange(n_iter):  # with 100,000 iterations (and not "asmatrix")
        m1 = np.inner(a, b)
    m1[0] = 0 # just to avoid complaints
    
def dottest(a, b, n_iter):
    for i in xrange(n_iter):  # with 100,000 iterations (and not "asmatrix")
        m1 = np.dot(a, b)
    m1[0] = 0 # just to avoid complaints
    
# test speed of simulated RTMf.m data
nrows = 13
ncols = 36
n_iter = 626178  # 6,261,780 / 10  (another time SCOPE made 7,560,938 calls)
small_m = (rand(nrows, ncols))  # or rand(13,36)
m_10x_rows = (rand(nrows*10, ncols))  # or rand(130,36)
m_10x_cols = (rand(nrows, ncols*10))  # or rand(13,360)
m_100x_cols = (rand(nrows, ncols*100))  # or rand(13,360)
m_500x_cols = (rand(nrows, ncols*500))  # or rand(13,360)
m3 = (rand(3, 4, 5))


print('Powers')
#t0 = tic()
powers(small_m, 100000)  # 100,000 iterations
#toc(t0)

## INNER vs DOT
#print('Inner:')
#t0 = tic()
#innertest(m_10x_rows, small_m, n_iter)  # 3.9 s
#toc(t0)
#print("\n")
#
#print('Dot:')
#t0 = tic()
#dottest(m_10x_rows, small_m.T, n_iter)  # 3.7 s
#toc(t0)
#print("\n")
#
#
#print('Dot, no transpose:')
#t0 = tic()
#dottest(m_10x_rows, rand(ncols, nrows), n_iter)  # 3.7 s
#toc(t0)
#print("\n")

#print('Small array, many iterations:')
#t0 = tic()
#cols_array(small_m, n_iter*10)  # 10x iterations
#toc(t0)
#
#print('Small array, many iterations, matrix algebra:')
#t0 = tic()
#cols_array2(small_m, n_iter*10)  # 10x iterations
#toc(t0)
#print("\n")
#
##----
#print('10x cols, 10x fewer iterations:')
#t0 = tic()
#cols_array(m_10x_cols, n_iter) # 10x columns
#toc(t0)
#
#print('10x cols, 10x fewer iterations, matrix algebra:')
#t0 = tic()
#cols_array2(m_10x_cols, n_iter)  # 10x rows
#toc(t0)
#print("\n")
#
##----
#print('10x rows, 10x fewer iterations:')
#t0 = tic()
#cols_array(m_10x_rows, n_iter)  # 10x rows
#toc(t0)
#
#print('10x rows, 10x fewer iterations, matrix algebra:')
#t0 = tic()
#cols_array2(m_10x_rows, n_iter)  # 10x rows
#toc(t0)
#print("\n")
#
#print('10x rows, 10x fewer iterations, row sums:')
#t0 = tic()
#rows_array(m_10x_rows, n_iter)  # 10x rows
#toc(t0)
#
#print('10x rows, 10x fewer iterations, row sums, matrix algebra:')
#t0 = tic()
#rows_array2(m_10x_rows, n_iter)  # 10x rows
#toc(t0)
#print("\n")
#
##----
#print('100x cols, 100x fewer iterations:')
#t0 = tic()
#cols_array(m_100x_cols, n_iter/10) # 100x columns, note that the base # of iterations is already max_iter/10 
#toc(t0)
#
#print('100x cols, 100x fewer iterations, matrix algebra:')
#t0 = tic()
#cols_array2(m_100x_cols, n_iter/10)  # 10x iterations
#toc(t0)
#print("\n")
#
##----
#print('500x cols, 500x fewer iterations:')
#t0 = tic()
#cols_array(m_500x_cols, n_iter/50) # 100x columns, note that the base # of iterations is already max_iter/10 
#toc(t0)
#
#print('500x cols, 500x fewer iterations, matrix algebra:')
#t0 = tic()
#cols_array2(m_500x_cols, n_iter/50)  # 10x iterations
#toc(t0)
