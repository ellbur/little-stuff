
library(tuneR)
library(seewave)

source('ceps-pieces.R')

readSound = function(filename, ...) {
	if (length(grep('\\.mp3$', filename)) > 0) {
		readMP3(filename, ...)
	}
	else {
		readWave(filename, ...)
	}
}

Dirs = Sys.glob('music/*')

Source = do.call(rbind, lapply(Dirs, function(Dir) {
	data.frame(
		Files = c(
			Sys.glob(Dir %+% '/*.wav'),
			Sys.glob(Dir %+% '/*.mp3')
		),
		Types = Dir,
		stringsAsFactors = F
	)
}))

Files = Source$Files
Types = Source$Types

Sounds = lapply(Files, readSound)

Ceps = lapply(seq_along(Files), function (I) {
	S    = Sounds[[I]]
	File = Files[[I]]
	Type = Types[[I]]
	transform(ceps.pieces(S), File=File, Type=Type)
})

All.C = do.call(rbind, Ceps)

Test = ceps.pieces(readSound('/home/owen/stuff/music/me/entertainer/final1.mp3'))
Train = All.C[,grep('V', colnames(All.C))]
Class = All.C[,'Type']

Pick = knn(Train, Test, Class)

