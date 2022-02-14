function norm_im = z_norm(image_mat, gauss_width, gauss_sd, local_sd_thresh)
% Z_NORM Normalizes (standardizes) local (regional) image values to zero 
% mean and unit variance. For significant amounts of noise, a threshold can
% be defined for regulation.
%
% NORM_IM = Z_NORM(IMAGE_MAT, GAUSS_WIDTH, GAUSS_SD, LOCAL_SD_THRESH) 
% returns normalized image NORM_IM from IMAGE_MAT. IMAGE_MAT is the input 
% image matrix. GAUSS_WIDTH is the length and GAUSS_SD is the standard 
% deviation of the LP Gaussian kernel filter. LOCAL_SD_THRESH is the lower 
% threshold for standard deviation in the image region.
% 
% Author: 
%   Nemanja Sakac, student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2019.
% Last modified: 2021.

% Create Gaussian LP filter of width 'gauss_width' and standard deviation 
% 'gauss_sd'
h = fspecial('gaussian', [1, gauss_width], gauss_sd);

% Estimate local mean value of image
loc_mean = conv2(h', h, image_mat, 'same');

% Calculate squared differences
loc_var = (image_mat - loc_mean) .^ 2;
% Estimate local variance
loc_var = conv2(h', h, loc_var, 'same');
loc_var = loc_var .* (~(loc_var < local_sd_thresh))...
    + (loc_var < local_sd_thresh) .* local_sd_thresh;

% Normalize image values
norm_im = (image_mat - loc_mean) ./ sqrt(loc_var);
