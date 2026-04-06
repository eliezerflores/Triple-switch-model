% Define the number of workers
numWorkers = 127;  % Use the number of CPUs allocated in the PBS script
load("LP_whiskers.mat");

% Start a parallel pool with the specified number of workers
if isempty(gcp('nocreate'))
    pool = parpool('local', numWorkers);  % Use the specified number of workers
end

num_simulations = 10000000;  % Number of iterations

% Initialize cells to store results
t_sw_all = cell(num_simulations, 1);
y_sw_all = cell(num_simulations, 1);
modified_params_all = cell(num_simulations, 1);

% Start the timer
tic;

% Extract bounds as column vectors
lb = LP_whiskers.LowerWhisker;
ub = LP_whiskers.UpperWhisker;

parfor i = 1:num_simulations
    params = zeros(16,1);

    % Sample each parameter within LP whisker bounds
    for p = 1:16
        if p == 1 || p == 2
            params(p) = 0;  % P_ex fixed at 0
        else
            params(p) = lb(p) + (ub(p) - lb(p)) * rand;
        end
    end

    % Store parameters
    modified_params_all{i} = params;

    % Run the simulation
    model = HDSModel(params);
    [t, y, t_sw, y_sw] = model.solve_ivp( ...
        linspace(0, 40, 80), ...
        [0.1, 1, 0.1, 0.1], ...
        [0, 0, 0] ...
    );

    % Store results
    t_sw_all{i} = t_sw;
    y_sw_all{i} = y_sw;
end

%% Convert to 0-3 code
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

% Loop through each element in y_TAD to filter based on the number of rows
for i = 1:length(y_TAD)
    current_matrix = y_TAD{i};
    
    % Check if the current matrix has more than 8 rows
    if size(current_matrix, 1) > 8
        % Add to y_LP and params_LP
        y_LP{end+1} = current_matrix;
        params_LP{end+1} = params_TAD{i};
    else
        % Keep track of indices to retain in y_TAD and params_TAD
        indices_to_keep = [indices_to_keep, i];
    end
end

% Retain only the elements with 8 or fewer rows in y_TAD and params_TAD
y_TAD = y_TAD(indices_to_keep);
params_TAD = params_TAD(indices_to_keep);

%% Stop the timer
simulation_time = toc;

% Display the elapsed time
fprintf('Total simulation time for %d simulations: %.2f seconds\n', num_simulations, simulation_time);

% Save the results to a .mat file
output_filename = 'simulation_results_10m_Jan2.mat';
save(output_filename, 'params_LP', 'params_TAD', 'simulation_time');

% Shut down the parallel pool
delete(gcp('nocreate'));
