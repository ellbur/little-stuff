
function Sim = file_similarity(File1, File2)
%
% Use bunzip2 compression algorithm to rate the similarity
% of two files.
%
% File1, File2 are file names.
%
% Sim is a number in [0, 1], where 0 is no similarity, 1 is
% completely similar.
%
% The idea is that the compressed size of a file gives the amount of
% information contained in it. So let
%  A = information in File1
%  B = information in File2
% AB = information in File1 and File2 together
%
% Then A + B - AB gives the redundant information shared by the files.
% The more information they share, the more similar.
%
% The program 'bzip2' must be installed for this function to work.
%

Copy1 = tempname();
Copy2 = tempname();
Cat   = tempname();

copyfile(File1, Copy1);
copyfile(File2, Copy2);

% 'cat' is UNIX, so we'll make our own cat
file_cat({Copy1, Copy2}, Cat);


ZipA  = [ Copy1 '.bz2' ];
ZipB  = [ Copy2 '.bz2' ];
ZipAB = [ Cat   '.bz2'];

system(sprintf('bzip2 < ''%s'' > ''%s''', Copy1, ZipA));
system(sprintf('bzip2 < ''%s'' > ''%s''', Copy2, ZipB));
system(sprintf('bzip2 < ''%s'' > ''%s''',   Cat, ZipAB));

StatA  = dir(ZipA);
StatB  = dir(ZipB);
StatAB = dir(ZipAB);

Lap = StatA.bytes + StatB.bytes - StatAB.bytes;
Sim = Lap / (StatA.bytes + StatB.bytes) * 2;

if Sim < 0
	Sim = 0;
elseif Sim > 1
	Sim = 1;
end

delete(Copy1);
delete(Copy2);
delete(Cat);

delete(ZipA);
delete(ZipB);
delete(ZipAB);
