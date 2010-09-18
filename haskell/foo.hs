
length'num = fromIntegral . length

len = length'num

mean v =
	(sum v) / (fromIntegral (length v))

sd v =
	let 
		m     = mean v
		resid = [ x-m | x <- v ]
		ss     = (sum [r^2 | r <- resid]) / ((length'num v) - 1)
	in sqrt ss

rsd v = (sd v) / (mean v)

main = do
	let x = [0.33, 0.64, 0.66, 0.75]
	let mean_x = mean x
	let sd_x   = sd x
	
	print mean_x
	print sd_x
	print (rsd x)

