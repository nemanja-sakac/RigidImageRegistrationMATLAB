%%
% Displays and saves C++ and MATLAB z-normalizations   
%%
% Load reference image
ref_im_matlab = double(imread('F:/projects/rigid_image_registration_gradient_descent/matlab/img/REG_HE.png'));
%
ref_im_cpp = double(imread('F:/projects/rigid_image_registration_gradient_descent/c++/rigid_image_registration/img/znorm_img2.png'));
ref_im_cpp = uint8(ref_im_cpp(:, :, 1));

%%
% Z-normalize MATLAB reference image
gauss_width = 30;
gauss_sd = 20;
thresh = 10;

znorm_ref_matlab = z_norm(ref_im_matlab, gauss_width, gauss_sd, 1);

%%
% Normalize reference image to a value between 0 and 255
norm_ref_matlab = uint8(lin_normalize(znorm_ref_matlab, 0, 255));

%%
% Display images
figure
imshow(norm_ref_matlab, [])

figure
imshow(ref_im_cpp, [])

