
function Spectrum = emsa_read(File)

[Status File2] = system(sprintf('./emsa_read.pl %s', File), 1);
Table = csvread(File2);

delete(File2);

Len = length(Table);

Spectrum.Offset   = Table(1);
Spectrum.EvPerBin = Table(2);
Spectrum.Channels = Table(3:Len);
Spectrum.Lefts    = ((0:(Len-3))*Table(2) + Table(1))';
Spectrum.Centers  = (((1:(Len-2))-0.5)*Table(2) + Table(1))';
Spectrum.File     = File;
