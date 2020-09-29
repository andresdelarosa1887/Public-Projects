import numpy as np

classification_vector= np.array([-1,-1,-1,-1,-1,1,1,1,1,1])
data_vector= np.array([[0,0],
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

mistake= np.array([ 
    1,9,10,5,9,11,9,3,1,1
    ])

thetas=[]
thetas0= []
final_theta=0
final_theta0= 0 
for i, x  in enumerate(data_vector):
    theta=classification_vector[i]*mistake[i]*(data_vector[i])
    theta0= mistake[i]*classification_vector[i]
    thetas.append(theta)
    thetas0.append(theta0)
    final_theta += theta
    final_theta0 += theta0


def perceptron(feature_matrix, labels, T):
    # Your code here
    theta_0  = 0
    theta= np.zeros(len(feature_matrix[0])) 
    for epoch in range(T): 
        for i, x in enumerate(feature_matrix):
            if (labels[i]*(np.dot(feature_matrix[i], theta) + theta_0)) <= 0:
                theta= theta + (np.dot(labels[i], feature_matrix[i]))
                theta_0= (theta_0 + labels[i])
                print(theta)
            else:
                theta_0= theta_0
                theta= theta
    return((theta, theta_0))

epochs= 500
perceptron(data_vector, classification_vector,epochs)

