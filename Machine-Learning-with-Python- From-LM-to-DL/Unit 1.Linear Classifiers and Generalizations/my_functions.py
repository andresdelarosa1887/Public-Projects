msg= "hello_world"

import numpy as np

##Classifier- Im using pegasos
from string import punctuation, digits
import numpy as np
import random
from matplotlib import pyplot as plt


def get_order(n_samples):
    try:
        with open(str(n_samples) + '.txt') as fp:
            line = fp.readline()
            return list(map(int, line.split(',')))
    except FileNotFoundError:
        random.seed(1)
        indices = list(range(n_samples))
        random.shuffle(indices)
        return indices
    
def pegasos_single_step_update(
        feature_vector,
        label,
        L,
        eta,
        current_theta,
        current_theta_0):
    if label*(feature_vector@current_theta + current_theta_0) <= 1:
        current_theta =  (1 - eta*L)*current_theta + eta*label*feature_vector
        current_theta_0 = current_theta_0 + eta*label
    else:
        current_theta =  (1 - eta*L)*current_theta
    return (current_theta, current_theta_0)

def classifier(feature_matrix, labels, T, L):
    pegasos_theta = np.zeros(len(feature_matrix[0])) 
    pegasos_theta_0 = 0
    update_counter = 0
    # updating perceptrons
    for t in range(T):
        for i in get_order(feature_matrix.shape[0]):
            update_counter += 1
            eta = 1/(np.sqrt(update_counter))
            pegasos_theta, pegasos_theta_0 = pegasos_single_step_update(feature_matrix[i],
                                                                        labels[i],
                                                                        L,
                                                                        eta,
                                                                        pegasos_theta,
                                                                        pegasos_theta_0)
    return (pegasos_theta, pegasos_theta_0)


##Classification Function##
def classify(feature_matrix, theta, theta_0):
    result= []
    for i, x in enumerate(feature_matrix): 
        if (np.dot(feature_matrix[i], theta) + theta_0) >0: 
            classification= 1
        else:
            classification= -1 
        result.append(classification)
    return(np.array(result))

def accuracy(preds, targets):
    """
    Given length-N vectors containing predicted and target labels,
    returns the percentage and number of correct predictions.
    """
    return (preds == targets).mean()