%%
% Minimum dimension size
min_dim = min(size(ref_im));
% Optimum parameters for each pyramid level
opt_params = [];

% Objective function test
pyr_lvl = 2;
% Decompose images
[~, ref_img_decomp, ~, ~] = vis_decomp_lappyr(ref_im, pyr_lvl);
[~, test_img_decomp, ~, ~] = vis_decomp_lappyr(test_im, pyr_lvl);

% Local image value z-normalization - accentuates structures
% Default z-norm parameters
gauss_width = ceil(20 / (2 ^ pyr_lvl));
gauss_sd = 10 / (2 ^ pyr_lvl);
thresh = 5;

norm_ref = z_norm(ref_img_decomp, gauss_width, gauss_sd, thresh);
norm_test = z_norm(test_img_decomp, gauss_width, gauss_sd, thresh);

tx_max = ceil(20 / (2 ^ pyr_lvl));
ty_max = ceil(20 / (2 ^ pyr_lvl));
% Define step
tx = -tx_max:0.1:tx_max;
ty = -ty_max:0.1:ty_max;

%%
% Create objective function grid
[X, Y] = meshgrid(1:size(norm_ref, 2), 1:size(norm_ref, 1));
int_ref = interp2(1:size(norm_ref, 2), 1:size(norm_ref, 1),...
    norm_ref, X, Y, 'linear');

%%
% Calculate objective function over grid

obj_func = zeros(length(tx), length(ty));

for k = 1:size(obj_func, 1)
    X1 = X + tx(k);
    for j = 1:size(obj_func, 2)
        Y1 = Y + ty(j);
        int_test = interp2(1:size(norm_test, 2), 1:size(norm_test, 1),...
            norm_test, X1, Y1, 'linear');
        % Calculate sum of squared differences
        sqd = (int_ref - int_test) .^ 2;
        ssqd = sum(sqd(:), 'omitnan');
        obj_func(k, j) = ssqd;
    end
end

[min_x_val, min_x] = min(min(obj_func, [], 2));
[min_y_val, min_y] = min(min(obj_func, [], 1));
opt_params = [opt_params; tx(min_x), ty(min_y), min_x_val];

%% 
% Plot objective function
figure
mesh(ty, tx, obj_func')
title('Objective Function')
xlabel('tx')
ylabel('ty')

