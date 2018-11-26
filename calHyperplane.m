%calculate the hyperplane based on logistic regression
function theta = calHyperplane( X, y )

%  Setup the data matrix appropriately, and add ones for the intercept term
[m, n] = size(X);

% Add intercept term to x and X_test
X = [ones(m, 1) X];

% Initialize fitting parameters
initial_theta = zeros(n + 1, 1);

%  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost] = ...
	fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% % Print theta to screen
% fprintf('Cost at theta found by fminunc: %f\n', cost);
% fprintf('theta: \n');
% fprintf(' %f \n', theta);


%% Compute accuracy on our training set
%p = predict(theta, X);

%fprintf('Train Accuracy: %f\n', mean(double(p == y)) * 100);


