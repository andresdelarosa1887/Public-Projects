
import numpy as np

##The size that you use to put the matrix inside the model is important.. 
##Important functions
def rectified_linear_unit(x):
    """ Returns the ReLU of x, or the maximum between 0 and x."""
    # TODO
    return np.maximum(0, x)

def rectified_linear_unit_derivative(x):
    """ Returns the derivative of ReLU."""
    if x>0:
        return 1 
    else: 
        return 0
    
relu= np.vectorize(rectified_linear_unit)
relu_dev = np.vectorize(rectified_linear_unit_derivative)
##In this case we are using np matrix instead of numpy array
input_to_hidden_weights = np.matrix('1 1; 1 1; 1 1')
hidden_to_output_weights = np.matrix('1 1 1')
biases = np.matrix('0; 0; 0')

##Converting into numpy arrays
input_to_hidden_weights = np.array(input_to_hidden_weights).astype('float64')
hidden_to_output_weights = np.array(hidden_to_output_weights).astype('float64')
biases = np.array(biases).astype('float64')


##To have the points in a shape that your model can handle you have to unpack them 
## Here the points are x1, x2, y
training_points = [((2,1), 10), ((3,3), 21), ((4,5), 32), ((6, 6), 42)]

##Using the testing points
input_values = np.matrix([[2],[1]]) # 2 by 1
y= 10
## Converting them into numpy matrices
input_values = np.array([[2],[1]]).astype('float64') 
learning_rate = .001

##Feedforward
hidden_layer_weighted_input= np.dot(input_to_hidden_weights, input_values) + biases # TODO (3 by 1 matrix)
hidden_layer_activation= relu(hidden_layer_weighted_input) # TODO (3 by 1 matrix) 
hidden_to_output= np.dot(hidden_to_output_weights, hidden_layer_activation)  
output =  hidden_to_output # TODO 1x1 
activated_output = relu(hidden_to_output)  # TODO 1X1


##Backpropagation 
##Definition of errors
output_layer_error = (y- activated_output) * relu_dev(hidden_to_output) 
hidden_layer_error = output_layer_error * relu_dev(hidden_layer_weighted_input)  # TODO (3 by 1 matrix)


##Computing the gradients (Derivatives)
bias_gradients = (y- activated_output)* relu_dev(hidden_layer_weighted_input)
hidden_to_output_weight_gradients = output * (y- activated_output)* relu_dev(activated_output) 


##These are the components of the change in the cost with respect to the first weights
#Put names to the derivatives bro
input_values
relu(hidden_layer_weighted_input)
hidden_to_output_weights
relu_dev(hidden_to_output)
(y- activated_output)

##Testing the result must be the same size of the input_to_hidden_weights (3,2)
input_to_hidden_weight_gradients= (np.dot(np.dot(relu_dev(hidden_layer_weighted_input), input_values.T).T, relu_dev(hidden_to_output_weights.T)) * relu_dev(hidden_to_output) * ((y- activated_output))).T

new_biases = biases - (learning_rate*bias_gradients)
new_input_to_hidden_weights = input_to_hidden_weights  - (learning_rate*input_to_hidden_weight_gradients) 
new_hidden_to_output_weights =  hidden_to_output_weights - (learning_rate*hidden_to_output_weight_gradients)   
    
    
    
##Test this shit tomorrow
def train(self, x1, x2, y):
    ### Forward propagation ###
    input_values = np.matrix([[x1],[x2]]) # 2 by 1

    # Calculate the input and activation of the hidden layer
    hidden_layer_weighted_input = np.dot(input_to_hidden_weights, input_values) + biases # TODO (3 by 1 matrix)
    hidden_layer_activation = relu(hidden_layer_weighted_input)  # TODO (3 by 1 matrix)
    hidden_to_output= np.dot(hidden_to_output_weights, hidden_layer_activation)  # TODO 1x1 

    output =  hidden_to_output # TODO 1x1 
    activated_output = relu(hidden_to_output)  # TODO 1X1

    ### Backpropagation ###
    # Compute gradients
    output_layer_error = (activated_output -y) * relu_dev(hidden_to_output) # TODO
    hidden_layer_error = output_layer_error * relu_dev(hidden_layer_weighted_input)  # TODO (3 by 1 matrix)

    bias_gradients = (hidden_layer_activation-y)* relu_dev(hidden_layer_weighted_input)
    hidden_to_output_weight_gradients =  output * (activated_output-y)* relu_dev(activated_output) 
    input_to_hidden_weight_gradients = (np.dot(np.dot(relu_dev(hidden_layer_weighted_input), input_values.T).T, relu_dev(hidden_to_output_weights.T)) * relu_dev(hidden_to_output) * (activated_output-y)).T

    # Use gradients to adjust weights and biases using gradient descent
    self.biases = biases - (learning_rate*bias_gradients)
    self.input_to_hidden_weights = input_to_hidden_weights  - (learning_rate*input_to_hidden_weight_gradients) 
    self.hidden_to_output_weights =  hidden_to_output_weights - (learning_rate*hidden_to_output_weights_gradients)         # TODO