%%
% Script for the preparation of boxplots for MATLAB and C++ implementations

%%
% Euclidean distance plot
op_pr_matlab_euc = op_pr_matlab(:, 3);
op_sgd_matlab_euc = op_sgd_matlab(:, 3);
op_pr_cpp_euc = op_pr_cpp(:, 3);
op_sgd_cpp_euc = op_sgd_cpp(:, 3);

group_euc = [ones(size(op_pr_matlab_euc));...
    2 * ones(size(op_pr_cpp_euc));...    
    3 * ones(size(op_sgd_matlab_euc));...
    4 * ones(size(op_sgd_cpp_euc))];

figure
box_euc_dist = boxplot([op_pr_matlab_euc;...
    op_pr_cpp_euc;...
    op_sgd_matlab_euc;...
    op_sgd_cpp_euc], group_euc)
set(gca, 'XTickLabel', {'Polak-Ribiere MATLAB',...
    'Polak-Ribiere C++',...
    'Gradient Descent MATLAB',...
    'Gradient Descent C++'})
title('Euclidean Distance')

%%
% Execution time plot
op_pr_matlab_euc = op_pr_matlab(:, 2);
op_sgd_matlab_euc = op_sgd_matlab(:, 2);
op_pr_cpp_euc = op_pr_cpp(:, 2);
op_sgd_cpp_euc = op_sgd_cpp(:, 2);

group_euc = [ones(size(op_pr_matlab_euc));...
    2 * ones(size(op_pr_cpp_euc));...    
    3 * ones(size(op_sgd_matlab_euc));...
    4 * ones(size(op_sgd_cpp_euc))];

figure
box_exec_time = boxplot([op_pr_matlab_euc;...
    op_pr_cpp_euc;...
    op_sgd_matlab_euc;...
    op_sgd_cpp_euc], group_euc)
set(gca, 'XTickLabel', {'Polak-Ribiere MATLAB',...
    'Polak-Ribiere C++',...
    'Gradient Descent MATLAB',...
    'Gradient Descent C++'})
title('Execution Time')
ylabel('t(s)')

%%
% Number of iterations plot
op_pr_matlab_euc = op_pr_matlab(:, 1);
op_sgd_matlab_euc = op_sgd_matlab(:, 1);
op_pr_cpp_euc = op_pr_cpp(:, 1);
op_sgd_cpp_euc = op_sgd_cpp(:, 1);

group_euc = [ones(size(op_pr_matlab_euc));...
    2 * ones(size(op_pr_cpp_euc));...    
    3 * ones(size(op_sgd_matlab_euc));...
    4 * ones(size(op_sgd_cpp_euc))];

figure
box_n_iter = boxplot([op_pr_matlab_euc;...
    op_pr_cpp_euc;...
    op_sgd_matlab_euc;...
    op_sgd_cpp_euc], group_euc)
set(gca, 'XTickLabel', {'Polak-Ribiere MATLAB',...
    'Polak-Ribiere C++',...
    'Gradient Descent MATLAB',...
    'Gradient Descent C++'})
title('Number of Iterations')
ylabel('n')