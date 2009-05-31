
function [ Group Grouper ] = do_group(Link, K, Rater, Guess)
%
% Attempt to find the best possible grouping for the
% elements.
%
% Link is a NxN matrix where N is the number of elements. Each cell
% in N should be the similarity between the corresponding elements.
%
% K is the number of groups.
%
% Rater is a function to rate the groups. See rate_cohesion, rate_best.
%
% Guess is an initial guess of the way to group them. If left empty,
% will make an initial guess.
%
% Group is the suggested grouping.
% Grouper is an object created by make_grouper
%

if nargin <= 3
	Guess = [ ];
end

Grouper = make_grouper(Link, K, Rater);
if ~isempty(Guess)
	Grouper.Group = Guess;
end

Grouper = improve_iter(Grouper);

Group = Grouper.Group;
