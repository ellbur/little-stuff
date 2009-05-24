
function [ Z ] = element_by_symbol(S_List)

global Symbols;

if ~iscell(S_List)
	S_List = { S_List };
end

Z = zeros(size(S_List));

for II=1:length(S_List)
	
	S = S_List{II};
	
	for JJ=1:length(Symbols)
		if strcmp(Symbols{JJ}, S)
			Z(II) = JJ;
			break;
		end
	end
end
