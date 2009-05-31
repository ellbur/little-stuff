#!/usr/bin/perl

use File::Temp qw(:POSIX);

$outfile = tmpnam();
$infile  = $ARGV[0];

open($in,  "<",  $infile) or die("Cannot open $infile $!");
open($out, ">", $outfile) or die("Cannot open $outfile $!");

$offset   = 0.0;
$evperbin = 10.0;

while ($line = <$in>)
{
	$line =~ s/\s*$//s;
	
	unless ($line =~ /\#(\w+)\s*\:\s*(.*?)\s*$/) {
		last;
	}
	
	$tag = $1;
	$arg = $2;
	
	if ($tag =~ /OFFSET/) {
		$offset = $arg;
	}
	elsif ($tag =~ /XPERCHAN/) {
		$evperbin = $arg;
	}
	elsif ($tag =~ /SPECTRUM/) {
		last;
	}
}

print $out "$offset\n";
print $out "$evperbin\n";

while ($line = <$in>) {
	
	if ($line =~ /\#/) {
		next;
	}
	
	unless ($line =~ /\s*(.*?)\,*\s*$/) {
		next;
	}
	
	print $out "$1\n";
}

close($in);
close($out);

print STDOUT "$outfile";
