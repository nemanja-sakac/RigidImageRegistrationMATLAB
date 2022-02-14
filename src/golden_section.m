function x = golden_section(input_func, interval)
%
% GOLDEN_SECTION Finds the local optimum of a specified function using the
% golden section algorithm.
%
% X = GOLDEN_SECTION(INPUT_FUNC, INTERVAL) finds the local optimum of
% INPUT_FUNC, the input function handle, on an interval specified by 
% INTERVAL. INTERVAL is a vector of two values, where the first value 
% represents the left bound and the second value the right bound of the 
% region in which the search is being conducted. Output X is the 
% location of the found local optimum.
%
% Author: 
%   Nemanja Sakac, student
%   Faculty of Technical Sciences, University of Novi Sad
%   Novi Sad, Serbia
% Date: 2019.
% Last modified: 2021.

% Maximum number of iterations
n_max = 50;
% Tolerance for stopping the algorithm
epsilon = 0.000001;
% Golden section coefficient
tau = (3 - sqrt(5)) / 2; 

% Left and right bound of interval
a = interval(1);
b = interval(2);

% Initialize number of iterations
n_iter = 0;

% Calculate first interval
y = a + tau * (b - a);
z = a + (1 - tau) * (b - a);

f_y = input_func(y);
f_z = input_func(z);

while ((abs(b - a) >= epsilon) && (n_iter < n_max))
    % Update iteration
    n_iter = n_iter + 1;
    if(f_y < f_z)
        % New b is z
        % New a is still previous a
        b = z;
        z = y;
        f_z = input_func(z);
        
        % New y
        y = a + tau * (b - a);
        f_y = input_func(y);
    else
        a = y;
        y = z;
        f_y = input_func(y);
        z = a + (1 - tau) * (b - a);
        f_z = input_func(z);
    end
end

% Minimum found
x = y;
% Value at minimum
% if(f_y < f_z)
%     f_x = f_y;
% else
%     f_x = f_z;
% end
