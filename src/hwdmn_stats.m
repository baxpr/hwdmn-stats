function hwdmn_stats(varargin)

P = inputParser;
addOptional(P,'matrix_csv','/INPUTS/R_removegm.csv')
addOptional(P,'out_dir','/OUTPUTS')
parse(P,varargin{:});
disp(P.Results)
matrix_csv = P.Results.matrix_csv;
out_dir = P.Results.out_dir;

%% Read matrix from conncalc
C = readtable(matrix_csv,'ReadRowNames',true);


%% Individual edges
result = table();
for k1 = 1:size(C,1)-1
    for k2 = k1+1:size(C,2)
        rname = C.Row{k1}(7:end);
        cname = C.Properties.VariableNames{k2}(7:end);
        result.([rname '_' cname]) = C{k1,k2};
    end
end


%% Mean DMN connectivity
% We will average over the list of DMN ROIs. First extract just this part
% of the matrix
dmnlist = { ...
    'r0005_DMN_PCC', ...
    'r0006_DMN_MPFC', ...
    'r0007_DMN_PAR_L', ...
    'r0008_DMN_PAR_R', ...
    'r0009_DMN_INFTEMP_L', ...
    'r0010_DMN_INFTEMP_R', ...
    'r0011_DMN_MDTHAL' ...
    };
Cdmn = table2array(C(dmnlist,dmnlist));

% Then extract just the upper triangle so we don't include the
% self-connections or duplicate values.
Clist = [];
for k1 = 1:size(Cdmn,1)-1
    for k2 = k1+1:size(Cdmn,2)
        Clist = [Clist Cdmn(k1,k2)];
    end
end

% And compute the mean of the extracted edges
result.('DMN_mean') = mean(Clist);


%% Save to file
writetable(result,fullfile(out_dir,'hwdmn.csv'));

