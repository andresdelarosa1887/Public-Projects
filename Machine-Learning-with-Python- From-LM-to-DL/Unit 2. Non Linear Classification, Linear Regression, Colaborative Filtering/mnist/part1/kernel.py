import numpy as np

### Functions for you to fill in ###
##This is the Polynomial Kernel Exercise

def polynomial_kernel(X, Y, c, p):
    """
        Compute the polynomial kernel between two matrices X and Y::
            K(x, y) = (<x, y> + c)^p
        for each pair of rows x in X and y in Y.

        Args:
            X - (n, d) NumPy array (n datapoints each with d features)
            Y - (m, d) NumPy array (m datapoints each with d features)
            c - a coefficient to trade off high-order and low-order terms (scalar)
            p - the degree of the polynomial kernel

        Returns:
            kernel_matrix - (n, m) Numpy array containing the kernel matrix
    """
    #X= X.shape
    #Y= Y.shape
    polynomial_kernel= (c + np.dot(X, Y.T)) ** p
    return polynomial_kernel



def rbf_kernel(X, Y, gamma):
    """
        Compute the Gaussian RBF kernel between two matrices X and Y::
            K(x, y) = exp(-gamma ||x-y||^2)
        for each pair of rows x in X and y in Y.

        Args:
            X - (n, d) NumPy array (n datapoints each with d features)
            Y - (m, d) NumPy array (m datapoints each with d features)
            gamma - the gamma parameter of gaussian function (scalar)

        Returns:
            kernel_matrix - (n, m) Numpy array containing the kernel matrix
    """
    m,d = Y.shape
    X= np.resize(X, (m,d))
    gaussian_kernel= np.exp(-1*np.linalg.norm(X-Y)**2/ (2 * (gamma ** 2)))
    return gaussian_kernel
# =============================================================================
# 
#     K = np.zeros((X.shape[0],Y.shape[0]))
#     for i,x in enumerate(X):
#         for j,y in enumerate(Y):
#             K[i,j] = np.exp(-1*np.linalg.norm(x-y)**2/ (2 * (gamma ** 2)))
#     return K
# =============================================================================

