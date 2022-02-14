function [min_x, min_y, min_val] = find_minimum(obj_func)
% FIND_MINIMUM Returns the minimum of the calculated objective function
% matrix along with its optimal parameters.
%
% [TX, TY, SSQ] = FIND_MINIMUM(OBJECTIVE_FUNCTION_MATRIX) returns the
% locations of the minimum of a matrix and the value at its location.
% 
% Author: 
%   Nemanja Sakac, student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2021.
% Last modified: 2021.

% Find the minimum over rows
[min_by_cols, min_x] = min(obj_func);
[min_val, min_y] = min(min_by_cols);
min_x = min_x(min_y);