
function Score = rate_group(Grouper, Group)
%
% Compute how good this grouping is.
%
% Grouper is an object created with make_grouper
% Group is the tentative grouping
%
% Score is a number that says how good it is.
% Lower scores are better.
%


Score = Grouper.Rater(Grouper, Group);
