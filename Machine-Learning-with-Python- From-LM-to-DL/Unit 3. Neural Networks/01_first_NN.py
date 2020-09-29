import numpy as np

##Given these features
X1= np.array([
    [-1.0],[1.0],[-1.0],[1.0]
    ])
X2= np.array([
    [-1.0],[-1.0], [1.0],[ 1.0]
    ])

w11= np.array([0,  2, -2])
w12= np.array([0, -2,  2])
w21= np.array([0,  2, -2])
w22= np.array([0, -2,  2])

## Given the bias
w01= np.array([0, 1, 1])
w02= np.array([0, 1, 1]) 

##We apply the transformation and evaluate the bias for each case.
##Also in this case we apply the activation function
transformed_vectors= []
for i, x in enumerate(w11):
    f1= 2*(w01[i] + np.dot(w11[i], X1) + np.dot(w21[i], X2))-3
    f2= 2*(w02[i] + np.dot(w12[i], X1) + np.dot(w22[i], X2))-3
    transformed_vector= np.hstack((f1, f2))
    transformed_vectors.append(transformed_vector)
transformed_vectors

##We check if these results are linearly separable (Do they converge?)
classification_vector= np.array([1,
                                 -1,
                                 -1,
                                 1])


data_vector1= transformed_vectors[0]
data_vector2= transformed_vectors[1]
data_vector3= transformed_vectors[2]


##Initialize theta and theta_0 
theta= np.zeros(len(data_vector1[0])) 
##Count the number of errors
errors = []
thetas= []
##Loop it 10 times
epochs = 100
##Loop de Perceptron algorithm to update the weights
for epoch in range(0,epochs): #training part, gradient descent part
    for i, x in enumerate(data_vector2):
        if (classification_vector[i]*(np.dot(data_vector2[i], theta))) <= 1:
            theta= theta + np.dot(classification_vector[i], data_vector2[i])
            error= 1
        else:
            theta= theta
            error=0
    errors.append(error)
    print(errors)

##The three of them never converge so they are not linearly separable


##Using other activation function, they do not converge using the tanh activation function
transformed_vectorstan= []
for i, x in enumerate(w11):
    f1= np.tanh(w01[i] + np.dot(w11[i], X1) + np.dot(w21[i], X2))
    f2= np.tanh(w02[i] + np.dot(w12[i], X1) + np.dot(w22[i], X2))
    transformed_vector= np.hstack((f1, f2))
    transformed_vectorstan.append(transformed_vector)

data_vectortan1= transformed_vectorstan[0]
data_vectortan2= transformed_vectorstan[1]
data_vectortan3= transformed_vectorstan[2]


##Initialize theta and theta_0 
theta= np.zeros(len(data_vector1[0])) 
##Count the number of errors
errors = []
thetas= []
##Loop it 10 times
epochs = 10
##Loop de Perceptron algorithm to update the weights
for epoch in range(0,epochs): #training part, gradient descent part
    for i, x in enumerate(data_vectortan3):
        if (classification_vector[i]*(np.dot(data_vectortan3[i], theta))) <= 1:
            theta= theta + np.dot(classification_vector[i], data_vectortan3[i])
            error= 1
        else:
            theta= theta
            error=0
        errors.append(error)
        
        





