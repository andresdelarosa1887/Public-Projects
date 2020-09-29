import sys
sys.path.append("..")
import utils
from utils import *
import numpy as np
import matplotlib.pyplot as plt
import scipy.sparse as sparse

n, d, k = 3, 5, 7
X = np.arange(0, n * d).reshape(n, d)
Y = np.arange(0, n)
zeros = np.zeros((k, d))
zeros
alpha = 2
temp = 0.2
lambda_factor = 0.5

k, o= zeros.shape
##In this case there are 10 classifications that we need to take into account
def compute_probabilities(X, theta, temp_parameter):
    XT= np.transpose(X)
    theta_x= np.dot(theta, XT)
    theta_x_by_temp= theta_x/temp_parameter
    c= theta_x_by_temp.max(0)
    theta_x_exp= np.exp(theta_x_by_temp - c) 
    theta_sum= np.sum(theta_x_exp, axis=0)
    return (theta_x_exp/ theta_sum)


def compute_cost_function(X, Y, theta, lambda_factor, temp_parameter):
    n,d= X.shape
    M = sparse.coo_matrix(([1]*n, (Y, range(n))), shape=(k,n)).toarray()
    prob_matrix= compute_probabilities(X, theta, temp_parameter)
    n, m= prob_matrix.shape
    prob_matrix2= sparse.coo_matrix(prob_matrix,(n,len(Y)))
    where_k_i= sparse.coo_matrix.diagonal(prob_matrix2)
    result= np.mean(-np.ma.log(where_k_i)) + (lambda_factor/2 * np.sum(theta**2))
    return result

###The thing was that didn't need the sparse matrix indext to continue
testing_my_brother= compute_cost_function(X, Y, zeros, lambda_factor, temp)
testing_my_brother

#This is only one interation of the gradient descent
def run_gradient_descent_iteration(X, Y, theta, alpha, lambda_factor, temp_parameter):
    n,d= X.shape
    k, o= theta.shape
    M = sparse.coo_matrix(([1]*n, (Y, range(n))), shape=(k,n)).toarray()
    predictions = compute_probabilities(X, theta, temp_parameter)
    front_part= (1/(len(Y)*temp_parameter))
    regularization_parameter= lambda_factor*theta
    theta= theta - (alpha*((-front_part*(M-predictions).dot(X)) + regularization_parameter))
    return (theta)



run_gradient_descent_iteration(X, Y, zeros, alpha, lambda_factor, temp)

##Unpacking the thetas obtained from the regression##
import gzip
import pickle

##These are the iterations of the thetas in each epoch to give the final result
with gzip.open('theta.pkl.gz', 'rb') as f:
    thetas = pickle.load(f)
    



