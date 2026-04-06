%% This is for producing all figures of Supplementary File 1
% Define the convergence threshold
convergence_threshold = 2;  % Example threshold in percent

% Population sizes corresponding to the matrices in 'means'
population_sizes = [10; 100; 1000; 10000; 100000; 1000000; 10000000];

% Number of parameters and classifications
num_params = 16;
num_classes = 4;

group_names = {'PAD', 'NAD', 'TAD', 'INT'};
param_names = {'B_ex', 'M_ex', 'M_env', 'kappa_M', 'alpha_M', 'gamma_MB', 'delta_M', ...
    'kappa_B', 'gamma_BB', 'gamma_BR', 'delta_B', 'kappa_A', ...
    'gamma_AB', 'delta_A', 'kappa_D', 'delta_D'};

% Initialize 3D arrays to hold means, medians, and variances
% Dimensions: [population_size, parameter_index, classification_index]
all_means = zeros(length(population_sizes), num_params, num_classes);
all_medians = zeros(length(population_sizes), num_params, num_classes);
all_variances = zeros(length(population_sizes), num_params, num_classes);

% Extract the means, medians, and variances from their respective cell arrays
for i = 1:length(population_sizes)
    for param_idx = 1:num_params
        for class_idx = 1:num_classes
            all_means(i, param_idx, class_idx) = means{i}(param_idx, class_idx);
            all_medians(i, param_idx, class_idx) = medians{i}(param_idx, class_idx);
            all_variances(i, param_idx, class_idx) = variances{i}(param_idx, class_idx);
        end
    end
end

% Initialize matrices for storing results
convergence_means = zeros(num_params, num_classes);
non_converged_means = cell(num_params, num_classes);

convergence_medians = zeros(num_params, num_classes);
non_converged_medians = cell(num_params, num_classes);

convergence_variances = zeros(num_params, num_classes);
non_converged_variances = cell(num_params, num_classes);

% Analyze convergence for each parameter and classification
for param_idx = 1:num_params
    for class_idx = 1:num_classes
        % ---- MEANS ----
        means_across_pops = squeeze(all_means(:, param_idx, class_idx));
        abs_differences_means = abs(diff(means_across_pops));
        percent_changes_means = 100 * abs_differences_means ./ abs(means_across_pops(1:end-1));
        
        % Check if the last change exceeds the threshold -> automatic non-convergence
        if percent_changes_means(end) > convergence_threshold
            means_converged = false;
        else
            % Check if 80% or more of the changes are below the threshold
            changes_below_threshold_means = sum(percent_changes_means < convergence_threshold);
            if changes_below_threshold_means / length(percent_changes_means) >= 0.1
                means_converged = true;
            else
                means_converged = false;
            end
        end
        
        % Store convergence status
        convergence_means(param_idx, class_idx) = means_converged;
        
        % Store values and differences for non-converged parameters
        if ~means_converged
            non_converged_means{param_idx, class_idx} = [means_across_pops, [abs(diff(means_across_pops)); NaN]];
        end
        
        % ---- MEDIANS ----
        medians_across_pops = squeeze(all_medians(:, param_idx, class_idx));
        abs_differences_medians = abs(diff(medians_across_pops));
        percent_changes_medians = 100 * abs_differences_medians ./ abs(medians_across_pops(1:end-1));
        
        % Check if the last change exceeds the threshold -> automatic non-convergence
        if percent_changes_medians(end) > convergence_threshold
            medians_converged = false;
        else
            % Check if 80% or more of the changes are below the threshold
            changes_below_threshold_medians = sum(percent_changes_medians < convergence_threshold);
            if changes_below_threshold_medians / length(percent_changes_medians) >= 0.1
                medians_converged = true;
            else
                medians_converged = false;
            end
        end
        
        % Store convergence status
        convergence_medians(param_idx, class_idx) = medians_converged;
        
        % Store values and differences for non-converged parameters
        if ~medians_converged
            non_converged_medians{param_idx, class_idx} = [medians_across_pops, [abs(diff(medians_across_pops)); NaN]];
        end
        
        % ---- VARIANCES ----
        variances_across_pops = squeeze(all_variances(:, param_idx, class_idx));
        abs_differences_variances = abs(diff(variances_across_pops));
        percent_changes_variances = 100 * abs_differences_variances ./ abs(variances_across_pops(1:end-1));
        
        % Check if the last change exceeds the threshold -> automatic non-convergence
        if percent_changes_variances(end) > convergence_threshold
            variances_converged = false;
        else
            % Check if 80% or more of the changes are below the threshold
            changes_below_threshold_variances = sum(percent_changes_variances < convergence_threshold);
            if changes_below_threshold_variances / length(percent_changes_variances) >= 0.1
                variances_converged = true;
            else
                variances_converged = false;
            end
        end
        
        % Store convergence status
        convergence_variances(param_idx, class_idx) = variances_converged;
        
        % Store values and differences for non-converged parameters
        if ~variances_converged
            non_converged_variances{param_idx, class_idx} = [variances_across_pops, [abs(diff(variances_across_pops)); NaN]];
        end
    end
