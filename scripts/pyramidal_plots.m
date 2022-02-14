%%
% Script for illustrating Gaussian pyramids

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

ref_im_roi = ref_im(rows(1):rows(2), columns(1):columns(2));
test_im_roi = test_im(rows(1):rows(2), columns(1):columns(2));

%%
% Local image value z-normalization - accentuate structures
% Default z-norm parameters
gauss_width = 30;
gauss_sd = 10;
thresh = 5;

norm_ref = z_norm(ref_im_roi, gauss_width, gauss_sd, thresh);
norm_test = z_norm(test_im_roi, gauss_width, gauss_sd, thresh);

%%
% Selecting the pyramid levels to display
pyr_levels = [0, 1, 2];

for i = 1:length(pyr_levels)
    % Decompose image
    [~, ref_img_decomp, ~, ~] = vis_decomp_lappyr(norm_ref, pyr_levels(i));
    [~, test_img_decomp, ~, ~] = vis_decomp_lappyr(norm_test, pyr_levels(i));
    
    % Normalize images to a value between 0 and 255
    norm_ref_decomp = lin_normalize(ref_img_decomp, 0, 255);
    norm_test_decomp = lin_normalize(test_img_decomp, 0, 255);
    
    % Display images
    figure
    imshow(ref_img_decomp, [])
    % Save images
    imwrite(uint8(norm_ref_decomp), ['ref_z_pyr', num2str(i), '.bmp'], 'bmp');
    
    % Display images
    figure
    imshow(test_img_decomp, [])
    % Save images
    imwrite(uint8(norm_test_decomp), ['test_z_pyr', num2str(i), '.bmp'], 'bmp');
    
end