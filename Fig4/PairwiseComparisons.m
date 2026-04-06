%If you don't want to calculate the Cliff's Delta (next section) just load
%CliffsDeltaResults.mat and jump to the visualization
% Define parameter names
param_names = {'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', 'delta_P', ...
    'kappa_B', 'gamma_BB', 'gamma_BR', 'delta_B', 'kappa_A', ...
    'gamma_AB', 'delta_A', 'kappa_D', 'delta_D'};

% Data groups
groups = {'NAD', 'TAD', 'AD', 'INT'};
data_groups = {NAD_downsampled, TAD_data_all, AD_downsampled, INT_downsampled};

% Initialize Cliff's Delta results
num_vars = size(NAD_downsampled, 2);
num_groups = length(groups);
cliffs_delta_results = zeros(num_groups, num_groups, num_vars);

%% Calculate Cliff's Delta for each pair of groups and each variable
for g1 = 1:num_groups
    for g2 = g1+1:num_groups
        for var_idx = 1:num_vars
            data1 = data_groups{g1}(:, var_idx);
            data2 = data_groups{g2}(:, var_idx);

            % Efficient calculation of Cliff's Delta
            N1 = 0;
            N2 = 0;
            for i = 1:length(data1)
                N1 = N1 + sum(data1(i) > data2); % data1 > data2
                N2 = N2 + sum(data1(i) < data2); % data1 < data2
            end

            % Cliff's Delta formula
            delta = (N1 - N2) / (length(data1) * length(data2));
            cliffs_delta_results(g1, g2, var_idx) = delta;
            cliffs_delta_results(g2, g1, var_idx) = -delta; % Symmetry
        end
    end
end

%% Visualization
%PAD vs NAD

parameters = {'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', ...
              'delta_P', 'kappa_B', 'gamma_BB', 'gamma_BR', ...
              'delta_B', 'kappa_A', 'gamma_AB', 'delta_A', ...
              'kappa_D', 'delta_D'};

% Set up figure
figure;
hold on;

% Initialize arrays for filtered effect sizes and labels
filtered_effect_sizes = [];
filtered_parameters = {};

% Loop through each parameter
for param = 1:14
    % Extract the effect size comparison (PAD vs NAD)
    effect_size_PAD_NAD = cliffs_delta_results(3, 1, param);
    
    % Only keep values where |effect size| >= 0.11
    if abs(effect_size_PAD_NAD) >= 0.11
        filtered_effect_sizes = [filtered_effect_sizes, effect_size_PAD_NAD];
        filtered_parameters{end + 1} = parameters{param}; % Store corresponding parameter name
    end
end

% Create a vertical bar plot with filtered values
b = bar(filtered_effect_sizes, 'FaceColor', 'flat');

% Assign colors for each bar
for i = 1:length(filtered_effect_sizes)
    if filtered_effect_sizes(i) > 0
        b.CData(i, :) = [1, 0, 0]; % Red for positive values
    else
        b.CData(i, :) = [0.5, 1, 0.5]; % Light green for negative values
    end
end

% Add labels and customize the plot
set(gca, 'XTick', 1:length(filtered_parameters), 'XTickLabel', filtered_parameters, 'XTickLabelRotation', 45);
ylabel('Effect Size');
xlabel('Parameters');
title('Effect Size Comparison: PAD vs NAD');
ylim([-1 1]); % Adjust y-axis to show effect sizes around 0
yline(0.11, '--k', 'LineWidth', 0.5);
yline(-0.11, '--k', 'LineWidth', 0.5);

hold off;

%% TAD vs NAD
parameters = {'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', ...
              'delta_P', 'kappa_B', 'gamma_BB', 'gamma_BR', ...
              'delta_B', 'kappa_A', 'gamma_AB', 'delta_A', ...
              'kappa_D', 'delta_D'};

% Set up figure
figure;
hold on;

% Initialize arrays for filtered effect sizes and labels
filtered_effect_sizes = [];
filtered_parameters = {};

% Loop through each parameter
for param = 1:14
    % Extract the effect size comparison (TAD vs NAD)
    effect_size_TAD_NAD = cliffs_delta_results(2, 1, param);
    
    % Only keep values where |effect size| >= 0.11
    if abs(effect_size_TAD_NAD) >= 0.11
        filtered_effect_sizes = [filtered_effect_sizes, effect_size_TAD_NAD];
        filtered_parameters{end + 1} = parameters{param}; % Store corresponding parameter name
    end
end

% Create a vertical bar plot with filtered values
b = bar(filtered_effect_sizes, 'FaceColor', 'flat');

% Assign colors for each bar
for i = 1:length(filtered_effect_sizes)
    if filtered_effect_sizes(i) > 0
        b.CData(i, :) = [1, 0, 0]; % Red for positive values
    else
        b.CData(i, :) = [0.5, 1, 0.5]; % Light green for negative values
    end
end

% Add labels and customize the plot
set(gca, 'XTick', 1:length(filtered_parameters), 'XTickLabel', filtered_parameters, 'XTickLabelRotation', 45);
ylabel('Effect Size');
xlabel('Parameters');
title('Effect Size Comparison: TAD vs NAD');
ylim([-1 1]); % Adjust y-axis to show effect sizes around 0
yline(0.11, '--k', 'LineWidth', 0.5);
yline(-0.11, '--k', 'LineWidth', 0.5);

hold off;


%% INT vs NAD
parameters = {'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', ...
              'delta_P', 'kappa_B', 'gamma_BB', 'gamma_BR', ...
              'delta_B', 'kappa_A', 'gamma_AB', 'delta_A', ...
              'kappa_D', 'delta_D'};

% Set up figure
figure;
hold on;

% Initialize arrays for filtered effect sizes and labels
filtered_effect_sizes = [];
filtered_parameters = {};

% Loop through each parameter
for param = 1:14
    % Extract the effect size comparison (LP vs NAD)
    effect_size_LP_NAD = cliffs_delta_results(4, 1, param);
    
    % Only keep values where |effect size| >= 0.11
    if abs(effect_size_LP_NAD) >= 0.11
        filtered_effect_sizes = [filtered_effect_sizes, effect_size_LP_NAD];
        filtered_parameters{end + 1} = parameters{param}; % Store corresponding parameter name
    end
end

% Create a vertical bar plot with filtered values
b = bar(filtered_effect_sizes, 'FaceColor', 'flat');

% Assign colors for each bar
for i = 1:length(filtered_effect_sizes)
    if filtered_effect_sizes(i) > 0
        b.CData(i, :) = [1, 0, 0]; % Red for positive values
    else
        b.CData(i, :) = [0.5, 1, 0.5]; % Light green for negative values
    end
end

% Add labels and customize the plot
set(gca, 'XTick', 1:length(filtered_parameters), 'XTickLabel', filtered_parameters, 'XTickLabelRotation', 45);
ylabel('Effect Size');
xlabel('Parameters');
title('Effect Size Comparison: INT vs NAD');
ylim([-1 1]); % Adjust y-axis to show effect sizes around 0
yline(0.11, '--k', 'LineWidth', 0.5);
yline(-0.11, '--k', 'LineWidth', 0.5);

hold off;
