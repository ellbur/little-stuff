
source('cpx-fit.R')

Beta0 = 1 + 3i
Beta1 = 3 - 2i

X = runif(15, 0, 10)
Y = (Beta0 + Beta1*X +
	rnorm(length(X), 0, 0.7) * exp(1i*runif(length(X), 0, 2*pi))
)

Model = fit.complex(Y, list(
	 const = 0*X+1,
	linear = X
))

Beta0.Est = Model$coefficients.complex[[1]]
Beta1.Est = Model$coefficients.complex[[2]]
