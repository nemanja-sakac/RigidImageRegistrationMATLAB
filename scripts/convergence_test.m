%%
% Convergence tests for steepest gradient descent and nonlinear
% conjugate-gradient descent optimization with variable z-normalization
% parameters

%%
% Load images
% Reference image
ref_im = double(imread('REG_HE.png'));
% Test image
test_im = double(imread('REG_LE_05.PNG'));

%%
% Extract ROI (region-of-interest)
rows = [round(0.15 * size(ref_im, 1)), round(0.85 * size(ref_im, 1))];
columns = [round(0.10 * size(ref_im, 2)), round(0.90 * size(ref_im, 2))];
roi = [rows; columns];

%%
% z-norm parameters for testing
gauss_widths = [5, 10, 20, 30];
gauss_sds = [5, 10, 20];
thresh = [1, 5, 10];

% Objective function optimum array with given translation parameters
optimum_params_sgd = [];
optimum_params_pr = [];


% Test optimization for different values of Guassian kernel widths, 
% standard deviations and thresholds
for l = 1:length(gauss_widths)
    for m = 1:length(gauss_sds)
        for n = 1:length(thresh)
            
            % Z-normalization parameter values for the given test
            z_params = [gauss_widths(l), gauss_sds(m), thresh(n)];
             
            % Find optimum parameters using steepest gradient descent (SGD)
            % Measure time
            tic
            [opt_param_sgd, ~, n_iter_sgd] = rig_reg(ref_im, test_im,...
                roi, z_params, 'method', 'vanilla');
            time_sgd = toc;
            
            optimum_params_sgd = [optimum_params_sgd; z_params, opt_param_sgd,...
                n_iter_sgd, time_sgd];
            
            
            % Find optimum parameters using Polak-Ribiere
            % Measure time
            tic
            [opt_param_pr, ~, n_iter_pr] = rig_reg(ref_im, test_im,...
                roi, z_params, 'method', 'polak-ribiere');
            time_pr = toc;
            
            optimum_params_pr = [optimum_params_pr; z_params, opt_param_pr,...
                n_iter_pr, time_pr];
        end
    end
end

%%
% Calculating the Euclidean distance between the optimum values and values 
% found by optimization

% Optimum parameters found by exhaustive search over a grid
optimum_xy = [8.3, -0.6];

% Parameters found by optimization
points_sgd = optimum_params_sgd(:, [4, 5]);
points_pr = optimum_params_pr(:, [4, 5]);

% SGD Euclidean distance
distance_sgd = sqrt((points_sgd(:, 1) - optimum_xy(1)) .^2 ...
    + (points_sgd(:, 2) - optimum_xy(2)) .^2);
optimum_params_sgd(:, 8) = distance_sgd;
% Polak-Ribiere Euclidean distance
distance_pr = sqrt((points_pr(:, 1) - optimum_xy(1)) .^2 ...
    + (points_pr(:, 2) - optimum_xy(2)) .^2);
optimum_params_pr(:, 8) = distance_pr;
