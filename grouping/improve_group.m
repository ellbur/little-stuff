
function [ Change Grouper ] = improve_group(Grouper)
%
% Attempt to find a better way to group elements
%

Order = randperm(Grouper.N);
Change = 0;

for II=Order
	[ This_Change Grouper ] = improve_elem(Grouper, II);
	
	Change = Change | This_Change;
end
