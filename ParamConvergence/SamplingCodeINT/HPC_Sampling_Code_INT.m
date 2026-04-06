% Define the number of workers
numWorkers = 127;  % Use the number of CPUs allocated in the PBS script
load("LP_whiskers.mat");

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

% Extract bounds as column vectors
lb = LP_whiskers.LowerWhisker;
ub = LP_whiskers.UpperWhisker;

parfor i = 1:num_simulations
    params = zeros(16,1);

    % Sample each parameter within LP whisker bounds
    for p = 1:16
        if p == 1 || p == 2
            params(p) = 0;   % fix p1 and p2 to zero
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

% Stop the timer
simulation_time = toc;

% Display the elapsed time
fprintf('Total simulation time for %d simulations: %.2f seconds\n', num_simulations, simulation_time);

% Save the results to a .mat file
output_filename = 'Results_1m_Jan2.mat';
save(output_filename, 'modified_params_all', 't_sw_all', 'y_sw_all');

% Shut down the parallel pool
delete(gcp('nocreate'));
