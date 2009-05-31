
function [ Groups Grouper ] = group_files(Files, K)
%
% Group files based on similarity.
%
% Files is a cell array of file names.
% K is number of groups
%
% Groups is a cell array of cell arrays
% Grouper is an object created with make_grouper
%

Groups = cell(K, 1);

Link = file_link_table(Files);
[ List Grouper ] = do_group_2(Link, K);

for II=1:K
	Groups{II} = {Files{List == II}};
end
