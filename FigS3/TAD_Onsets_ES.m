% Define parameter names
param_names = {'P_env', 'kappa_P', 'alpha_P', 'gamma_PB', 'delta_P', ...
    'kappa_B', 'gamma_BB', 'gamma_BR', 'delta_B', 'kappa_A', ...
    'gamma_AB', 'delta_A', 'kappa_D', 'delta_D'};

% New groups (paired by onset)
groups = {'NAD_1','TAD_1','NAD_3','TAD_3','NAD_6','TAD_6'};

data_groups = {NAD_1_matrix, TAD_1_matrix, ...
               NAD_3_matrix, TAD_3_matrix, ...
               NAD_6_matrix, TAD_6_matrix};

%%
num_vars = size(data_groups{1}, 2);
num_groups = length(groups);

cliffs_delta_results = zeros(num_groups, num_groups, num_vars);

for g1 = 1:num_groups
    for g2 = g1+1:num_groups
        for var_idx = 1:num_vars
            
            data1 = data_groups{g1}(:, var_idx);
            data2 = data_groups{g2}(:, var_idx);

            N1 = 0;
            N2 = 0;

            for i = 1:length(data1)
                N1 = N1 + sum(data1(i) > data2);
                N2 = N2 + sum(data1(i) < data2);
            end

            delta = (N1 - N2) / (length(data1) * length(data2));

            cliffs_delta_results(g1, g2, var_idx) = delta;
            cliffs_delta_results(g2, g1, var_idx) = -delta;
        end
    end
end

%%
% TAD_1 vs NAD_1
plot_effects(cliffs_delta_results, 2, 1, param_names, ...
    'Effect Size: TAD_1 vs NAD_1');

% TAD_3 vs NAD_3
plot_effects(cliffs_delta_results, 4, 3, param_names, ...
    'Effect Size: TAD_3 vs NAD_3');

% TAD_6 vs NAD_6
plot_effects(cliffs_delta_results, 6, 5, param_names, ...
    'Effect Size: TAD_6 vs NAD_6');

%%
function plot_effects(cliffs_delta_results, g_tad, g_nad, param_names, title_str)

    filtered_effect_sizes = [];
    filtered_parameters = {};

    for param = 1:length(param_names)-2 %I exclude delta_D and kappa_D from visualization bc they are non identifiable
        effect = cliffs_delta_results(g_tad, g_nad, param);

        if abs(effect) >= 0.11
            filtered_effect_sizes(end+1) = effect;
            filtered_parameters{end+1} = param_names{param};
        end
    end

    figure; hold on;

    b = bar(filtered_effect_sizes, 'FaceColor', 'flat');

    % ✅ COLOR FIX (as you requested)
    for i = 1:length(filtered_effect_sizes)
        if filtered_effect_sizes(i) > 0
            b.CData(i,:) = [0 0.6 0];   % green (positive)
        else
            b.CData(i,:) = [0.6 0.6 0.6]; % grey (negative)
        end
    end

    set(gca, 'XTick', 1:length(filtered_parameters), ...
        'XTickLabel', filtered_parameters, ...
        'XTickLabelRotation', 45);

    ylabel('Cliff''s Delta');
    xlabel('Parameters');
    title(title_str);

    ylim([-1 1]);
    yline(0.11, '--k');
    yline(-0.11, '--k');

    hold off;
end