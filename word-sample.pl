#!/usr/bin/perl

$pattern = $ARGV[0];

%table = { };

while ($line = <STDIN>) {
	
	$line = lc($line);
	@matches = ($line =~ /$pattern/g);
	
	foreach $match (@matches) {
		if (!$table{$match}) {
			$table{$match} = 0;
		}
		
		$table{$match}++;
	}
}

foreach $word (keys(%table)) {
	$num = $table{$word};
	
	if (!$num) {
		next;
	}
	
	print "$num $word\n";
}
