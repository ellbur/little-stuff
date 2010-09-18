
select = function(Table, Key, Add.Key=T, ...) {
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
