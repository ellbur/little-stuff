
function Grouper = make_grouper(Link, K, Rater)
%
% Create an object to store information about a grouping.
%
% Link is a matrix giving the similarity of elements. The II row and JJ
% column is the similarity between elements II and JJ.
%
% K is the number of groups desired.
%
% Rater is a function like rate_cohesion, rate_best that says how good a
% particular grouping is.
%
% Grouper is a struct with the following fields:
%   K     = the number of groups
%   N     = the number of elements
%   Link  = the similarity matrix, molded by fix_link
%   Group = a possible grouping
%   Stat  = The stationary probabilities in the Markov chain represented
%               by Link
%   Rater = The rater function supplied
%

Link = fix_link(Link);
N    = length(Link);

Stat = null(Link - eye(N));
Stat = Stat(:,1); % just in case
Stat = Stat / sum(Stat);

Grouper.K     = K;
Grouper.N     = N;
Grouper.Link  = Link;
Grouper.Group = mod(1:N, K) + 1;
Grouper.Stat  = Stat;
Grouper.Rater = Rater;
