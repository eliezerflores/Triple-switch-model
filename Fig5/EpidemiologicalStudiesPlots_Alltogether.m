%% PAD
% Import the CSV file
data = readtable('PAD_all.csv');

% Extract columns
years = data{:, 1};       % First column: Years (X-axis)
probability = data{:, 2}; % Second column: Probability (Y-axis)
tags = data{:, 3};        % Third column: Group Labels

% Get unique groups
unique_tags = unique(tags);

% Define colors for plotting
colors = lines(length(unique_tags)); % Use a colormap to assign unique colors

% Define different markers for each group
markers = {'o', 's', 'd', '^', 'v', 'p', 'h', '*', '+', '>', '<'}; 
num_markers = length(markers);

figure;
hold on;
grid on;
xlabel('Years');
ylabel('Probability (%)');
title('PAD Probability Over Time');
xlim([0 16])

% Plot each group separately
for i = 1:length(unique_tags)
    % Find indices corresponding to the current tag
    idx = strcmp(tags, unique_tags{i});
    
    % Select a marker (cycle through the list if there are more groups than markers)
    marker_style = markers{mod(i-1, num_markers) + 1};
    
    % Plot the data with filled markers
    plot(years(idx), probability(idx), '-', 'Color', colors(i, :), ...
         'DisplayName', unique_tags{i}, 'LineWidth', 1.5);
    
    scatter(years(idx), probability(idx), 60, colors(i, :), 'filled', ...
            'Marker', marker_style, 'DisplayName', '');
end

legend('show', 'Location', 'best');
hold off;

%% TAD Early Onset
% Import the CSV file
data = readtable('TAD_EarlyOnset.csv');

% Extract columns
years = data{:, 1};       % First column: Years (X-axis)
probability = data{:, 2}; % Second column: Probability (Y-axis)
tags = data{:, 3};        % Third column: Group Labels

% Get unique groups
unique_tags = unique(tags);

% Define colors for plotting
colors = lines(length(unique_tags)); % Use a colormap to assign unique colors

% Define different markers for each group
markers = {'s', 'd', 'v', 'v','p', 'h', '*', '+', '>', '<'}; 
num_markers = length(markers);

figure;
hold on;
grid on;
xlabel('Years');
ylabel('Probability (%)');
title('TAD Early Onset Probability Over Time');

% Plot each group separately
for i = 1:length(unique_tags)
    % Find indices corresponding to the current tag
    idx = strcmp(tags, unique_tags{i});
    
    % Select a marker (cycle through the list if there are more groups than markers)
    marker_style = markers{mod(i-1, num_markers) + 1};
    
    % Plot the data with filled markers
    plot(years(idx), probability(idx), '-', 'Color', colors(i, :), ...
         'DisplayName', unique_tags{i}, 'LineWidth', 1.5);
    
    scatter(years(idx), probability(idx), 60, colors(i, :), 'filled', ...
            'Marker', marker_style, 'DisplayName', '');
end

legend('show', 'Location', 'best');
hold off;

%% TAD Mid Onset
% Import the CSV file
data = readtable('TAD_MidOnset.csv');

% Extract columns
years = data{:, 1};       % First column: Years (X-axis)
probability = data{:, 2}; % Second column: Probability (Y-axis)
tags = data{:, 3};        % Third column: Group Labels

% Get unique groups
unique_tags = unique(tags);

% Define colors for plotting
colors = lines(length(unique_tags)); % Use a colormap to assign unique colors

% Define different markers for each group
markers = {'o', 's', 'd', '^', 'v', 'p', 'h', '*', '+', '>', '<'}; 
num_markers = length(markers);

figure;
hold on;
grid on;
xlabel('Years');
ylabel('Probability (%)');
title('TAD Mid Onset Probability Over Time');
xlim([0 16])

% Plot each group separately
for i = 1:length(unique_tags)
    % Find indices corresponding to the current tag
    idx = strcmp(tags, unique_tags{i});
    
    % Select a marker (cycle through the list if there are more groups than markers)
    marker_style = markers{mod(i-1, num_markers) + 1};
    
    % Plot the data with filled markers
    plot(years(idx), probability(idx), '-', 'Color', colors(i, :), ...
         'DisplayName', unique_tags{i}, 'LineWidth', 1.5);
    
    scatter(years(idx), probability(idx), 60, colors(i, :), 'filled', ...
            'Marker', marker_style, 'DisplayName', '');
