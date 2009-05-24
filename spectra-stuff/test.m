
Channels = csvread('./channels.csv');

Channels = Channels';
Channels = Channels(1:1000);

X = 1:length(Channels);
Y = Channels;

figure(1);
plot(X, Y);

FSize = 10;
Filter = [ -1*ones(1, FSize), 2*ones(1, FSize), -1*ones(1, FSize) ];

FY = filter2(Filter, Y);

figure(2);
plot(X, FY);
