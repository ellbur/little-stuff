#!/usr/bin/perl

$ddcommand  = $ARGV[0];
$chunk_size = $ARGV[1];
$command    = $ARGV[2];

$outfile = `mktemp`;
chomp $outfile;

for ($i=0; ; $i++) {
	$skip = $i * $chunk_size;
	$line = "$ddcommand of=$outfile skip=$skip count=$chunk_size 2>&1";
	$output = `$line`;
	
	if ($output =~ /dd/) {
		print $output;
		last;
	}
	
	system("$command $outfile $i");
}
