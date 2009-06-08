
function plot_stat(File)

[ Time, Data ] = read_stat(File);

Mean = mean(Data, 2);
Std  = std(Data, 0, 2);

plot(Time, Mean);
hold on;
plot(Time, Mean - 2*Std);
plot(Time, Mean + 2*Std);
hold off;

