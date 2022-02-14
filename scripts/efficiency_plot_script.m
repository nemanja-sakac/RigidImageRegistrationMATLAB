%%
% Efficiency plots for the gradient descent and nonlinear
% conjugate-gradient descent for each level of the Gaussian pyramid using a
% a multiresolution approach
%%
figure
plot(opt_params_van(:, 5), opt_params_van(:, 4))
title('Vanilla Gradient Descent - Efficiency');
xlabel('Pyramid Level');
ylabel('Time(s)');

%%
figure
plot(opt_params_conj(:, 5), opt_params_conj(:, 4))
title('Polak-Ribiere Gradient Descent - Efficiency');
xlabel('Pyramid Level');
ylabel('Time(s)');

%%
figure
plot([opt_params_van(:, 5), opt_params_conj(:, 5) ],...
    [opt_params_van(:, 4), opt_params_conj(:, 4)])
title('Efficiency');
legend('Vanilla', 'Polak-Ribiere');
xlabel('Pyramid Level');
ylabel('Time(s)');

%%
% Based on the excel spreadsheet calculations of the mean
mean_pr = [9.74552579; 0.96059396; 0.1481705; 0.14577961];
mean_gd = [8.58798958; 0.61906436; 0.17408564; 0.14204694];
pyr_lvl = [0; 1; 2; 3];

figure
plot([pyr_lvl, pyr_lvl], [mean_gd, mean_pr])
title('Efficiency');
legend('GD', 'PR');
xlabel('Pyramid Level');
ylabel('Time(s)');