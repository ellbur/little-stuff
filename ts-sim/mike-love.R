
# http://mikelove.wordpress.com/2010/04/22/bootstrapping-time-series/

length = 100
z = numeric(length)
z[1] = 0
beta = .85
for (t in 2:length) {
  z[t] = beta * z[t-1] + rnorm(1,0,2)
}
z = z - mean(z)

beta.hats = seq(from=-1,to=1,length=200)
RSE = sapply(beta.hats, function(b) sum(sapply(2:length, function(t) (z[t] - b*z[t-1])^2)))
beta.hat = beta.hats[which.min(RSE)]
#plot(beta.hats,RSE,ylim=c(0,max(RSE)),cex=.5);abline(v=beta.hat,lty=2)

epsilon.hat = numeric(length)
for (t in 2:length) {
  epsilon.hat[t] = z[t] - beta.hat * z[t-1]
}
epsilon.hat = epsilon.hat[-1]

epsilon.boot = sample(epsilon.hat,length-1,replace=TRUE)

z.boot = numeric(length)
z.boot[1] = z[1]
for (t in 1:(length-1)) {
  z.boot[t+1] = beta.hat * z.boot[t] + epsilon.boot[t]
}

z.naiveboot = sample(z,length,replace=TRUE)

par(mfrow=c(3,1),mar=c(2.5,3,2,1))
plot(z,type="n",xlab="",main="simulated data");lines(z)
plot(z.boot,type="n",xlab="",main="bootstrap first-order");lines(z.boot)
plot(z.naiveboot,type="n",xlab="",main="naive bootstrap");lines(z.naiveboot)
