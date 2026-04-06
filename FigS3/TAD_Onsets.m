%Load the paramsTAD_onset objects

paramsTAD_onset1_matrix = cell2mat(paramsTAD_onset1')';
paramsTAD_onset1_matrix(:,1:2) = [];
%boxplot(paramsTAD_onset1_matrix);

%%
paramsTAD_onset3_matrix_ = cell2mat(paramsTAD_onset3')';
paramsTAD_onset3_matrix_(:,1:2) = [];

paramsTAD_onset3_matrix_1 = cell2mat(paramsTAD_onset3_1)';
paramsTAD_onset3_matrix_1(:,1:2) = [];

paramsTAD_onset3_matrix_2 = cell2mat(paramsTAD_onset3_2')';
paramsTAD_onset3_matrix_2(:,1:2) = [];

paramsTAD_onset3_matrix = [paramsTAD_onset3_matrix_;paramsTAD_onset3_matrix_1;paramsTAD_onset3_matrix_2];

boxplot(paramsTAD_onset3_matrix);

%%
paramsTAD_onset6_matrix_ = cell2mat(paramsTAD_onset6')';
paramsTAD_onset6_matrix_(:,1:2) = [];

paramsTAD_onset6_matrix_1 = cell2mat(paramsTAD_onset6_1)';
paramsTAD_onset6_matrix_1(:,1:2) = [];

paramsTAD_onset6_matrix_2 = cell2mat(paramsTAD_onset6_2')';
paramsTAD_onset6_matrix_2(:,1:2) = [];

paramsTAD_onset6_matrix_3 = cell2mat(paramsTAD_onset6_3')';
paramsTAD_onset6_matrix_3(:,1:2) = [];

paramsTAD_onset6_matrix = [paramsTAD_onset6_matrix_;paramsTAD_onset6_matrix_1;paramsTAD_onset6_matrix_2;paramsTAD_onset6_matrix_3];

boxplot(paramsTAD_onset6_matrix);


