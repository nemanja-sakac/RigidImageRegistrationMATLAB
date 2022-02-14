%%
% Rigid image registration (translation) of X-ray lung images using vanilla 
% and nonlinear conjugate (Polak-Ribiere) gradient descent at several image
% levels (multiscale analysis).
% Subject: Medical Image Processing
% Author: 
%   Nemanja Sakac, Student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2021.
% Last modified: 2021.

%%
% Load images
% Reference image
ref_im = double(imread('F:\projects\rigid_image_registration_gradient_descent\matlab\img\REG_HE.png'));
% Test image
test_im = double(imread('F:\projects\rigid_image_registration_gradient_descent\matlab\img\REG_LE_05.PNG'));

%%
% Extract ROI (region-of-interest)
rows = [round(0.15 * size(ref_im, 1)), round(0.85 * size(ref_im, 1))];
columns = [round(0.10 * size(ref_im, 2)), round(0.90 * size(ref_im, 2))];
roi = [rows; columns];

%%
% ref_im = ref_im(rows(1):rows(2), columns(1):columns(2));
% test_im = test_im(rows(1):rows(2), columns(1):columns(2));

%%
% Display images after extracted ROI
% figure
% imshow(ref_im, [])
% figure
% imshow(test_im, [])

%%
% % Calculate objective function values
% % Minimum dimension size
% min_dim = min(size(ref_im));
% % Optimum parameters for each pyramid level
% opt_params = [];
% 
% % 5 => 2 ^ 5 = 32, so down to 32x32 pixels
% figure
% for i = 1:(floor(log2(min_dim)) - 5)
%     % Objective function test
%     pyr_lvl = 2;
%     % Decompose images
%     [~, ref_img_decomp, ~, ~] = vis_decomp_lappyr(ref_im, i);
%     [~, test_img_decomp, ~, ~] = vis_decomp_lappyr(test_im, i);
% 
%     % Local image value z-normalization - accentuates structures
%     % Default z-norm parameters
%     gauss_width = ceil(20 / (2 ^ i));
%     gauss_sd = 10 / (2 ^ i);
%     thresh = 5;
% 
%     norm_ref = z_norm(ref_img_decomp, gauss_width, gauss_sd, thresh);
%     norm_test = z_norm(test_img_decomp, gauss_width, gauss_sd, thresh);
% 
%     tx_max = ceil(20 / (2 ^ i));
%     ty_max = ceil(20 / (2 ^ i));
%     % Define step
%     tx = -tx_max:0.1:tx_max;
%     ty = -ty_max:0.1:ty_max;
% 
%     % Create objective function grid
%     [X, Y] = meshgrid(1:size(norm_ref, 2), 1:size(norm_ref, 1));
%     int_ref = interp2(1:size(norm_ref, 2), 1:size(norm_ref, 1),...
%         norm_ref, X, Y, 'linear');
% 
%     % Calculate objective function over grid
%     obj_func = zeros(length(tx), length(ty));
% 
%     for k = 1:size(obj_func, 1)
%         X1 = X + tx(k);
%         for j = 1:size(obj_func, 2)
%             Y1 = Y + ty(j);
%             int_test = interp2(1:size(norm_test, 2), 1:size(norm_test, 1),...
%                 norm_test, X1, Y1, 'linear');
%             % Calculate sum of squared differences
%             sqd = (int_ref - int_test) .^ 2;
%             ssqd = sum(sqd(:), 'omitnan');
%             obj_func(k, j) = ssqd;
%         end
%     end
% 
%     [min_x_val, min_x] = min(min(obj_func, [], 2));
%     [min_y_val, min_y] = min(min(obj_func, [], 1));
%     opt_params = [opt_params; tx(min_x), ty(min_y), min_x_val];
% 
%     % Plot objective function
%     
%     filename = ['obj_func_lvl_', num2str(i), '.png'];
%     mesh(ty, tx, obj_func')
%     title('Objective Function')
%     xlabel('tx')
%     ylabel('ty')
%     saveas(gcf, filename);
% 
% end

%%
% csvwrite('./obj_func_multires', obj_func);
% csvwrite('./opt_params', opt_params);

%%
% Find optimum values using gradient descent
% Minimum dimension size
min_dim = min(size(ref_im));
% Optimum parameters for each pyramid level
opt_params_van = [];
opt_params_conj = [];
conv_rate_van = {};
conv_rate_conj = {};

for i = 0:(floor(log2(min_dim)) - 5)
    
    % Measure vanilla efficiency
    tic
    [opt_param_van, conv_rate] = multires_rig_reg(ref_im, test_im, roi, i,...
        [], 'method', 'vanilla');
    time_vanilla = toc;
    opt_params_van = [opt_params_van; opt_param_van, time_vanilla, i];
    conv_rate_van{i + 1} = conv_rate;
    
    % Measure nonlinear conjugate efficiency
    tic
    [opt_param_conj, conv_rate] = multires_rig_reg(ref_im, test_im, roi, i,...
        [], 'method', 'polak-ribiere');
    time_conj = toc;
    opt_params_conj = [opt_params_conj; opt_param_conj, time_conj, i];
    conv_rate_conj{i + 1} = conv_rate;
end

%%
% Save results
save('multires_results.mat', 'opt_params_van', 'opt_params_conj',... 
    'conv_rate_van', 'conv_rate_conj');



