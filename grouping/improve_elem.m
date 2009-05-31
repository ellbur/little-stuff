
function [ Change Grouper ] = improve_elem(Grouper, II)
%
% Attempt to find a better group to put the specified element in.
%
% Grouper is an object created with make_grouper.
% II is the index of the element.
%
% Change is 1 if it found a better group, 0 if not.
% In the case Change is 0, Grouper will be unmodified.
%

Score = rate_group(Grouper, Grouper.Group);

Try_Group = Grouper.Group;
Change = 0;

if sum(Grouper.Group == Grouper.Group(II)) == 1
	return
end

for Try=1:(Grouper.K)
	if Try == Grouper.Group(II)
		continue
	end
	
	Try_Group(II) = Try;
	Try_Score = rate_group(Grouper, Try_Group);
	
	if Try_Score < Score
		Change = 1;
		Grouper.Group = Try_Group;
		
		break;
	end
end

