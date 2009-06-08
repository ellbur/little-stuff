
function plot_summary(File)

[ Time Summary ] = read_summary(File);

plot(
	Time, Summary(:, 2), 'y', ... % Q1
	Time, Summary(:, 3), 'g', ... % Med
	Time, Summary(:, 4), 'y', ... % Q3
	Time, Summary(:, 6), 'b'  ... % Mean
);
