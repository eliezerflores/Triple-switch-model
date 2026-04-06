[nRows, nCols] = size(M);

% Step 1: Binarize
binM = cellfun(@(x) sum(x == '1') >= 2, M);

% Preallocate
features = zeros(nRows, 6);
feature4 = strings(nRows,1);

for i = 1:nRows
    row = binM(i,:);
    
    % Feature 3
    numOnes = sum(row);
    
    % Runs of 1s
    d = diff([0 row 0]);
    startIdx = find(d == 1);
    endIdx   = find(d == -1) - 1;
    
    runLengths = endIdx - startIdx + 1;
    
    % Feature 1
    longestSpell = 0;
    if ~isempty(runLengths)
        longestSpell = max(runLengths);
    end
    
    % Feature 2
    numSpells = length(runLengths);
    
    % Feature 4
    if numOnes == 0
        feature4(i) = "No";
    elseif numSpells == 1
        feature4(i) = "Single";
    else
        feature4(i) = "Intermittent";
    end
    
    % Feature 5
    if numOnes == 0
        onset = 0;
    else
        onset = find(row, 1, 'first');
    end
    
    % Feature 6
    lastObs = nCols;
    
    % Store
    features(i,1) = longestSpell;
    features(i,2) = numSpells;
    features(i,3) = numOnes;
    features(i,5) = onset;
    features(i,6) = lastObs;
end

% Final table
featureTable = table(features(:,1), features(:,2), features(:,3), ...
                     feature4, features(:,5), features(:,6), ...
    'VariableNames', {'LongestSpell','NumSpells','NumObservations',...
                      'SpellType','TimeOnset','LastObs'});