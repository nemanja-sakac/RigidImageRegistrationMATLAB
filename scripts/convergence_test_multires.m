%%
% Convergence tests for steepest gradient descent and nonlinear
% conjugate-gradient descent optimization with variable z-normalization
% parameters using a multiresolution approach

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


% Pyramid levels for which evaluation is taking place
pyr_lvls = [1, 2, 3, 4];
pyr_opt_sgd = cell(1, length(pyr_lvls));
pyr_opt_pr = cell(1, length(pyr_lvls));

% Test optimization for different values of Guassian kernel widths, 
% standard deviations and thresholds

for pyr_lvl = 1:length(pyr_lvls)
    % ----------------------------------
    % Objective function optimum array with given translation parameters
    optimum_params_pr = [];
    optimum_params_sgd = [];

    for l = 1:length(gauss_widths)
        for m = 1:length(gauss_sds)
            for n = 1:length(thresh)

                % Z-normalization parameter values for the given test
                z_params = [gauss_widths(l), gauss_sds(m), thresh(n)];

                % Find optimum parameters using steepest gradient descent (SGD)
                % Measure time
                tic
                [opt_param_sgd, ~, n_iter_sgd] = multires_rig_reg(ref_im, test_im,...
                    roi, pyr_lvl, z_params, 'method', 'vanilla');
                time_sgd = toc;

                % Place optimum parameters in cells

                optimum_params_sgd = [optimum_params_sgd; z_params, opt_param_sgd,...
                    n_iter_sgd, time_sgd];


                % Find optimum parameters using Polak-Ribiere
                % Measure time
                tic
                [opt_param_pr, ~, n_iter_pr] = multires_rig_reg(ref_im, test_im,...
                    roi, pyr_lvl, z_params, 'method', 'polak-ribiere');
                time_pr = toc;

                optimum_params_pr = [optimum_params_pr; z_params, opt_param_pr,...
                    n_iter_pr, time_pr];
            end
        end
    end
    % ----------------------------------
    % Calculating the Euclidean distance between the optimum 
    % values and values found by the optimization procedures

    % Optimum parameters found by exhaustive search over a grid
    optimum_xy = [8.3, -0.6];

    % Parameters found by optimization
    points_sgd = optimum_params_sgd(:, [4, 5]);
    points_pr = optimum_params_pr(:, [4, 5]);

    % SGD Euclidean distance
    distance_sgd = sqrt((points_sgd(:, 1) - optimum_xy(1)) .^2 ...
        + (points_sgd(:, 2) - optimum_xy(2)) .^2);
    optimum_params_sgd(:, 9) = distance_sgd;
    % Polak-Ribiere Euclidean distance
    distance_pr = sqrt((points_pr(:, 1) - optimum_xy(1)) .^2 ...
        + (points_pr(:, 2) - optimum_xy(2)) .^2);
    optimum_params_pr(:, 9) = distance_pr;
    % ----------------------------------
    % Place the optimum values for each pyramid level in a cell
    pyr_opt_sgd{pyr_lvl} = optimum_params_sgd;
    pyr_opt_pr{pyr_lvl} = optimum_params_pr;
end

