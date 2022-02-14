%%
% Load images
% Reference image
ref_im = double(imread('REG_HE.png'));
% Test image
test_im = double(imread('REG_LE_05.PNG'));

%%
% Display images before preprocessing
figure
imshow(ref_im, [])
figure
imshow(test_im, [])

%%
% Extract ROI (region-of-interest)
rows = [round(0.15 * size(ref_im, 1)), round(0.85 * size(ref_im, 1))];
columns = [round(0.10 * size(ref_im, 2)), round(0.90 * size(ref_im, 2))];
roi = [rows; columns];

%%
% Display images after extracted ROI
figure
imshow(ref_im(rows(1):rows(2), columns(1):columns(2)), [])
figure
imshow(test_im(rows(1):rows(2), columns(1):columns(2)), [])

%%
% Local image value z-normalization - accentuate structures
% Default z-norm parameters
gauss_width = 20;
gauss_sd = 5;
thresh = 1;

norm_ref = z_norm(ref_im, gauss_width, gauss_sd, thresh);
norm_test = z_norm(test_im, gauss_width, gauss_sd, thresh);

norm_ref = norm_ref(rows(1):rows(2), columns(1):columns(2));
norm_test = norm_test(rows(1):rows(2), columns(1):columns(2));


% figure
% title_name = sprintf('KernelWidth = %d, \\sigma = %d, Threshold = %d',...
%     gauss_width, gauss_sd, thresh)
% imshow(norm_ref, [])
% title(title_name)

% 
% figure
% imshow(norm_test, [])


%%
gauss_width = 20;
gauss_sd = 20;
thresh = 5;

norm_ref = z_norm(ref_im, gauss_width, gauss_sd, thresh);
norm_test = z_norm(test_im, gauss_width, gauss_sd, thresh);

figure
imshow(uint8(norm_ref * 255), [0, 255])
figure
imshow(norm_test, [])
