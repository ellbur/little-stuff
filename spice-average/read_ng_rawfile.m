
function Vars = read_ng_rawfile(File)

if length(File) == 1
	FID = File;
else
	FID = fopen(File, 'r');
	if FID == -1
		error(fprintf('Can''t open %s', File));
		return
	end
end

while 1
	Line = fgets(FID);
	if Line == -1
		break
	elseif startswith(Line, 'No. Variables:')
		M = str2num(nthtoken(Line, 3));
	elseif startswith(Line, 'No. Points:')
		N = str2num(nthtoken(Line,3));
	elseif startswith(Line, 'Variables:')
		break
	end
end

Names = cell(1, M);

for K = 1:(M+1)
	Line = fgets(FID);
	if Line == -1
		break
	elseif startswith(Line, 'Values:')
		break
	end
	
	Name = nthtoken(Line, 2);
	Name = regexprep(Name, '([^\w\d]|^\d)', '');
	
	Names{K} = Name;
end

BigVec = zeros(1, N);

for J = 1:(N*M)
	Line = fgets(FID);
	if Line == -1
		break
	end
	T = lasttoken(Line);
	E = interp_number(T);
	BigVec(J) = E;
end

Vars = struct();
BaseII = 1:length(Names):length(BigVec);

for K = 1:length(Names)
	KII = BaseII + (K-1);
	Vars.(Names{K}) = BigVec(KII);
end

fclose(FID);

% -------------------------------------------------------

function Y = startswith(A, B)

if length(B) > length(A)
	Y = false;
elseif A(1:length(B)) == B
	Y = true;
else
	Y = false;
end

% -------------------------------------------------------

function T = nthtoken(Line, N)

for II=1:N
	[T, Line] = strtok(Line);
end

% -------------------------------------------------------

function T = lasttoken(Line, N)

T = regexprep(Line, '.*\s([^\s])', '$1');
T = regexprep(T,    '\s*$',   '');

% -------------------------------------------------------

function E = interp_number(Text)

if any(Text == ',')
	T1 = regexprep(Text, '\,.*', '');
	T2 = regexprep(Text, '.*\,', '');
	E = str2num(T1) + str2num(T2)*1j;
else
	E = str2num(Text);
end


