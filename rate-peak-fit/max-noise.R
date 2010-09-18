
source('spectrum.R')
source('clean.R')
source('math.R')

test.max.noise = function(N, Peak.Height) {
	Spectrum.Zero = make.spectrum(numeric(200), 0, 10)
	
	Peak.Width = 80
	
	Counts.Base = make.peak(Spectrum.Zero, 1000, Peak.Height, Peak.Width)
	Vars = Counts.Base
	
	Cum.Dist = max.abs.normal.cdf(Counts.Base, sqrt(Vars))
	Den.Dist = max.abs.normal.pdf(Counts.Base, sqrt(Vars))
	
	Trials = do.trials(N, function(Trial) {
		
		Noise = rnorm(length(Vars)) * sqrt(Vars)
		Counts.Noisy = Counts.Base + Noise
		
		Max = max(abs(Counts.Noisy))
		
		as.list(environment())
		
	})
	
	Mean.Est = quick.mean(max(abs(Counts.Base)), Cum.Dist, Den.Dist)
	Sample.Mean = mean(Trials$Max)
	
	as.list(environment())
}

