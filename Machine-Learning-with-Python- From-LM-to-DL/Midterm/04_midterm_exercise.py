import numpy as np
classification_vector= np.array([-1,-1,-1,-1,-1,1,1,1,1,1])
data_vector= np.array([[0,0], [2,0],[3,0], [0,2],[2,2],[5,1],[5,2],[2,4],[4,4],[5,5]])


def quadratic_kernel(data_vector):
    return np.array((1 + np.dot(data_vector, data_vector.T))**2)


def perceptron_quadratic_kernel(feature_matrix, labels, T):
    # Your code here
    theta_0  = 0
    theta= np.zeros(len(feature_matrix[0])) 
    for epoch in range(T): 
        for i, x in enumerate(feature_matrix):
            kernelized_vector= quadratic_kernel(feature_matrix[i])
            if (labels[i]*(np.dot(kernelized_vector, theta) + theta_0))[1] <= 0:
                theta= theta + (np.dot(labels[i], kernelized_vector))
                theta_0= (theta_0 + labels[i])
                print(theta)
            else:
                theta_0= theta_0
                theta= theta
    return((theta, theta_0))





