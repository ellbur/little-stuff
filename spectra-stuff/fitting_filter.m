
function Y = fitting_filter(Y)

T = top_hat(Y, 8);
Y = Y(12:(length(Y)-12));

Y = T/norm(T) + Y/norm(Y);
