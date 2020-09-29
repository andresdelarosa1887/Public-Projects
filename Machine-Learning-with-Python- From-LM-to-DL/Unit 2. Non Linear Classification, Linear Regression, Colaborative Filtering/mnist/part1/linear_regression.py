import numpy as np
import os

##Creating the identity matrix to answer the questions.

# =============================================================================
# This was the approach that I used to find the solution. 
# Read this link dude https://towardsdatascience.com/linear-regression-from-scratch-with-numpy-implementation-finally-8e617d8e274c
# XT= np.transpose(train_x)
# XTX= np.dot(XT, train_x)
# 
# ##What must be the size of the identity matrix - It has to be the same size as the matrix X transpose dot X 
# XTX.shape
# n, m= XTX.shape
# identm= np.identity(n)
# 
# lmda= 0.01
# RIXTX = np.linalg.inv(XTX + (lmda*identm))
# theta= np.dot(RIXTX, np.dot(XT,train_y))
# pred_y= np.dot(test_x, theta)
# error= test_y- pred_y
# =============================================================================

### Functions for you to fill in ###

def closed_form(X, Y, lambda_factor):
    """
    Computes the closed form solution of linear regression with L2 regularization

    Args:
        X - (n, d + 1) NumPy array (n datapoints each with d features plus the bias feature in the first dimension)
        Y - (n, ) NumPy array containing the labels (a number from 0-9) for each
            data point
        lambda_factor - the regularization constant (scalar)
    Returns:
        theta - (d + 1, ) NumPy array containing the weights of linear regression. Note that theta[0]
        represents the y-axis intercept of the model and therefore X[0] = 1
    """
    # YOUR CODE HERE
    transpose_x= np.transpose(X)
    xtx= np.dot(transpose_x, X)
    n,m= xtx.shape
    identity_matrix= np.identity(n)
    rtxtx= np.linalg.inv(xtx + (lambda_factor*identity_matrix))
    theta= np.dot(rtxtx, np.dot(transpose_x, Y))
    return theta
    raise NotImplementedError

### Functions which are already complete, for you to use ###
def compute_test_error_linear(test_x, Y, theta):
    test_y_predict = np.round(np.dot(test_x, theta))
    test_y_predict[test_y_predict < 0] = 0
    test_y_predict[test_y_predict > 9] = 9
    return 1 - np.mean(test_y_predict == Y)
