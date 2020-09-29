import numpy as np
from sklearn.svm import LinearSVC

# =============================================================================
# Use this documentation https://scikit-learn.org/stable/modules/generated/sklearn.svm.LinearSVC.html
# ##Instatiate the model
# classifier= LinearSVC(random_state=0, C=1)
# classifier.fit(train_x, train_y)
# predictions= classifier.predict(test_x)
# predictions.shape
# #This are the parameters that were used
# classifier.get_params
# =============================================================================


### Functions for you to fill in ###

def one_vs_rest_svm(train_x, train_y, test_x):
    """
    Trains a linear SVM for binary classifciation

    Args:
        train_x - (n, d) NumPy array (n datapoints each with d features)
        train_y - (n, ) NumPy array containing the labels (0 or 1) for each training data point
        test_x - (m, d) NumPy array (m datapoints each with d features)
    Returns:
        pred_test_y - (m,) NumPy array containing the labels (0 or 1) for each test data point
    """
    classifier= LinearSVC(random_state=0, C=0.1)
    classifier.fit(train_x, train_y)
    predictions= classifier.predict(test_x)
    return predictions


##Testing the results with multiples values of C

##A multiclass classification is different from a binary classification (or bernoulli) - But sklearn automatically
    # converts to multiclass classification
def multi_class_svm(train_x, train_y, test_x):
    """
    Trains a linear SVM for multiclass classifciation using a one-vs-rest strategy

    Args:
        train_x - (n, d) NumPy array (n datapoints each with d features)
        train_y - (n, ) NumPy array containing the labels (int) for each training data point
        test_x - (m, d) NumPy array (m datapoints each with d features)
    Returns:
        pred_test_y - (m,) NumPy array containing the labels (int) for each test data point
    """
    classifier= LinearSVC(random_state=0, C=0.1)
    classifier.fit(train_x, train_y)
    predictions= classifier.predict(test_x)
    return predictions


def compute_test_error_svm(test_y, pred_test_y):
    return 1 - np.mean(pred_test_y == test_y)

