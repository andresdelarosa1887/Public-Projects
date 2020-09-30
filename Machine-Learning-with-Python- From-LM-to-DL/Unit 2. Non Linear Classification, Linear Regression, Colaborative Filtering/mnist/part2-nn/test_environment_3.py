
import numpy as np

class NeuralNetwork():
    def __init__(self):
        # DO NOT CHANGE PARAMETERS
        self.input_to_hidden_weights = np.matrix('1 1; 1 1; 1 1')
        self.hidden_to_output_weights = np.matrix('1 1 1')
        self.biases = np.matrix('0; 0; 0')
        self.learning_rate = .001
        self.epochs_to_train = 10
        self.training_points = [((2, 1), 10), ((3, 3), 21), ((4, 5), 32), ((6, 6), 42)]
        self.testing_points = [(1,1), (2,2), (3,3), (5,5), (10,10)]

    def train(self, x1, x2, y):        
        def rectified_linear_unit(x):
            return np.maximum(0, x)
        def rectified_linear_unit_derivative(x):
            if x>0:
                return 1 
            else: 
                return 0
            
        ### Forward propagation ###
        input_values = np.matrix([[x1],[x2]]) # 2 by 1
        input_values = np.array([[x1],[x2]]).astype('float64') 
        ##Converting to numpy array
        self_input_to_hidden_weights = np.array(self.input_to_hidden_weights).astype('float64')
        self_hidden_to_output_weights = np.array(self.hidden_to_output_weights).astype('float64')
        self_biases = np.array(self.biases).astype('float64')
        #Activation functions
        relu= np.vectorize(rectified_linear_unit)
        relu_dev = np.vectorize(rectified_linear_unit_derivative)
        
        # Calculate the input and activation of the hidden layer
        hidden_layer_weighted_input = np.dot(self_input_to_hidden_weights, input_values) + self_biases # TODO (3 by 1 matrix)
        hidden_layer_activation = relu(hidden_layer_weighted_input)  # TODO (3 by 1 matrix)
        hidden_to_output= np.dot(self_hidden_to_output_weights, hidden_layer_activation)  # TODO 1x1 

        output =  hidden_to_output # TODO 1x1 
        activated_output = relu(hidden_to_output)  # TODO 1X1

        ### Backpropagation ###
        # Compute gradients
        output_layer_error = (y- activated_output) * relu_dev(hidden_to_output) 
        hidden_layer_error = output_layer_error * relu_dev(hidden_layer_weighted_input)  # TODO (3 by 1 matrix)

        bias_gradients = (y- activated_output)* relu_dev(hidden_layer_weighted_input)
        hidden_to_output_weight_gradients =  output * (y- activated_output)* relu_dev(activated_output) 
        input_to_hidden_weight_gradients = (np.dot(np.dot(relu_dev(hidden_layer_weighted_input), input_values.T).T, relu_dev(self_hidden_to_output_weights.T)) * relu_dev(hidden_to_output) * (y- activated_output)).T

        # Use gradients to adjust weights and biases using gradient descent
        new_biases = self_biases - (self.learning_rate*bias_gradients)
        new_input_to_hidden_weights = self_input_to_hidden_weights  - (self.learning_rate*input_to_hidden_weight_gradients) 
        new_hidden_to_output_weights =  self_hidden_to_output_weights - (self.learning_rate*hidden_to_output_weight_gradients) 

        ##This goes at the end to convert back the matrices
        #And at the end, I convert back after calculating the new biases and weights:
        self.biases = np.matrix(new_biases)
        self.input_to_hidden_weights = np.matrix(new_input_to_hidden_weights)
        self.hidden_to_output_weights =  np.matrix(new_hidden_to_output_weights)
    

    # Run this to train your neural network once you complete the train method
    def train_neural_network(self):
        print('Training pairs:  ', self.training_points)
        print('Starting params:  ')
        print('')
        print('(Input --> Hidden Layer) Weights:  ', self.input_to_hidden_weights)
        print('(Hidden --> Output Layer) Weights:  ', self.hidden_to_output_weights)
        print('Biases:  ', self.biases)
        for epoch in range(self.epochs_to_train):
            print('')
            print('Epoch  ', epoch)
        for x,y in self.training_points:
            self.train(x[0], x[1], y)
            print('(Input --> Hidden Layer) Weights:  ', self.input_to_hidden_weights)
            print('(Hidden --> Output Layer) Weights:  ', self.hidden_to_output_weights)
            print('Biases:  ', self.biases)


##Testing the Neural Network
x = NeuralNetwork()
x.train_neural_network()
    
    
    