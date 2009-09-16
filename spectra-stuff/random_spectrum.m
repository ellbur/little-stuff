
function Spectrum = random_spectrum(Dir='/home/owen/stuff/spectra')

All_Files = dir(Dir);
Names = {All_Files.name};

Filter = { };

JJ=1;
for II=1:length(All_Files)
	Pick = Names{II};
	
	if length(Pick) < 5
		continue;
	end
	
	if Pick(length(Pick)-3) ~= '.'
		continue;
	end
	
	Filter{JJ} = Pick;
	JJ = JJ + 1;
end

Pick = Filter{1 + floor(rand()*length(Filter))};
File = sprintf('%s/%s', Dir, Pick);

Spectrum = emsa_read(File);
