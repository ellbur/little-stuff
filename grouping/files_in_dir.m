
function Files = files_in_dir(Directory)
%
% Do to lack of 'glob' function in matlab,
% use this wrapper around the 'dir' function
%
% Directory is a string directory name
% Files is a cell array of file names.
%

Dir = dir(Directory);
Files = {Dir.name};
Files = {Files{3:length(Files)}};

for II=1:length(Files)
	Files{II} = [ Directory '/' Files{II} ];
end