end

% The results of the convergence checks are in convergence_means, convergence_medians, and convergence_variances
% Non-converged values and their differences are stored in non_converged_means, non_converged_medians, and non_converged_variances

%% Plot and Save Results (Means Across Population Sizes)

output_folder = 'Mean_Plots';  % Folder to save plots
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for param_idx = 1:16
    for class_idx = 1:num_classes
        % Extract the means across population sizes for this parameter and classification
        means_across_pops = squeeze(all_means(:, param_idx, class_idx));
        
        % Calculate absolute differences between successive means
        abs_differences = abs(diff(means_across_pops));
        
        % Calculate percentage changes between successive means
        percent_changes = 100 * abs_differences ./ abs(means_across_pops(1:end-1));
        
        % Get parameter and group names
        param_name = param_names{param_idx};
        class_name = group_names{class_idx};
        
        % Create a descriptive figure name
        fig_title = sprintf('Parameter: %s | Classification: %s', param_name, class_name);
        fig_filename = sprintf('%s/Mean_%s_%s.png', output_folder, param_name, class_name);
        %fig_filename = sprintf('%s/Mean_%s_%s.svg', output_folder, param_name, class_name);
        
        % Create figure (invisible, for saving only)
        fig = figure('Visible', 'off', 'Name', fig_title, 'NumberTitle', 'off');
        
        % Subplot 1: Means vs Population Size
        subplot(2,1,1);
        plot(log10(population_sizes), means_across_pops, '-o', ...
            'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
        xlabel('Log_{10} of Population Size');
        ylabel('Mean Value');
        title(sprintf('%s\nMean vs Population Size', fig_title), 'Interpreter', 'none');
        
        % Set x-axis ticks to actual log10(population_sizes) values
        xticks(log10(population_sizes));
        xticklabels(arrayfun(@(x) sprintf('%.0f', log10(x)), population_sizes, 'UniformOutput', false));
        
        % Subplot 2: Percentage change
        subplot(2,1,2);
        plot(log10(population_sizes(2:end)), percent_changes, '-o', ...
            'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
        xlabel('Log_{10} of Population Size');
        ylabel('Percentage Change in Mean');
        title(sprintf('%s\nPercentage Change Between Successive Population Sizes', fig_title), 'Interpreter', 'none');
        
        % Set x-axis ticks to actual log10(population_sizes)
        xticks(log10(population_sizes(2:end)));
        xticklabels(arrayfun(@(x) sprintf('%.0f', log10(x)), population_sizes(2:end), 'UniformOutput', false));
        
        % Add horizontal line for convergence threshold
        hold on;
        yline(2, '--r', 'Convergence Threshold (2%)');
        hold off;
        
        % Adjust layout and save
        set(gcf, 'Position', [100, 100, 700, 600]);
        saveas(fig, fig_filename);
        close(fig);
    end
end

disp('All parameter plots saved successfully.');


%% Plot and Save Results (Medians Across Population Sizes)

output_folder = 'Median_Plots';  % Folder to save plots
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for param_idx = 1:16
    for class_idx = 1:num_classes
        % Extract the medians across population sizes for this parameter and classification
        medians_across_pops = squeeze(all_medians(:, param_idx, class_idx));
        
        % Calculate absolute differences between successive medians
        abs_differences = abs(diff(medians_across_pops));
        
        % Calculate percentage changes between successive medians
        percent_changes = 100 * abs_differences ./ abs(medians_across_pops(1:end-1));
        
        % Get parameter and group names
        param_name = param_names{param_idx};
        class_name = group_names{class_idx};
        
        % Clean names for filenames
        clean_param = strrep(param_name, '_', '-');
        clean_class = strrep(class_name, '_', '-');
        
        % Create a descriptive figure name
        fig_title = sprintf('Parameter: %s | Classification: %s', param_name, class_name);
        fig_filename = sprintf('%s/Median_%s_%s.png', output_folder, clean_param, clean_class);
        
        % Create figure (invisible)
        fig = figure('Visible', 'off', 'Name', fig_title, 'NumberTitle', 'off');
        
        % Subplot 1: Medians vs Population Size
        subplot(2,1,1);
        plot(log10(population_sizes), medians_across_pops, '-o', ...
            'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
        xlabel('Log_{10} of Population Size');
        ylabel('Median Value');
        title(sprintf('%s\nMedian vs Population Size', fig_title), 'Interpreter', 'none');
        
        % Set x-axis ticks
        xticks(log10(population_sizes));
        xticklabels(arrayfun(@(x) sprintf('%.0f', log10(x)), population_sizes, 'UniformOutput', false));
        
        % Subplot 2: Percentage changes
        subplot(2,1,2);
        plot(log10(population_sizes(2:end)), percent_changes, '-o', ...
            'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
        xlabel('Log_{10} of Population Size');
        ylabel('Percentage Change in Median');
        title(sprintf('%s\nPercentage Change Between Successive Population Sizes', fig_title), 'Interpreter', 'none');
        ylim([0 10]);

        % Set x-axis ticks
        xticks(log10(population_sizes(2:end)));
        xticklabels(arrayfun(@(x) sprintf('%.0f', log10(x)), population_sizes(2:end), 'UniformOutput', false));
        
        % Add threshold line
        hold on;
        yline(2, '--r', 'Convergence Threshold (2%)');
        hold off;
        
        % Adjust layout, save, and close
        set(gcf, 'Position', [100, 100, 700, 600]);
        saveas(fig, fig_filename);
        close(fig);
    end
end

disp('All median plots saved successfully.');


%% Plot and Save Results (Variances Across Population Sizes)

output_folder = 'Variance_Plots';  % Folder to save plots
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for param_idx = 1:16
    for class_idx = 1:num_classes
        % Extract the variances across population sizes for this parameter and classification
        variance_across_pops = squeeze(all_variances(:, param_idx, class_idx));
        
        % Calculate absolute differences between successive variances
        abs_differences = abs(diff(variance_across_pops));
        
        % Calculate percentage changes between successive variances
        percent_changes = 100 * abs_differences ./ abs(variance_across_pops(1:end-1));
        
        % Get parameter and group names
        param_name = param_names{param_idx};
        class_name = group_names{class_idx};
        
        % Clean names for filenames
        clean_param = strrep(param_name, '_', '-');
        clean_class = strrep(class_name, '_', '-');
        
        % Create a descriptive figure name
        fig_title = sprintf('Parameter: %s | Classification: %s', param_name, class_name);
        fig_filename = sprintf('%s/Variance_%s_%s.png', output_folder, clean_param, clean_class);
        
        % Create figure (invisible)
        fig = figure('Visible', 'off', 'Name', fig_title, 'NumberTitle', 'off');
        
        % Subplot 1: Variance vs Population Size
        subplot(2,1,1);
        plot(log10(population_sizes), variance_across_pops, '-o', ...
            'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
        xlabel('Log_{10} of Population Size');
        ylabel('Variance Value');
        title(sprintf('%s\nVariance vs Population Size', fig_title), 'Interpreter', 'none');
        
        % Set x-axis ticks
        xticks(log10(population_sizes));
        xticklabels(arrayfun(@(x) sprintf('%.0f', log10(x)), population_sizes, 'UniformOutput', false));
        
        % Subplot 2: Percentage changes
        subplot(2,1,2);
        plot(log10(population_sizes(2:end)), percent_changes, '-o', ...
            'MarkerFaceColor', 'auto', 'LineWidth', 1.5);
        xlabel('Log_{10} of Population Size');
        ylabel('Percentage Change in Variance');
        title(sprintf('%s\nPercentage Change Between Successive Population Sizes', fig_title), 'Interpreter', 'none');
        ylim([0 10]);

        % Set x-axis ticks
        xticks(log10(population_sizes(2:end)));
        xticklabels(arrayfun(@(x) sprintf('%.0f', log10(x)), population_sizes(2:end), 'UniformOutput', false));
        
        % Add threshold line
        hold on;
        yline(2, '--r', 'Convergence Threshold (2%)');
        hold off;
        
        % Adjust layout, save, and close
        set(gcf, 'Position', [100, 100, 700, 600]);
        saveas(fig, fig_filename);
        close(fig);
    end
end

disp('All variance plots saved successfully.');
