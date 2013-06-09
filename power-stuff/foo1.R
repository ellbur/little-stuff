
f = 440;
T = 1/f;
t = seq(0, T, len=1000)

x = abs(2*(t/T - floor(t/T + 1/2)))

a = 0.8;
b = 0.7;

y1 = a*x/(1 - a*x)
y2 = b*x/(1 - b*x)

y = y1 - y2;

k = seq(0, 10);
hump = a**k - b**k;

