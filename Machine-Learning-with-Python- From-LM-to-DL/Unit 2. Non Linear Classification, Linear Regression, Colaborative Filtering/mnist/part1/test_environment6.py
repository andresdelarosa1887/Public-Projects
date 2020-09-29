import sys
import numpy as np
import matplotlib.pyplot as plt
sys.path.append("..")
from utils import *
from linear_regression import *
from svm import *
from softmax import *
from features import *
from kernel import *


##Given the following parameters
X = np.array([
        [1, 2, 3],
        [2, 4, 6],
        [3, 6, 9],
        [4, 8, 12],
    ])
n_components = 2
##Understanding Principal Components Analysis. These two functions were given. 
def center_data(X):
    feature_means = X.mean(axis=0)
    return (X - feature_means), feature_means

def principal_components(centered_data):
    scatter_matrix = np.dot(centered_data.transpose(), centered_data)
    eigen_values, eigen_vectors = np.linalg.eig(scatter_matrix)
    # Re-order eigenvectors by eigenvalue magnitude:
    idx = eigen_values.argsort()[::-1]
    eigen_values = eigen_values[idx]
    eigen_vectors = eigen_vectors[:, idx]
    return eigen_vectors

def project_onto_PC(X, pcs, n_components, feature_means):
    x_centered, feature_means = center_data(X)
    n,m = X.shape
    X_pca = np.dot(x_centered, pcs)
    return X_pca[0:n, 0:n_components]


##Trying the MINST regression using the given components
train_x, train_y, test_x, test_y = get_MNIST_data()

def center_data(X):
    feature_means = X.mean(axis=0)
    return (X - feature_means)

def principal_components(centered_data):
    scatter_matrix = np.dot(centered_data.transpose(), centered_data)
    eigen_values, eigen_vectors = np.linalg.eig(scatter_matrix)
    # Re-order eigenvectors by eigenvalue magnitude:
    idx = eigen_values.argsort()[::-1]
    eigen_values = eigen_values[idx]
    eigen_vectors = eigen_vectors[:, idx]
    return eigen_vectors

#principal_components(center_data(train_x))
def project_onto_PC(X, n_components):
    data_centered = center_data(X)
    pcs= principal_components(data_centered)
    x_centered = center_data(X)
    n,m = X.shape
    X_pca = np.dot(x_centered, pcs)
    return X_pca[0:n, 0:n_components]

test_x_pca = project_onto_PC(test_x, n_components)
train_x_pca= project_onto_PC(train_x, n_components)

def run_softmax_on_MNIST_using_PCA(temp_parameter=1):
    n_components = 18
    train_x, train_y, test_x, test_y = get_MNIST_data()
    train_x_pca = project_onto_PC(train_x, n_components)
    test_x_pca = project_onto_PC(test_x, n_components)
    theta, cost_function_history = softmax_regression(train_x_pca, train_y,
                                                      temp_parameter, alpha=0.3,
                                                      lambda_factor=1.0e-4, k=10,
                                                      num_iterations=150)
    plot_cost_function_over_time(cost_function_history)
    test_error = compute_test_error(test_x_pca,
                                    test_y, theta,
                                    temp_parameter)
    return test_error


print('softmax PCA using test_error=', run_softmax_on_MNIST_using_PCA(temp_parameter=1))









##Dimensionality Reduction using Principal Component Analysis-- Other Approach
train_x_centered, feature_means = center_data(X)
pcs = principal_components(train_x_centered)


##Mean of each feature 
feature_means= np.mean(X, axis=0)

##Center of the data
data_center= X - feature_means

##Covariance of the matrix in order to check the covariance score for each column with respect to the actual column
cov_matrix= np.cov(data_center)
eigenval, eigenvec = np.linalg.eig(cov_matrix)
significance = [np.abs(i)/np.sum(eigenval) for i in eigenval]

#Plotting the Cumulative Summation of the Explained Variance
plt.figure()
plt.plot(np.cumsum(significance))
plt.xlabel('Number of Components')
plt.ylabel('Variance (%)') #for each component
plt.title('Pulsar Dataset Explained Variance')
plt.show()





