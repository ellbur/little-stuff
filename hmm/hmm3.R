
library(HMM)

Thing = item(
	trans.matrix =,
	obs.gens =,
	
	num.states = nrow(trans.matrix),
	states = 1:num.states,
	
	gen.data = λ(num.points) %=% {
		start.state = sample(states, 1)
		state = start.state
		obs = vector(num.points, mode='list')
		
		for (i in 1:num.points) {
			obs[[i]] = obs.gens[[state]]()
			state = sample(states, 1, prob=trans.matrix[,state])
		}
		
		obs
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
		which.min(sapply(1:num.centers, λ(k) %=% {
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
	Thing(
		rbind(
			c(0.5, 0.1, 0.2),
			c(0.2, 0.6, 0.1),
			c(0.3, 0.3, 0.7)
		),
		list(
			λ() %=% rnorm(1, 0, 1),
			λ() %=% rnorm(1, 1, 1),
			λ() %=% rnorm(1, 2, 1)
		)
	),
	Thing(
		rbind(
			c(0.9, 0.1, 0.2),
			c(0.1, 0.8, 0.2),
			c(0.0, 0.1, 0.6)
		),
		list(
			λ() %=% rnorm(1, 0, 1),
			λ() %=% rnorm(1, 0, 2),
			λ() %=% rnorm(1, 0, 3)
		)
	)
)

samples = xapply(things, Sample(x, 1000))
short.samples = xapply(things, Sample(x, 5))
models = xapply(samples, Model(x))

tests = xsapply(short.samples,
	ysapply(models, y$likeliness(x))
)

