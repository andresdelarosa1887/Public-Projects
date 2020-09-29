import numpy as np
import scipy.sparse as sparse

n, m, d = 3, 5, 7
gamma = 0.5
X = np.random.random((n, d))
Y = np.random.random((m, d))


Y.shape

X.shape
##Introduction to array broadcasting 


##We need to make the matrices of the same size to work the problem out
##I needtwo new rows on X

m,d = Y.shape
X= np.resize(X, (m,d))
gaussian_kernel= np.exp(-1*np.linalg.norm(X-Y)**2/ (2 * (gamma ** 2)))

##This apprach is wrong. Copy the Idea on the size of Y
def rbf_kernel(X,Y, gamma):
    m,d = Y.shape
    X= np.resize(X, (m,d))
    gaussian_kernel= np.exp(-1*np.linalg.norm(X-Y)**2/ (2 * (gamma ** 2)))
    return gaussian_kernel

##The thing is that in the end  I need a matrix as a result not a scalar
