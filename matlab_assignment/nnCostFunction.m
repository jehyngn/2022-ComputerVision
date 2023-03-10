function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


% Part 1:

% Number of datapoints
m = size(X, 1); 


% Feedforward Propagation
hx = predict(Theta1, Theta2, X);



% Whereas the original labels in the variable y) were 1, 2, ..., 10, for the purpose of training a neural
% network, we need to recode the labels as vectors containing only values 0 or 1
% http://stackoverflow.com/questions/5904488/use-a-vector-as-an-index-to-a-matrix-in-matlab
old_y = y;
y = zeros(size(old_y, 1), size(Theta2, 1));
y(sub2ind(size(y), 1:size(old_y, 1), old_y')) = 1; 

% Compute J, the cost function
J = (-1/m) * sum(sum(y.*log(hx), 2) + sum((1-y).*log(1-hx),2));
J = J + (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)))* lambda/(2*m);
% Part 2: implement backpropagation

z = [ones(m, 1) X] * Theta1';
d3 = (hx-y);
d2 = (Theta2(:, 2:end)' * d3') .* sigmoidGradient(z)';
D1 = d2 * [ones(m, 1) X];
D2 = d3' * [ones(m, 1), sigmoid([ones(m, 1) X]*Theta1')];

                                 
% Part 3: regularization term

% -------------------------------------------------------------

reg1 = lambda * [zeros(size(Theta1, 1), 1) Theta1(:,2:end)];
reg2 = lambda * [zeros(size(Theta2, 1), 1) Theta2(:,2:end)];
 
Theta1_grad = (1/m)*(D1 + reg1); 
Theta2_grad = (1/m)*(D2 + reg2);
% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end