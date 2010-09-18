#!/usr/bin/perl

while (<>) {
	$_ = lc($_);
	tr/\;\,\.pyfgcrl\~\@aoeuidhtns\-\'qjkxbmwvz/qwertyuiop\[\]asdfghjkl\;\'zxcvbnm\,\./;
	print;
}
