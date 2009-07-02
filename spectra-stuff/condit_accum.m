
function Distr = condit_accum(Values_1, Distr_1, Depend_Func)

% Normalize to 1
Distr_1 = Distr_1 / sum(Distr_1);

Distr = zeros(size(Depend_Func(Values_1(1))));

for II=1:length(Values_1)
	Condit_Distr = Depend_Func(Values_1(II));
	Condit_Distr = Condit_Distr / sum(Condit_Distr);
	
	Distr = Distr + Distr_1(II) * Condit_Distr;
end
