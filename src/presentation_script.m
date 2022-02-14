%%
% Rigid image registration (translation) of X-ray lung images using vanilla 
% and nonlinear conjugate (Polak-Ribiere) gradient descent.
% Subject: Medical Image Processing
% Author: 
%   Nemanja Sakac, Student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2019.
% Last modified: 2021.

%%
% Load images
% Reference image
ref_im = double(imread('F:\projects\rigid_image_registration_gradient_descent\matlab\img\REG_HE.png'));
% Test image
test_im = double(imread('F:\projects\rigid_image_registration_gradient_descent\matlab\img\REG_LE_05.PNG'));

%%
% Display images before preprocessing
figure
imshow(ref_im, [])
figure
imshow(test_im, [])

%%
% Define ROI (region-of-interest)
rows = [round(0.15 * size(ref_im, 1)), round(0.85 * size(ref_im, 1))];
columns = [round(0.10 * size(ref_im, 2)), round(0.90 * size(ref_im, 2))];
roi = [rows; columns];

%%
% Extract ROI
ref_im_roi = ref_im(rows(1):rows(2), columns(1):columns(2));
test_im_roi = test_im(rows(1):rows(2), columns(1):columns(2));

%%
% Display images after extracted ROI
figure
imshow(ref_im_roi, [])

figure
imshow(test_im_roi, [])

%% 
% Display image difference before registration
diff_roi = ref_im_roi - test_im_roi;
figure
imshowpair(ref_im_roi, test_im_roi);

%% 
% Image translation example
trans_ref_im = imtranslate(ref_im_roi, [40, 40], 'linear');

figure
imshow(ref_im_roi, [])

figure
imshow(trans_ref_im, [])

diff_trans = ref_im_roi - trans_ref_im;
figure
imshowpair(ref_im_roi, trans_ref_im);

%%
% Plot image translation examples on one plot
figure
subplot(1, 3, 1)
imshow(ref_im_roi, [])
title('Reference image')

subplot(1, 3, 2)
imshow(trans_ref_im, [])
title_format = sprintf('Translated image\ntx = %d, ty = %d', 40, 40)
title(title_format)

subplot(1, 3, 3)
imshowpair(ref_im_roi, trans_ref_im);
title('Translation difference')

%%
% Local image value z-normalization - accentuate structures
% Default z-norm parameters
gauss_width = 10;
gauss_sd = 20;
thresh = 5;

norm_ref = z_norm(ref_im_roi, gauss_width, gauss_sd, thresh);
norm_test = z_norm(test_im_roi, gauss_width, gauss_sd, thresh);

%% 
% Display z-normalized images
figure
imshow(norm_ref, [])
figure
imshow(norm_test, [])

%%
% Display images after normalization
figure
imshow(uint8(norm_ref * 255), [0, 255])
figure
imshow(norm_test, [])

%%
% Create objective function grid
[X, Y] = meshgrid(1:size(ref_im_roi, 2), 1:size(ref_im_roi, 1));
int_ref = interp2(norm_ref, X, Y, 'linear');

%%
% Define step
tx = -20:1:20;
ty = -20:1:20;

%%
% Calculate objective function over grid

% % Initialize objective function
% obj_func = zeros(length(tx), length(ty));
% 
% for i = 1:size(obj_func, 1)
%     X1 = X + tx(i);
%     for j = 1:size(obj_func, 2)
%         Y1 = Y + ty(j);
%         int_test = interp2(1:size(norm_test, 2), 1:size(norm_test, 1),...
%             norm_test, X1, Y1, 'linear');
%         % Calculate sum of squared differences
%         sqd = (int_ref - int_test) .^ 2;
%         ssqd = sum(sqd(:), 'omitnan');
%         obj_func(i, j) = ssqd;
%     end
% end

% csvwrite('./obj_func', obj_func);
% csvwrite('./tx', tx);
% csvwrite('./ty', ty);

%% 
% Plot objective function

% figure
% mesh(ty, tx, obj_func')
% title('Objective Function')
% xlabel('tx')
% ylabel('ty')

%%
% Vanilla gradient descent
% figure
% contour(ty, tx, obj_func', 20)
% title('Convergence Rate - Vanilla Gradient Descent')
% xlabel('tx')
% ylabel('ty')
% hold on

% Measure time
tic
[opt_param, conv_rate] = rig_reg(ref_im, test_im, roi, [], 'method', 'vanilla')
time_vanilla = toc;
% hold off

%% 
% Polak-Ribiere nonlinear conjugate gradient descent
% figure
% contour(ty, tx, obj_func', 20)
% title('Convergence Rate - Polak-Ribiere')
% xlabel('tx')
% ylabel('ty')
% hold on

% Measure time
% tic
% [opt_param, conv_rate] = rig_reg(ref_im, test_im, roi, [], 'method', 'polak-ribiere')
% time_pr = toc;
% hold off

%%
% Display image differences before and after registration
X1 = X + opt_param(1);
Y1 = Y + opt_param(2);

%%
% Translate the reference with accordance to the optimal parameters
test_ref_img = imtranslate(ref_im_roi, opt_param, 'linear');

translation_res = ref_im_roi - test_ref_img;

figure
imshow(translation_res, [])
title('After Registration')

%%
test_im1 = interp2(1:size(test_im_roi, 2), 1:size(test_im_roi, 1),...
    test_im_roi, X, Y, 'linear');
test_im2 = interp2(1:size(test_im_roi, 2), 1:size(test_im_roi, 1),...
    test_im_roi, X1, Y1, 'linear');

diff1 = ref_im_roi - test_im1;
diff2 = ref_im_roi - test_im2;

%%
figure
imshow(diff1, [])
title('Before Registration')

figure
imshow(diff2, [])
title('After Registration')

%%
% Display iterative process of rigid registration and save as GIF file
% ref_im_roi = ref_im(rows(1):rows(2), columns(1):columns(2));
% h = figure;
% axis tight manual
% % Remove border
% iptsetpref('ImshowBorder', 'tight');
% 
% filename = 'pr_conv_rate.gif';
% for i = 1:size(conv_rate, 1)
%     X1 = X + conv_rate(i, 1);
%     Y1 = Y + conv_rate(i, 2);
%     int_test_im = interp2(1:size(test_im, 2), 1:size(test_im, 1),...
%         test_im, X1, Y1, 'linear');
%     diff = ref_im_roi - int_test_im;
%     
%     % Display iterative optimization process
%     imshow(diff, [])
%     
%     % Capture plot as image 
%     frame = getframe(h);
%     im = frame2im(frame);
%     [imind, cm] = rgb2ind(im, 256);
%     
%     % Write to GIF file 
%     if i == 1 
%       imwrite(imind, cm, filename, 'gif', 'Loopcount', inf,...
%           'DelayTime', 1, 'Comment', num2str(i)); 
%     else 
%       imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append',...
%           'DelayTime', 1, 'Comment', num2str(i)); 
%     end
% end

%%

figure
imshowpair(ref_im_roi, test_im2);
