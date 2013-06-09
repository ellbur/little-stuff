
library(HMM)

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
	# (1) Discretize the output space
	num.centers = 10,
	num.states = 5,
	
	data.matrix = do.call(rbind, sample$data),
	k.fit = kmeans(data.matrix, num.centers),
	centers = k.fit$centers,
	
	discretize = λ(points) %=% {
		as.character(sapply(points, closest))
	},
	
	closest = λ(point) %=% {
		which.min(sapply(1:num.centers, function(k) {
			sum((centers[[k]] - point)**2)
		}))
	},
	
	sample.obs = discretize(sample$data),
	symbols = as.character(1:num.centers),
	states  = as.character(1:num.states),
	
	# (2) Create a Hidden Markov Model
	hmm.blank = initHMM(states, symbols),
	hmm = baumWelch(hmm.blank, sample.obs)$hmm,
	
	likeliness = λ(next.sample) %=% {
		forw = forward(hmm, discretize(next.sample$data))
		sums = colSums(forw)
		sums[[length(sums)]]
	}
)

things = list(
	Thing(0, 1),
	Thing(2, 1),
	Thing(4, 1)
)

samples = xapply(things, Sample(x, 100))
short.samples = xapply(things, Sample(x, 5))
models = xapply(samples, Model(x))

tests = xsapply(short.samples,
	ysapply(models, y$likeliness(x))
)

