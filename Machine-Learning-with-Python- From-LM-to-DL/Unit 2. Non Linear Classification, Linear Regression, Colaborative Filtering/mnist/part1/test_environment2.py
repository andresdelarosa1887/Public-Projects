import sys
sys.path.append("..")
import utils
from utils import *
import numpy as np
import matplotlib.pyplot as plt
import scipy.sparse as sparse

##Testing the cost function given in the exercise
Y = np.array([1, 1, 1, 1, 1, 1, 1, 1, 1, 1,])
##In this case there are 10 classifications that we need to take into account

X = np.array([
     [ 1, 11, 97, 68, 42,  3, 73, 63, 32, 55, 33],
     [ 1, 25, 78, 68,  1, 70, 21, 60,  7, 11, 29],
     [ 1, 41, 62, 74, 70, 86, 36, 35, 69, 77, 73],
     [ 1, 52, 50, 10, 71, 84, 23, 70, 39, 25, 88],
     [ 1, 90, 83, 71, 65, 72, 88, 64, 32, 35, 40],
     [ 1, 75,  6,  6, 54, 61, 46, 86,  6, 71, 39],
     [ 1, 10, 18, 35, 71, 29, 75, 50, 15, 39, 74],
     [ 1, 58, 21, 94, 99, 36, 65, 46, 18, 87, 47],
     [ 1, 92, 47, 51,  3,  1, 56, 10, 24, 28, 46],
     [ 1, 12,  1, 91, 75, 70, 65, 93, 53, 27, 24]
     ])  

theta= np.array([
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ]) 
temp_parameter=  1.0  
lambda_factor=  0.0001


###Getting the probabilities matrix
def compute_probabilities(X, theta, temp_parameter):
    XT= np.transpose(X)
    theta_x= np.dot(theta, XT)
    theta_x_by_temp= theta_x/temp_parameter
    c= theta_x_by_temp.max(0)
    theta_x_exp= np.exp(theta_x_by_temp - c) 
    theta_sum= np.sum(theta_x_exp, axis=0)
    return (theta_x_exp/ theta_sum)

##Probability matrix of this problem
results= compute_probabilities(X, theta, temp_parameter) #This are the probabilities for each one of the observations so..
np.sum(results, axis=0) ##They make a perfect sum of one satisfying the conditions that we talked earlier.
#Now what do I make with this to make y==j

def compute_cost_function(X, Y, theta, lambda_factor, temp_parameter):
    prob_matrix= compute_probabilities(X, theta, temp_parameter)
    n, m= prob_matrix.shape
    prob_matrix2= sparse.coo_matrix(prob_matrix,(n,len(Y)))
    where_k_i= sparse.coo_matrix.diagonal(prob_matrix2)
    result= np.mean(-np.ma.log(where_k_i)) + (lambda_factor/2 * np.sum(theta**2))
    return where_k_i


###The thing was that didn't need the sparse matrix indext to continue
testing_my_brother= compute_cost_function(X, Y, theta, lambda_factor, temp_parameter)
testing_my_brother



##Testing the sparse matrix function to finally get some answers
prob_matrix= sparse.coo_matrix(results,(10,10))
where_k_i= sparse.coo_matrix.diagonal(prob_matrix)
test= sparse.coo_matrix.eliminate_zeros(prob_matrix)


##This is anoother approach,but IDK the reason why is getting wrong answers
##For each one of the observations what is the mean probability loss
def compute_cost_function(X, Y, theta, lambda_factor, temp_parameter):
    ##Y has three classes that we are trying to predict [0,1,2] and is a 3 by one matrix
    one_hot_y= (np.arange(np.max(Y) + 1) == Y[:, None]).astype(float)
    ##Prediction of y after we apply the softmax squeezing function
    y_pred= compute_probabilities(X, theta, temp_parameter)
    ##We apply the cross entropy loss to evaluate the result of the predictions made by the softmax
    loss= -np.dot(np.log(y_pred), one_hot_y) + (lambda_factor/2 * np.sum(theta**2))
    ##We average the final loss 
    final_loss= np.mean(loss)
    ##Maximun log probability of the yi_j_component
    yi_j_component= np.log(y_pred).max(0)
    return(loss)

###The thing was that didn't need the sparse matrix indext to continue
testing_my_brother2= compute_cost_function(X, Y, theta, lambda_factor, temp_parameter)
