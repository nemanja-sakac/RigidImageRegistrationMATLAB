%%
% Calculating the Euclidean distance between the optimum values and values 
% found by optimization - C++

% Optimum parameters found by exhaustive search over a grid
optimum_xy = [8.3, -0.6];

% Parameters found by optimization
points_sgd = optimum_params_sgd_cpp(:, [4, 5]);
points_pr = optimum_params_pr_cpp(:, [4, 5]);

% SGD Euclidean distance
distance_sgd = sqrt((points_sgd(:, 1) - optimum_xy(1)) .^2 ...
    + (points_sgd(:, 2) - optimum_xy(2)) .^2);
optimum_params_sgd_cpp(:, 9) = distance_sgd;
% Polak-Ribiere Euclidean distance
distance_pr = sqrt((points_pr(:, 1) - optimum_xy(1)) .^2 ...
    + (points_pr(:, 2) - optimum_xy(2)) .^2);
optimum_params_pr_cpp(:, 9) = distance_pr;

%%
% Scale execution time to seconds
optimum_params_sgd_cpp(:, 8) = optimum_params_sgd_cpp(:, 8) / 1000;
optimum_params_pr_cpp(:, 8) = optimum_params_pr_cpp(:, 8) / 1000;