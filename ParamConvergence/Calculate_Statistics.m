%% Number of sample sizes
num_sample_sizes = 7;

% Initialize cell arrays to hold the parameter matrices and group labels
sample_matrices = cell(1, num_sample_sizes);
group_cells = cell(1, num_sample_sizes);

% Assume matrices are named all_params_1, all_params_2, ..., all_params_7
% and group labels are named group_labels_1, group_labels_2, ..., group_labels_7
for i = 1:num_sample_sizes
    sample_matrices{i} = eval(['all_params_', num2str(i)]);  % Load matrix into cell array
    group_cells{i} = eval(['group_labels_', num2str(i)]);    % Load group labels into cell array
end

% Parameters
param_names = {'B_ex', 'M_ex', 'M_env', 'kappa_M', 'alpha_M', 'gamma_MB', 'delta_M', ...
    'kappa_B', 'gamma_BB', 'gamma_BR', 'delta_B', 'kappa_A', ...
    'gamma_AB', 'delta_A', 'kappa_D', 'delta_D'};
num_params = length(param_names);

% Initialize cell arrays to hold results
means = cell(1, num_sample_sizes);
medians = cell(1, num_sample_sizes);
variances = cell(1, num_sample_sizes);
iqrs = cell(1, num_sample_sizes);

%% Effect Size, Central Tendency, and Spread Calculation
for i = 1:num_sample_sizes
    % Load current sample data
    current_matrix = sample_matrices{i}; % ith matrix with parameter data
    group_labels = group_cells{i}; % ith cell with group labels

    % Initialize arrays to store results for this sample size
    means{i} = zeros(num_params, 4);  % 4 groups
    medians{i} = zeros(num_params, 4);
    variances{i} = zeros(num_params, 4);
    iqrs{i} = zeros(num_params, 4);

    for j = 1:num_params
        % Extract parameter data for this column
        param_data = current_matrix(:, j);

        % Group-wise data extraction
        AD_data = param_data(strcmp(group_labels, 'AD'));
        NAD_data = param_data(strcmp(group_labels, 'NAD'));
        TAD_data = param_data(strcmp(group_labels, 'TAD'));
        LP_data = param_data(strcmp(group_labels, 'INT'));

        % Central Tendency (Mean and Median)
        means{i}(j, :) = [mean(AD_data), mean(NAD_data), mean(TAD_data), mean(LP_data)];
        medians{i}(j, :) = [median(AD_data), median(NAD_data), median(TAD_data), median(LP_data)];

        % Spread (Variance and IQR)
        variances{i}(j, :) = [var(AD_data), var(NAD_data), var(TAD_data), var(LP_data)];
        iqrs{i}(j, :) = [iqr(AD_data), iqr(NAD_data), iqr(TAD_data), iqr(LP_data)];
    end
end

%% Central Tendency and Spread Convergence Plots
%You can visualize any parameter (from 3 to 16) by editing j. For INT run
%the _INT script loading the corresponding _INT sampling data
for j = 3
    figure;
    subplot(2, 1, 1);
    hold on;
    means_over_samples = cell2mat(cellfun(@(x) x(j, :)', means, 'UniformOutput', false));
    plot(1:num_sample_sizes, means_over_samples, 'LineWidth', 2);
    xlabel('Sample Size');
    ylabel('Mean');
    title(['Mean Convergence for ', param_names{j}]);
    %set(gca, 'XScale', 'log');
    legend({'AD', 'NAD', 'TAD', 'INT'}, 'Location', 'Best');
    hold off;

    subplot(2, 1, 2);
    hold on;
    variances_over_samples = cell2mat(cellfun(@(x) x(j, :)', variances, 'UniformOutput', false));
    plot(1:num_sample_sizes, variances_over_samples, 'LineWidth', 2);
    xlabel('Sample Size');
    ylabel('Variance');
    title(['Variance Convergence for ', param_names{j}]);
    %set(gca, 'XScale', 'log');
    legend({'AD', 'NAD', 'TAD', 'INT'}, 'Location', 'Best');
    hold off;
end
