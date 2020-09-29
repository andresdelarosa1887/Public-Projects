import numpy as np
from sklearn.svm import LinearSVC


##Trying different C. For the next one please use GridSearch and create a Pipeline for hyperparamethers

##Using the one vs rest algorithm
def one_vs_rest_svm(train_x, train_y, test_x):
    classifier= LinearSVC(random_state=0, C=5)
    classifier.fit(train_x, train_y)
    predictions= classifier.predict(test_x)
    return predictions

def run_svm_one_vs_rest_on_MNIST():
    train_x, train_y, test_x, test_y = get_MNIST_data()
    train_y[train_y != 0] = 1 ##Maybe the data has some errors that they are changing this part
    test_y[test_y != 0] = 1
    pred_test_y = one_vs_rest_svm(train_x, train_y, test_x)
    test_error = compute_test_error_svm(test_y, pred_test_y)
    return test_error
print('SVM one vs. rest test_error:', run_svm_one_vs_rest_on_MNIST())


### Using the Multiclasss algorithm
def multi_class_svm(train_x, train_y, test_x):
    classifier= LinearSVC(random_state=0, C=1)
    classifier.fit(train_x, train_y)
    predictions= classifier.predict(test_x)
    return predictions


def run_multiclass_svm_on_MNIST():
    train_x, train_y, test_x, test_y = get_MNIST_data()
    pred_test_y = multi_class_svm(train_x, train_y, test_x)
    test_error = compute_test_error_svm(test_y, pred_test_y)
    return test_error
print('Multiclass SVM test_error:', run_multiclass_svm_on_MNIST())

