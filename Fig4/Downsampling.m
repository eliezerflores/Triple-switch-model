% Load params_Subtype
% Extract the parameter data for different groups
NAD_data_all = cell2mat(params_NAD);
NAD_data_all = NAD_data_all.';
AD_data_all = cell2mat(params_AD);
AD_data_all = AD_data_all.';
INT_data_all = cell2mat(params_INT);
INT_data_all = INT_data_all.';

%% Remove first two parameters (we dont use these parameters for the current analysis)
NAD_data_all(:, 1:2) = [];
AD_data_all(:, 1:2) = [];
INT_data_all(:, 1:2) = [];

%% Number of samples to downsample to (editable)
target_size = 80437;

% Perform stratified downsampling (TAD 
NAD_downsampled = stratified_downsample(NAD_data_all, target_size);
AD_downsampled = stratified_downsample(AD_data_all, target_size);
INT_downsampled = stratified_downsample(INT_data_all, target_size);


%% Functions
function stratified_sample = stratified_downsample(data, target_size)
    % Assume data is a matrix with rows as samples and columns as features
    num_samples = size(data, 1);
    num_features = size(data, 2);
    
    % Initialize cell array to hold stratified samples for each feature
    stratified_samples_cell = cell(1, num_features);
    
    % Initialize array to collect all samples
    all_samples = [];

    % Perform stratified sampling for each feature
    for feature_idx = 1:num_features
        feature_data = data(:, feature_idx); % Extract the feature column
        
        % Calculate bin edges and counts
        [counts, edges] = histcounts(feature_data, 'BinMethod', 'sturges');
        edges(end) = edges(end) + eps; % Ensure the last edge includes the maximum value
        
        % Calculate number of samples per bin
        samples_per_bin = max(1, round((counts / sum(counts)) * target_size));
        
        % Initialize storage for stratified samples of this feature
        stratified_feature_sample = [];
        
        % Loop through each bin
        for bin_idx = 1:length(edges) - 1
            % Define the bin data indices
            if bin_idx == length(edges) - 1
                bin_idx_mask = feature_data >= edges(bin_idx) & feature_data <= edges(bin_idx + 1);
            else
                bin_idx_mask = feature_data >= edges(bin_idx) & feature_data < edges(bin_idx + 1);
            end
            
            bin_data = data(bin_idx_mask, :); % Extract data for this bin
            
            % Check if we need more samples
            if size(bin_data, 1) <= samples_per_bin(bin_idx)
                stratified_feature_sample = [stratified_feature_sample; bin_data];
            else
                % Randomly sample from the bin
                stratified_feature_sample = [stratified_feature_sample; bin_data(randsample(size(bin_data, 1), samples_per_bin(bin_idx)), :)];
            end
        end
        
        % If we still don’t have enough samples, sample from remaining data
        if size(stratified_feature_sample, 1) < target_size
            missing_samples = target_size - size(stratified_feature_sample, 1);
            remaining_data = data(~ismember(data, stratified_feature_sample, 'rows'), :);
            stratified_feature_sample = [stratified_feature_sample; remaining_data(randsample(size(remaining_data, 1), missing_samples), :)];
        end
        
        % Store the stratified sample for this feature
        stratified_samples_cell{feature_idx} = stratified_feature_sample;
        
        % Collect all samples to check dimensions
        all_samples = [all_samples; stratified_feature_sample];
    end
    
    % Ensure the final matrix has consistent dimensions
    % Resize if necessary to avoid dimensional mismatch
    num_final_samples = min(target_size, size(all_samples, 1));
    stratified_sample = all_samples(1:num_final_samples, :);
end
