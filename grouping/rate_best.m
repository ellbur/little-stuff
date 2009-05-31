
function Score = rate_best(Grouper, Group)
%
% Evaluate a grouping
%
% The return value is the number of elements that are NOT in the 
% same group as the element to which they are most similar.
%

[ Ignored Best ] = max(Grouper.Link);
Score = sum(Group ~= Group(Best));
