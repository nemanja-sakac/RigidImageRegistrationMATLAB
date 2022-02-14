%%
addpath('F:\projects\rigid_image_registration_gradient_descent\matlab\img');
addpath('F:\projects\rigid_image_registration_gradient_descent\matlab\src');
% Load images
% Reference image
ref_im = double(imread('../img/REG_HE.png'));
% Test image
test_im = double(imread('../img/REG_LE_05.PNG'));

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
% Examples of image for different z-norm parameters
ref_im_roi = ref_im(rows(1):rows(2), columns(1):columns(2));
test_im_roi = test_im(rows(1):rows(2), columns(1):columns(2));

%% 
% Variable width, fixed standard deviation and threshold
gauss_width = [5, 10, 30];
gauss_sd = 10;
thresh = 5;

for i = 1:length(gauss_width)
    figure
    imshow(z_norm(ref_im_roi, gauss_width(i), gauss_sd, thresh), [])
    format_title = sprintf('w = %d, \\sigma = %d, \\sigma_min = %d',...
        gauss_width(i), gauss_sd, thresh)
    title(format_title)
end

%% 
% Variable width, fixed standard deviation and threshold
gauss_width = 30;
gauss_sd = [5, 10, 20];
thresh = 5;

for i = 1:length(gauss_sd)
    figure
    imshow(z_norm(ref_im_roi, gauss_width, gauss_sd(i), thresh), [])
    format_title = sprintf('w = %d, \\sigma = %d, \\sigma_min = %d',...
        gauss_width, gauss_sd(i), thresh)
    title(format_title)
end


