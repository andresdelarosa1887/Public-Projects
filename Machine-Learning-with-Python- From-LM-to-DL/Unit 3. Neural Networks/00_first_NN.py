import numpy as np

feature_set = np.array([[0,1,0],
                        [0,0,1],
                        [1,0,0],
                        [1,1,0],
                        [1,1,1]])

##Labels that we are trying to predict
labels = np.array([[1,0,0,1,1]])
labels = labels.reshape(5,1)

##Defining weight and randomness
np.random.seed(42)
weights = np.random.rand(3,1)

bias = np.random.rand(1)
weights.shape
feature_set.shape
# feedforward step1
XW = np.dot(feature_set, weights) + bias
weights
#feedforward step2
z = sigmoid(XW)

