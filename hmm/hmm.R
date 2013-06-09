
library(RHmm)

Thing = item(mean=, sd=,
	gen.data = function(num.points) {
		lapply(1:num.points, function(k) {
			rnorm(2, mean=mean, sd=sd)
		})
	}
)

Sample = item(thing=, num.points=,
	data = thing$gen.data(num.points)
)

Model = item(sample=,
	model = HMMFit(sample$data, nStates=1),
	
	assess = function(other.sample) {
		Rho = forwardBackward(model, other.sample$data, keep.log=T)$Rho
		Rho[[length(Rho)]]
	}
)

things = list(
	Thing(0, 1),
	Thing(2, 1),
	Thing(4, 1)
)

samples       = xapply(things, Sample(x, 100))
short.samples = xapply(things, Sample(x, 100))

models = xapply(samples, Model(x))

tests = sapply(short.samples, function(sample)
	sapply(models, function(model)
		model$assess(sample)
	)
)

