
function [ Group Grouper ] = do_group_2(Link, K)
%
% Link is a NxN matrix where N is the number of elements. Each cell
% in N should be the similarity between the corresponding elements.
%
% K is the number of groups.
%
% Group is the suggested grouping.
% Grouper is an object created by make_grouper
%

[ Guess Grouper ] = do_group(Link, K, @rate_cohesion);
[ Group Grouper ] = do_group(Link, K, @rate_best, Guess);
