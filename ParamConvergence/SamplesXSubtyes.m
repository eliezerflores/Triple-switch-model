%% This code takes the output of the sampling code and labels virtual patients in subtypes
%Convert to 0-3 code
% Determine the number of objects in this iteration
num_objects = length(t_sw_all);

% Determine the maximum length of t_sw
max_length_t_sw = max(cellfun(@(x) length(x), t_sw_all));

% Initialize the transitions matrix
transitions = zeros(num_objects, max_length_t_sw);

% Loop over each object to process y_sw
for i = 1:num_objects
    y_sw = y_sw_all{i};  % Extract the current y_sw
    num_rows = size(y_sw, 1);  % Number of rows in the current y_sw

    % Label each row of y_sw
    labels = zeros(num_rows, 1);
    for j = 1:num_rows
        if sum(y_sw(j, :)) == 0
            labels(j) = 0;
        elseif sum(y_sw(j, :)) == 1
            labels(j) = 1;
        elseif sum(y_sw(j, :)) == 2
            labels(j) = 2;
        elseif sum(y_sw(j, :)) == 3
            labels(j) = 3;
        end
    end

    % Fill the corresponding row in transitions matrix
    transitions(i, 1:num_rows) = labels';

    % Fill the remaining columns with the last label if y_sw is shorter than max_length_t_sw
    if num_rows < max_length_t_sw
        transitions(i, num_rows+1:end) = labels(end);
    end
end

%% Classify the transitions into NAD, TAD/LP or AD
% Classification labels
NAD_label = 1; 
TAD_label = 2; 
AD_label = 3;

% Initialize the classification array for this iteration
classifications = zeros(size(transitions, 1), 1);

% Initialize cell arrays to store params based on classifications
params_NAD = {};
params_TAD = {};
params_AD = {};

% Loop over each row in the transitions matrix to classify
for i = 1:size(transitions, 1)
    transition_row = transitions(i, :);
    
    % Assign classification based on the detected pattern
    if  all(ismember(transition_row, [0, 1]))  % NAD: only 0s and 1s
        classifications(i) = NAD_label;
        params_NAD{end+1} = modified_params_all{i}; % Store params in params_NAD
    elseif all(ismember(transition_row(3:end), [2, 3]))  % AD: only 2s and 3s from the 3rd transition
        classifications(i) = AD_label;
        params_AD{end+1} = modified_params_all{i}; % Store params in params_AD
    else
        classifications(i) = TAD_label; % TAD: ends with 0 or 1 but has at least one 2 or 3
        params_TAD{end+1} = modified_params_all{i}; % Store params in params_TAD
    end
end

%% Separate LP from TAD based on number of transitions
y_TAD = y_sw_all(classifications == 2);
y_LP = {};       % To store matrices with more than 8 rows
params_LP = {};  % To store corresponding parameters

% Indices to keep for y_TAD and params_TAD
indices_to_keep = [];
indices_to_LP = [];

% Loop through each element in y_TAD to filter based on the number of rows
for i = 1:length(y_TAD)
    current_matrix = y_TAD{i};
    
    % Check if the current matrix has more than 8 rows
    if size(current_matrix, 1) > 8
        % Add to y_LP and params_LP
        y_LP{end+1} = current_matrix;
        params_LP{end+1} = params_TAD{i};
        indices_to_LP = [indices_to_LP,i];
    else
        % Keep track of indices to retain in y_TAD and params_TAD
        indices_to_keep = [indices_to_keep, i];
    end
end

% Retain only the elements with 8 or fewer rows in y_TAD and params_TAD
y_TAD = y_TAD(indices_to_keep);
params_TAD = params_TAD(indices_to_keep);

 %% Look at parameter values
% Initialize empty arrays to hold the parameters and group labels
all_params = [];  % To store all parameters
group_labels = {};  % To store corresponding group labels

% Process each cell object to combine parameters and labels
[all_params, group_labels] = process_params(params_NAD, 'NAD', all_params, group_labels);
[all_params, group_labels] = process_params(params_AD, 'AD', all_params, group_labels);
[all_params, group_labels] = process_params(params_TAD, 'TAD', all_params, group_labels);
[all_params, group_labels] = process_params(params_LP, 'LP', all_params, group_labels);

%% Convert group_labels to a categorical array for the boxplot
group_labels = categorical(group_labels);
param_names = {'B_ex', 'P_ex', 'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', 'delta_P', ...
    'kappa_B', 'gamma_BB', 'gamma_BR', 'delta_B', 'kappa_A', ...
    'gamma_AB', 'delta_A', 'kappa_D', 'delta_D'};

% Create boxplots for each parameter (ignore the first two parameters as instructed)
figure;
num_params = 16;  % Number of parameters
for paramIdx = 3:num_params
    subplot(4, 4, paramIdx - 2);  % Subplot grid
    boxplot(all_params(:, paramIdx), group_labels, 'Notch', 'on');
    title(param_names{paramIdx});
    xlabel('Behavior');
    ylabel('Parameter Value');
end

sgtitle('Distribution of Parameters Across Different Behaviors');

%% Per cluster visualization
% List of parameter names (keeping the order as specified)
param_names = {
    'B_ex', 'P_ex', 'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', 'delta_P', ...
    'kappa_B', 'gamma_BB', 'gamma_BR', 'delta_B', 'kappa_A', ...
    'gamma_AB', 'delta_A', 'kappa_D', 'delta_D'
};

% Define behaviors and corresponding parameter cells
behaviors = {'NAD', 'AD', 'TAD', 'LP'};
grouping_labels = {params_NAD, params_AD, params_TAD, params_LP};

% Iterate through each behavior and create a figure
for behIdx = 1:length(behaviors)
    
    % Create a new figure for each behavior
    figure;
    behavior_name = behaviors{behIdx};
    
    % Extract the parameters for the current behavior
    current_params = grouping_labels{behIdx};
    
    % Initialize matrix to hold parameters
    behavior_params = zeros(length(current_params), 16);
    
    % Loop through each cell and fill behavior_params
    for i = 1:length(current_params)
        behavior_params(i, :) = current_params{i}(:)'; % Convert to row vector and fill the matrix
    end
    
    % Ignore the second parameter and only plot the rest
    params_to_plot = behavior_params(:, [1, 3:end]);
    
    % Create boxplots for all parameters in a single figure
    boxplot(params_to_plot, 'Notch', 'on');
    
    % Set x-axis labels to parameter names (ignoring the second)
    set(gca, 'XTickLabel', param_names(:, [1, 3:end]));
    xtickangle(45);  % Rotate x-axis labels for better readability
    xlabel('Parameters');
    ylabel('Parameter Value');
    
    % Set the title for each figure
    title(['Parameter Distribution for ', behavior_name, ' Behavior']);
    
end

%% Functions 
% Function to process and combine parameters
function [all_params, group_labels] = process_params(cell_object, behavior_label, all_params, group_labels)
    if ~isempty(cell_object)
        % Extract parameters from the cell object and ensure correct orientation
        num_entries = numel(cell_object);  % Number of parameter sets
        params_matrix = zeros(num_entries, 16);  % Pre-allocate for performance

        % Fill the params_matrix with parameter sets
        for idx = 1:num_entries
            params_matrix(idx, :) = cell_object{idx}';  % Transpose to ensure 1x16 row vector
        end
        
        % Append to the combined parameter array
        all_params = [all_params; params_matrix];
        
        % Create corresponding labels for each parameter set
        labels = repmat({behavior_label}, num_entries, 1);
        
        % Append to the group labels array
        group_labels = [group_labels; labels];
    end
end