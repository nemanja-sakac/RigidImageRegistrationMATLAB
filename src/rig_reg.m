function [opt_param, conv_rate, n_iter] = rig_reg(ref_im, test_im, roi, z_params, varargin)
%
% RIG_REG Performs rigid registration of two input images of the same
% anatomy using gradient descent.
%
% [OPT_PARAM, CONV_RATE] = RIG_REG(REF_IM, TEST_IM, ROI, Z_PARAMS, OPTIONAL) performs
% rigid registration of the test image, given by TEST_IM, with regards to 
% the reference image, given by REF_IM. The outputs are optimum parameters
% given by OPT_PARAM and a matrix of step (tx, ty) values and the values of
% the objective function during the optimization process, CONV_RATE.
%
% ROI represents the region-of-interest in the images for which 
% registration should take place. ROI is a two-by-two matrix, 
% ROI = [ROWS; COLUMNS], where the boundary pixels along the y-axis are 
% given by the first (upper) ROWS vector, and the boundary pixels along the
% x-axis are given by the second (lower) COLUMNS vector.
% Example: If REF_IM is a 1000x1000 px image and the pixels defining the
% boundaries of the region-of-interest are given by ordered (x, y) pairs 
% {(100, 200), (900, 200), (100, 800), (900, 800)}, the matrix ROI should 
% be defined as ROI = [100, 800; 200, 900]
% 
% Z_PARAMS represents a vector of Gaussian filter parameters. It should be 
% z_params(1)
% corresponds to filter width, z_params(2) corresponds to filter standard
% deviation and z_params()
% 
% OPTIONAL:
%
% 'method' is a string argument defining the gradient descent method to be
% used for finding the optimum translation. Two methods have been
% implemented:
%
% 'vanilla' - Basic (vanilla) gradient descent
% 'polak-ribiere' - Nonlinear conjugate gradient descent based on
%   Polak-Ribiere's method. 
% 
% If the 'method' argument is not specified, the default method used is 
% 'vanilla'.
%
% Author: 
%   Nemanja Sakac, student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2019.
% Last modified: 2021.

% Parsing optional inputs
p = inputParser;

% Parse 'method' if specified
defaultMethod = 'vanilla';
validMethods = {'vanilla', 'polak-ribiere'};
checkMethod = @(x) any(validatestring(x, validMethods));
addOptional(p, 'method', defaultMethod, checkMethod);

% Parse 
parse(p, varargin{:})
method = p.Results.method;

% Image value z-normalization
% Default values (subject to change)
if (length(z_params) == 3)
    filt_width = z_params(1);
    filt_sd = z_params(2);
    thresh = z_params(3);
else
    filt_width = 10;
    filt_sd = 20;
    thresh = 5;
end

% Normalize images using z-normalization
norm_ref_im = z_norm(ref_im, filt_width, filt_sd, thresh);
norm_test_im = z_norm(test_im, filt_width, filt_sd, thresh);

% ROI
rows_oi = roi(1, :);
columns_oi = roi(2, :);

% Location grid for interpolation
[X, Y] = meshgrid(columns_oi(1):columns_oi(2), rows_oi(1):rows_oi(2));
int_loc.X = X;
int_loc.Y = Y;

% Interpolated reference image
int_ref_im = interp2(1:size(norm_ref_im, 2), 1:size(norm_ref_im, 1),...
    norm_ref_im, X, Y, 'linear');

% Initialize optimum parameters
tx = 0;
ty = 0;
opt_param = [tx, ty];
% Step dxy
dxy = 1;
% Matrix of all steps (conv_rate)
conv_rate = [];
% Successful optimization flag
is_success = 0;
% Number of iterations
n_iter = 1;
% Maximum number of iterations
max_iter = 100;
while(is_success == 0 && (n_iter < max_iter))
    % Calculate sum of squared differences between the normalized
    % reference image and test image for new optimum parameters
    ssq = ssq_rig_reg(opt_param, int_loc, norm_test_im, int_ref_im);
    
    if (n_iter > 1)
        conv_rate = [conv_rate; tx ty ssq k];
    end
    % Plot new optimum parameters
    % plot(tx, ty, 'rx')
    % hold on

    % Find 4 points in the area of optimum parameters
    tx1 = tx + dxy;
    tx2 = tx - dxy;
    ty1 = ty + dxy;
    ty2 = ty - dxy;
    ssq_x1 = ssq_rig_reg([tx1 ty], int_loc, norm_test_im, int_ref_im);
    ssq_x2 = ssq_rig_reg([tx2 ty], int_loc, norm_test_im, int_ref_im);
    ssq_y1 = ssq_rig_reg([tx ty1], int_loc, norm_test_im, int_ref_im);
    ssq_y2 = ssq_rig_reg([tx ty2], int_loc, norm_test_im, int_ref_im);

    % Check if optimization succeeded
    if (ssq_x1 > ssq && ssq_x2 > ssq && ssq_y1 > ssq && ssq_y2 > ssq)
        is_success = 1;
        continue
    end

    % Calculate gradient and normalize it
    [norm_gx, norm_gy] = calc_gradient(ssq_x1, ssq_x2, ssq_y1, ssq_y2, dxy);

    switch method
        case 'vanilla'
            % Find optimum step in gradient direction
            obj_func = @(k) ssq_rig_reg([(tx + k * norm_gx),...
                (ty + k * norm_gy)], int_loc, norm_test_im, int_ref_im);
            k = golden_section(obj_func, [-20, 20]);

            % Display gradient direction
            % quiver(tx, ty, k * norm_gx, k * norm_gy, 0, 'k')
            
            % Calculate new optimum parameters
            tx = tx + k * norm_gx;
            ty = ty + k * norm_gy;
            
        case 'polak-ribiere'
            norm_g = [norm_gx; norm_gy];
            
            % Update current conjugate gradient direction
            if (n_iter == 1)
                s_cur = norm_g;
            else
                beta = (norm_g' * (norm_g - s_cur)) / (s_cur' * s_cur);
                % Calculate new conjugate gradient direction
                s_cur = norm_g + beta * s_cur;
            end

            % Find optimum step in gradient direction
            obj_func = @(k) ssq_rig_reg([(tx + k * s_cur(1)),...
                (ty + k * s_cur(2))], int_loc, norm_test_im, int_ref_im);
            k = golden_section(obj_func, [-20 20]);

            % Display gradient direction
            % quiver(tx, ty, k * s_cur(1), k * s_cur(2), 0, 'k')

            % Calculate new optimum parameters
            tx = tx + k * s_cur(1);
            ty = ty + k * s_cur(2);
    end

    % Store optimum parameters
    opt_param(1) = tx;
    opt_param(2) = ty;
    
    % Update iteration
    n_iter = n_iter + 1;
            

end