end

legend('show', 'Location', 'best');
hold off;

%% TAD Late Onset
% Import the CSV file
data = readtable('TAD_LateOnset.csv');

% Extract columns
years = data{:, 1};       % First column: Years (X-axis)
probability = data{:, 2}; % Second column: Probability (Y-axis)
tags = data{:, 3};        % Third column: Group Labels

% Get unique groups
unique_tags = unique(tags);

% Define colors for plotting
colors = lines(length(unique_tags)); % Use a colormap to assign unique colors

% Define different markers for each group
markers = {'o', 's', 'd', 'p', 'h', '*', '+', '>', '<'}; 
num_markers = length(markers);

figure;
hold on;
grid on;
xlabel('Years');
ylabel('Probability (%)');
title('TAD Late Onset Probability Over Time');
xlim([0 16])

% Plot each group separately
for i = 1:length(unique_tags)
    % Find indices corresponding to the current tag
    idx = strcmp(tags, unique_tags{i});
    
    % Select a marker (cycle through the list if there are more groups than markers)
    marker_style = markers{mod(i-1, num_markers) + 1};
    
    % Plot the data with filled markers
    plot(years(idx), probability(idx), '-', 'Color', colors(i, :), ...
         'DisplayName', unique_tags{i}, 'LineWidth', 1.5);
    
    scatter(years(idx), probability(idx), 60, colors(i, :), 'filled', ...
            'Marker', marker_style, 'DisplayName', '');
end

legend('show', 'Location', 'best');
hold off;

%% NAD
% Import the CSV file
data = readtable('NAD_all.csv');

% Extract columns
years = data{:, 1};       % First column: Years (X-axis)
probability = data{:, 2}; % Second column: Probability (Y-axis)
tags = data{:, 3};        % Third column: Group Labels

% Get unique groups
unique_tags = unique(tags);

% Define colors for plotting
colors = lines(length(unique_tags)); % Use a colormap to assign unique colors

% Define different markers for each group
markers = {'o', 's', 'd', '^', 'v', 'p', 'h', '*', '+', '>', '<'}; 
num_markers = length(markers);

figure;
hold on;
grid on;
xlabel('Years');
ylabel('Probability (%)');
ylim([0 100])
title('NAD Probability Over Time');
xlim([0 16])

% Plot each group separately
for i = 1:length(unique_tags)
    % Find indices corresponding to the current tag
    idx = strcmp(tags, unique_tags{i});
    
    % Select a marker (cycle through the list if there are more groups than markers)
    marker_style = markers{mod(i-1, num_markers) + 1};
    
    % Plot the data with filled markers
    plot(years(idx), probability(idx), '-', 'Color', colors(i, :), ...
         'DisplayName', unique_tags{i}, 'LineWidth', 1.5);
    
    scatter(years(idx), probability(idx), 60, colors(i, :), 'filled', ...
            'Marker', marker_style, 'DisplayName', '');
end

legend('show', 'Location', 'best');
hold off;

%% INT
% Import the CSV file
data = readtable('INT_all.csv');

% Extract columns
years = data{:, 1};       % First column: Years (X-axis)
probability = data{:, 2}; % Second column: Probability (Y-axis)
tags = data{:, 3};        % Third column: Group Labels

% Get unique groups
unique_tags = unique(tags);

% Define colors for plotting
colors = lines(length(unique_tags)); % Use a colormap to assign unique colors

% Define different markers for each group
markers = {'o','d', '^', 'v', 'p', 'h', '*', '+', '>', '<'}; 
num_markers = length(markers);

figure;
hold on;
grid on;
xlabel('Years');
ylabel('Probability (%)');
ylim([0 100])
title('INT Probability Over Time');
xlim([0 16])

% Plot each group separately
for i = 1:length(unique_tags)
    % Find indices corresponding to the current tag
    idx = strcmp(tags, unique_tags{i});
    
    % Select a marker (cycle through the list if there are more groups than markers)
    marker_style = markers{mod(i-1, num_markers) + 1};
    
    % Plot the data with filled markers
    plot(years(idx), probability(idx), '-', 'Color', colors(i, :), ...
         'DisplayName', unique_tags{i}, 'LineWidth', 1.5);
    
    scatter(years(idx), probability(idx), 60, colors(i, :), 'filled', ...
            'Marker', marker_style, 'DisplayName', '');
end

legend('show', 'Location', 'best');
hold off;
