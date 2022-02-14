function ssq = ssq_rig_reg(param_trans, int_loc, test_im, int_ref_im)
% 
% SSQ_RIG_REG Calculates the sum of squared differences between two images
% 
% SSQ = SSQ_RIG_REG(PARAM_TRANS, INT_LOC, TEST_IM, INT_REF_IM) Outputs the
% sum of squared differences SSQ. PARAM_TRANS are current translation
% steps for which the sum of squared differences is being calculated (tx, 
% ty). INT_LOC is a structure containing X and Y, representing the grid of 
% pixel values. TEST_IM is the (z-normalized) test image. INT_REF_IM is the
% (z-normalized) reference image, previously interpolated to account for
% step values.
%
% Author: 
%   Nemanja Sakac, student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2019.
% Last modified: 2021.

% Interpolate for initial values
tx = param_trans(1);
ty = param_trans(2);

X = int_loc.X + tx;
Y = int_loc.Y + ty;

% Calculate objective function
int_test_im = interp2(1:size(test_im, 2), 1:size(test_im, 1), test_im, X,...
    Y, 'linear');

sq_diff = (int_ref_im - int_test_im) .^ 2; 
ssq = sum(sq_diff(:), 'omitnan');
