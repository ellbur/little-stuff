
function file_cat(Inputs, Output)
%
% Concatenate a list of files into a destination file.
%
% Inputs is a cell array containing input file names.
% Output is a string that is the output file name.
%

Text = [ ]; % col vector

for II = 1:length(Inputs)
	Input = Inputs{II};
	
	Handle = fopen(Input, 'rb');
	Contents = fread(Handle);
	
	Text = [ Text ; Contents ];
	fclose(Handle);
end

Handle = fopen(Output, 'wb');
fwrite(Handle, Text);
fclose(Handle);
