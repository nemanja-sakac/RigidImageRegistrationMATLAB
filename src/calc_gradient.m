function [norm_gx, norm_gy] = calc_gradient(x1, x2, y1, y2, dxy)
% CALC_GRADIENT Calculates and normalizes the gradient using the symmetric
% differences quotient approximation
%
% [NORM_GX, NORM_GY] = CALC_GRADIENT(X1, X2, Y1, Y2, H) calculates the
% gradient using a two-point formula to compute the slope of a nearby 
% secant line through the points X1 and X2 and Y1 and Y2. It is assumed
% that X1 and X2, and Y1 and Y2 are already precalculated values of the
% function at points (X - dxy, X + dxy) and (Y - dxy, Y + dxy). After that
% gx and gy are normalized to a value between 0 and 1.
%
% Reference: https://en.wikipedia.org/wiki/Symmetric_derivative
% Author: 
%   Nemanja Sakac, Student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2021.
% Last modified: 2021.
%

% Calculate the gradient using the symmetric differences quotient 
% approximation
gx = (x1 - x2) / (2 * dxy);
gy = (y1 - y2) / (2 * dxy);

% Normalize gradient - calculate direction
norm_gx = gx / sqrt(gx ^ 2 + gy ^ 2);
norm_gy = gy / sqrt(gx ^ 2 + gy ^ 2);