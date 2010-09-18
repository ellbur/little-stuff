
# Dude, why did you not do a χ² test on that distribution?
# OK, well I'll do it myself.

Table = data.frame(
	Digit  = c(1, 2, 3, 4, 5, 6, 7, 8, 9),
	Count  = c(143, 90, 46, 42, 51, 31, 45, 20, 29),
	P.Expected = c(
		.301, .176, .125, .097, .079, .067,
		.058, .051, .046)
)

rownames(Table) <- as.character(Table$Digit)

Test = chisq.test(
	x = Table$Count,
	p = Table$P.Expected)
