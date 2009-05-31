
function Link = fix_link(Link)
%
% Turn a similarity matrix into something that the rest
% of the program can deal with
%
% Make it symmetric, make each column sum to 1, make the diagonal 0.
%

N = length(Link);

Link  = Link + Link';

for II=1:N
	Link(II,II) = 0;
end

for II=1:N
	Col = Link(:, II);
	Sum = sum(Col);
	
	if abs(Sum) < 1e-13
		Link(II, II) = 1;
	else
		Link(:, II) = Col / sum(Col);
	end
end
