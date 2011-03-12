
library(ggplot2)

t = seq(0, 10, len=10000)

x = runif(length(t))
(function() {
	w = length(t)/10
	x <<- filter(x, rep(1, w)/w)
	x <<- filter(x, rep(1, w)/w)
})()

x[is.na(x)] = 0
x[x!=0] = x[x!=0] - mean(x[x!=0])

m = cos(100*t)

