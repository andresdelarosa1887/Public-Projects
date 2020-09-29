import numpy as np
from sklearn.svm import LinearSVC

##Changing Labels to see the results
n, d, k = 3, 5, 7
X = np.arange(0, n * d).reshape(n, d)
Y = np.arange(0, n)
zeros = np.zeros((k, d))
zeros
alpha = 2
temp = 0.2
lambda_factor = 0.5

def update_y(train_y, test_y):
    train_y_mod3= np.mod(train_y, 3)
    test_y_mod3= np.mod(test_y, 3)
    return (train_y_mod3, test_y_mod3)

def compute_test_error_mod3(X, Y, theta, temp_parameter):
    error_count = 0.
    assigned_labels = get_classification(X, theta, temp_parameter)
    mod_3_labels= np.mod(assigned_labels, 3)
    return 1 - np.mean(mod_3_labels == Y)


def run_softmax_on_MNIST_mod3(temp_parameter=1):
    train_x, train_y, test_x, test_y = get_MNIST_data()
    train_y, test_y= update_y(train_y, test_y)
    theta, cost_function_history = softmax_regression(train_x, train_y, temp_parameter, alpha=0.3,
                                                      lambda_factor=1.0e-4, k=10, num_iterations=150)
    plot_cost_function_over_time(cost_function_history)
    test_error = compute_test_error_mod3(test_x, test_y, theta, temp_parameter)
    # Save the model parameters theta obtained from calling softmax_regression to disk.
    write_pickle_data(theta, "./theta.pkl.gz")
    # TODO: add your code here for the "Using the Current Model" question in tab 4.
    #      and print the test_error_mod3
    return test_error

print('softmax test_error=', run_softmax_on_MNIST(temp_parameter=1))



