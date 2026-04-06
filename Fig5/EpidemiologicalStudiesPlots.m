% List of study files
study_files = {'study1.csv', 'study2.csv', 'study3.csv', 'study4.csv','study5.csv'};

% Loop through each study file
for study_idx = 1:length(study_files)
    % Read the CSV file
    data = readtable(study_files{study_idx}, 'VariableNamingRule', 'preserve');

    % Extract columns
    time = data{:, 1};  % Column 1: Time (x-axis)
    percentage_AD = data{:, 2};  % Column 2: Percentage of patients with AD symptoms (y-axis)
    labels = data{:, 3};  % Column 3: Phenotype labels (categorical)

    % Identify unique phenotypes in the study
    unique_labels = unique(labels, 'stable');  % Preserve order of appearance

    % Define colors for plotting
    colors = lines(length(unique_labels));  % Generate distinct colors

    % Create a new figure
    figure;
    hold on;
    
    % Plot each phenotype separately
    for i = 1:length(unique_labels)
        phenotype = unique_labels{i};
        
        % Select data for the current phenotype
        phenotype_idx = strcmp(labels, phenotype);
        time_phenotype = time(phenotype_idx);
        percentage_phenotype = percentage_AD(phenotype_idx);

        % Plot data
        plot(time_phenotype, percentage_phenotype, '-o', ...
            'DisplayName', phenotype, 'Color', colors(i, :), 'LineWidth', 1.5);
    end

    % Customize the plot
    xlabel('Time');
    ylabel('Percentage of Patients with AD Symptoms');
    title(['Study ', num2str(study_idx)]);
    legend('show', 'Location', 'best'); % Show legend with phenotype names
    grid on;
    hold off;
end
