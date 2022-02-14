%% 
% A script created for plotting objective functions with variable
% z-normalization parameters

%%
clear
clc
close all
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
% Images after extracted ROI
ref_im_roi = ref_im(rows(1):rows(2), columns(1):columns(2));
test_im_roi = test_im(rows(1):rows(2), columns(1):columns(2));

%%
% Create objective function grid
[X, Y] = meshgrid(1:size(ref_im_roi, 2), 1:size(ref_im_roi, 1));

%%
% Define step
tx = -20:1:20;
ty = -20:1:20;

%%
% Calculate objective function over grid

obj_func = zeros(length(tx), length(ty));

% z-norm parameters for testing
gauss_widths = [5, 10, 20, 30];
gauss_sds = [5, 10, 20];
thresh = [1, 5, 10];

% Objective function optimum array with given translation parameters
optimum_params = [];


% Test for different values of Guassian kernel widths, standard
% deviations and threshold
for l = 1:length(gauss_widths)
    for m = 1:length(gauss_sds)
        for n = 1:length(thresh)
            %--------------------
            for i = 1:size(obj_func, 1)
                X1 = X + tx(i);
                for j = 1:size(obj_func, 2)
                    Y1 = Y + ty(j);
                            
                    % z-normalize images
                    norm_ref = z_norm(ref_im_roi,...
                        gauss_widths(l),...
                        gauss_sds(m),...
                        thresh(n));
                    int_ref = interp2(norm_ref, X, Y, 'linear');
                    
                    norm_test = z_norm(test_im_roi,...
                        gauss_widths(l),...
                        gauss_sds(m),...
                        thresh(n));
                    
                    % Translate image by given values                    
                    int_test = interp2(1:size(norm_test, 2), 1:size(norm_test, 1),...
                        norm_test, X1, Y1, 'linear');
                    
                    % Calculate sum of squared differences
                    sqd = (int_ref - int_test) .^ 2;
                    ssqd = sum(sqd(:), 'omitnan');
                    obj_func(i, j) = ssqd;
                    
                end
            end
            %--------------------
            % Format image name
            image_title = sprintf(['Objective function\n', ...
                'KernelWidth = %d, \\sigma = %d, Threshold = %d'],...
                gauss_widths(l), gauss_sds(m), thresh(n));
            
            % Show mesh of the objective function
            figure
            mesh(ty, tx, obj_func')
            % So the image gets plotted correctly
            pause(5)
            
            % Image title
            title(image_title)
            % Save image
            image_name = sprintf(['obj_func_%d_%d_%d'], ...
                gauss_widths(l), gauss_sds(m), thresh(n));
            saveas(gcf, ['../img/obj_funcs/combinations/', image_name, '.tiff']);
            
            % So there is enough time to save the image
            pause(5)
            
            % Find minimum
            [min_tx, min_ty, ssqd] = find_minimum(obj_func);
            optimum_params = [optimum_params; tx(min_tx), ty(min_ty), ssqd];

        end 
    end
end
















