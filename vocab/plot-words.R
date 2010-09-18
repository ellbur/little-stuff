
library(sqldf)

make.word.table = function(Big.Table) {
	Word.Table = sqldf('select word, count(1) as count ' %+%
		' from `Big.Table` group by word')
	
	Word.Table = Word.Table[order(Word.Table$count, decreasing=T),]
	
	Word.Table = transform(Word.Table,
		rank = 1:nrow(Word.Table),
		freq = count / sum(count)
	)
	
	Word.Table = transform(Word.Table,
		cum.freq = cumsum(freq)
	)
	
	Word.Table
}
