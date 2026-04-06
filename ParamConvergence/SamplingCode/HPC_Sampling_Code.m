% Define the number of workers
numWorkers = 127;  % Use the number of CPUs allocated in the PBS script

% Start a parallel pool with the specified number of workers
if isempty(gcp('nocreate'))
    pool = parpool('local', numWorkers);  % Use the specified number of workers
end

num_simulations = 1000000;  % Number of iterations

% Initialize cells to store results
t_sw_all = cell(num_simulations, 1);
y_sw_all = cell(num_simulations, 1);
modified_params_all = cell(num_simulations, 1);

% Start the timer
tic;

% Parallel loop for simulations
parfor i = 1:num_simulations
    % Create random parameters
    params = 0.1 + (10 - 0.1) * rand(16, 1);  % All parameters random
    params(1) = 0;                           % Keep (B_ex) fixed at 0
    params(2) = 0;                           % Keep (P_ex) fixed at 0
    
    % Store modified parameters
    modified_params_all{i} = params;

    % Run the simulation (assuming HDSModel is your model function)
    model = HDSModel(params);
    [t, y, t_sw, y_sw] = model.solve_ivp(linspace(0, 40, 80), [0.1, 1, 0.1, 0.1], [0, 0, 0]);
    
    % Store results
    t_sw_all{i} = t_sw;
    y_sw_all{i} = y_sw;
end

% Stop the timer
simulation_time = toc;

% Display the elapsed time
fprintf('Total simulation time for %d simulations: %.2f seconds\n', num_simulations, simulation_time);

% Save the results to a .mat file
output_filename = 'Results_1m.mat';
save(output_filename, 'modified_params_all', 't_sw_all', 'y_sw_all');

% Shut down the parallel pool
delete(gcp('nocreate'));
