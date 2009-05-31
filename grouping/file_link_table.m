
function Link = file_link_table(Files)
%
% Create a similarity matrix for a list of files.
%
% Files is a cell array of file names.
%
% Link is an NxN matrix where N is the number of files.
% Link is symmetry and the diagonal entries are zero.
%
% See file_symilarity
%

N = length(Files);
Link = zeros(N);

for II=1:N
for JJ=1:(II-1)
	Link(II, JJ) = file_similarity(Files{II}, Files{JJ});
end
end

Link = Link + Link';
