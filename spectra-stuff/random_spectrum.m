
function Spectrum = random_spectrum()

All_Files = dir('/home/owen/stuff/spectra');
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

Pick = Names{1 + floor(rand()*length(Names))};
File = sprintf('/home/owen/stuff/spectra/%s', Pick);

Spectrum = emsa_read(File);
