
Means = replicate(10000,   mean(rnorm(30)))
Meds  = replicate(10000, median(rnorm(30)))

Measures = data.frame(
	Est  = c(Means, Meds),
	Type = c(rep('mean',length(Means)), rep('median',length(Meds)))
)
