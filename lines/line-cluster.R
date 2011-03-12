
source('spec-cluster.R')

line.cluster = function(
	Points,
	Dist.Thresh,
	Area.Scale
)
{
	N = length(Points)
	
	Segs = do.call(c, lapply(1:(N-1), function(I) {
		lapply((I+1):N, function (J) {
			list(Points[[I]], Points[[J]])
		})
	}))
	
	Segs = Filter(x=Segs, f=function(Seg) {
		seg.len(Seg) <= Dist.Thresh
	})
	
	M = length(Segs)
	
	Mat = matrix(1, M, M)
	
	for (I in 1:(M-1))
	for (J in (I+1):M) {
		Area = seg.prox(Segs[[I]], Segs[[J]], Area.Scale)
		
		Mat[I,J] = Area
		Mat[J,I] = Area
	}
	
	KM = spec.cluster(Mat, 4, 3)
	
	Table = seg.tab(Segs)
	Table$group = as.character(KM$cluster)
	
	print(ggplot(data=Table)
		+ geom_segment(aes(x=x1, y=y1, xend=x2, yend=y2, color=group))
		+ scale_colour_discrete()
	)
	
	KM
}

seg.len = function(
	Seg
)
{
	sqrt(sum((Seg[[2]] - Seg[[1]])**2))
}

seg.prox = function(
	Seg1, 
	Seg2,
	Scale
)
{
	D1 = line.point.dist.sq(Seg1, Seg2[[1]])
	D2 = line.point.dist.sq(Seg1, Seg2[[2]])
	D3 = line.point.dist.sq(Seg2, Seg1[[1]])
	D4 = line.point.dist.sq(Seg2, Seg1[[2]])
	
	#DM = mean(c(D1,D2,D3,D4))
	DM = sort(c(D1,D2,D3,D4))[[2]]
	
	exp(-DM/Scale)
}

line.point.dist.sq = function(Seg, P) {
	x1 = Seg[[1]]['x']
	y1 = Seg[[1]]['y']
	
	x2 = Seg[[2]]['x']
	y2 = Seg[[2]]['y']
	
	x3 = P['x']
	y3 = P['y']
	
	t = ( ( (y3-y1)*(y2-y1) + (x3-x1)*(x2-x1) )
		/ ( (x2-x1)**2 + (y2-y1)**2 ) )
	
	xp = t*(x2-x1) + x1
	yp = t*(y2-y1) + y1
	
	(xp-x3)**2 + (yp-y3)**2
}

seg.area = function(Seg1, Seg2) {
	Area1 = three.area(Seg1[[1]], Seg2[[1]], Seg2[[2]])
	Area2 = three.area(Seg1[[1]], Seg2[[2]], Seg1[[2]])
	
	abs(Area1) + abs(Area2)
}

three.area = function(PBase, P1, P2) {
	P1 = P1 - PBase
	P2 = P2 - PBase
	
	0.5 * (P1['x']*P2['y'] - P1['y']*P2['x'])
}

seg.tab = function(Segs) {
	tab(lapply(Segs, function(S)
		c(x1=S[[1]][['x']], y1=S[[1]][['y']],
		  x2=S[[2]][['x']], y2=S[[2]][['y']])
	     )
	)
}

plot.segs = function(Segs, ...) {
	SegTab = seg.tab(Segs)
	
	print(ggplot(data=SegTab)
		+ geom_segment(aes(x=x1, y=y1, xend=x2, yend=y2), ...)
	)
}

tab = function(x) {
	as.data.frame(t(sapply(x, identity)))
}

