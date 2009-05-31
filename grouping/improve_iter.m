
function [ Grouper ] = improve_iter(Grouper)
%
% Iteratively improve a grouping
%

while 1
	[ Change Grouper ] = improve_group(Grouper);
	
	if ~Change
		break
	end
end
