
import numpy as np

def sigmoid(x):
    return 1/(1 + np.exp(-x))

#Derivative of the sigmoid function
def sigmoid_prime(x):
    return sigmoid(x)*(1.0 - sigmoid(x))

##the loss is equal to 
z1=0.03
a1= 0.03

z2= -1.15
a2= sigmoid(-1.15)

y  = sigmoid(-1.15)
loss = 1/2*((y- 1)**(2))

##The partial derivative with respect to the weight is
2*(a1-1) * sigmoid_prime(z1)

##The partial derivative with respect to the second weight
2*(a2-1) * sigmoid_prime(z2)

##The partial derivative with respect to the bias
sigmoid_prime(z2)* 2*(a2-1) 
