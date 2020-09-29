import sys
sys.path.append("..")
import utils
from utils import *
import numpy as np
import matplotlib.pyplot as plt
import scipy.sparse as sparse

##Given Parameters
n, d, k = 3, 5, 7
X = np.arange(0, n * d).reshape(n, d)
X
Y = np.arange(0, n)

zeros = np.zeros((k, d))
temp = 0.2
lambda_factor = 0.5
exp_res = 1.9459101490553135

##Shape audit and transformations

##How many categories do I have. I have three categories that I want to predict using a softmax 
# multiclassification algorithm
Y.shape 
Y

def compute_probabilities(X, theta, temp_parameter):
    XT= np.transpose(X)
    theta_x= np.dot(theta, XT)
    theta_x_by_temp= theta_x/temp_parameter
    c= theta_x_by_temp.max(0)
    theta_x_exp= np.exp(theta_x_by_temp - c) 
    theta_sum= np.sum(theta_x_exp, axis=0)
    return (theta_x_exp/ theta_sum)





#But we have to represent it as a one hot vector - I don't know very much about this... 
one_hot_y = (np.arange(np.max(Y) + 1) == Y[:, None]).astype(float)













##Taking into account the indicartor variable and seeing if its 
##We need to think about including this indicator variable to get the ecuations of the loss
for i, x in enumerate(Y): 
    if k[i] ==1 then:
        indicator=1
    else:
        indicator=0




##We need to take into account when y=k, how we evaluate the error 
##Feed forward of the multiclassification softmax regression
def compute_cost_function(X, Y, theta, lambda_factor, temp_parameter):
    ##Y has three classes that we are trying to predict [0,1,2] and is a 3 by one matrix
    one_hot_y= (np.arange(np.max(Y) + 1) == Y[:, None]).astype(float)
    ##Prediction of y after we apply the softmax squeezing function
    y_pred= compute_probabilities(X, theta, temp_parameter)
    ##We apply the cross entropy loss to evaluate the result of the predictions made by the softmax
    loss= -np.dot(np.log(y_pred), one_hot_y) 
    ##We average the final loss 
    final_loss= np.mean(loss) + (lambda_factor/2 * sum(theta**2))
    ##Maximun log probability of the yi_j_component
    yi_j_component= np.log(y_pred).max(0)
    return(y_pred, one_hot_y, final_loss, yi_j_component)



prediction_result= compute_cost_function(X, Y, zeros, lambda_factor, temp)
prediction_result


##Feed forward of the multiclassification softmax regression
def compute_cost_function(X, Y, theta, lambda_factor, temp_parameter):
    ##Y has three classes that we are trying to predict [0,1,2] and is a 3 by one matrix
    one_hot_y= (np.arange(np.max(Y) + 1) == Y[:, None]).astype(float)
    ##Prediction of y after we apply the softmax squeezing function
    y_pred= compute_probabilities(X, theta, temp_parameter)
    ##We apply the cross entropy loss to evaluate the result of the predictions made by the softmax
    loss= -np.dot(np.log(y_pred), one_hot_y) 
    ##We average the final loss 
    final_loss= np.mean(loss) + (lambda_factor/2 * sum(theta**2)) 
    ##Maximun log probability of the yi_j_component
    yi_j_component= np.log(y_pred).max(0)
    return(y_pred, one_hot_y, final_loss, yi_j_component)

sum(theta**2)

prediction_result= compute_cost_function(X, Y, zeros, lambda_factor, temp)
prediction_result

##Just testing the regularization parameter
##These are the values that I need to evaluate.
n, d, k = 3, 5, 7
X = np.arange(0, n * d).reshape(n, d)
zeros = np.zeros((k, d))
temp = 0.2
theta = np.arange(0, k * d).reshape(k, d)
temp_parameter = 0.2



two= (lambda_factor/2)  # This is an scalar
one= np.sum(theta**2)
two * np.sum(theta**2, axis=0)


#But now I have to take into account the regularization part



#Making sure that they can be multiplied
prediction_result.shape
one_hot_y.shape



##For each class we sum the number of probabilities. 
##This is the objective- computing a cost function for  a multinomial softmax regression with ridge regularization
##We have many images with different classifications. 

def compute_probabilities(X, theta, temp_parameter):
    XT= np.transpose(X)
    theta_x= np.dot(theta, XT)
    theta_x_by_temp= theta_x/temp_parameter
    c= theta_x_by_temp.max(0)
    theta_x_exp= np.exp(theta_x_by_temp - c) 
    theta_sum= np.sum(theta_x_exp, axis=0)
    return (theta_x_exp/ theta_sum)


##Which is called a cross-entropy function: 

        
        
    #YOUR CODE HERE
        





###This is the regularization part


theta**2
sum(theta**2)


# =============================================================================
# ##Some theory about the softmax probabilities.
    # read this documentation https://medium.com/data-science-bootcamp/understand-the-softmax-function-in-minutes-f3a59641e86d
##For each one of the X in the array compute this probability and then create a matrix. 
##Generally it is done in this way


##Answer to the excercise
##It is necessary to transpose the matrix
XT= np.transpose(X)
##Multiplicate the theta values with the X matrix
theta.shape
X.shape

##We have a set of parameters that have the size 7 observations and 5 columns 
##A set of factors that are equal to 5 columns and 3 observations




theta_x= np.dot(theta, XT)
#Divided by the temperature
theta_x_by_temp= theta_x/temp_parameter
# Find the maximum values for each row. The terms that are used on the exponent may get to large, this can cause numerical or overflow errors.
#To deal with this we subtract some fixed amount c from each exponent to keep 
c= theta_x_by_temp.max(0)
#Calculate the exponential of the difference of the transformed matrix and the c parameter
theta_x_exp= np.exp(theta_x_by_temp - c) 
##It has to be the sum of the columns
theta_sum= np.sum(theta_x_exp, axis=0) 
##Matrix of probabilities - I  already implemented the softmax on X
theta_x_exp/ theta_sum

##Understanding the result that this gives me 







