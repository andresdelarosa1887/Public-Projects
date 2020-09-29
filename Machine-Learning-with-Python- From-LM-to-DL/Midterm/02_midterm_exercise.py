from sklearn import svm
import numpy as np

classification_vector= np.array([-1,
                                 -1,
                                 -1,
                                 -1, 
                                 -1,
                                  1,
                                  1,
                                  1,
                                  1,
                                  1])

data_vector= np.array([
        [0,0],
        [2,0],
        [3,0],
        [0,2],
        [2,2],
        [5,1],
        [5,2],
        [2,4],
        [4,4],
        [5,5]
])

clf= svm.LinearSVC(C=1, loss='hinge', penalty='l2')
clf2= svm.LinearSVC()

clf.fit(data_vector, classification_vector)

clf.coef_
clf.intercept_
clf.get_params



## Using the parameters theta_0 and theta corresponding to the maximun margin separator,
#What is the sum of the hinge loses 

def hinge_loss_full(feature_matrix, labels, theta, theta_0):
    total_loss=[]
    for i, x in enumerate(feature_matrix):
        if (labels[i]*(np.dot(theta, feature_matrix[i]) + theta_0)) >= 1:
            loss= 0
        else: 
            loss= 1 - (labels[i]*(np.dot(theta, feature_matrix[i])+ theta_0))
        total_loss.append(loss)
    return sum(total_loss)


hinge_loss_full(data_vector, classification_vector, clf.coef_, clf.intercept_ )

##Dividing theta and theta 0 by two
hinge_loss_full(data_vector, classification_vector, (clf.coef_/2), (clf.intercept_/2))
