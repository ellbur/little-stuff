
source('emsa.R')

make.spectrum = function(
	Counts,
	Offset,
	EvPerBin
)
{
	
	Rights   = (1:length(Counts))*EvPerBin+Offset
	Lefts    = Rights - EvPerBin
	Centers  = Lefts + EvPerBin/2
	
	Spec = Counts
	
	attr(Spec, 'offset')     = Offset
	attr(Spec, 'ev.per.bin') = EvPerBin
	attr(Spec, 'lefts')      = Lefts
	attr(Spec, 'rights')     = Rights
	attr(Spec, 'centers')    = Centers
	
	class(Spec) = 'spectrum'
	
	Spec
}

lines.spectrum = function(Spectrum, ...) {
	lines(attr(Spectrum, 'centers'), Spectrum, ...)
}

plot.spectrum = function(Spectrum, ...) {
	plot(
		attr(Spectrum, 'centers'),
		Spectrum, type='l',
		xlab='Energy',
		ylab='Counts',
		...
	)
}

make.peak = function(
	Spectrum,
	Center,
	Height,
	FWHM
)
{
	E = attr(Spectrum, 'centers')
	S = fwhm.to.s(FWHM)
	Counts = Height * exp(
		- (E - Center)^2 / 2 / S^2
	)
	
	attributes(Counts) = attributes(Spectrum)
	class(Counts) = c('spectrum', 'peak')
	
	attr(Counts, 'center') = Center
	attr(Counts, 'height') = Height
	attr(Counts, 'fwhm')   = FWHM
	
	Counts
}

fwhm.to.s = function(FWHM) {
	FWHM / (2*sqrt(2*log(2)))
}

fit.height = function(Spectrum, Center, FWHM) {
	Peak = make.peak(Spectrum, Center, 1, FWHM)
	Height = sum(Peak*Spectrum) / sum(Peak^2)
	
	attr(Height, 'fit') = Height * Peak
	attr(Height, 'spectrum') = Spectrum
	class(Height) = 'fit'
	
	Height
}

print.fit = function(Fit, ...) {
	attributes(Fit) = c()
	print(Fit, ...)
}

lines.fit = function(Fit, ...) {
	lines(attr(Fit, 'fit'), ...)
}

plot.fit = function(Fit, ...) {
	plot(attr(Fit, 'spectrum'), ...)
	lines(Fit, col='red')
}

make.noise = function(Spectrum) {
	Noise = Spectrum * 0
	
	for (II in 1:length(Spectrum)) {
		Noise[[II]] = rnorm(1, 0, sqrt(Spectrum[[II]]))
	}
	
	Noise
}

counts = function(x, ...) UseMethod('counts')
counts.spectrum = function(Spectrum, Energy) {
	Bin = energy.to.bin(Spectrum, Energy)
	Bin = floor(Bin)
	
	if (Bin < 1 || Bin > length(Spectrum)) {
		0
	}
	else {
		Spectrum[[Bin]]
	}
}

energy.to.bin = function(x, ...) UseMethod('energy.to.bin')
energy.to.bin.spectrum = function(Spectrum, Energy) {
	(Energy - attr(Spectrum, 'offset')) / attr(Spectrum, 'ev.per.bin')
}

bin.to.energy = function(x, ...) UseMethod('bin.to.energy')
bin.to.energy.spectrum = function(Spectrum, Bin) {
	Bin * attr(Spectrum, 'ev.per.bin') + attr(Spectrum, 'offset')
}

'%+%.spectrum' = function(Spectrum1, Spectrum2) {
	for (II in 1:length(Spectrum1)) {
		Energy = bin.to.energy(Spectrum1, II)
		Spectrum1[[II]] = Spectrum1[[II]] + counts(Spectrum2, Energy)
	}
	
	Spectrum1
}

'%-%.spectrum' = function(Spectrum1, Spectrum2) {
	for (II in 1:length(Spectrum1)) {
		Energy = bin.to.energy(Spectrum1, II)
		Spectrum1[[II]] = Spectrum1[[II]] - counts(Spectrum2, Energy)
	}
	
	Spectrum1
}
