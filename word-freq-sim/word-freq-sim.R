
Num.Stories = 200

Story.Nums    = seq(1, Num.Stories)
Story.Lengths = sapply(Story.Nums, function(N) {
	Len = 150 + 30*rnorm(1)
	if (Len < 10) {
		Len = 10
	}
	
	Len
})
Story.Time.F = (Story.Nums-1) / (Num.Stories-1)

F.Use = Story.Time.F * 0.15e-2

Present = sapply(Story.Nums, function(N) {
	Len    = Story.Lengths[N]
	Freq   = F.Use[N]
	Lambda = Len * Freq
	
	if (runif(1) < 1-ppois(lambda=Lambda, q=0)) {
		1
	}
	else {
		0
	}
})

Model = lm(Present ~ I(Story.Time.F*Story.Lengths))

run.ave = function(x, by) {
	filter(x=x, filter=rep(1,by)/by)
}

Use.Est = Present / Story.Lengths
Use.Est.Smooth = run.ave(Present, 50)
