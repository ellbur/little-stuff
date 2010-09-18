
source('spectrum.R')
source('clean.R')
source('math.R')

make.bad.fit = function(Spectrum,
	Center,
	Height,
	FWHM,
	A,
	B
)
{
	Peak1 = make.peak(Spectrum, Center-FWHM*A, Height, FWHM*(1-B))
	Peak2 = make.peak(Spectrum, Center, Height, FWHM)
	
	list(
		Actual = Peak1,
		Fit    = Peak2
	)
}

test.fit.addin = function(Glitch, Center, Height, FWHM) {
	Peak = make.peak(Glitch, Center, Height, FWHM)
	fit.height(Peak + Glitch, Center, FWHM)
}



how.bad.glitch = function(Glitch, Center, Height, FWHM) {
	Step = attr(Glitch, 'ev.per.bin')
	Centers = seq(from=Center-FWHM*2, to=Center+FWHM*2, by=Step)
	
	Fit.Heights = sapply(Centers, function(Center) {
		test.fit.addin(Glitch, Center, Height, FWHM)
	})
	
	Errors = abs((Fit.Heights - Height) / Height)
	
	Badness = max(Errors)
	attr(Badness, 'errors')       = Errors
	attr(Badness, 'fit.heights')  = Fit.Heights
	attr(Badness, 'centers')      = Centers
	attr(Badness, 'worst.center') = Centers[[which.max(Errors)]]
	
	Badness
}

how.bad.glitch.noise = function(Spec.Total, Spec.Base, Center, Height, FWHM) {
	Step = attr(Spec.Total, 'ev.per.bin')
	Centers = seq(from=Center-FWHM*2, to=Center+FWHM*2, by=Step)
	
	Fit.Heights = lapply(Centers, function(Try.Center) {
		Peak = make.peak(Spec.Base, Try.Center, Height, FWHM)
		
		fit.height(Spec.Base + Peak, Try.Center, FWHM)
	})
	
	Try.Heights = sapply(Fit.Heights, identity)
	
	Errors = abs((Try.Heights - Height) / Height)
	Worst.Bin    = which.max(Errors)
	Worst.Center = Centers[[Worst.Bin]]
	
	Fit.Glitch = Fit.Heights[[Worst.Bin]]
	
	Badness.Glitch = max(Errors)
	
	Peak = make.peak(Spec.Base, Worst.Center, Height, FWHM)
	
	Noisy.Spectra        = list()
	Noisy.Glitch.Spectra = list()
	
	Vars = Spec.Total + Peak
	X.Peak = make.peak(Spec.Total, Worst.Center, 1, FWHM)
	Var = sum(X.Peak^2 * Vars) / sum(X.Peak^2)^2
	
	Mabs.Noise = mabs(Height, Height, sqrt(Var)) / Height
	Mabs.Both  = mabs(Height, noattr(Fit.Glitch), sqrt(Var)) / Height
	
#	Since the calculations in Mabs.* appear to be correct, we can safely
#	omit these next steps.
#
# 	for (II in 1:100) {
# 		Noise = make.noise(Spec.Total + Peak)
# 		
# 		Noisy.Spectra[[II]]        = Peak + Noise
# 		Noisy.Glitch.Spectra[[II]] = Peak + Spec.Base + Noise
# 	}
# 	
# 	Fit.Noise = lapply(Noisy.Spectra, fit.height,
# 		Center=Worst.Center, FWHM=FWHM)
# 	Fit.Both  = lapply(Noisy.Glitch.Spectra, fit.height,
# 		Center=Worst.Center, FWHM=FWHM)
# 	
# 	Badness.Noise = abs(sapply(Fit.Noise, identity) - Height) / Height
# 	Badness.Both  = abs(sapply(Fit.Both, identity) - Height) / Height
	
	as.list(environment())
}

Norms = lapply(alist(
	sqrt(sum(Glitch^2)),
	sum(abs(Glitch)^3)^(1/3),
	sum(abs(Glitch)^3)^(1/3),
	sum(abs(Glitch)^4)^(1/4),
	max(abs(Glitch)),
	sqrt(sum(Glitch^2)) + sqrt(sum(diff(Glitch)^2))
),
	function(Exp) {
		Func = function(Glitch) { }
		body(Func) = Exp
		
		Func
	}
)

names(Norms) = paste('Norm', as.character(1:length(Norms)), sep='.')
	
