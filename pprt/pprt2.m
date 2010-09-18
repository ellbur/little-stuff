
A_Mean = 10
A_Std  = 6
B_Mean = 20
B_Std  = 11

B_Mean_Vec    = 11:1:100;
Best_Trig_Vec = zeros(size(B_Mean_Vec));
Best_A_Vec    = zeros(size(B_Mean_Vec));

for II=1:length(B_Mean_Vec)
	
	B_Mean = B_Mean_Vec(II);
	
	[ Best_PPRT, Best_Trig, Best_A, Best_B ] = ...
		pprtmin(A_Mean, A_Std, B_Mean, B_Std);
	
	Best_Trig_Vec(II) = Best_Trig;
	Best_A_Vec(II) = Best_A;
	
	fprintf('%.0f %.0f %.3f\n', B_Mean, Best_Trig, Best_A)
end

figure(1)
plot(B_Mean_Vec, Best_Trig_Vec)

figure(2)
plot(B_Mean_Vec, Best_A_Vec)
