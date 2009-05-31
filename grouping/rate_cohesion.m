
function Score = rate_cohesion(Grouper, Group)
%
% Evaluate a grouping.
%
% The formula is kind of weird, and involves a strange empiracle
% calculation, but it seems to work.
%

Score = 0;

for II=1:(Grouper.K)
	Volume = sum(Grouper.Stat(Group == II));
	
	Select = Grouper.Link(Group == II, Group ~= II);
	Surface = sum(sum(Select));
	
	Expect_Surface = Grouper.N/4 - Grouper.N*(Volume - 0.5).^2;
	
	Score = Score + Surface / Expect_Surface;
end

