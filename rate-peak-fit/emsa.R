
read.emsa = function(File) {
	File = file(File, 'r')
	Lines = readLines(File)
	close(File)
	
	r(Header, Lines) %=% read.emsa.header(Lines)

	read.emsa.spectrum(Header, Lines)
}

read.emsa.header = function(Lines) {
	
	II = 1
	
	Header = list()
	
	while (1) {
		if (II > length(Lines)) {
			break
		}
		
		Line = Lines[[II]]
		
		Pattern = '\\#(\\w+)\\s*\\-{0,1}\\s*(\\w+){0,1}\\s*\\:\\s*([^\\s]*)'
		if (regexpr(Pattern, Line) == -1) {
			warning('Header line does not match')
			break
		}
		
		Name  = sub(Pattern, '\\1', Line)
		Unit  = sub(Pattern, '\\2', Line)
		Value = sub(Pattern, '\\3', Line)
		
		Value = type.convert(Value, as.is=T)
		
		Name = toupper(Name)
		Value = read.emsa.fix.units(Header, Name, Unit, Value)
		
		Header[[Name]] = Value
		
		II = II + 1
		
		if (Name == 'SPECTRUM') {
			break
		}
	}
	
	list(Header, Lines[II:length(Lines)])
}

read.emsa.spectrum = function(Header, Lines) {
	
	if (is.null(Header[['OFFSET']])) {
		Header[['OFFSET']] = 0
	}
	if (is.null(Header[['XPERCHAN']])) {
		Header[['XPERCHAN']] = 10
	}
	
	Spectrum = make.spectrum(
		numeric(Header[['NPOINTS']]),
		Header[['OFFSET']],
		Header[['XPERCHAN']]
	)
	JJ = 1
	
	II = 1
	
	while (1) {
		
		if (II > length(Lines)) {
			break
		}
		
		Line = Lines[[II]]
		
		if (regexpr('\\#', Line) != -1) {
			break
		}
		
		Parts = strsplit(Line, '\\s*\\,\\s*', perl=T)[[1]]
		for (Part in Parts) {
			Part = as.numeric(Part)
			
			Count = read.emsa.fix.units(Header, 'SPECTRUM', '', Part)
			Spectrum[[JJ]] = Count
			
			JJ = JJ + 1
		}
		
		II = II + 1
	}
	
	Spectrum
}

read.emsa.X.Names = list(
	'XPERCHAN',
	'OFFSET',
	'SPECTRUM'
)

read.emsa.Unit.Factors = list(
	 ev = 1e0,
	kev = 1e3,
	mev = 1e6
)

read.emsa.fix.units = function(Header, Name, Unit, Value) {
	if (! is.numeric(Value)) {
		Value
	}
	else {
		if (nchar(Unit) == 0) {
			if (any(Name %in% read.emsa.X.Names)) {
				Unit = Header[['XUNITS']]
			}
		}
		
		Unit = tolower(Unit)
		
		Factor = read.emsa.Unit.Factors[[Unit]]
		if (is.null(Factor)) {
			Factor = 1
		}
		
		Value * Factor
	}
}

# ------------------------------------------------------------------------

write.emsa = function(Spectrum, File) {
	File = file(File, 'w')
	
	File.Name = summary.connection(File)[['description']]
	
	cat(sprintf('#FORMAT      : EMSA/MAS SPECTRAL DATA FILE\n'), file=File)
	cat(sprintf('#VERSION     : 1.0\n')                        , file=File)
	cat(sprintf('#TITLE       : %s\n', File.Name)              , file=File)
	cat(sprintf('#NCOLUMNS    : 1\n')                          , file=File)
	cat(sprintf('#XUNITS      : eV\n')                         , file=File)
	cat(sprintf('#YUNITS      : Counts\n')                     , file=File)
	cat(sprintf('#DATATYPE    : Y\n')                          , file=File)
	cat(sprintf('#XPERCHAN    : %f\n', attr(Spectrum, 'ev.per.bin')), file=File)
	cat(sprintf('#OFFSET      : %f\n', attr(Spectrum, 'offset')), file=File)
	cat(sprintf('#NPOINTS     : %d\n', length(Spectrum))       , file=File)
	cat(sprintf('#SPECTRUM :\n')                               , file=File)
	
	for (II in 1:length(Spectrum)) {
		cat(sprintf('%f\n', Spectrum[[II]]), file=File)
	}
	
	cat('#ENDOFDATA :\n\n', file=File)
	
	close(File)
}

