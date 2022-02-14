%% 
% Basic performance statistics

% Mean
mean_pr_matlab = mean(op_pr_matlab);
mean_pr_cpp = mean(op_pr_cpp);
mean_sgd_matlab = mean(op_sgd_matlab);
mean_sgd_cpp = mean(op_sgd_cpp);

% Standard deviation
std_pr_matlab = std(op_pr_matlab);
std_pr_cpp = std(op_pr_cpp);
std_sgd_matlab = std(op_sgd_matlab);
std_sgd_cpp = std(op_sgd_cpp);

% Median
med_pr_matlab = median(op_pr_matlab);
med_pr_cpp = median(op_pr_cpp);
med_sgd_matlab = median(op_sgd_matlab);
med_sgd_cpp = median(op_sgd_cpp);