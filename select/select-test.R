
Table = data.frame(
	Alice = rep(c(1, 2, 3, 4), 1000),
	Bob   = rep(1:2000, 2),
	Cathy = rnorm(4000),
	Doug  = rep('a', 4000)
)

select1  = function(Table, Key, Add.Key=T, ...) {
	Columns = as.list(substitute(list(...)))[-1L]
	
	S.Key = substitute(Key)
	Key.Str = deparse(S.Key)
	Group.By = eval(S.Key, envir=Table)
	Table[[Key.Str]] = Group.By
	
	Group.Gen = function(Group) {
		List.Out = sapply(Columns, function(Col) {
			eval(Col, envir=Group)
		})
		
		if (Add.Key) {
			List.Key = list()
			List.Key[[Key.Str]] = unique(Group[[Key.Str]])
			
			List.Out = c(List.Key, List.Out)
		}
		
		as.data.frame(List.Out)
	}
	
	Group.List = by(Table, Group.By, Group.Gen, simplify=F)
	names(Group.List) = c()
	
	Result 	= do.call(rbind, Group.List)
	
	Result
}

select2  = function(Table, Key, Add.Key=T, ...) {
	Columns = as.list(substitute(list(...)))[-1L]
	
	S.Key    = substitute(Key)
	Key.Str  = deparse(S.Key)
	Group.By = eval(S.Key, envir=Table)
	
	Indices  = tapply(1:nrow(Table), Group.By, c)
	
	Col.List = as.list(Table)
	
	Col.Out.List = lapply(Columns, function(Column) {
		sapply(Indices, function(Group) {
			Subset = lapply(Col.List, function(Col) Col[Group])
			eval(Column, envir=Subset)
		})
	})
	if (Add.Key) {
		Key.List = list();
		Key.List[[Key.Str]] = sapply(Indices, function(Group) {
			unique(Group.By[Group])
		})
		
		Col.Out.List = c(Key.List, Col.Out.List)
	}
	
	Table.Out = do.call(data.frame, Col.Out.List)
	
	Table.Out
}