glitch.routine = function(N, Height) {
	Spectrum = make.spectrum(1:200, 0, 10)
	
	Center = 1000
	FWHM   =   80
	
	Sum.Height  = 50
	Peak.Height = Height
	
	Trials = clean(as.data.frame(t(sapply(1:N, function(Trial) {
		
		Bad.Fit = make.bad.fit(Spectrum, Center, Sum.Height, FWHM,
			runif(1, -0.2, 0.2),
			runif(1, -0.2, 0.2)
		)
		Glitch = with(Bad.Fit, Actual - Fit)
		
		Badness = how.bad.glitch(Glitch, Center, Peak.Height, FWHM)
		for (Norm.Name in names(Norms)) {
			assign(Norm.Name, Norms[[Norm.Name]](Glitch))
		}
		
		as.list(environment())
		
	}))))
	
	Trials
}

glitch.routine.noise = function(N) {
	Spectrum = make.spectrum(numeric(200), 0, 10)
	
	Center = 1000
	
	Trials = clean(as.data.frame(t(sapply(1:N, function(Trial) {
		
		FWHM = runif(1, 60, 100)
		
		Sum.Height  = runif(1,   5, 100)
		Peak.Height = runif(1, 100, 600)
		
		Background = Spectrum + runif(1, 0, 50)
		
		Bad.Fit = make.bad.fit(Spectrum, Center, Sum.Height, FWHM,
			runif(1, -0.2, 0.2),
			runif(1, -0.2, 0.2)
		)
		
		Spec.Total  = Spectrum + Background + Bad.Fit$Actual
		Spec.Glitch = Spectrum + Bad.Fit$Actual - Bad.Fit$Fit
		
		Badness = how.bad.glitch.noise(
			Spec.Total,
			Spec.Glitch,
			Center,
			Peak.Height,
			FWHM
		)
		
		Badness.Glitch = Badness$Badness.Glitch
		Badness.Noise  = Badness$Mabs.Noise
		Badness.Both   = Badness$Mabs.Both
		
		Height.Background  = Background[[Badness$Worst.Bin]]
		Height.Total       = Sum.Height + Height.Background + Peak.Height
		Height.Glitch      = max(abs(Spec.Glitch))
		Height.Sum         = Sum.Height
		Height.Peak        = Peak.Height
		
		as.list(environment())
		
	}))))
	
	Trials
}

glitch.report = function(Dir, N) {
	
	dir.create(Dir, rec=T, mode="755")
	dir.create(Dir %+% "/spectra", rec=T, mode="755")
	
	Trials = glitch.routine.noise(N)
	
	Table = with(Trials, data.frame(
		stringsAsFactors = F,
		
		Height.Sum     = Height.Sum,
		Height.Peak    = Height.Peak,
		Height.Bg      = Height.Background,
		Height.Glitch  = Height.Glitch,
		Height.Total   = Height.Total,
		
		Badness.Glitch = Badness.Glitch,
		Badness.Noise  = Badness.Noise,
		Badness.Both   = Badness.Both,
		
		File.Total     = sapply(1:nrow(Trials), function(I) {
			Dir %+% "/spectra/" %+% sprintf("spec-%03d-total.msa", I)
		}),
		
		File.Glitch    = sapply(1:nrow(Trials), function(I) {
			Dir %+% "/spectra/" %+% sprintf("spec-%03d-glitch.msa", I)
		})
	))
	
	write.csv(Table, Dir %+% "/table.csv")
	
	for (I in 1:nrow(Trials)) {
		File.Total  = Table$File.Total[[I]]
		File.Glitch = Table$File.Glitch[[I]]
		
		write.emsa(
				Trials$Background[[I]] +
				Trials$Spec.Glitch[[I]] +
				Trials$Badness[[I]][['Peak']],
			File.Total
		)
		write.emsa(
				Trials$Background[[I]] +
				Trials$Spec.Glitch[[I]],
			File.Glitch
		)
	}
	
	png(Dir %+% "/badness.glitch.png")
	with(Trials, plot(
		Height.Glitch / Height.Peak,
		Badness.Glitch
	))
	dev.off()
	
	png(Dir %+% "/badness.noise.png")
	with(Trials, plot(
		sqrt(Height.Total) / Height.Peak,
		Badness.Noise
	))
	dev.off()
	
	png(Dir %+% "/glitch-over-noise.png")
	with(Trials, plot(
		Height.Glitch / sqrt(Height.Total),
		Badness.Glitch / Badness.Noise
	))
	dev.off()
}
