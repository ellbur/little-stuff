
zero.crossings = function(x, y)
{
	if (length(x) <= 0) {
		c()
	}
	
	else {
		Old.Sign = 0
		Old.X = x[1]
		Old.Y = y[1]
		
		Hits = c()
		
		for (II in cdr(seq_along(x))) {
			New.Sign = sign(y[II])
			New.X = x[II]
			New.Y = y[II]
			
			if (flipped(Old.Sign, New.Sign)) {
				Hit = Old.X - Old.Y*(New.X - Old.X)/(New.Y - Old.Y)
				Hits = append(Hits, Hit)
			}
			
			Old.X = New.X
			Old.Y = New.Y
			if (New.Sign != 0) {
				Old.Sign = New.Sign
			}
		}
		
		Hits
	}
}

flipped = function(s1, s2) {
	( (s1<0)&(s2>0) ) | ( (s1>0)&(s2<0) )
}

cdr = function(x) {
	x[2:length(x)]
}

