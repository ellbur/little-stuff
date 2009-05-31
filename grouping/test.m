
% Test code for the grouping algorithm.

Directory  = './test-files/'
Num_Groups = 3

Files = files_in_dir(Directory)

Groups = group_files(Files, Num_Groups)

for II = 1:length(Groups)
	
	Group = Groups{II};
	
	for JJ = 1:length(Group)
		disp(Group{JJ});
	end
	
	fprintf('\n')
end
