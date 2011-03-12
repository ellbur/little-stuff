
# http://mike-love.net/r-scripts/spectral.R

spec.cluster = function(Adj, Dims, Groups)
{
	N = nrow(Adj)
	
	G = diag(rowSums(Adj))
	L = G - Adj
	
	P = eigen(L)[['vectors']]
	
	Traits = P[,N-(1:Dims)]
	KM = kmeans(Traits, centers=Groups, iter.max=20, nstart=Groups+2)
	KM$traits = Traits
	Centers = KM$centers[KM$cluster,]
	KM$dists = sqrt(rowSums((Traits-Centers)**2))
	
	KM
}

