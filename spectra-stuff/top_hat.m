
function Y = top_hat(Y, Size=8)

Filter = [ -1*ones(1, Size), 2*ones(1, Size), -1*ones(1, Size) ];

Y = filter2(Filter, Y, 'valid');
